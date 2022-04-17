/datum/material/stone
	name = "stone"
	desc = "Oldfag."
	color = "#878687"
	sheet_type = /obj/item/stack/sheet/stone

/obj/item/stack/ore/stone
	name = "stone"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "stone"
	singular_name = "Stone piece"
	max_amount = 1
	refined_type = /obj/item/stack/sheet/stone
	merge_type = /obj/item/stack/ore/stone

/obj/item/stack/ore/stone/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/blacksmith/chisel))
		playsound(src, 'white/valtos/sounds/tough.wav', 100, TRUE)
		if(prob(25))
			to_chat(user, span_warning("You process \the [src]."))
			return
		new /obj/item/stack/sheet/stone(user.loc)
		to_chat(user, span_notice("You process \the [src]."))
		qdel(src)
		return
	if(istype(I, /obj/item/blacksmith/smithing_hammer))
		playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE)
		new /obj/item/stack/ore/glass(drop_location())
		to_chat(user, span_notice("You smash \the [src]."))
		qdel(src)
		return

/obj/item/stack/sheet/stone
	name = "brick"
	desc = "Used in building."
	singular_name = "Brick"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "block"
	inhand_icon_state = "sheet-metal"
	force = 10
	throwforce = 10
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_TINY
	merge_type = /obj/item/stack/sheet/stone
	material_type = /datum/material/stone
	matter_amount = 4
	cost = 500
