/obj/item/stack/sheet/tallow
	name = "tallow"
	desc = "Pure grease, do not use it while it's raining."
	singular_name = "Tallow"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "tallow"
	inhand_icon_state = "sheet-metal"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/stack/sheet/tallow/get_fuel()
	return 2 * amount

GLOBAL_LIST_INIT(tallow_recipes, list (
	new/datum/stack_recipe("Candle", /obj/item/flashlight/fueled/candle, 1,,,30),
))
//new/datum/stack_recipe(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1,time = 0)
/obj/item/stack/sheet/tallow/get_main_recipes()
	. = ..()
	. += GLOB.tallow_recipes
