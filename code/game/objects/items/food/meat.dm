/obj/item/food/meat
	name = "meat"
	desc = "Beat it."
	mood_event_type = /datum/mood_event/ate_raw_food/meat
	food_reagents = list(/datum/reagent/consumable/nutriment=50)

/obj/item/food/meat/slab
	desc = "A slab of meat."
	icon_state = "meat"

/obj/item/food/meat/slab/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/slice/meat, 3, 2 SECONDS)

/obj/item/food/meat/slab/human
	desc = "You probably should not eat this one."

/obj/item/food/meat/slab/troll
	name = "troll meat"
	desc = "Slab of a troll meat. Made for a greater dishes."
	icon_state = "troll_meat"

/obj/item/food/meat/slab/troll/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/slice/meat/troll, 3, 2 SECONDS)
