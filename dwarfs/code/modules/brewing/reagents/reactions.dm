/datum/chemical_reaction/wort2beer
	required_reagents = list(/datum/reagent/wort/beer)
	required_temp = 373.15
	results = list(/datum/reagent/consumable/ethanol/young/beer)
	required_container = /obj/structure/brewery/l
	reaction_tags = REACTION_TAG_EASY

/datum/chemical_reaction/beer
	required_reagents = list(/datum/reagent/consumable/ethanol/young/beer)
	results = list(/datum/reagent/consumable/ethanol/beer)
	required_container = /obj/structure/brewery/r
	silent = TRUE
	reaction_tags = REACTION_TAG_EASY
