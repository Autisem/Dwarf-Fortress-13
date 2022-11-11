/obj/item/food/slice

/obj/item/food/slice/plump_helmet
	name = "plump slice"
	desc = "Juicy slice of juicy mushroom."
	icon_state = "plump_slice"
	mood_event_type = /datum/mood_event/ate_raw_food/mild
	mood_gain = -2
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=15)

/obj/item/food/slice/meat
	name = "meat slice"
	desc = "Meat cutlet."
	icon_state = "meat_slice"
	mood_event_type = /datum/mood_event/ate_raw_food/meat
	mood_gain = -5
	mood_duration = 5 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=20)

/obj/item/food/slice/meat/troll
	name = "troll meat slice"
	desc = "Meat cutlet, made for a greater dishes."
	icon_state = "troll_slice"

/obj/item/food/slice/dough
	name = "dough slice"
	desc = "Cut piece of a dough"
	icon_state = "dough_slice"
	mood_event_type = /datum/mood_event/ate_raw_food/mild
	mood_gain = -4
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=20)

/obj/item/food/dough
	name = "dough"
	desc = "Dough for all kind of bakery."
	icon_state = "dough"
	mood_event_type = /datum/mood_event/ate_raw_food/mild
	mood_gain = -4
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=20)

/obj/item/food/flat_dough
	name = "flat dough"
	desc = "Mama mia!"
	icon_state = "dough_flat"
	mood_event_type = /datum/mood_event/ate_raw_food/mild
	mood_gain = -4
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=20)

/obj/item/food/dough/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/slice/dough, 3, 2 SECONDS)
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, /obj/item/food/flat_dough, 1, 2 SECONDS)

/obj/item/food/intestines
	name = "intestines"
	desc = "Used for sausage production."
	icon_state = "intestines"

/obj/item/food/intestines/stitched_casing
	name = "stitched casing"
	desc = ""
	icon_state = "sausage_casing"

/obj/item/food/intestines/stitched_casing/MakeEdible()
	return // not edible

/obj/item/food/intestines/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/sausage)

/obj/item/food/intestines/attack_self(mob/user, modifiers)
	to_chat(user, span_notice("You start tying up \the [src]..."))
	if(!do_after(user, 10 SECONDS, src))
		return
	var/datum/cooking_recipe/R = find_recipe(subtypesof(/datum/cooking_recipe/sausage), contents)
	var/mob/living/carbon/human/H = user
	if(!R)
		var/held_index = H.is_holding(src)
		qdel(src)
		var/obj/item/food/sausage/failed/S = new
		H.put_in_hand(S, held_index)
		return

	var/obj/item/food/F = new R.result
	var/held_index = H.is_holding(src)
	qdel(src)
	H.put_in_hand(F, held_index)
	to_chat(user, span_notice("You finish tying up \the [src]..."))

/obj/item/food/sausage
	name = "sausage"
	desc = "Best served roasted."
	icon_state = "sausage"
	mood_event_type = /datum/mood_event/ate_raw_food/meat
	mood_gain = -5
	mood_duration = 5 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=30)

/obj/item/food/sausage/luxurious
	food_reagents = list(/datum/reagent/consumable/nutriment=50)

/obj/item/food/sausage/failed // bad sausage; gives poop when cooked
