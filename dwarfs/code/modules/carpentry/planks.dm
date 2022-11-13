/obj/item/stack/sheet/planks
	name = "planks"
	desc = "Used in building."
	singular_name = "Plank"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "planks"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	merge_type = /obj/item/stack/sheet/planks

/obj/item/stack/sheet/planks/get_fuel()
	return 10 * amount

GLOBAL_LIST_INIT(plank_recipes, list (
	new/datum/stack_recipe("Weapon Hilt", /obj/item/weapon_hilt, 1, time=5 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Tool Handle", /obj/item/tool_handle, 1, time=5 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Bucket", /obj/item/reagent_containers/glass/bucket, 3, time=15 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Bed", /obj/structure/bed, 8, time=25 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Plate", /obj/item/reagent_containers/glass/plate/regular, 2, time=10 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Flat Plate", /obj/item/reagent_containers/glass/plate/flat, 2, time=10 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Bowl", /obj/item/reagent_containers/glass/plate/bowl, 3, time=10 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Stick", /obj/item/stick, res_amount=2, time=5 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Wooden Cup", /obj/item/reagent_containers/glass/cup, 2, time=10 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Torch Handle", /obj/item/torch_handle, res_amount=2, time=5 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Rolling Pin", /obj/item/kitchen/rollingpin, 2, time=5 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Barrel", /obj/structure/barrel, 6, time=20 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Wooden Crate", /obj/structure/closet/crate/wooden, 8, time=25 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Wooden Table", /obj/structure/table/wood, 5, time=25 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Wooden Chair", /obj/item/chair/wood, 5, time=20 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Loom", /obj/structure/loom, 10, time=30 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Scepter Shaft", /obj/item/scepter_shaft, 1, time=5 SECONDS, tools=TOOL_AXE),
	new/datum/stack_recipe("Club", /obj/item/club, 5, time=15 SECONDS, tools=TOOL_AXE)
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
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'

/obj/structure/lattice
	name = "wooden lattice"
	desc = "Blocks you from falling down and allows building floors."
	icon = 'dwarfs/icons/structures/construction.dmi'
	icon_state = "lattice"
	anchored = 1
	obj_flags = BLOCK_Z_IN_UP | BLOCK_Z_IN_DOWN | BLOCK_Z_OUT_DOWN
