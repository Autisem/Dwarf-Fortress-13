/turf/closed/mineral/random/vietnam
	icon = 'white/valtos/icons/rocks.dmi'
	icon_state = "rock"
	smooth_icon = 'white/valtos/icons/rocks_smooth.dmi'
	smoothing_flags = SMOOTH_CORNERS
	environment_type = "stone_raw"
	turf_type = /turf/open/floor/stone/raw
	baseturfs = /turf/open/floor/stone/raw
	mineralSpawnChanceList = list(/obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 3, /obj/item/stack/ore/iron = 40)

/turf/closed/mineral/random/vietnam/Initialize()
	. = ..()
	transform = null // backdoor

/datum/outfit/huev_latnik_one
	name = "Лёгкий лабеб"
	uniform = /obj/item/clothing/under/chainmail
	gloves = /obj/item/clothing/gloves/plate_gloves
	head = /obj/item/clothing/head/helmet/plate_helmet
	suit = /obj/item/clothing/suit/armor/light_plate
	shoes = /obj/item/clothing/shoes/jackboots/plate_boots
	back = /obj/item/blacksmith/katanus

/datum/outfit/huev_latnik_two
	name = "Тяжёлый лабеб"
	uniform = /obj/item/clothing/under/chainmail
	gloves = /obj/item/clothing/gloves/plate_gloves
	head = /obj/item/clothing/head/helmet/plate_helmet
	suit = /obj/item/clothing/suit/armor/heavy_plate
	shoes = /obj/item/clothing/shoes/jackboots/plate_boots
	r_hand = /obj/item/blacksmith/zwei

/datum/crafting_recipe/smithman/anvil
	name = "Наковальня"
	result = /obj/item/blacksmith/anvil_free
	tool_paths = list(/obj/item/blacksmith/smithing_hammer)
	reqs = list(/obj/item/blacksmith/ingot = 3,
				/obj/item/stack/sheet/stone = 5)
	time = 350
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/workplace
	name = "Наковальня на полене"
	result = /obj/structure/anvil
	tool_paths = list(/obj/item/blacksmith/smithing_hammer)
	reqs = list(/obj/item/blacksmith/srub = 1,
				/obj/item/blacksmith/anvil_free = 1)
	time = 350
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/srub
	name = "Полено"
	result = /obj/item/blacksmith/srub
	reqs = list(/obj/item/stack/sheet/mineral/wood = 10)
	time = 100
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/furnace
	name = "Плавильня"
	result = /obj/structure/furnace
	reqs = list(/obj/item/stack/sheet/stone = 10, /obj/item/stack/sheet/mineral/wood = 10)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/furnace_cook
	name = "Печь для готовки"
	result = /obj/machinery/microwave/furnace
	reqs = list(/obj/item/stack/sheet/stone = 8, /obj/item/stack/sheet/mineral/wood = 6)
	time = 200
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/forge
	name = "Кузница"
	result = /obj/structure/forge
	reqs = list(/obj/item/stack/sheet/stone = 20, /obj/item/stack/sheet/mineral/wood = 20)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonedoor
	name = "Каменная дверь"
	result = /obj/structure/mineral_door/heavystone
	reqs = list(/obj/item/stack/sheet/stone = 5, /obj/item/stack/sheet/mineral/wood = 1, /obj/item/blacksmith/ingot = 1)
	time = 300
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonechair
	name = "Каменный стул"
	result = /obj/structure/chair/comfy/stone
	reqs = list(/obj/item/stack/sheet/stone = 1)
	time = 100
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/stonetable
	name = "Каменный стол"
	result = /obj/structure/table/stone
	reqs = list(/obj/item/stack/sheet/stone = 2)
	time = 100
	category = CAT_STRUCTURE
	always_available = TRUE

/datum/crafting_recipe/smithman/sarcophage
	name = "Саркофаг"
	result = /obj/structure/closet/crate/sarcophage
	reqs = list(/obj/item/stack/sheet/stone = 10)
	time = 250
	category = CAT_STRUCTURE
	always_available = TRUE

/obj/effect/baseturf_helper/beach/raw_stone
	name = "raw stone baseturf editor"
	baseturf = /turf/open/floor/stone/raw

/obj/effect/mob_spawn/human/dwarf
	name = "мягкая шконка"
	desc = "Тут кто-то под шконкой, кирку мне в зад..."
	icon = 'white/valtos/icons/prison/prison.dmi'
	icon_state = "spwn"
	roundstart = FALSE
	death = FALSE
	short_desc = "Я Дварф в невероятно диких условиях."
	flavour_text = "Выжить."
	mob_species = /datum/species/dwarf
	outfit = /datum/outfit/dwarf
	assignedrole = "Dwarf"
