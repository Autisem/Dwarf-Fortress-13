/obj/item/growable/seeds
	icon = 'dwarfs/icons/farming/seeds.dmi'
	desc = "A bag of seeds."
	worn_icon_state = "seeds"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/obj/structure/plant/plant

/obj/item/growable/seeds/Initialize(mapload)
	. = ..()
	icon_state = initial(plant.species)
	name = "[initial(plant.name)] seeds"

/obj/item/growable/seeds/plump_helmet
	plant = /obj/structure/plant/garden/crop/plump_helmet

/obj/item/growable/seeds/pig_tail
	plant = /obj/structure/plant/garden/crop/pig_tail

/obj/item/growable/seeds/sweet_pod
	plant = /obj/structure/plant/garden/perennial/sweet_pod

/obj/item/growable/seeds/barley
	plant = /obj/structure/plant/garden/crop/barley

/obj/item/growable/seeds/cotton
	plant = /obj/structure/plant/garden/crop/cotton

/obj/item/growable/seeds/turnip
	plant = /obj/structure/plant/garden/crop/turnip

/obj/item/growable/seeds/carrot
	plant = /obj/structure/plant/garden/crop/carrot

/obj/item/growable/seeds/cave_wheat
	plant = /obj/structure/plant/garden/crop/cave_wheat
