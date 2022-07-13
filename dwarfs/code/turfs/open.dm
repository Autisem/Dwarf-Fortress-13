/turf/open/floor/stone
	name = "stone floor"
	desc = "Classic."
	icon = 'dwarfs/icons/turf/floors_dwarven.dmi'
	icon_state = "stone_floor"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	floor_tile = /turf/open/floor/stone/raw
	slowdown = 0
	var/busy = FALSE

/turf/open/floor/stone/ScrapeAway(amount, flags)
	return ChangeTurf(/turf/open/floor/stone/raw)

/turf/open/floor/stone/setup_broken_states()
	return list(icon_state)

/turf/open/floor/stone/crowbar_act(mob/living/user, obj/item/I)
	if(pry_tile(I, user))
		new /obj/item/stack/sheet/stone(get_turf(src))
		return TRUE

/turf/open/floor/stone/raw
	name = "ugly stone floor"
	desc = "Terrible."
	icon = 'dwarfs/icons/turf/floors_cavern.dmi'
	icon_state = "stone"
	slowdown = 1
	baseturfs = /turf/open/lava/smooth/nospread
	var/digged_up = FALSE

/turf/open/floor/stone/raw/ScrapeAway(amount, flags)
	return ChangeTurf(/turf/open/lava/smooth/nospread)

/turf/open/floor/stone/raw/crowbar_act(mob/living/user, obj/item/I)
	return FALSE

/turf/open/floor/stone/raw/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pickaxe))
		if(digged_up)
			playsound(src, pick(I.usesound), 100, TRUE)
			if(do_after(user, 5 SECONDS, target = src))
				if(QDELETED(src))
					return
				var/turf/TD = SSmapping.get_turf_below(src)
				if(istype(TD, /turf/closed/mineral))
					TD.ChangeTurf(/turf/open/floor/stone/raw)
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
					TD.ChangeTurf(/turf/open/floor/stone/raw)
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
