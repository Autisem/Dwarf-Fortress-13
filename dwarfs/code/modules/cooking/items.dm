/obj/item/stick
	name = "stick"
	desc = "Stick. That's just stick."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "tool_handle"

/obj/item/stick/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/stick)

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
		var/datum/cooking_recipe/R = find_recipe(subtypesof(/datum/cooking_recipe/stick), contents)
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
		update_appearance()

// /obj/item/stick/attack_obj(obj/O, mob/living/user, params) // removed fireplace - replace it later with bonefire
// 	if(istype(O, /obj/structure/fireplace))
// 		var/datum/cooking_recipe/R = find_recipe(subtypesof(/datum/cooking_recipe/stick), contents)
// 		var/mob/living/carbon/human/H = user
// 		if(!R)
// 			var/held_index = H.is_holding(src)
// 			if(held_index)
// 				qdel(src)
// 				var/obj/item/food/badrecipe/S = new
// 				H.put_in_hand(S, held_index)
// 			else
// 				new /obj/item/food/badrecipe(loc)
// 				qdel(src)

// 		var/obj/item/food/F = new R.result
// 		var/held_index = H.is_holding(src)
// 		if(held_index)
// 			qdel(src)
// 			H.put_in_hand(F, held_index)
// 		else
// 			F.forceMove(loc)
// 			qdel(src)
// 	else
// 		. = ..()

/obj/item/stack/sheet/tallow
	name = "tallow"
	desc = "Pure grease, do not use it while it's raining."
	singular_name = "Tallow"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "tallow"
	inhand_icon_state = "sheet-metal"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/stack/sheet/tallow/get_fuel()
	return 2 * amount

GLOBAL_LIST_INIT(tallow_recipes, list (
	new/datum/stack_recipe("Candle", /obj/item/flashlight/fueled/candle, 4,,,30),
))
//new/datum/stack_recipe(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1,time = 0)
/obj/item/stack/sheet/tallow/get_main_recipes()
	. = ..()
	. += GLOB.tallow_recipes
