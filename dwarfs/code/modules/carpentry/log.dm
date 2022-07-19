/obj/item/log
	name = "log"
	desc = "Flat."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "log"

/obj/item/log/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	pixel_x += rand(-8,8)
	pixel_y += rand(-8,8)

/obj/item/log/towercap
	name = "towercap log"
	icon_state = "towercap_log"
