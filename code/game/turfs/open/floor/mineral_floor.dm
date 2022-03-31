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
	name = "минеральный пол"
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

//GOLD

/turf/open/floor/mineral/gold
	name = "золотое покрытие"
	icon_state = "gold"
	floor_tile = /obj/item/stack/tile/mineral/gold
	icons = list("gold","gold_dam")
	custom_materials = list(/datum/material/gold = 500)

//SILVER

/turf/open/floor/mineral/silver
	name = "серебряное покрытие"
	icon_state = "silver"
	floor_tile = /obj/item/stack/tile/mineral/silver
	icons = list("silver","silver_dam")
	custom_materials = list(/datum/material/silver = 500)

//DIAMOND

/turf/open/floor/mineral/diamond
	name = "алмазное покрытие"
	icon_state = "diamond"
	floor_tile = /obj/item/stack/tile/mineral/diamond
	icons = list("diamond","diamond_dam")
	custom_materials = list(/datum/material/diamond = 500)
