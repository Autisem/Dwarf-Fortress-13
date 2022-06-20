/* In this file:
 *
 * Plasma floor
 * Gold floor
 * Silver floor
 * Bananium floor
 * Diamond floor
 * Uranium floor
 * Shuttle floor (Titanium)
 */

/turf/open/floor/mineral
	name = "mineral floor"
	icon_state = ""
	var/list/icons
	tiled_dirt = FALSE


/turf/open/floor/mineral/Initialize()
	. = ..()
	icons = typelist("icons", icons)

/turf/open/floor/mineral/setup_broken_states()
	return list("[initial(icon_state)]_dam")

/turf/open/floor/mineral/update_icon()
	. = ..()
	if(!.)
		return
	if(!broken && !burnt)
		if( !(icon_state in icons) )
			icon_state = initial(icon_state)
