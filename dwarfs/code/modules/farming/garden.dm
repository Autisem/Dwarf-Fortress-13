// leaf plants can be collected only once; once they grow up they grow everything they can at once
/obj/structure/plant/garden
	name = "garden plant"
	desc = "garden green?"

/obj/structure/plant/garden/can_grow_harvestable()
	if(harvestable)
		return FALSE
	return ..()

/*
/obj/structure/plant/garden/artichoke
	name = "artichoke"
	desc = "A relatively tall plant with arching, deeply lobed, silvery, glaucous-green leaves. The flowers develop in a large head from an edible bud."
	species = "artichoke"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/asparagus
	name = "asparagus"
	desc = "A tall plant with scale like leaves emerging from the underground stem and has stout stems and feathery foliage."
	species = "asparagus"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/string_bean
	name = "string bean"
	desc = "A bean plant that produces large amounts of thin bean pods."
	species = "string_bean"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/broad_bean
	name = "broad bean"
	desc = "Older brother of string bean."
	species = "broad_bean"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/beet
	name = "beet"
	desc = "Usually the deep purple roots of beets are eaten boiled."
	species = "beet"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/cabbage
	name = "cabbage"
	desc = "So leafy."
	species = "cabbage"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/wild_carrot
	name = "wild carrot"
	desc = "When did it run away?"
	species = "wild_carrot"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/celery
	name = "celery"
	desc = "Tasty leaf."
	species = "celery"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/chicory
	name = "chicory"
	desc = "A somewhat woody plant that resembles a daisy."
	species = "chicory"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/cress
	name = "cress"
	desc = "A poor man's pepper plant."
	species = "cress"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/garlic
	name = "garlic"
	desc = "Perfect for seasoning."
	species = "garlic"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/leek
	name = "leek"
	desc = "Definitely better than garlic."
	species = "leek"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/lettuce
	name = "lettuce"
	desc = "Commonly used to make salads."
	species = "lettuce"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/muskmelon
	name = "muskmelon"
	desc = "Often noted for their musky-scented sweet juicy orange flesh."
	species = "muskmelon"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/onion
	name = "onion"
	desc = "Not for crybabies."
	species = "onion"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/parsnip
	name = "parsnip"
	desc = "A carrot-like plant with edible roots."
	species = "parsnip"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/pea
	name = "pea"
	desc = "Well known for its sweet pods."
	species = "pea"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/radish
	name = "radish"
	desc = "Crunch crunch!"
	species = "radish"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/red_bean
	name = "red bean"
	desc = "Boil it."
	species = "red_bean"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/rhubarb
	name = "rhubarb"
	desc = "Looks edible?"
	species = "rhubarb"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/soybean
	name = "soybean"
	desc = "Can be made into milk."
	species = "soybean"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/spinach
	name = "spinach"
	desc = "Eating it will not improve your strength."
	species = "spinach"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/turnip
	name = "turnip"
	desc = "White beet."
	species = "turnip"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/long_yam
	name = "long yam"
	desc = "Long potato."
	species = "long_yam"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/// mostly plants that can be milled into flour

/obj/structure/plant/garden/spelt
	name = "spelt"
	desc = "A poor man's wheat."
	species = "spelt"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/oat
	name = "oat"
	desc = "Most commonly used to feed lifestock."
	species = "oat"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/alfalfa
	name = "alfalfa"
	desc = "Ofthen used as grazing hay."
	species = "alfalfa"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/rye
	name = "rye"
	desc = "Known for its beer."
	species = "rye"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/quinoa
	name = "quinoa"
	desc = "Usually planted for its edible seeds."
	species = "quinoa"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/kaniwa
	name = "kaniwa"
	desc = "Wheat #4389?"
	species = "kaniwa"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/bitter_vetch
	name = "bitter vetch"
	desc = "An excellent sheep and cattle feed concentrate."
	species = "bitter_vetch"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/purple_amaranth
	name = "purple amaranth"
	desc = "A tall grainy plant."
	species = "purple_amaranth"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/red_spinach
	name = "red spinach"
	desc = "Cannot be grown domestically in a fortress."
	species = "red_spinach"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/white_millet
	name = "white millet"
	desc = "Well known for its quick growth."
	species = "white_millet"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/finger_millet
	name = "finger millet"
	desc = "A self polinating cereal crop."
	species = "finger_millet"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/foxtail_millet
	name = "foxtail millet"
	desc = ""
	species = "foxtail_millet"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/hemp
	name = "hemp"
	desc = ""
	species = "hemp"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/// Cave plants

/obj/structure/plant/garden/plump_helmet
	name = "plump helmet"
	desc = ""
	species = "plump_helmet"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/pig_tail
	name = "pig tail"
	desc = ""
	species = "pig_tail"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/cave_wheat
	name = "cave wheat"
	desc = ""
	species = "cave_wheat"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/sweet_pod
	name = "sweet pod"
	desc = ""
	species = "sweet_pod"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/quarry_bush
	name = "quarry bush"
	desc = ""
	species = "quarry_bush"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/garden/dimple_cup
	name = "dimple cup"
	desc = ""
	species = "dimple_cup"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =
*/
