/obj/item/transfer_food
	name = "almost food"
	desc = "This shouldn't exist"
	icon = 'dwarfs/icons/items/food.dmi'
	//Our original container we cooking this stuff in
	var/original_container
	//Container we need to transfer your stuff to
	var/required_container
	//How many times we can transfer
	var/charges = 1
	//What food do we have inside src
	var/obj/item/food_inside

/obj/item/transfer_food/pre_attack(atom/O, mob/living/user, params)
	if(istype(O, required_container))
		if(O.reagents?.total_volume || O.contents.len)
			to_chat(user, span_warning("[O] has to be empty!"))
			return
		var/obj/item/I = new food_inside(O.loc)
		I.pixel_x = O.pixel_x
		I.pixel_y = O.pixel_y
		qdel(O)
		to_chat(user, span_notice("You transfer [initial(food_inside.name)] into [O]."))
		charges--
		if(charges)
			return
		var/mob/living/carbon/human/H = user
		var/held_index = H.is_holding(src)
		if(held_index)
			qdel(src)
			var/obj/item/C = new original_container
			H.put_in_hand(C, held_index)
		else
			new original_container(loc)
			qdel(src)
	else
		. = ..()


/obj/item/transfer_food/stew
	name = "stew in pot"
	desc = "Almost stew."
	food_inside = /obj/item/food/dish/dwarven_stew
	required_container = /obj/item/reagent_containers/glass/plate/bowl
	original_container = /obj/item/reagent_containers/glass/cooking_pot

/obj/item/transfer_food/beer_wurst
	name = "beer wurst in pan"
	desc = "Almost that."
	food_inside = /obj/item/food/dish/roasted_beer_wurst
	required_container = /obj/item/reagent_containers/glass/plate/regular
	original_container = /obj/item/reagent_containers/glass/pan

/obj/item/transfer_food/allwurst
	name = "allwurst in pan"
	desc = "Everything sausage."
	food_inside = /obj/item/food/dish/allwurst
	required_container = /obj/item/reagent_containers/glass/plate/regular
	original_container = /obj/item/reagent_containers/glass/pan
