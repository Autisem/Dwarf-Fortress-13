// perennial plants don't die when harvested
/obj/structure/plant/garden/perennial
	name = "perennial plant"
	desc = "Long green?"
	density = FALSE

/obj/structure/plant/garden/perennial/can_grow_harvestable()
	if(!length(produced))
		return FALSE
	if(growthstage != growthstages)
		return FALSE
	return TRUE

/obj/structure/plant/garden/perennial/sweet_pod
	name = "sweet_pod"
	desc = "Crop treasured for it sweet fruits, which can be made into sweet syrup."
	species = "sweet_pod"
	health = 60
	maxhealth = 60
	growthstages = 5
	produce_delta = 90 SECONDS
	growthdelta = 60 SECONDS
	lifespan = 9
	produced = list(/obj/item/growable/sweet_pod=5)
/*
/obj/structure/plant/garden/perennial/grape
	name = "grape"
	desc = "A \"proper\" source of wine."
	species = "grape"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/perennial/cranberry
	name = "cranberry"
	desc = "Low, creeping shrubs or vines. They have slender, wiry stems that are not thickly woody and have small evergreen leaves."
	species = "cranberry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/perennial/bilberry
	name = "bilberry"
	desc = "Don't confuse it with blueberries."
	species = "bilberry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/perennial/blueberry
	name = "blueberry"
	desc = "Do not say that blueberries are blue, those suckers are purple. Truly blue food is kept by nobles from the rest of the dwarves because it probably bestows immortality."
	species = "blueberry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/perennial/blackberry
	name = "blackberry"
	desc = "A back raspberry."
	species = "blackberry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/perennial/raspberry
	name = "raspberry"
	desc = "Can be brewed into wine."
	species = "raspberry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =
*/
