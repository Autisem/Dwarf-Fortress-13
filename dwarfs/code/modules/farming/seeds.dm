/obj/item/growable/seeds
	icon = 'dwarfs/icons/farming/seeds.dmi'
	icon_state = "seed"				// Unknown plant seed - these shouldn't exist in-game.
	worn_icon_state = "seed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	/// Name of plant when planted.
	var/planttype

/obj/item/growable/seeds/Initialize(mapload, nogenes = 0)
	. = ..()
	pixel_x = base_pixel_x + rand(-8, 8)
	pixel_y = base_pixel_y + rand(-8, 8)

/obj/item/growable/seeds/crop
	name = "crop seed"

/obj/item/growable/seeds/tree
	name = "tree seed"

/obj/item/growable/seeds/grass
	name = "grass seed"
