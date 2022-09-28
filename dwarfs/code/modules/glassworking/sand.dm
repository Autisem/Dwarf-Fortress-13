/obj/item/stack/ore/smeltable/sand
	name = "sand"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "sand"
	singular_name = "pile of sand"
	novariants = FALSE
	refined_type = /obj/item/stack/glass

/obj/item/stack/glass
	name = "glass"
	singular_name = "piece of glass"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "glass"
	novariants = TRUE

GLOBAL_LIST_INIT(glass_recipes, list(
		new/datum/stack_recipe("Demijohn", /obj/structure/demijohn),
		new/datum/stack_recipe("Glass Bottle", /obj/item/reagent_containers/glass/bottle)
	))

/obj/item/stack/glass/get_main_recipes()
	. = ..()
	. += GLOB.glass_recipes
