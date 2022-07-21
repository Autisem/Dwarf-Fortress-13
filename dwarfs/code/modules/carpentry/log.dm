/obj/item/log
	name = "log"
	desc = "Flat."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "log"
	throw_range = 0
	w_class = WEIGHT_CLASS_BULKY

/obj/item/log/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	pixel_x += rand(-8,8)
	pixel_y += rand(-8,8)

/obj/item/log/large
	name = "large log"
	desc = "Big flat."
	icon_state = "large_log"
	density = 1
	w_class = WEIGHT_CLASS_GIGANTIC

/obj/item/log/large/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	pixel_x = rand(-3,3)
	pixel_y = rand(-3,3)

/obj/item/log/large/pickup(mob/user)
	to_chat(user, span_notice("You start lifting [src]..."))
	if(!do_after(user, 10 SECONDS, src))
		return FALSE
	. = ..()

/obj/item/log/large/dropped(mob/user, silent)
	. = ..()
	dir = user.dir

/obj/item/log/towercap
	name = "towercap log"
	icon_state = "towercap_log"

/obj/item/log/large/towercap
	name = "large towercap log"
	icon_state = "large_towercap"
