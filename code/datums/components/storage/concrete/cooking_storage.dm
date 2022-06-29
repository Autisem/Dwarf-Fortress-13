/datum/component/storage/concrete/cooking
	can_hold = list(/obj/item/growable, /obj/item/food)
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = 50 //dunno, just so everything fits
	rustle_sound = null

// /datum/component/storage/concrete/cooking/remove_from_storage(atom/movable/AM, atom/new_location)
// 	. = ..()
// 	var/obj/P = parent
// 	P.update_appearance()

// /datum/component/storage/concrete/cooking/mob_item_insertion_feedback(mob/user, mob/M, obj/item/I, override)
// 	. = ..()
// 	var/obj/P = parent
// 	P.update_appearance()

/datum/component/storage/concrete/cooking/pan
	max_items = 5

/datum/component/storage/concrete/cooking/pot
	max_items = 8

/datum/component/storage/concrete/cooking/stick
	max_items = 5

/datum/component/storage/concrete/cooking/plate
	max_items = 8

/datum/component/storage/concrete/cooking/sausage
	max_items = 6