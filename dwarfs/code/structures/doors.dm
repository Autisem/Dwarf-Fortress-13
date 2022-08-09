/obj/structure/mineral_door/heavystone
	name = "heavy stone door"
	icon = 'dwarfs/icons/structures/stonedoor.dmi'
	icon_state = "heavystone"
	max_integrity = 600
	var/locked_door = FALSE
	sheetType = /obj/item/stack/sheet/stone

/obj/structure/mineral_door/heavystone/examine(mob/user)
	. = ..()
	if(isdwarf(user))
		. += "<hr><span class='notice'>CTRL-click to [locked_door ? "un" : ""]lock \the [src].</span>"

/obj/structure/mineral_door/heavystone/CtrlClick(mob/user)
	. = ..()
	if(isdwarf(user) && !door_opened)
		visible_message(span_notice("<b>[user]</b> [locked_door ? "un" : ""]locks \the [src].") , null, COMBAT_MESSAGE_RANGE)
		locked_door = !locked_door
		playsound(get_turf(src), 'sound/effects/stonelock.ogg', 65, vary = TRUE)

/obj/structure/mineral_door/heavystone/SwitchState()
	if(locked_door)
		return FALSE
	. = ..()
