/obj/item/growable
	name = "growable"
	desc = "Plant produce it."
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

/obj/item/growable/Initialize()
	. = ..()
	if(edible)
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

/obj/item/growable/fruit
	name = "fruit"
	desc = "Yummy! They also contain seeds."
	edible = TRUE
	icon = 'dwarfs/icons/farming/fruit.dmi'

/obj/item/growable/fruit/Initialize()
	. = ..()
	START_PROCESSING(SSplants, src)
	// TODO: fruits rot when not in storage

/obj/item/growable/fruit/Destroy()
	. = ..()
	STOP_PROCESSING(SSplants, src)

/obj/item/growable/leaf
	name = "leaf"
	desc = "Green stuff that comes from plants."
