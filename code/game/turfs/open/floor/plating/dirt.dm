/turf/open/floor/plating/dirt
	gender = PLURAL
	name = "грязь"
	desc = "При более тщательном рассмотрении, это все еще грязь."
	icon = 'icons/turf/floors.dmi'
	icon_state = "dirt"
	baseturfs = /turf/open/chasm/jungle
	attachment_holes = FALSE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/plating/dirt/dark
	icon_state = "greenerdirt"

/turf/open/floor/plating/dirt/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return
