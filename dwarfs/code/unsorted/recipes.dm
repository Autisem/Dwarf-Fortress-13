/datum/smithing_recipe
	var/name = ""
	var/result
	var/metal_type_need = "iron"
	var/max_resulting = 1

/datum/smithing_recipe/zwei
	name = "\[part\] zweihander blade"
	result = /obj/item/partial/zwei

/datum/smithing_recipe/flail
	name = "\[part\] ball on a chain"
	result = /obj/item/partial/flail

/datum/smithing_recipe/sword
	name = "\[part\] sword blade"
	result = /obj/item/partial/sword

/datum/smithing_recipe/dagger
	name = "\[part\] dagger"
	result = /obj/item/partial/dagger
	max_resulting = 3

/datum/smithing_recipe/pickaxe
	name = "\[part\] pickaxe"
	result = /obj/item/partial/pickaxe

/datum/smithing_recipe/shovel
	name = "\[part\] shovel"
	result = /obj/item/partial/shovel
	max_resulting = 2

/datum/smithing_recipe/axe
	name = "\[part\] axe"
	result = /obj/item/partial/axe
	max_resulting = 2

/datum/smithing_recipe/axe
	name = "\[part\] builder's hammer"
	result = /obj/item/partial/builder_hammer
	max_resulting = 2

/datum/smithing_recipe/smithing_hammer
	name = "\[part\] smithing hammer"
	result = /obj/item/partial/smithing_hammer

/datum/smithing_recipe/tongs
	name = "tongs"
	result = /obj/item/tongs
	max_resulting = 2

/datum/smithing_recipe/chisel
	name = "chisel (stone)"
	result = /obj/item/chisel
	max_resulting = 2

/datum/smithing_recipe/light_plate
	name = "chest plate"
	result = /obj/item/clothing/suit/armor/light_plate

/datum/smithing_recipe/heavy_plate
	name = "plate armor"
	result = /obj/item/clothing/suit/armor/heavy_plate

/datum/smithing_recipe/chainmail
	name = "chainmail"
	result = /obj/item/clothing/under/chainmail

/datum/smithing_recipe/plate_helmet
	name = "plate helmet"
	result = /obj/item/clothing/head/helmet/plate_helmet
	max_resulting = 2

/datum/smithing_recipe/plate_gloves
	name = "plate gloves"
	result = /obj/item/clothing/gloves/plate_gloves
	max_resulting = 3

/datum/smithing_recipe/plate_boots
	name = "plate boots"
	result = /obj/item/clothing/shoes/jackboots/plate_boots
	max_resulting = 3

/datum/smithing_recipe/torch_fixture
	name = "torch handle"
	result = /obj/item/torch_handle
	max_resulting = 5

/datum/smithing_recipe/shpatel
	name = "trowel"
	result = /obj/item/trowel
	max_resulting = 2

/datum/smithing_recipe/crown
	name = "empty crown"
	result = /obj/item/partial/crown_empty
	metal_type_need = "gold"

/datum/smithing_recipe/scepter
	name = "scepter part"
	result = /obj/item/partial/scepter_part
	metal_type_need = "gold"

/datum/workbench_recipe
	var/name = "workbench_recipe"
	var/result
	var/list/reqs

/datum/workbench_recipe/dagger
	name = "dagger"
	result = /obj/item/dagger
	reqs = list(/obj/item/partial/dagger=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/zwei
	name = "zweihander"
	result = /obj/item/zwei
	reqs = list(/obj/item/stack/sheet/leather = 2, /obj/item/partial/zwei=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/flail
	name = "flail"
	result = /obj/item/flail
	reqs = list(/obj/item/partial/flail=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/sword
	name = "sword"
	result = /obj/item/sword
	reqs = list(/obj/item/stack/sheet/leather = 1, /obj/item/partial/sword=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/crown
	name = "crown"
	result = /obj/item/clothing/head/helmet/dwarf_crown
	reqs = list(/obj/item/stack/sheet/mineral/gem/sapphire = 3, /obj/item/partial/crown_empty = 1)

/datum/workbench_recipe/pickaxe
	name = "pickaxe"
	result = /obj/item/pickaxe
	reqs = list(/obj/item/partial/pickaxe=1, /obj/item/tool_handle=1)

/datum/workbench_recipe/axe
	name = "axe"
	result = /obj/item/axe
	reqs = list(/obj/item/partial/axe=1, /obj/item/tool_handle=1)

/datum/workbench_recipe/shovel
	name = "shovel"
	result = /obj/item/shovel
	reqs = list(/obj/item/partial/shovel=1, /obj/item/tool_handle=1)

/datum/workbench_recipe/builder_hammer
	name = "builder's hammer"
	result = /obj/item/builder_hammer
	reqs = list(/obj/item/partial/builder_hammer=1, /obj/item/tool_handle=1)

/datum/workbench_recipe/smithing_hammer
	name = "smithing hammer"
	result = /obj/item/smithing_hammer
	reqs = list(/obj/item/partial/smithing_hammer=1, /obj/item/tool_handle=1)
