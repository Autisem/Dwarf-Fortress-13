/obj/structure/table/stone
	name = "stone table"
	desc = "Caveman technology."
	icon = 'white/valtos/icons/stone_table.dmi'
	icon_state = "stone_table-0"
	base_icon_state = "stone_table"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 300
	buildstack = /obj/item/stack/sheet/stone
	smoothing_groups = list(SMOOTH_GROUP_BRONZE_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_BRONZE_TABLES)

/obj/structure/table/stone/attackby(obj/item/W, mob/user, params)
	if (W.tool_behaviour == TOOL_WRENCH || W.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_warning("How..."))
		return
	else
		return ..()
