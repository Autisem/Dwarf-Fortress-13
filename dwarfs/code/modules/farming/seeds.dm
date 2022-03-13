/obj/item/growable/seeds
	icon = 'dwarfs/icons/farming/seeds.dmi'
	icon_state = "sample"			// Unknown plant seed - these shouldn't exist in-game.
	worn_icon_state = "seeds"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/obj/structure/plant/plant

/obj/item/growable/seeds/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-8, 8)
	pixel_y = base_pixel_y + rand(-8, 8)
	icon_state = initial(plant.species)

/obj/item/growable/seeds/garden
	name = "garden seed"

/obj/item/growable/seeds/tree
	name = "tree seed"

/obj/item/growable/seeds/sapling
	name = "tree sapling"
