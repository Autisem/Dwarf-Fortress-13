/obj/item/reagent_containers/sack
	name = "sack"
	desc = "sack of balls"
	icon = 'dwarfs/icons/items/kitchen.dmi'
	icon_state = "bag"
	volume = 80
	allowed_reagents = list(/datum/reagent/grain, /datum/reagent/flour)
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list()

/obj/item/reagent_containers/sack/update_icon(updates)
	. = ..()
	if(contents.len || reagents.has_reagent_subtype(/datum/reagent/grain))
		icon_state = "bag_grain"
	else if(reagents.has_reagent_subtype(/datum/reagent/flour))
		icon_state = "bag_flour"
	else
		icon_state = "bag"
