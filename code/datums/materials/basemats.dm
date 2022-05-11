///Has no special properties.
/datum/material/iron
	name = "iron"
	desc = "Common iron ore often found in sedimentary and igneous layers of the crust."
	color = "#878687"
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/iron
	value_per_unit = 0.0025

/datum/material/iron/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
	return TRUE

///Breaks extremely easily but is transparent.
/datum/material/glass
	name = "glass"
	desc = "Glass forged by melting sand."
	color = "#88cdf1"
	alpha = 150
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	integrity_modifier = 0.1
	sheet_type = /obj/item/stack/sheet/glass
	shard_type = /obj/item/shard
	value_per_unit = 0.0025
	beauty_modifier = 0.05

/datum/material/glass/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5, attack_type = SHARP) //cronch
	return TRUE

/*
Color matrices are like regular colors but unlike with normal colors, you can go over 255 on a channel.
Unless you know what you're doing, only use the first three numbers. They're in RGB order.
*/

///Has no special properties. Could be good against vampires in the future perhaps.

///Slight force increase
/datum/material/gold
	name = "gold"
	desc = "Gold."
	color = "#ffbb50" //gold is shiny, but not as bright as bananium
	strength_modifier = 1.2
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/gold
	value_per_unit = 0.0625
	beauty_modifier = 0.15

/datum/material/gold/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
	return TRUE

///Can cause bluespace effects on use. (Teleportation) (Not yet implemented)
/datum/material/bluespace
	name = "bluespace crystal"
	desc = "Crystals with bluespace properties"
	color = "#55bbff"
	alpha = 200
	categories = list(MAT_CATEGORY_ORE = TRUE)
	beauty_modifier = 0.5
	value_per_unit = 0.15

/datum/material/bluespace/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.reagents.add_reagent(/datum/reagent/bluespace, rand(5, 8))
	source_item?.reagents?.add_reagent(/datum/reagent/bluespace, source_item.reagents.total_volume*(2/5))
	return TRUE

///Force decrease and mushy sound effect. (Not yet implemented)
/datum/material/biomass
	name = "biomass"
	desc = "Organic matter"
	color = "#735b4d"
	strength_modifier = 0.8
	value_per_unit = 0.025

/datum/material/wood
	name = "wood"
	desc = "Flexible, durable, but flamable. Hard to come across in space."
	color = "#bb8e53"
	strength_modifier = 0.5
	sheet_type = /obj/item/stack/sheet/mineral/wood
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE)
	value_per_unit = 0.01
	beauty_modifier = 0.1
	texture_layer_icon_state = "woodgrain"

/datum/material/wood/on_applied_obj(obj/source, amount, material_flags)
	. = ..()
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/wooden = source
		wooden.resistance_flags |= FLAMMABLE

/datum/material/wood/on_removed_obj(obj/source, amount, material_flags)
	. = ..()
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/wooden = source
		wooden.resistance_flags &= ~FLAMMABLE

/datum/material/wood/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.apply_damage(5, BRUTE, BODY_ZONE_HEAD)
	victim.reagents.add_reagent(/datum/reagent/cellulose, rand(8, 12))
	source_item?.reagents?.add_reagent(/datum/reagent/cellulose, source_item.reagents.total_volume*(2/5))

	return TRUE

//formed when freon react with o2, emits a lot of plasma when heated
/datum/material/hot_ice
	name = "hot ice"
	desc = "A weird kind of ice, feels warm to the touch"
	color = "#88cdf1"
	alpha = 150
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/hot_ice
	value_per_unit = 0.2
	beauty_modifier = 0.2

/datum/material/hot_ice/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.reagents.add_reagent(/datum/reagent/toxin/plasma, rand(5, 6))
	source_item?.reagents?.add_reagent(/datum/reagent/toxin/plasma, source_item.reagents.total_volume*(3/5))
	return TRUE

//I don't like sand. It's coarse, and rough, and irritating, and it gets everywhere.
/datum/material/sand
	name = "sand"
	desc = "You know, it's amazing just how structurally sound sand can be."
	color = "#EDC9AF"
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/sandblock
	value_per_unit = 0.001
	strength_modifier = 0.5
	integrity_modifier = 0.1
	beauty_modifier = 0.25
	turf_sound_override = FOOTSTEP_SAND
	texture_layer_icon_state = "sand"

/datum/material/sand/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.adjust_disgust(17)
	return TRUE

//And now for our lavaland dwelling friends, sand, but in stone form! Truly revolutionary.
/datum/material/paper
	name = "paper"
	desc = "Ten thousand folds of pure starchy power."
	color = "#E5DCD5"
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/paperframes
	value_per_unit = 0.0025
	beauty_modifier = 0.3
	turf_sound_override = FOOTSTEP_SAND
	texture_layer_icon_state = "paper"

/datum/material/paper/on_applied_obj(obj/source, amount, material_flags)
	. = ..()
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/paper = source
		paper.resistance_flags |= FLAMMABLE
		paper.obj_flags |= UNIQUE_RENAME

/datum/material/paper/on_removed_obj(obj/source, amount, material_flags)
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/paper = source
		paper.resistance_flags &= ~FLAMMABLE
	return ..()

/datum/material/cardboard
	name = "cardboard"
	desc = "They say cardboard is used by hobos to make incredible things."
	color = "#5F625C"
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/cardboard
	value_per_unit = 0.003
	beauty_modifier = -0.1

/datum/material/cardboard/on_applied_obj(obj/source, amount, material_flags)
	. = ..()
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/cardboard = source
		cardboard.resistance_flags |= FLAMMABLE
		cardboard.obj_flags |= UNIQUE_RENAME

/datum/material/cardboard/on_removed_obj(obj/source, amount, material_flags)
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/obj/cardboard = source
		cardboard.resistance_flags &= ~FLAMMABLE
	return ..()

/datum/material/bone
	name = "bone"
	desc = "Man, building with this will make you the coolest caveman on the block."
	color = "#e3dac9"
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/bone
	value_per_unit = 0.05
	beauty_modifier = -0.2

/datum/material/bamboo
	name = "bamboo"
	desc = "If it's good enough for pandas, it's good enough for you."
	color = "#87a852"
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/bamboo
	value_per_unit = 0.0025
	beauty_modifier = 0.2
	turf_sound_override = FOOTSTEP_WOOD
	texture_layer_icon_state = "bamboo"

/datum/material/zaukerite/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.apply_damage(30, BURN, BODY_ZONE_HEAD, wound_bonus = 5)
	source_item?.reagents?.add_reagent(/datum/reagent/toxin/plasma, source_item.reagents.total_volume*5)
	return TRUE
