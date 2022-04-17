/datum/smithing_recipe
	var/name = ""
	var/result
	var/metal_type_need = "iron"
	var/max_resulting = 1

/datum/smithing_recipe/katanus
	name = "\[Part\] katanus blade"
	result = /obj/item/blacksmith/partial/katanus

/datum/smithing_recipe/zwei
	name = "\[part\] zweihander blade"
	result = /obj/item/blacksmith/partial/zwei

/datum/smithing_recipe/cep
	name = "\[part\] ball on a chain"
	result = /obj/item/blacksmith/partial/cep

/datum/smithing_recipe/dwarfsord
	name = "\[part\] sword blade"
	result = /obj/item/blacksmith/partial/dwarfsord

/datum/smithing_recipe/dagger
	name = "dagger"
	result = /obj/item/blacksmith/dagger
	max_resulting = 3

/datum/smithing_recipe/pickaxe
	name = "pickaxe"
	result = /obj/item/pickaxe

/datum/smithing_recipe/shovel
	name = "shovel"
	result = /obj/item/shovel
	max_resulting = 2

/datum/smithing_recipe/smithing_hammer
	name = "hammer"
	result = /obj/item/blacksmith/smithing_hammer

/datum/smithing_recipe/tongs
	name = "tongs"
	result = /obj/item/blacksmith/tongs
	max_resulting = 2

/datum/smithing_recipe/chisel
	name = "chisel (stone)"
	result = /obj/item/blacksmith/chisel
	max_resulting = 2

/datum/smithing_recipe/chisel_retard
	name = "chisel (sculptures)"
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
	result = /obj/item/blacksmith/torch_handle
	max_resulting = 5

/datum/smithing_recipe/shpatel
	name = "trowel"
	result = /obj/item/blacksmith/shpatel
	max_resulting = 2

/datum/smithing_recipe/scepter
	name = "golden necklace"
	result = /obj/item/clothing/neck/necklace/dope
	metal_type_need = "gold"

/datum/smithing_recipe/scepter
	name = "scepter"
	result = /obj/item/blacksmith/scepter
	metal_type_need = "none"

/datum/smithing_recipe/crown
	name = "empty crown"
	result = /obj/item/blacksmith/partial/crown_empty
	metal_type_need = "gold"

/datum/smithing_recipe/scepter
	name = "scepter part"
	result = /obj/item/blacksmith/partial/scepter_part
	metal_type_need = "gold"

/datum/workbench_recipe
	var/name = "workbench_recipe"
	var/result
	var/list/reqs
	var/obj/primary

/datum/workbench_recipe/zwei
	name = "zweihander"
	result = /obj/item/blacksmith/zwei
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3, /obj/item/stack/sheet/leather = 2, /obj/item/blacksmith/partial/zwei=1)
	primary = /obj/item/blacksmith/partial/zwei

/datum/workbench_recipe/katanus
	name = "katanus"
	result = /obj/item/blacksmith/katanus
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3, /obj/item/stack/sheet/leather = 2,/obj/item/blacksmith/partial/katanus=1)
	primary = /obj/item/blacksmith/partial/katanus

/datum/workbench_recipe/cep
	name = "flail"
	result = /obj/item/blacksmith/cep
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2, /obj/item/blacksmith/partial/cep=1)
	primary = /obj/item/blacksmith/partial/cep

/datum/workbench_recipe/sword
	name = "sword"
	result = /obj/item/blacksmith/dwarfsord
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2, /obj/item/stack/sheet/leather = 1, /obj/item/blacksmith/partial/dwarfsord=1)
	primary = /obj/item/blacksmith/partial/dwarfsord

/datum/workbench_recipe/crown
	name = "crown"
	result = /obj/item/clothing/head/helmet/dwarf_crown
	reqs = list(/obj/item/stack/sheet/mineral/gem/sapphire = 3, /obj/item/blacksmith/partial/crown_empty = 1)
	primary = /obj/item/blacksmith/partial/crown_empty

/datum/workbench_recipe/scepter
	name = "scepter"
	result = /obj/item/blacksmith/scepter
	reqs = list(/obj/item/stack/sheet/mineral/gem/ruby = 1, /obj/item/blacksmith/partial/scepter_part = 1, /obj/item/scepter_shaft = 1)
	primary = /obj/item/blacksmith/partial/scepter_part

/datum/workbench_recipe/dagger_sneath
	name = "dagger sneath"
	result = /obj/item/storage/belt/dagger_sneath
	reqs = list(/obj/item/stack/sheet/leather = 3)
	primary = null
