/datum/reagent/grain
	name = "grain"
	color = "#ffff"
	var/datum/reagent/flour/flour_type
	var/flour_ratio = 1

/datum/reagent/grain/New()
	. = ..()
	AddComponent(/datum/component/grindable, flour_type, liquid_ratio=flour_ratio)

/datum/reagent/grain/barley
	name = "barley grain"
	flour_type = /datum/reagent/flour/barley

/datum/reagent/grain/cave_wheat
	name = "cave wheat grain"
	color = "#6e6e6eff"
	flour_type = /datum/reagent/flour/cave_wheat

/datum/reagent/flour
	name = "flour"
	color = "#ffff"

/datum/reagent/flour/barley
	name = "barley flour"

/datum/reagent/flour/cave_wheat
	name = "cave whear flour"
	color = "#6e6e6eff"
