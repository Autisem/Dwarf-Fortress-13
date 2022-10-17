/obj/item/torch_handle
	name = "torch handle"
	desc = "Put torch here."
	icon = 'dwarfs/icons/items/equipment.dmi'
	icon_state = "torch_empty"

/obj/item/torch_handle/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/growable/cave_wheat) || istype(I, /obj/item/growable/barley))
		to_chat(user, span_notice("Torch>?"))
		var/mob/living/carbon/human/H = user
		var/obj/item/flashlight/fueled/torch/T = new()
		var/held_index = H.is_holding(src)
		if(held_index)
			qdel(src)
			H.put_in_hand(T, held_index)
		else
			T.forceMove(loc)
			qdel(src)
		qdel(I)
	else
		. = ..()

/obj/item/tool_handle
	name = "tool handle"
	desc = "Basic component needed for making tools."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "tool_handle"

/obj/item/weapon_hilt
	name = "weapon hilt"
	desc = "Protects you from slide cutting your hands off."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "sword_handle"

/obj/item/scepter_shaft
	name = "scepter shaft"
	desc = "Truly royal scepter shaft. Will look great in king's hands."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "scepter_shaft"
