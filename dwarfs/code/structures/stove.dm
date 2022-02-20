/obj/machinery/microwave/furnace
	name = "stove"
	icon = 'white/valtos/icons/peeech.dmi'
	icon_state = "peeech"
	use_power = NO_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	efficiency = 4

/obj/machinery/microwave/furnace/update_icon_state()
	if(broken)
		icon_state = "peech"
	else if(dirty_anim_playing)
		icon_state = "peech"
	else if(dirty == 100)
		icon_state = "peech"
	else if(operating)
		icon_state = "peech1"
	else if(panel_open)
		icon_state = "peech"
	else
		icon_state = "peech"
	return ..()

/obj/machinery/microwave/furnace/attackby(obj/item/O, mob/user, params)
	efficiency = 4
	broken = 0
	dirty = 0
	if(is_wire_tool(O))
		return FALSE
	..()
