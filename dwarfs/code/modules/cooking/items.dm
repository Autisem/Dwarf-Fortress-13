/obj/item/stick
	name = "stick"
	desc = "Stick."
	//no icon :(
	icon = 'dwarfs/icons/items/parts.dmi'
	icon_state = "scepter_shaft"

/obj/item/stick/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/debug)

/obj/item/stick/update_overlays()
	. = ..()
	for(var/i=1;i<=contents.len;i++)
		var/obj/item/item = contents[i]
		var/mutable_appearance/M = mutable_appearance(item.icon, item.icon_state)
		M.pixel_x = (12 + 3*(i-1))-16
		M.pixel_y = (12 + 3*(i-1))-16
		M.transform = turn(M.transform, 360*sin(i*30))
		M.transform *= 0.6
		.+=M

/obj/item/stick/attackby(obj/item/I, mob/user, params)
	if(I.get_temperature())
		var/list/d = find_recipe(subtypesof(/datum/cooking_recipe/stick), contents)
		var/mob/living/carbon/human/H = user
		if(!d)
			var/held_index = H.is_holding(src)
			if(held_index)
				qdel(src)
				var/obj/item/food/sausage/S = new
				H.put_in_hand(S, held_index)
			else
				new /obj/item/food/sausage(loc)
				qdel(src)
		var/datum/cooking_recipe/R = d[1]
		var/perfect_recipe = d[2]

		if(perfect_recipe)
			var/obj/item/food/F = new R.result
			var/held_index = H.is_holding(src)
			if(held_index)
				qdel(src)
				H.put_in_hand(F, held_index)
			else
				F.forceMove(loc)
				qdel(src)
		else
			var/obj/item/food/F = new R.custom_result
			F.transfer_nutrients_from(src)
			var/held_index = H.is_holding(src)
			if(held_index)
				qdel(src)
				H.put_in_hand(F, held_index)
			else
				F.forceMove(loc)
				qdel(src)
	else
		. = ..()
		update_appearance()

/obj/item/stick/attack_obj(obj/O, mob/living/user, params)
	if(istype(O, /obj/structure/fireplace))
		var/list/d = find_recipe(subtypesof(/datum/cooking_recipe/stick), contents)
		var/mob/living/carbon/human/H = user
		if(!d)
			var/held_index = H.is_holding(src)
			if(held_index)
				qdel(src)
				var/obj/item/food/sausage/S = new
				H.put_in_hand(S, held_index)
			else
				new /obj/item/food/sausage(loc)
				qdel(src)
		var/datum/cooking_recipe/R = d[1]
		var/perfect_recipe = d[2]

		if(perfect_recipe)
			var/obj/item/food/F = new R.result
			var/held_index = H.is_holding(src)
			if(held_index)
				qdel(src)
				H.put_in_hand(F, held_index)
			else
				F.forceMove(loc)
				qdel(src)
		else
			var/obj/item/food/F = new R.custom_result
			F.transfer_nutrients_from(src)
			var/held_index = H.is_holding(src)
			if(held_index)
				qdel(src)
				H.put_in_hand(F, held_index)
			else
				F.forceMove(loc)
				qdel(src)
	else
		. = ..()

/obj/item/spoon
	name = "spoon"
	desc = "Spooooooooooon."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	icon_state = "spoon"
