/obj/structure/mineral_door/detailed_door
	name = "majestic stone door"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "detaileddoor"
	max_integrity = 600
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	var/locked_door = FALSE
	sheetType = /obj/item/stack/sheet/stone

/obj/structure/mineral_door/detailed_door/examine(mob/user)
	. = ..()
	if(isdwarf(user))
		. += "<hr><span class='notice'>CTRL-click to [locked_door ? "un" : ""]lock \the [src].</span>"

/obj/structure/mineral_door/detailed_door/CtrlClick(mob/user)
	. = ..()
	if(isdwarf(user) && !door_opened)
		visible_message(span_notice("<b>[user]</b> [locked_door ? "un" : ""]locks \the [src].") , null, COMBAT_MESSAGE_RANGE)
		locked_door = !locked_door
		playsound(get_turf(src), 'white/valtos/sounds/stonelock.ogg', 65, vary = TRUE)

/obj/structure/mineral_door/detailed_door/SwitchState()
	if(locked_door)
		return FALSE
	. = ..()
/obj/structure/mineral_door/heavystone
	name = "heavy stone door"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "heavystone"
	max_integrity = 600
	smoothing_groups = list(SMOOTH_GROUP_INDUSTRIAL_LIFT)
	var/locked_door = FALSE
	sheetType = /obj/item/stack/sheet/stone
	var/busy = FALSE

/obj/structure/mineral_door/heavystone/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/blacksmith/chisel))
		if(busy)
			to_chat(user, span_warning("Currently busy."))
			return
		busy = TRUE
		if(!do_after(user, 10 SECONDS, target = src))
			busy = FALSE
			return
		busy = FALSE
		to_chat(user, span_warning("You detail [src]."))
		var/obj/structure/mineral_door/D = new /obj/structure/mineral_door/detailed_door(loc)
		D.dir = dir
		qdel(src)


/obj/structure/mineral_door/heavystone/examine(mob/user)
	. = ..()
	if(isdwarf(user))
		. += "<hr><span class='notice'>CTRL-click to [locked_door ? "un" : ""]lock \the [src].</span>"

/obj/structure/mineral_door/heavystone/CtrlClick(mob/user)
	. = ..()
	if(isdwarf(user) && !door_opened)
		visible_message(span_notice("<b>[user]</b> [locked_door ? "un" : ""]locks \the [src].") , null, COMBAT_MESSAGE_RANGE)
		locked_door = !locked_door
		playsound(get_turf(src), 'white/valtos/sounds/stonelock.ogg', 65, vary = TRUE)

/obj/structure/mineral_door/heavystone/SwitchState()
	if(locked_door)
		return FALSE
	. = ..()
