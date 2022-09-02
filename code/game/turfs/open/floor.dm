/turf/open/floor
	//NOTE: Floor code has been refactored, many procs were removed and refactored
	//- you should use istype() if you want to find out whether a floor has a certain type
	//- floor_tile is now a path, and not a tile obj
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	base_icon_state = "floor"
	baseturfs = /turf/open/floor/rock

	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	flags_1 = NO_SCREENTIPS_1
	turf_flags = CAN_BE_DIRTY_1
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_TURF_OPEN)
	intact = TRUE
	tiled_dirt = TRUE

	var/broken = FALSE
	var/burnt = FALSE
	var/list/broken_states
	var/list/burnt_states


/turf/open/floor/Initialize(mapload)
	. = ..()
	if (broken_states)
		stack_trace("broken_states defined at the object level for [type], move it to setup_broken_states()")
	else
		broken_states = string_list(setup_broken_states())
	if (burnt_states)
		stack_trace("burnt_states defined at the object level for [type], move it to setup_burnt_states()")
	else
		var/list/new_burnt_states = setup_burnt_states()
		if(new_burnt_states)
			burnt_states = string_list(new_burnt_states)
	if(!broken && broken_states && (icon_state in broken_states))
		broken = TRUE
	if(!burnt && burnt_states && (icon_state in burnt_states))
		burnt = TRUE
	if(is_fortress_level(z))
		GLOB.station_turfs += src

/turf/open/floor/proc/setup_broken_states()
	return list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")

/turf/open/floor/proc/setup_burnt_states()
	return

/turf/open/floor/Destroy()
	if(is_fortress_level(z))
		GLOB.station_turfs -= src
	return ..()

/turf/open/floor/ex_act(severity, target)
	var/shielded = is_shielded()
	..()
	if(severity != 1 && shielded && target != src)
		return
	if(target == src)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return
	if(target != null)
		severity = 3

	switch(severity)
		if(1)
			ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
		if(2)
			switch(pick(1,2;75,3))
				if(1)
					if(!length(baseturfs) || !ispath(baseturfs[baseturfs.len-1], /turf/open/floor))
						ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
					else
						ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
				if(2)
					ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
				if(3)
					if(prob(80))
						ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
					else
						break_tile()
		if(3)
			if (prob(50))
				src.break_tile()

/turf/open/floor/is_shielded()
	for(var/obj/structure/A in contents)
		return 1

/turf/open/floor/attack_paw(mob/user)
	return attack_hand(user)

/turf/open/floor/proc/break_tile_to_plating()
	var/turf/open/floor/T = make_plating()
	if(!istype(T))
		return
	T.break_tile()

/turf/open/floor/proc/break_tile()
	if(broken)
		return
	icon_state = pick(broken_states)
	broken = 1

/turf/open/floor/burn_tile()
	if(broken || burnt)
		return
	if(LAZYLEN(burnt_states))
		icon_state = pick(burnt_states)
	else
		icon_state = pick(broken_states)
	burnt = 1

/turf/open/floor/proc/make_plating(force = FALSE)
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

///For when the floor is placed under heavy load. Calls break_tile(), but exists to be overridden by floor types that should resist crushing force.
/turf/open/floor/proc/crush()
	break_tile()

/turf/open/floor/ChangeTurf(path, new_baseturf, flags)
	if(!isfloorturf(src))
		return ..() //fucking turfs switch the fucking src of the fucking running procs
	if(!ispath(path, /turf/open/floor))
		return ..()
	var/old_dir = dir
	var/turf/open/floor/W = ..()
	W?.setDir(old_dir)
	W?.update_icon()
	return W

/turf/open/floor/attackby(obj/item/I, mob/user, params)
	if(!I || !user)
		return TRUE
	. = ..()
	if(.)
		return .
	if(user.a_intent == INTENT_HARM && istype(I, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/sheets = I
		return sheets.on_attack_floor(user, params)
	if(I.tool_behaviour == TOOL_BUILDER_HAMMER)
		var/obj/item/builder_hammer/H = I
		if(!H.selected_blueprint)
			to_chat(user, span_warning("[H] doesn't have a blueprint selected!"))
			return
		var/obj/structure/blueprint/B = new H.selected_blueprint
		var/list/dimensions = B.dimensions
		qdel(B)
		var/list/turfs = RECT_TURFS(dimensions[1], dimensions[2], src)
		for(var/turf/T in turfs)
			if(T.is_blocked_turf())
				to_chat(user, span_warning("You have to free the space required to place the blueprint first!"))
				return
		var/obj/structure/blueprint/new_blueprint = new H.selected_blueprint(src)
		new_blueprint.update_appearance()
		H.selected_blueprint = null
	else if(istype(I, /obj/item/sapling))
		var/obj/item/offhand = user.get_inactive_held_item()
		if(!offhand || offhand?.tool_behaviour != TOOL_SHOVEL)
			to_chat(user, span_warning("You need a shovel to plant [I]!"))
			return
		var/obj/item/sapling/S = I
		var/obj/structure/plant/P = new S.plant_type(src)
		P.health = S.health
		P.growthstage = S.growthstage
		P.update_appearance()
		to_chat(user, span_notice("You plant [S]."))
		qdel(S)
		user.mind.adjust_experience(/datum/skill/farming, rand(1,7))
	return FALSE

/turf/open/floor/crowbar_act(mob/living/user, obj/item/I)
	if(do_after(user, I.toolspeed * 0.5 SECONDS, src))
		if(intact && pry_tile(I, user))
			return TRUE

/turf/open/floor/proc/pry_tile(obj/item/I, mob/user, silent = FALSE)
	I.play_tool_sound(src, 80)
	return remove_tile(user, silent)

/turf/open/floor/proc/remove_tile(mob/user, silent = FALSE, force_plating)
	if(broken || burnt)
		broken = FALSE
		burnt = FALSE
		if(user && !silent)
			to_chat(user, span_notice("You remove the damaged tile."))
	else
		if(user && !silent)
			to_chat(user, span_notice("You remove the tile."))
	return make_plating(force_plating)

/turf/open/floor/acid_melt()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/material
	name = "floor"
	icon_state = "materialfloor"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
