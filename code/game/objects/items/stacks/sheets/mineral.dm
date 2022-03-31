/*
Mineral Sheets
	Contains:
		- Diamond
		- Gold
		- Silver
	Others:
		- Coal
*/


/*
 * Diamond
 */
/obj/item/stack/sheet/mineral/diamond
	name = "diamond"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "sheet-diamond"
	inhand_icon_state = "sheet-diamond"
	singular_name = "diamond sheet"
	sheettype = "diamond"
	mats_per_unit = list(/datum/material/diamond=MINERAL_MATERIAL_AMOUNT)
	novariants = TRUE
	grind_results = list(/datum/reagent/carbon = 20)
	point_value = 25
	merge_type = /obj/item/stack/sheet/mineral/diamond
	material_type = /datum/material/diamond
	walltype = /turf/closed/wall/mineral/diamond

GLOBAL_LIST_INIT(diamond_recipes, list ())

/obj/item/stack/sheet/mineral/diamond/get_main_recipes()
	. = ..()
	. += GLOB.diamond_recipes


/*
 * Gold
 */
/obj/item/stack/sheet/mineral/gold
	name = "gold"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "sheet-gold"
	inhand_icon_state = "sheet-gold"
	singular_name = "golden sheet"
	sheettype = "gold"
	mats_per_unit = list(/datum/material/gold=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/gold = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/gold
	material_type = /datum/material/gold
	walltype = /turf/closed/wall/mineral/gold

GLOBAL_LIST_INIT(gold_recipes, list ())

/obj/item/stack/sheet/mineral/gold/get_main_recipes()
	. = ..()
	. += GLOB.gold_recipes

/*
 * Silver
 */
/obj/item/stack/sheet/mineral/silver
	name = "silver"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "sheet-silver"
	inhand_icon_state = "sheet-silver"
	singular_name = "silver sheet"
	sheettype = "silver"
	mats_per_unit = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/silver = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/silver
	material_type = /datum/material/silver
	tableVariant = /obj/structure/table/optable
	walltype = /turf/closed/wall/mineral/silver

GLOBAL_LIST_INIT(silver_recipes, list ())

/obj/item/stack/sheet/mineral/silver/get_main_recipes()
	. = ..()
	. += GLOB.silver_recipes


/****************************** Others ****************************/
/*
 * Coal
 */

/obj/item/stack/sheet/mineral/coal
	name = "coal lump"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	desc = "Black gold of the mountains, used to fuel furnaces"
	icon_state = "coal"
	singular_name = "coal lump"
	merge_type = /obj/item/stack/sheet/mineral/coal
	grind_results = list(/datum/reagent/carbon = 20)

/obj/item/stack/sheet/mineral/coal/attackby(obj/item/W, mob/user, params)
	if(W.get_temperature() > 300)//If the temperature of the object is over 300, then ignite
		var/turf/T = get_turf(src)
		message_admins("Coal ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Coal ignited by [key_name(user)] in [AREACOORD(T)]")
		fire_act(W.get_temperature())
		return TRUE
	else
		return ..()

/obj/item/stack/sheet/mineral/coal/fire_act(exposed_temperature, exposed_volume)
	qdel(src)

/obj/item/stack/sheet/mineral/coal/five
	amount = 5

/obj/item/stack/sheet/mineral/coal/ten
	amount = 10
