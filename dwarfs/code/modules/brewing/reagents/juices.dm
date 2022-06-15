/datum/reagent/consumable/juice
	name = "juice"
	description = "sus"

/datum/reagent/consumable/juice/plump
	name = "plump juice"
	color = "#9c1780"

/datum/reagent/consumable/juice/plump/New()
	. = ..()
	AddComponent(/datum/component/fermentable, ferment_into=/datum/reagent/consumable/ethanol/wine/plump)

/datum/reagent/consumable/juice/sweet_pod
	name = "sweet syrup"
	color = "#b2e456ff"
