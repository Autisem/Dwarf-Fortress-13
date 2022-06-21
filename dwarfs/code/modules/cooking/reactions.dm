/datum/chemical_reaction/barleyflour2dough
	required_reagents = list(/datum/reagent/water=10, /datum/reagent/flour/barley=20)

/datum/chemical_reaction/barleyflour2dough/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	. = ..()
	new /obj/item/food/dough(get_turf(holder.my_atom))
