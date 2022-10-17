/datum/reagent/consumable/ethanol/wine
	name = "Wine"
	description = "Traditional dwarfen mushroom wine. Heals dwarf's souls and minds (and probably more)."
	color = "#c9220cff"

/datum/reagent/consumable/ethanol/wine/New()
	. = ..()
	AddComponent(/datum/component/fermentable, ferment_into=/datum/reagent/consumable/vinegar)

/datum/reagent/consumable/ethanol/wine/plump
	name = "Plump wine"
	color = "#96418aff"
