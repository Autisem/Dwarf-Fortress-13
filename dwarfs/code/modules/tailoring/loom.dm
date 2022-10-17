/obj/structure/loom
	name = "loom"
	desc = "Nobody ever told anyone that weaving is easy. Neither fun."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "loom"
	var/working = FALSE

/obj/structure/loom/update_icon_state()
	. = ..()
	if(working)
		icon_state = "loom_workoing"
	else
		icon_state = "loom"

/obj/structure/loom/update_overlays()
	. = ..()
	if(working)
		var/mutable_appearance/M = mutable_appearance(icon, "loom_working_overlay")
		. += M
