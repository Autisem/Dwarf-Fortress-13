/obj/item/food/dish
	var/plate_type

/obj/item/food/dish/MakeEdible()
	AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				eatverbs = eatverbs,\
				bite_consumption = bite_consumption,\
				on_consume = CALLBACK(src, .proc/on_consume))

/obj/item/food/dish/proc/on_consume(mob/living/eater, mob/living/feeder)
	if(plate_type)
		var/mob/living/carbon/human/H = feeder
		var/held_index = H.is_holding(src)
		if(held_index)
			var/obj/item/I = new plate_type
			qdel(src)
			H.put_in_hand(I, held_index)
		else
			new plate_type(get_turf(feeder))

//**********************FIRST TIER DISHES*****************************//
/obj/item/food/dish/plump_with_steak
	name = "plump with steak"
	desc = "Medium rare."
	icon_state = "plump_n_steak"
	plate_type = /obj/item/reagent_containers/glass/plate/regular
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

/obj/item/food/dish/plump_skewer
	name = "plump skewer"
	desc = ""
	icon_state = "plump_kebab"
	plate_type = /obj/item/stick
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

/obj/item/food/dish/salad
	name = "salad"
	desc = "Almost green."
	icon_state = "salad"
	plate_type = /obj/item/reagent_containers/glass/plate/regular
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

//**********************SECOND TIER DISHES*****************************//

/obj/item/food/dish/dwarven_stew
	name = "dwarven stew"
	desc = ""
	icon_state = "swarven_stew"
	plate_type = /obj/item/reagent_containers/glass/cooking_pot
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

/obj/item/food/dish/plump_pie
	name = "plump pie"
	desc = ""
	icon_state = "plump_pie"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

/obj/item/food/dish/roasted_beer_wurst
	name = "roasted beer wurst"
	desc = ""
	icon_state = "beer_wurst"
	plate_type = /obj/item/reagent_containers/glass/pan
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

//**********************THIRD TIER DISHES*****************************//

/obj/item/food/dish/balanced_roll
	name = "balanced roll"
	desc = ""
	icon_state = "gyros"
	plate_type = /obj/item/reagent_containers/glass/plate/flat
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

/obj/item/food/dish/troll_delight
	name = "troll's delight"
	desc = ""
	icon_state = "troll_delight"
	plate_type = /obj/item/reagent_containers/glass/plate/flat
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

/obj/item/food/dish/allwurst
	name = "allwurst"
	desc = ""
	icon_state = "allwurst"
	plate_type = /obj/item/reagent_containers/glass/pan
	food_reagents = list(/datum/reagent/consumable/nutriment=1)
