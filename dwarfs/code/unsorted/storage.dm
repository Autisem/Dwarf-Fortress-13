/obj/item/storage/soil
	name = "soil bag"
	desc = "How does it work?"
	icon = 'dwarfs/icons/items/storage.dmi'
	icon_state = "soil_bag"
	worn_icon = 'dwarfs/icons/mob/clothing/back.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	component_type = /datum/component/storage/concrete/stack

/obj/item/storage/ore/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/stack/STR = GetComponent(/datum/component/storage/concrete/stack)
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.max_combined_stack_amount = 50
	STR.set_holdable(list(
		/obj/item/stack/dirt,
		/obj/item/stack/sand
	))
