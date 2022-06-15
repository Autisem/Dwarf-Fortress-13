/datum/chemical_reaction/food/dough
	required_reagents = list(/datum/reagent/flour = 10, /datum/reagent/water)

/datum/chemical_reaction/food/dough/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	new /obj/item/food/dough(get_turf(holder.my_atom))
