// leaf plants can be collected only once; once they grow up they grow everything they can at once
/obj/structure/plant/leafy
	name = "leafy plant"
	desc = "Leafy green?"

/obj/structure/plant/leafy/can_grow_harvestable()
	if(length(harvestables))
		return FALSE
	return ..()

/obj/structure/plant/leafy/try_grow_harvestebles()
	if(!can_grow_harvestable())
		return
	for(var/I in produced)
		for(var/i in 1 to max_per_harvestable)
			var/obj/item/P = new I (src)
			harvestables.Add(P)
	update_appearance()

/obj/structure/plant/leafy/harvest(mob/user)
	. = ..()
	qdel(src)

/obj/structure/plant/leafy/cabbage
	name = "cabbage"
	species = "sample"
	produced = list(/obj/item/growable/leaf/cabbage)

/obj/item/growable/leaf/cabbage
	name = "cabbage"
	icon_state = "apple"
	icon = 'dwarfs/icons/farming/fruit.dmi'
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 5)
	edible = TRUE
