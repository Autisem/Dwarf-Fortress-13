/turf/open/water
	gender = FEMALE
	name = "вода"
	desc = "Ммм..."
	icon = 'icons/turf/floors.dmi'
	icon_state = "riverwater_motion"
	baseturfs = /turf/open/water
	slowdown = 1
	bullet_sizzle = TRUE
	bullet_bounce_sound = null //needs a splashing sound one day.

	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

	var/spread = TRUE

	var/turf/open/openspace/water/water_top

/turf/open/water/Initialize(mapload)
	. = ..()

	var/mutable_appearance/overlay = mutable_appearance('icons/turf/floors.dmi', "riverwater_motion")
	overlay.plane = ABOVE_GAME_PLANE
	overlay.layer = ABOVE_MOB_LAYER
	overlay.alpha = 200
	add_overlay(overlay)

	if(!spread)
		return
	update_water_effect()

/turf/open/water/proc/update_water_effect()
	if(!spread)
		return

	LAZYADD(SSliquids.liquid_turfs_list, src)

	var/turf/top_turf = SSmapping.get_turf_above(src)
	if(isopenspace(top_turf))
		water_top = top_turf.ChangeTurf(/turf/open/openspace/water)

/turf/open/water/spread_liquid()
	var/list/temp_turf_list = list()
	for(var/direction in GLOB.cardinals)
		temp_turf_list += get_step(src, direction)

	for(var/turf/T as() in temp_turf_list)

		if(!T || isclosedturf(T) || istype(T, /turf/open/water))
			continue

		T.ChangeTurf(/turf/open/water)

	return TRUE

/turf/open/water/Destroy(force)
	if(water_top)
		water_top.ChangeTurf(/turf/open/openspace)
	. = ..()

/turf/open/water/nospread
	spread = FALSE

/turf/open/openspace/water
	gender = FEMALE
	name = "вода"
	desc = "Глубокая..."
	intact = TRUE
	alpha = 160
	icon = 'icons/turf/floors.dmi'
	icon_state = "riverwater_motion"
	slowdown = 1
	bullet_sizzle = TRUE
	bullet_bounce_sound = null

	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

/turf/open/openspace/water/Entered(atom/movable/A)
	if(isliving(A))
		var/mob/living/L = A
		L.adjustStaminaLoss(1)
		L.movement_type |= FLOATING
	. = ..()

/turf/open/openspace/water/Exited(atom/movable/A, direction)
	. = ..()
	if(isliving(A))
		var/mob/living/L = A
		L.movement_type |= FLOATING
