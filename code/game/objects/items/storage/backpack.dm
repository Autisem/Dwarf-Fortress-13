/obj/item/storage/satchel
	name = "satchel"
	desc = "You wear this on your back and put items into it."
	icon = 'dwarfs/icons/items/storage.dmi'
	worn_icon = 'dwarfs/icons/mob/clothing/back.dmi'
	icon_state = "satchel"
	inhand_icon_state = "satchel"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/backpack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_items = 21
