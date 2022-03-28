/obj/item/growable
	name = "growable"
	desc = "Plant produce it."
	icon = 'dwarfs/icons/farming/growable.dmi'
	var/edible = FALSE // some types are edible; some seeds are edible
	var/seed_type // if contains seeds it can be processed to get them, except seeds ofc
	var/list/food_reagents
	var/food_flags
	var/foodtypes
	var/max_volume
	var/eat_time
	var/list/tastes
	// var/list/eatverbs
	var/bite_consumption
	// PROCESSING VARS
	var/juice_type // can it be made into juice?
	var/juice_volume = 10

/obj/item/growable/Initialize()
	. = ..()
	if(edible)
		if(!food_reagents)
			food_reagents = list(/datum/reagent/consumable/nutriment=5)
		AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				bite_consumption = bite_consumption)

/obj/item/growable/pod
	name = "pod"
	desc = "Not edible structure containing seeds."

/obj/item/growable/Initialize()
	. = ..()
	pixel_x = base_pixel_x + rand(-8, 8)
	pixel_y = base_pixel_y + rand(-8, 8)
	START_PROCESSING(SSplants, src)
	// TODO: fruits rot when not in storage

/obj/item/growable/fruit/Destroy()
	. = ..()
	STOP_PROCESSING(SSplants, src)

/obj/item/growable/leaf
	name = "leaf"
	desc = "Green stuff that comes from plants."

/obj/item/growable/apple
	name = "apple"
	desc = "Red?"
	icon_state = "apple"
	edible = TRUE
	bite_consumption = 100
	foodtypes = FRUIT
	max_volume = 100
	bite_consumption = 1
	food_reagents = list(/datum/reagent/consumable/applejuice = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("apple" = 1)

/obj/item/growable/cave_wheat
	name = "cave wheat"
	desc = ""
	icon_state = "cave_wheat"
	seed_type = /obj/item/growable/seeds/cave_wheat

/obj/item/growable/barley
	name = "barley"
	desc = ""
	icon_state = "barley"
	seed_type = /obj/item/growable/seeds/barley

/obj/item/growable/turnip
	name = "turnip"
	desc = ""
	icon_state = "turnip"
	seed_type = /obj/item/growable/seeds/turnip
	edible = TRUE

/obj/item/growable/carrot
	name = "carrot"
	desc = ""
	icon_state = "carrot"
	seed_type = /obj/item/growable/seeds/carrot
	edible = TRUE

/obj/item/growable/cotton
	name = "cotton"
	desc = ""
	icon_state = "cotton"
	seed_type = /obj/item/growable/seeds/cotton

/obj/item/growable/sweet_pod
	name = "sweet pod"
	desc = ""
	icon_state = "sweet_pod"
	seed_type = /obj/item/growable/seeds/sweet_pod
	edible = TRUE

/obj/item/growable/pig_tail
	name = "pig tail"
	desc = ""
	icon_state = "pig_tail"
	seed_type = /obj/item/growable/seeds/pig_tail

/obj/item/growable/plump_helmet
	name = "plump helmet"
	desc = ""
	icon_state = "plump_helmet"
	seed_type = /obj/item/growable/seeds/plump_helmet
	edible = TRUE
	juice_type = /datum/reagent/plumpjuice

/datum/reagent/plumpjuice
	name = "plump juice"
	color = "#b35313"
