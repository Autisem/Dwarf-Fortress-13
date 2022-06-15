/obj/item/food/meat
	name = "meat"

/obj/item/food/meat/slab
	desc = "A slab of meat."
	icon_state = "meat"

/obj/item/food/meat/slab/human

/obj/item/food/meat/slab/goliath

/obj/item/food/meat/slab/troll
	name = "troll meat"

/obj/item/food/meat/slab/troll/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/slice/meat/troll, 3, 2 SECONDS)
