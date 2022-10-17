/obj/structure/table/stone
	name = "stone table"
	desc = "Caveman technology, but at least you can eat on it."
	icon = 'dwarfs/icons/structures/stone_table.dmi'
	icon_state = "stone_table-0"
	base_icon_state = "stone_table"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 300
	buildstack = /obj/item/stack/sheet/stone

/obj/structure/table/stone/attackby(obj/item/W, mob/user, params)
	if (W.tool_behaviour == TOOL_WRENCH || W.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_warning("How..."))
		return
	else
		return ..()

/obj/structure/table/wood
	name = "wooden table"
	desc = ""
	icon = 'dwarfs/icons/structures/wood_table.dmi'
	icon_state = "wood_table-0"
	base_icon_state = "wood_table"
	buildstack = /obj/item/stack/sheet/planks
