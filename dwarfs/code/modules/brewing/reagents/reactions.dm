/datum/chemical_reaction/wort2beer_barley
	required_reagents = list(/datum/reagent/wort/beer/barley=1)
	required_temp = 450
	results = list(/datum/reagent/consumable/ethanol/young/beer/barley=1)
	required_container = /obj/structure/brewery/l
	reaction_tags = REACTION_TAG_EASY

/datum/chemical_reaction/beer
	required_reagents = list(/datum/reagent/consumable/ethanol/young/beer/barley=1)
	results = list(/datum/reagent/consumable/ethanol/beer/barley=1)
	required_container = /obj/structure/brewery/r
	silent = TRUE
	reaction_tags = REACTION_TAG_EASY

/datum/chemical_reaction/wort_barley_beer
	required_reagents = list(/datum/reagent/water=10, /datum/reagent/grain/barley=10)
	results = list(/datum/reagent/wort/beer/barley=10)
	reaction_tags = REACTION_TAG_EASY
	required_container = /obj/structure/brewery/l
	required_temp = 400
