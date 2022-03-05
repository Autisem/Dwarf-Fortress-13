// leaf plants can be collected only once; once they grow up they grow everything they can at once
/obj/structure/plant/garden
	name = "garden plant"
	desc = "garden green?"

/obj/structure/plant/garden/Initialize()
	. = ..()
	icon_ripe = "[species][growthstages]"

/obj/structure/plant/garden/can_grow_harvestable()
	if(length(harvestables))
		return FALSE
	return ..()

/obj/structure/plant/garden/try_grow_harvestebles()
	if(!can_grow_harvestable())
		return
	for(var/I in produced)
		for(var/i in 1 to max_per_harvestable)
			var/obj/item/P = new I (src)
			harvestables.Add(P)
	update_appearance()

/obj/structure/plant/garden/harvest(mob/user)
	. = ..()
	qdel(src)

/obj/structure/plant/garden/cabbage
	name = "cabbage"
	species = "sample"
	produced = list(/obj/item/growable/leaf/cabbage)

/obj/item/growable/leaf/cabbage
	name = "cabbage"
	icon_state = "apple"
	icon = 'dwarfs/icons/farming/fruit.dmi'
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 5)
	edible = TRUE
