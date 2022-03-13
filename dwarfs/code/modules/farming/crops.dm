/// plants that are collected once only
/obj/structure/plant/garden/crop
	name = "crop"

/obj/structure/plant/garden/crop/Initialize()
	. = ..()
	icon_ripe = "[species]-[growthstages]"

/obj/structure/plant/garden/harvest(mob/user)
	. = ..()
	qdel(src)

/obj/structure/plant/garden/crop/plump_helmet
	name = "plump helmet"
	desc = ""
	species = "plump_helmet"
	produced = list(/obj/item/growable/plump_helmet=3)

/obj/structure/plant/garden/crop/pig_tail
	name = "pig tail"
	desc = ""
	species = "pig_tail"
	produced = list(/obj/item/growable/pig_tail=3)

/obj/structure/plant/garden/crop/barley
	name = "barley"
	desc = ""
	species = "barley"
	produced = list(/obj/item/growable/barley=3)

/obj/structure/plant/garden/crop/cotton
	name = "cotton"
	desc = ""
	species = "cotton"
	produced = list(/obj/item/growable/cotton=3)

/obj/structure/plant/garden/crop/turnip
	name = "turnip"
	desc = ""
	species = "turnip"
	produced = list(/obj/item/growable/turnip=3, /obj/item/growable/seeds/turnip=3)

/obj/structure/plant/garden/crop/carrot
	name = "carrot"
	desc = ""
	species = "carrot"
	produced = list(/obj/item/growable/carrot=3, /obj/item/growable/seeds/carrot=3)

/obj/structure/plant/garden/crop/cave_wheat
	name = "cave wheat"
	desc = ""
	species = "cave_wheat"
	produced = list(/obj/item/growable/cave_wheat=3)
