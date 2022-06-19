/obj/item/reagent_containers/glass/sack
	name = "sack"
	desc = "sack of balls"
	icon = 'dwarfs/icons/items/kitchen.dmi'
	icon_state = "bag"
	volume = 80
	allowed_reagents = list(/datum/reagent/grain, /datum/reagent/flour)
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list()

/obj/item/reagent_containers/glass/sack/examine(mob/user)
	. = ..()
	if(!reagents.total_volume)
		.+="<br>It's empty."
	else
		.+="<br>It has [reagents.get_reagent_names()] in it."

/obj/item/reagent_containers/glass/sack/update_icon(updates)
	. = ..()
	if(reagents.has_reagent_subtype(/datum/reagent/grain))
		icon_state = "bag_grain"
	else if(reagents.has_reagent_subtype(/datum/reagent/flour))
		icon_state = "bag_flour"
	else
		icon_state = "bag"

/obj/item/reagent_containers/glass/cooking_pot
	name = "cooking pot"
	desc = "boomer"
	icon = 'dwarfs/icons/items/kitchen.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "cooking_pot_open"
	amount_per_transfer_from_this = 10
	volume = 50
	var/open = TRUE

/obj/item/reagent_containers/glass/cooking_pot/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)

/obj/item/reagent_containers/glass/cooking_pot/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	find_recipe()

/obj/item/reagent_containers/glass/cooking_pot/Exited(atom/movable/gone, direction)
	. = ..()
	find_recipe()

/obj/item/reagent_containers/glass/cooking_pot/on_reagent_change(datum/reagents/holder, ...)
	. = ..()
	find_recipe()

/obj/item/reagent_containers/glass/cooking_pot/update_overlays()
	. = ..()
	if(open && reagents.total_volume)
		var/mutable_appearance/M = mutable_appearance("dwarfs/icons/items/kitchen.dmi", "cooking_pot_overlay")
		M.color = mix_color_from_reagents(reagents.reagent_list)
		. += M

/obj/item/reagent_containers/glass/cooking_pot/update_icon_state()
	. = ..()
	if(open)
		icon_state = "cooking_pot_open"
	else
		icon_state = "cooking_pot_closed"

/obj/item/reagent_containers/glass/cooking_pot/attack_self_secondary(mob/user, modifiers)
	open = !open
	update_appearance()
	to_chat(user, span_notice("You [open?"open":"close"] [src]."))
	amount_per_transfer_from_this = open ? initial(amount_per_transfer_from_this) : 0 // cannot transfer reagents when closed

/obj/item/reagent_containers/glass/plate
	icon = 'dwarfs/icons/items/kitchen.dmi'

/obj/item/reagent_containers/glass/plate/Initialize(mapload, vol)
	. = ..()
	AddComponent(/datum/component/storage/concrete/debug)
/obj/item/reagent_containers/glass/plate/regular
	name = "plate"
	desc = "Good for holding some food inside it."
	icon_state = "wooden_plate"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list()
	volume = 50

/obj/item/reagent_containers/glass/plate/regular/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/kitchen/knife))
		var/datum/cooking_recipe/R = find_recipe(subtypesof(/datum/cooking_recipe/plate), contents)
		var/mob/living/carbon/human/H = user
		if(!R)
			var/held_index = H.is_holding(src)
			if(held_index)
				qdel(src)
				var/obj/item/food/badrecipe/S = new
				H.put_in_hand(S, held_index)
			else
				new /obj/item/food/badrecipe(loc)
				qdel(src)

		var/obj/item/food/F = new R.result
		var/held_index = H.is_holding(src)
		if(held_index)
			qdel(src)
			H.put_in_hand(F, held_index)
		else
			F.forceMove(loc)
			qdel(src)
	else
		. = ..()

/obj/item/reagent_containers/glass/plate/flat
	name = "flat plate"
	desc = "Holds food a bit worse than a ragular plate."
	icon_state = "fancy_plate"

/obj/item/reagent_containers/glass/plate/bowl
	name = "bowl"
	desc = "Deep plate."
	icon_state = "wooden_bowl"

/obj/item/reagent_containers/glass/pan
	name = "frying pan"
	desc = "Used to fry stuff."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "skillet"

/obj/item/reagent_containers/glass/pan/Initialize(mapload, vol)
	. = ..()
	AddComponent(/datum/component/storage/concrete/debug)
