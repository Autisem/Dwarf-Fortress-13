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
	desc = "A well known round-head mushroom. Looks tasty"
	species = "plump_helmet"
	health = 40
	maxhealth = 40
	growthstages = 5
	growthdelta = 90 SECONDS
	lifespan = 6
	produced = list(/obj/item/growable/plump_helmet=3)

/obj/structure/plant/garden/crop/pig_tail
	name = "pig tail"
	desc = "Twisting stalk which can be made into thread"
	species = "pig_tail"
	health = 40
	maxhealth = 40
	growthstages = 5
	growthdelta = 90 SECONDS
	lifespan = 6
	produced = list(/obj/item/growable/pig_tail=2)

/obj/structure/plant/garden/crop/barley
	name = "barley"
	desc = "One of the most common grains you can find in human settlement"
	species = "barley"
	health = 40
	maxhealth = 40
	growthstages = 5
	growthdelta = 70 SECONDS
	lifespan = 6
	produced = list(/obj/item/growable/barley=4)

/obj/structure/plant/garden/crop/cotton
	name = "cotton"
	desc = "Its smooth buds is useful for a thread processing"
	species = "cotton"
	health = 40
	maxhealth = 40
	growthstages = 5
	growthdelta = 120 SECONDS
	lifespan = 6
	produced = list(/obj/item/growable/cotton=2)

/obj/structure/plant/garden/crop/turnip
	name = "turnip"
	desc = "A plump root which can be eated raw or cooked"
	species = "turnip"
	health = 40
	maxhealth = 40
	growthstages = 5
	growthdelta = 100 SECONDS
	lifespan = 6
	produced = list(/obj/item/growable/turnip=2, /obj/item/growable/seeds/turnip=4)

/obj/structure/plant/garden/crop/carrot
	name = "carrot"
	desc = "White flowering plant with eadible root"
	species = "carrot"
	health = 40
	maxhealth = 40
	growthstages = 5
	growthdelta = 100 SECONDS
	lifespan = 6
	produced = list(/obj/item/growable/carrot=2, /obj/item/growable/seeds/carrot=4)

/obj/structure/plant/garden/crop/cave_wheat
	name = "cave wheat"
	desc = "Grain adapted to lack of sunlight and harsh soils of underground dwarven farms"
	species = "cave_wheat"
	health = 40
	maxhealth = 40
	growthstages = 5
	growthdelta = 90 SECONDS
	lifespan = 6
	produced = list(/obj/item/growable/cave_wheat=4)
