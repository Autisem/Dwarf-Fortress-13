/obj/item/stack/sheet/animalhide
	name = "hide"
	desc = "Something went wrong."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "sheet-hide"
	inhand_icon_state = "sheet-hide"
	novariants = TRUE
	max_amount = 1
	var/leather_amount = 5
	merge_type = /obj/item/stack/sheet/animalhide
	var/damaged_type = /obj/item/stack/sheet/animalhide/damaged

/obj/item/stack/sheet/animalhide/damaged

/obj/item/stack/sheet/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "hide_cat"
	inhand_icon_state = "sheet-cat"
	leather_amount = 2
	merge_type = /obj/item/stack/sheet/animalhide/cat
	damaged_type = /obj/item/stack/sheet/animalhide/cat/damaged

/obj/item/stack/sheet/animalhide/cat/damaged
	name = "torn cat hide"
	leather_amount = 1
	singular_name = "torn cat hide piece"

/obj/item/stack/sheet/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of its hair, but still needs washing and tanning."
	singular_name = "hairless hide piece"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "raw_hide"
	inhand_icon_state = "sheet-hairlesshide"
	var/leather_amount
	max_amount = 1
	merge_type = /obj/item/stack/sheet/hairlesshide

/obj/item/stack/sheet/wethide
	name = "wet hide"
	desc = "This hide has been cleaned but still needs to be dried."
	singular_name = "wet hide piece"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "wet_hide"
	inhand_icon_state = "sheet-wetleather"
	merge_type = /obj/item/stack/sheet/wethide
	max_amount = 1
	var/leather_amount
	/// Reduced when exposed to high temperatures
	var/wetness = 30
	/// Kelvin to start drying
	var/drying_threshold_temperature = 500

/obj/item/stack/sheet/wethide/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	AddElement(/datum/element/dryable, /obj/item/stack/sheet/dryhide)

/obj/item/stack/sheet/dryhide
	name = "dry hide"
	desc = "This hide has been cleaned and dried but it still needs to be exposed to tanin."
	singular_name = "dry hide piece"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "dry_hide"
	merge_type = /obj/item/stack/sheet/dryhide
	max_amount = 1
	var/leather_amount

/*
 * Leather SHeet
 */
/obj/item/stack/sheet/leather
	name = "leather"
	desc = "A by-product of animal farming."
	singular_name = "piece of leather"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "leather"
	inhand_icon_state = "sheet-leather"
	merge_type = /obj/item/stack/sheet/leather

GLOBAL_LIST_INIT(leather_recipes, list (
	new/datum/stack_recipe("Backpack", /obj/item/storage/satchel),
	new/datum/stack_recipe("Ore Bag", /obj/item/storage/ore)
))

/obj/item/stack/sheet/leather/get_main_recipes()
	. = ..()
	. += GLOB.leather_recipes

/*Plates*/
/obj/item/stack/sheet/animalhide/goliath_hide
	name = "goliath hide plate"
	desc = "Pieces of a goliath's rocky hide, these might be able to make your suit a bit more durable to attack from the local fauna."
	icon = 'icons/obj/mining.dmi'
	icon_state = "goliath_hide"
	singular_name = "hide plate"
	max_amount = 6
	novariants = FALSE
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER
	merge_type = /obj/item/stack/sheet/animalhide/goliath_hide

//Step one - dehairing.

/obj/item/stack/sheet/animalhide/attackby(obj/item/W, mob/user, params)
	if(W.get_sharpness())
		playsound(loc, 'sound/weapons/slice.ogg', 50, TRUE, -1)
		user.visible_message(span_notice("<b>[user]</b> starts cutting hair off \the <b>[src]</b>.") , span_notice("You start cutting hair off \the <b>[src]</b>...") , span_hear("You hear the sound of a knife rubbing against flesh."))
		if(do_after(user, 50, target = src))
			to_chat(user, span_notice("You cut the hair from this [src.singular_name]."))
			var/obj/item/stack/sheet/hairlesshide/H = new (user.drop_location(), 1)
			H.leather_amount = leather_amount
			use(1)
	else
		return ..()


//Step two - washing..... it's actually in washing machine code.

//Step three - drying
