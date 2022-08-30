/obj/item/storage/ore
	name = "ore bag"
	desc = "How does it work?"
	component_type = /datum/component/storage/concrete/stack

/obj/item/storage/ore/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/stack/STR = GetComponent(/datum/component/storage/concrete/stack)
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.max_combined_stack_amount = 50
	STR.set_holdable(/obj/item/stack/ore)
