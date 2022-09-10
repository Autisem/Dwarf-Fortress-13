/obj/item/stack/sheet/planks
	name = "planks"
	desc = "Used in building."
	singular_name = "Plank"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "planks"
	inhand_icon_state = "sheet-metal"
	w_class = WEIGHT_CLASS_BULKY
	merge_type = /obj/item/stack/sheet/planks

/obj/item/stack/sheet/planks/get_fuel()
	return 10 * amount

GLOBAL_LIST_INIT(plank_recipes, list (
	new/datum/stack_recipe("Weapon Hilt", /obj/item/weapon_hilt),
	new/datum/stack_recipe("Tool Handle", /obj/item/tool_handle),
	new/datum/stack_recipe("Bucket", /obj/item/reagent_containers/glass/bucket),
	new/datum/stack_recipe("Bed", /obj/structure/bed),
	new/datum/stack_recipe("Plate", /obj/item/reagent_containers/glass/plate/regular),
	new/datum/stack_recipe("Flat Plate", /obj/item/reagent_containers/glass/plate/flat),
	new/datum/stack_recipe("Bowl", /obj/item/reagent_containers/glass/plate/bowl),
	new/datum/stack_recipe("Stick", /obj/item/stick),
	new/datum/stack_recipe("Wooden Cup", /obj/item/reagent_containers/glass/cup),
	new/datum/stack_recipe("Torch Handle", /obj/item/torch_handle),
	new/datum/stack_recipe("Rolling Pin", /obj/item/kitchen/rollingpin),
	new/datum/stack_recipe("Barrel", /obj/structure/barrel),
	new/datum/stack_recipe("Wooden Crate", /obj/structure/closet/crate/wooden),
	new/datum/stack_recipe("Wooden Table", /obj/structure/table/wood),
	new/datum/stack_recipe("Wooden Chair", /obj/item/chair/wood),
	new/datum/stack_recipe("Loom", /obj/structure/loom),
))
//new/datum/stack_recipe(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1,time = 0)
/obj/item/stack/sheet/planks/get_main_recipes()
	. = ..()
	. += GLOB.plank_recipes

/obj/item/stack/sheet/bark
	name = "bark"
	desc = "Is this real?"
	singular_name = "Bark"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "bark"
	w_class = WEIGHT_CLASS_SMALL
	merge_type = /obj/item/stack/sheet/bark

/obj/structure/lattice
	name = "wooden lattice"
	desc = "Blocks you from falling down and allows building floors."
	anchored = 1
	obj_flags = BLOCK_Z_IN_UP | BLOCK_Z_IN_DOWN | BLOCK_Z_OUT_DOWN
