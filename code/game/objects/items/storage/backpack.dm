/* Backpacks
 * Contains:
 *		Backpack
 *		Backpack Types
 *		Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "рюкзак"
	desc = "Ты носишь это на спине и кладешь туда вещи."
	icon_state = "backpack"
	inhand_icon_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK	//ERROOOOO
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/backpack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_items = 21

/*
 * Backpack Types
 */

/obj/item/storage/backpack/old/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 12

/obj/item/bag_of_holding_inert
	name = "инертная блюспейс сумка"
	desc = "То, что в настоящее время представляет собой просто громоздкий металлический блок со слотом, готовым принять ядро блюспейс аномалии."
	icon = 'icons/obj/storage.dmi'
	icon_state = "brokenpack"
	inhand_icon_state = "brokenpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "сумка"
	desc = "Модная сумка."
	icon_state = "satchel-norm"
	inhand_icon_state = "satchel-norm"
	gender = FEMALE // прикол

/obj/item/storage/backpack/satchel/leather
	name = "кожаная сумка"
	desc = "Это очень модная сумка из тонкой кожи."
	icon_state = "satchel"
	inhand_icon_state = "satchel"

/obj/item/storage/backpack/satchel/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag
	name = "вещмешок"
	desc = "Большая сумка для хранения лишних вещей."
	icon_state = "duffel"
	inhand_icon_state = "duffel"
	slowdown = 1

/obj/item/storage/backpack/duffelbag/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 30
