/turf/open/floor/glass
	name = "стеклянный пол"
	desc = "Не прыгай по нему! Или прыгай. Я не твоя мамаша."
	icon = 'icons/turf/floors/glass.dmi'
	icon_state = "glass-0"
	base_icon_state = "glass"
	baseturfs = /turf/open/openspace
	intact = FALSE //this means wires go on top
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	floor_tile = /obj/item/stack/tile

/turf/open/floor/glass/setup_broken_states()
	return list("glass-damaged1", "glass-damaged2", "glass-damaged3")


/turf/open/floor/glass/Initialize()
	icon_state = "" //Prevent the normal icon from appearing behind the smooth overlays
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/glass/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency)


/turf/open/floor/glass/reinforced
	name = "армированный стеклянный пол"
	desc = "Не прыгай по нему! Он выдержит."
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "reinf_glass-0"
	base_icon_state = "reinf_glass"
	floor_tile = /obj/item/stack/tile

/turf/open/floor/glass/reinforced/setup_broken_states()
	return list("reinf_glass-damaged1", "reinf_glass-damaged2", "reinf_glass-damaged3")
