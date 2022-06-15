/datum/reagent/consumable/ethanol/wine
	name = "wine"
	description = "sus"
	color = "#c9220cff"

/datum/reagent/consumable/ethanol/wine/New()
	. = ..()
	AddComponent(/datum/component/fermentable, ferment_into=/datum/reagent/consumable/vinegar)

/datum/reagent/consumable/ethanol/wine/plump
	name = "plump wine"
	color = "#96418aff"
