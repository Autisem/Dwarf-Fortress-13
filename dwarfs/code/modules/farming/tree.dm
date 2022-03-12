/obj/structure/plant/tree
	name = "tree"
	desc = "Big green?"
	icon = 'dwarfs/icons/farming/growing_tree.dmi'
	density = TRUE

/obj/structure/plant/tree/Initialize()
	. = ..()
	pixel_x = -20

/obj/structure/plant/tree/try_grow_harvestebles()
	if(!..())
		return
	var/list/eharvestables = list() // list of existing harvestable types and their amount
	for(var/obj/item/H in harvestables)
		if(H.type in eharvestables)
			eharvestables[H.type]++
		else
			eharvestables[H.type] = 1
	var/list/allowed_products = list() // list of items it can produce that are under the limit
	for(var/P in produced)
		if(eharvestables[P] < max_per_harvestable)
			allowed_products.Add(P)
	if(!length(allowed_products))
		return
	var/obj/item/I = pick(allowed_products)
	I = new I (src)
	harvestables.Add(I)
	visible_message(span_notice("[src] grows \a [I]."))

/obj/structure/plant/tree/apple
	name = "apple tree"
	desc = ""
	species = "apple"
	produced = list(/obj/item/growable/fruit/apple)
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/alder
	name = "alder tree"
	desc = ""
	species = "alder"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/almond
	name = "almond tree"
	desc = ""
	species = "almond"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/apricot
	name = "apricot tree"
	desc = ""
	species = "apricot"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/ash
	name = "ash tree"
	desc = ""
	species = "ash"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/bayberry
	name = "bayberry tree"
	desc = ""
	species = "bayberry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/birch
	name = "birch tree"
	desc = ""
	species = "birch"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/cedar
	name = "cedar tree"
	desc = ""
	species = "cedar"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/cherry
	name = "cherry tree"
	desc = ""
	species = "cherry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/chestnut
	name = "chestnut tree"
	desc = ""
	species = "chestnut"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/ginkgo
	name = "ginkgo tree"
	desc = ""
	species = "ginkgo"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/hazel
	name = "hazel tree"
	desc = ""
	species = "hazel"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/larch
	name = "larch tree"
	desc = ""
	species = "larch"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/maple
	name = "maple tree"
	desc = ""
	species = "maple"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/oak
	name = "oak tree"
	desc = ""
	species = "oak"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/peach
	name = "peach tree"
	desc = ""
	species = "peach"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/pear
	name = "pear tree"
	desc = ""
	species = "pear"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/pecan
	name = "pecan tree"
	desc = ""
	species = "pecan"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/persimmon
	name = "persimmon tree"
	desc = ""
	species = "persimmon"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/plum
	name = "plum tree"
	desc = ""
	species = "plum"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/sand_pear
	name = "sand pear tree"
	desc = ""
	species = "sand_pear"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/walnut
	name = "walnut tree"
	desc = ""
	species = "walnut"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/willow
	name = "willow tree"
	desc = ""
	species = "willow"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =
