// perennial plants don't die when harvested
/obj/structure/plant/garden/perennial
	name = "perennial plant"
	desc = "Long green?"
	density = TRUE

/obj/structure/plant/garden/perennial/can_grow_harvestable()
	if(!length(produced))
		return FALSE
	if(length(harvestables) >= max_harvestables)
		return FALSE // no space for more stuff
	if(growthstage != growthstages)
		return FALSE
	return TRUE

/obj/structure/plant/garden/perennial/try_grow_harvestebles()
	if(!can_grow_harvestable())
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
