/datum/chemical_reaction/wort2beer
	required_reagents = list(/datum/reagent/wort/beer)
	required_temp = 373.15
	results = list(/datum/reagent/consumable/ethanol/young/beer)
	required_container = /obj/structure/brewery/l

/datum/chemical_reaction/beer
	required_reagents = list(/datum/reagent/consumable/ethanol/young/beer)
	results = list(/datum/reagent/consumable/ethanol/beer)
	required_container = /obj/structure/brewery/r
	silent = TRUE

/datum/chemical_reaction/beer_wort
	required_reagents = list(/datum/reagent/water, /datum/reagent/grain/barley)
	results = list(/datum/reagent/wort/beer)
	required_container = /obj/item/reagent_containers/cooking_pot
	required_temp = 373.15
