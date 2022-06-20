/obj/item/stack/tile
	name = "сломанная плитка"
	singular_name = "broken tile"
	desc = "Сломанная плитка. Её не должно быть."
	lefthand_file = 'icons/mob/inhands/misc/tiles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/tiles_righthand.dmi'
	icon = 'icons/obj/tiles.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	novariants = TRUE
	/// What type of turf does this tile produce.
	var/turf_type = null
	/// Determines certain welder interactions.
	var/mineralType = null
	/// Cached associative lazy list to hold the radial options for tile reskinning. See tile_reskinning.dm for more information. Pattern: list[type] -> image
	var/list/tile_reskin_types


/obj/item/stack/tile/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3) //randomize a little
	if(tile_reskin_types)
		tile_reskin_types = tile_reskin_list(tile_reskin_types)


/obj/item/stack/tile/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(throwforce) //do not want to divide by zero or show the message to borgs who can't throw
		var/verb
		switch(CEILING(MAX_LIVING_HEALTH / throwforce, 1)) //throws to crit a human
			if(1 to 3)
				verb = "ideal"
			if(4 to 6)
				verb = "amazing"
			if(7 to 9)
				verb = "good"
			if(10 to 12)
				verb = "regular"
			if(13 to 15)
				verb = "decent"
		if(!verb)
			return
		. += span_notice("Can be used as [verb] throwing wepon.")

/obj/item/stack/tile/proc/place_tile(turf/open/T)
	if(!turf_type || !use(1))
		return
	. = T.PlaceOnTop(turf_type, flags = CHANGETURF_INHERIT_AIR)

/obj/item/stack/tile/material
