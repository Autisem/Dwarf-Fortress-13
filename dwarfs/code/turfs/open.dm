/turf/open/genturf
	name = "ungenerated turf"
	desc = "If you see this, and you're not a ghost, yell at coders"
	icon = 'icons/turf/debug.dmi'
	icon_state = "genturf"

/turf/open/floor/stone
	name = "stone floor"
	desc = "Classic."
	icon = 'dwarfs/icons/turf/floors_dwarven.dmi'
	icon_state = "stone_floor"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	slowdown = 0
	var/busy = FALSE

/turf/open/floor/stone/ScrapeAway(amount, flags)
	return ChangeTurf(/turf/open/floor/rock)

/turf/open/floor/stone/setup_broken_states()
	return list(icon_state)

/turf/open/floor/stone/crowbar_act(mob/living/user, obj/item/I)
	if(pry_tile(I, user))
		new /obj/item/stack/sheet/stone(get_turf(src))
		return TRUE

/turf/open/floor/rock
	name = "rock"
	desc = "Terrible."
	icon = 'dwarfs/icons/turf/floors_cavern.dmi'
	icon_state = "stone"
	slowdown = 1
	baseturfs = /turf/open/lava/smooth/nospread
	var/digged_up = FALSE

/turf/open/floor/rock/ScrapeAway(amount, flags)
	return ChangeTurf(/turf/open/lava/smooth/nospread)

/turf/open/floor/rock/crowbar_act(mob/living/user, obj/item/I)
	return FALSE

/turf/open/floor/rock/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pickaxe))
		if(digged_up)
			playsound(src, pick(I.usesound), 100, TRUE)
			if(do_after(user, 5 SECONDS, target = src))
				if(QDELETED(src))
					return
				var/turf/TD = SSmapping.get_turf_below(src)
				if(istype(TD, /turf/closed/mineral))
					TD.ChangeTurf(/turf/open/floor/rock)
					var/obj/O = new /obj/structure/stairs(TD)
					O.dir = REVERSE_DIR(user.dir)
					ChangeTurf(/turf/open/openspace)
					user.visible_message(span_notice("<b>[user]</b> constructs stairs downwards.") , \
										span_notice("You construct stairs downwards."))
				else
					to_chat(user, span_warning("Something very dense underneath!"))
	if((I.tool_behaviour == TOOL_SHOVEL) && params)
		playsound(src, pick(I.usesound), 100, TRUE)
		if(do_after(user, 5 SECONDS, target = src))
			if(QDELETED(src))
				return
			if(digged_up)
				var/turf/TD = SSmapping.get_turf_below(src)
				if(istype(TD, /turf/closed/mineral))
					TD.ChangeTurf(/turf/open/floor/rock)
					ChangeTurf(/turf/open/openspace)
					user.visible_message(span_warning("<b>[user]</b> digs up a hole!") , \
										span_notice("You dig up a hole."))
				else
					to_chat(user, span_warning("Something very dense underneath!"))
			else
				for(var/i in 1 to rand(3, 6))
					var/obj/item/S = new /obj/item/stack/ore/stone(src)
					S.pixel_x = rand(-8, 8)
					S.pixel_y = rand(-8, 8)
				digged_up = TRUE
				user.visible_message(span_notice("<b>[user]</b> digs up some stones.") , \
									span_notice("You dig up some stones."))
	if(..())
		return

/turf/open/floor/sand
	name = "sand"
	desc = "Cheese?"
	icon = 'dwarfs/icons/turf/floors_cavern.dmi'
	icon_state = "sand"
	baseturfs = /turf/open/floor/sand
	var/digged_up = FALSE

/turf/open/floor/sand/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SHOVEL)
		to_chat(user, span_notice("You start digging [src]..."))
		if(I.use_tool(src, user, 5 SECONDS))
			if(QDELETED(src))
				return
			if(digged_up)
				user.visible_message(span_notice("[user] digs out a hole in the ground."), span_notice("You dig out a hole in the ground."))
				ChangeTurf(/turf/open/openspace)
			else
				new/obj/item/stack/sand(src, rand(3,6))
				digged_up = TRUE
				user.visible_message(span_notice("<b>[user]</b> digs up some stones.") , \
					span_notice("You dig up some stones."))
	else
		. = ..()

/turf/open/floor/dirt
	name = "fertile dirt"
	desc = "Found near bodies of water. Can be farmed on."
	icon = 'dwarfs/icons/turf/floors_fertile.dmi'
	icon_state = "fertile"
	var/digged_up = FALSE

/turf/open/floor/dirt/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_HOE)
		if(digged_up)
			to_chat(user, span_warning("There is no more dirt to be tilled!"))
			return
		to_chat(user, span_notice("You start tilling [src]..."))
		if(I.use_tool(src, user, 10 SECONDS))
			ChangeTurf(/turf/open/floor/tilled)
			user.mind.adjust_experience(/datum/skill/farming, 7)
	else if(I.tool_behaviour == TOOL_SHOVEL)
		to_chat(user, span_notice("You start digging [src]..."))
		if(I.use_tool(src, user, 5 SECONDS))
			if(digged_up)
				return
			else
				new/obj/item/stack/dirt(src, rand(2,5))
				user.visible_message(span_notice("<b>[user]</b> digs up some dirt.") , \
					span_notice("You dig up some dirt."))

/turf/open/floor/tilled
	name = "tilled dirt"
	desc = "Ready for plants."
	icon = 'dwarfs/icons/turf/floors_fertile.dmi'
	icon_state = "fertile_tilled"
	var/waterlevel = 0
	var/watermax = 100
	var/waterrate = 1
	var/fertlevel = 0
	var/fertmax = 100
	var/fertrate = 1
	var/list/allowed_species
	///The currently planted plant
	var/obj/structure/plant/myplant = null


/turf/open/floor/tilled/examine(mob/user)
	. = ..()
	.+="<hr>"
	if(myplant)
		.+="There is \a [myplant] growing here."
	else
		.+="It's empty."
	var/fert_text = "<br>"
	switch(fertlevel)
		if(60 to 100)
			fert_text+="There is plenty of fertilizer in it."
		if(30 to 59)
			fert_text+="There is some fertilizer in it."
		if(1 to 29)
			fert_text+="There is almost no fertilizer in it."
		else
			fert_text+="There is no fertilizer in it."
	.+=fert_text
	var/water_text = "<br>"
	switch(waterlevel)
		if(60 to 100)
			water_text+="Looks very moist."
		if(30 to 59)
			water_text+="Looks normal."
		if(1 to 29)
			water_text+="Looks a bit dry."
		else
			water_text+="Looks extremely dry."
	.+=water_text

/turf/open/floor/tilled/Destroy()
	if(myplant)
		QDEL_NULL(myplant)
	return ..()

/turf/open/floor/tilled/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/growable/seeds))
		if(!myplant)
			var/obj/item/growable/seeds/S = O
			to_chat(user, span_notice("You plant [S]."))
			var/obj/structure/plant/P = new S.plant(loc)
			qdel(S)
			myplant = P
			P.plot = src
			myplant.update_appearance()
			RegisterSignal(P, COSMIG_PLANT_DAMAGE_TICK, .proc/on_damage)
			RegisterSignal(P, COSMIG_PLANT_EAT_TICK, .proc/on_eat)
			return
		else
			to_chat(user, span_warning("[capitalize(src.name)] already has seeds in it!"))
			return

	else if(istype(O, /obj/item/shovel))
		user.visible_message(span_notice("[user] starts digging out [src]'s plants...") ,
			span_notice("You start digging out [src]'s plants..."))
		if(O.use_tool(src, user, 50, volume=50) || !myplant)
			user.visible_message(span_notice("[user] digs out the plants in [src]!") , span_notice("You dig out all of [src]'s plants!"))
			if(myplant) //Could be that they're just using it as a de-weeder
				QDEL_NULL(myplant)
				name = initial(name)
				desc = initial(desc)
			update_appearance()
			return
	else if(istype(O, /obj/item/fertilizer))
		user.visible_message(span_notice("[user] adds [O] to \the [src]."), span_notice("You add [O] to \the [src]."))
		var/obj/item/fertilizer/F = O
		fertlevel = clamp(fertlevel+F.fertilizer, 0, fertmax)
		qdel(F)
	else
		return ..()

/turf/open/floor/tilled/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(myplant)
		if(myplant.dead)
			to_chat(user, span_notice("You remove the dead plant from [src]."))
			QDEL_NULL(myplant)
			update_appearance()
	else
		if(user)
			user.examinate(src)

/turf/open/floor/tilled/proc/on_damage(obj/structure/plant/source)
	SIGNAL_HANDLER
	if(!waterlevel)
		source.health -= rand(1,3)
	if(allowed_species && !(source.species in allowed_species))
		source.health -= rand(1,3)

/turf/open/floor/tilled/proc/on_eat(obj/structure/plant/source)
	SIGNAL_HANDLER
	waterlevel = clamp(waterlevel-waterrate, 0, watermax)
	fertlevel = clamp(fertlevel-fertrate, 0, fertmax)
	source.growth_modifiers["fertilizer"] = fertlevel ? 0.8 : 1

/turf/open/water
	name = "water"
	desc = "Stay hydrated."
	icon = 'dwarfs/icons/turf/water.dmi'
	icon_state = "water-255"
	base_icon_state = "water"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_WATER)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_WATER)

/turf/open/water/attackby(obj/item/C, mob/user, params)
	if(C.is_refillable())
		var/obj/item/reagent_containers/CC = C
		if(CC.reagents.total_volume == CC.volume)
			to_chat(user, span_warning("[CC] is full!"))
			return
		to_chat(user, span_notice("You fill [CC] with water."))
		CC.reagents.add_reagent(/datum/reagent/water, CC.volume - CC.reagents.total_volume)
	else
		. = ..()
