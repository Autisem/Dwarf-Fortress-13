/obj/structure/loom
	name = "loom"
	desc = "Nobody ever told anyone that weaving is easy. Neither fun."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "loom"
	var/working = FALSE
	var/ready = FALSE

/obj/structure/loom/update_icon_state()
	. = ..()
	if(working)
		icon_state = "loom_working"
	else
		icon_state = "loom"

/obj/structure/loom/update_overlays()
	. = ..()
	if(working)
		var/mutable_appearance/M = mutable_appearance(icon, "loom_working_overlay")
		. += M
	else if(ready)
		var/mutable_appearance/M = mutable_appearance(icon, "loom_ready_overlay")
		. += M

/obj/structure/loom/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet/string))
		var/obj/item/stack/S = I
		if(!S.use(5))
			to_chat(user, span_warning("Not enough strings!"))
			return
		if(ready)
			to_chat(user, span_warning("[src] is already set up!"))
			return
		ready = TRUE
		to_chat(user, span_notice("You set up [src]."))
		update_appearance()
	else
		. = ..()

/obj/structure/loom/attack_hand(mob/user)
	if(!ready)
		to_chat(user, span_warning("[src] is not ready."))
		return
	if(working)
		to_chat(user, span_warning("Somebody is already working at [src]!"))
		return
	working = TRUE
	update_appearance()
	to_chat(user, span_notice("You start working at [src]..."))
	if(do_after(user, 15 SECONDS, src))
		to_chat(user, span_notice("You finish working at [src]."))
		ready = FALSE
		new /obj/item/stack/sheet/cloth(get_turf(src), 2)
	working = FALSE
	update_appearance()
