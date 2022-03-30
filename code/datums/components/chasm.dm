// Used by /turf/open/chasm and subtypes to implement the "dropping" mechanic
/datum/component/chasm
	var/turf/target_turf
	var/fall_message = "GAH! Ah... where are you?"
	var/oblivion_message = "You stumble and stare into the abyss before you. It stares back, and you fall into the enveloping dark."

	/// List of refs to falling objects -> how many levels deep we've fallen
	var/static/list/falling_atoms = list()
	var/static/list/forbidden_types = typecacheof(list(
		/obj/structure/lattice,
		/obj/structure/stone_tile,
		/obj/projectile,
		/obj/effect/projectile,
		/obj/effect/abstract,
		/obj/effect/landmark,
		/obj/effect/temp_visual,
		/obj/effect/particle_effect/ion_trails,
		/obj/effect/dummy/phased_mob,
		/obj/effect/mapping_helpers,
		))

/datum/component/chasm/Initialize(turf/target)
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, .proc/Entered)
	target_turf = target
	START_PROCESSING(SSobj, src) // process on create, in case stuff is still there

/datum/component/chasm/proc/Entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	START_PROCESSING(SSobj, src)
	drop_stuff(arrived)

/datum/component/chasm/process()
	if (!drop_stuff())
		STOP_PROCESSING(SSobj, src)

/datum/component/chasm/proc/is_safe()
	//if anything matching this typecache is found in the chasm, we don't drop things
	var/static/list/chasm_safeties_typecache = typecacheof(list(/obj/structure/lattice/catwalk))

	var/atom/parent = src.parent
	var/list/found_safeties = typecache_filter_list(parent.contents, chasm_safeties_typecache)
	return LAZYLEN(found_safeties)

/datum/component/chasm/proc/drop_stuff(AM)
	if (is_safe())
		return FALSE

	var/atom/parent = src.parent
	var/to_check = AM ? list(AM) : parent.contents
	for (var/thing in to_check)
		if (droppable(thing))
			. = TRUE
			INVOKE_ASYNC(src, .proc/drop, thing)

/datum/component/chasm/proc/droppable(atom/movable/AM)
	var/datum/weakref/falling_ref = WEAKREF(AM)
	// avoid an infinite loop, but allow falling a large distance
	if(falling_atoms[falling_ref] && falling_atoms[falling_ref] > 30)
		return FALSE
	if(!isliving(AM) && !isobj(AM))
		return FALSE
	if(is_type_in_typecache(AM, forbidden_types) || AM.throwing || (AM.movement_type & (FLOATING|FLYING)))
		return FALSE
	//Flies right over the chasm
	if(ismob(AM))
		var/mob/M = AM
		if(M.buckled) //middle statement to prevent infinite loops just in case!
			var/mob/buckled_to = M.buckled
			if((!ismob(M.buckled) || (buckled_to.buckled != M)) && !droppable(M.buckled))
				return FALSE
	return TRUE

/datum/component/chasm/proc/drop(atom/movable/AM)
	var/datum/weakref/falling_ref = WEAKREF(AM)
	//Make sure the item is still there after our sleep
	if(!AM || !falling_ref?.resolve())
		falling_atoms -= falling_ref
		return
	falling_atoms[falling_ref] = (falling_atoms[falling_ref] || 0) + 1
	var/turf/T = target_turf

	if(T)
		// send to the turf below
		AM.visible_message(span_boldwarning("<b>[AM]</b> падает в [parent]!") , span_userdanger("[fall_message]"))
		T.visible_message(span_boldwarning("<b>[AM]</b> падает сверху!"))
		AM.forceMove(T)
		if(isliving(AM))
			var/mob/living/L = AM
			L.Paralyze(100)
			L.adjustBruteLoss(30)
		falling_atoms -= falling_ref

	else
		// send to oblivion
		AM.visible_message(span_boldwarning("<b>[AM]</b> падает в <b>[parent]</b>!") , span_userdanger("[oblivion_message]"))
		if (isliving(AM))
			var/mob/living/L = AM
			L.notransform = TRUE
			L.Paralyze(20 SECONDS)

		var/oldtransform = AM.transform
		var/oldcolor = AM.color
		var/oldalpha = AM.alpha
		animate(AM, transform = matrix() - matrix(), alpha = 0, color = rgb(0, 0, 0), time = 10)
		for(var/i in 1 to 5)
			//Make sure the item is still there after our sleep
			if(!AM || QDELETED(AM))
				return
			AM.pixel_y--
			sleep(2)

		//Make sure the item is still there after our sleep
		if(!AM || QDELETED(AM))
			return

		if(isliving(AM))
			var/mob/living/L = AM
			if(L.stat != DEAD)
				L.death(TRUE)

		falling_atoms -= falling_ref
		qdel(AM)
		if(AM && !QDELETED(AM)) //It's indestructible
			var/atom/parent = src.parent
			parent.visible_message(span_boldwarning("[parent] spits out [AM]!"))
			AM.alpha = oldalpha
			AM.color = oldcolor
			AM.transform = oldtransform
			AM.throw_at(get_edge_target_turf(parent,pick(GLOB.alldirs)),rand(1, 10),rand(1, 10))


#define STABLE 0 //The tile is stable and won't collapse/sink when crossed.
#define COLLAPSE_ON_CROSS 1 //The tile is unstable and will temporary become unusable when crossed.
#define DESTROY_ON_CROSS 2 //The tile is nearly broken and will permanently become unusable when crossed.
#define UNIQUE_EFFECT 3 //The tile has some sort of unique effect when crossed.
//stone tiles for boss arenas
/obj/structure/stone_tile
	name = "stone tile"
	icon = 'icons/turf/boss_floors.dmi'
	icon_state = "pristine_tile1"
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/tile_key = "pristine_tile"
	var/tile_random_sprite_max = 24
	var/fall_on_cross = STABLE //If the tile has some sort of effect when crossed
	var/fallen = FALSE //If the tile is unusable
	var/falling = FALSE //If the tile is falling

/obj/structure/stone_tile/Initialize(mapload)
	. = ..()
	icon_state = "[tile_key][rand(1, tile_random_sprite_max)]"
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/stone_tile/Destroy(force)
	if(force || fallen)
		. = ..()
	else
		return QDEL_HINT_LETMELIVE

/obj/structure/stone_tile/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(falling || fallen)
		return
	var/turf/T = get_turf(src)
	if(!islava(T) && !ischasm(T)) //nothing to sink or fall into
		return
	var/obj/item/I
	if(istype(AM, /obj/item))
		I = AM
	var/mob/living/L
	if(isliving(AM))
		L = AM
	switch(fall_on_cross)
		if(COLLAPSE_ON_CROSS, DESTROY_ON_CROSS)
			if((I && I.w_class >= WEIGHT_CLASS_BULKY) || (L && !(L.movement_type & FLYING) && L.mob_size >= MOB_SIZE_HUMAN)) //too heavy! too big! aaah!
				INVOKE_ASYNC(src, .proc/collapse)
		if(UNIQUE_EFFECT)
			crossed_effect(AM)

/obj/structure/stone_tile/proc/collapse()
	falling = TRUE
	var/break_that_sucker = fall_on_cross == DESTROY_ON_CROSS
	playsound(src, 'sound/effects/pressureplate.ogg', 50, TRUE)
	Shake(-1, -1, 25)
	sleep(5)
	if(break_that_sucker)
		playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE)
	else
		playsound(src, 'sound/mecha/mechmove04.ogg', 50, TRUE)
	animate(src, alpha = 0, pixel_y = pixel_y - 3, time = 5)
	fallen = TRUE
	if(break_that_sucker)
		QDEL_IN(src, 10)
	else
		addtimer(CALLBACK(src, .proc/rebuild), 55)

/obj/structure/stone_tile/proc/rebuild()
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y) - 5
	animate(src, alpha = initial(alpha), pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 30)
	sleep(30)
	falling = FALSE
	fallen = FALSE

/obj/structure/stone_tile/proc/crossed_effect(atom/movable/AM)
	return

/obj/structure/stone_tile/block
	name = "stone block"
	icon_state = "pristine_block1"
	tile_key = "pristine_block"
	tile_random_sprite_max = 4

/obj/structure/stone_tile/slab
	name = "stone slab"
	icon_state = "pristine_slab1"
	tile_key = "pristine_slab"
	tile_random_sprite_max = 4

/obj/structure/stone_tile/center
	name = "stone center tile"
	icon_state = "pristine_center1"
	tile_key = "pristine_center"
	tile_random_sprite_max = 4

/obj/structure/stone_tile/surrounding
	name = "stone surrounding slab"
	icon_state = "pristine_surrounding1"
	tile_key = "pristine_surrounding"
	tile_random_sprite_max = 2

/obj/structure/stone_tile/surrounding_tile
	name = "stone surrounding tile"
	icon_state = "pristine_surrounding_tile1"
	tile_key = "pristine_surrounding_tile"
	tile_random_sprite_max = 2

//cracked stone tiles
/obj/structure/stone_tile/cracked
	name = "cracked stone tile"
	icon_state = "cracked_tile1"
	tile_key = "cracked_tile"

/obj/structure/stone_tile/block/cracked
	name = "cracked stone block"
	icon_state = "cracked_block1"
	tile_key = "cracked_block"

/obj/structure/stone_tile/slab/cracked
	name = "cracked stone slab"
	icon_state = "cracked_slab1"
	tile_key = "cracked_slab"
	tile_random_sprite_max = 1

/obj/structure/stone_tile/center/cracked
	name = "cracked stone center tile"
	icon_state = "cracked_center1"
	tile_key = "cracked_center"

/obj/structure/stone_tile/surrounding/cracked
	name = "cracked stone surrounding slab"
	icon_state = "cracked_surrounding1"
	tile_key = "cracked_surrounding"
	tile_random_sprite_max = 1

/obj/structure/stone_tile/surrounding_tile/cracked
	name = "cracked stone surrounding tile"
	icon_state = "cracked_surrounding_tile1"
	tile_key = "cracked_surrounding_tile"

//burnt stone tiles
/obj/structure/stone_tile/burnt
	name = "burnt stone tile"
	icon_state = "burnt_tile1"
	tile_key = "burnt_tile"

/obj/structure/stone_tile/block/burnt
	name = "burnt stone block"
	icon_state = "burnt_block1"
	tile_key = "burnt_block"

/obj/structure/stone_tile/slab/burnt
	name = "burnt stone slab"
	icon_state = "burnt_slab1"
	tile_key = "burnt_slab"

/obj/structure/stone_tile/center/burnt
	name = "burnt stone center tile"
	icon_state = "burnt_center1"
	tile_key = "burnt_center"

/obj/structure/stone_tile/surrounding/burnt
	name = "burnt stone surrounding slab"
	icon_state = "burnt_surrounding1"
	tile_key = "burnt_surrounding"

/obj/structure/stone_tile/surrounding_tile/burnt
	name = "burnt stone surrounding tile"
	icon_state = "burnt_surrounding_tile1"
	tile_key = "burnt_surrounding_tile"

#undef STABLE
#undef COLLAPSE_ON_CROSS
#undef DESTROY_ON_CROSS
#undef UNIQUE_EFFECT
