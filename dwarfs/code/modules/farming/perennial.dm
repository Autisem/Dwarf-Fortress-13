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

/obj/structure/plant/tree/try_grow_harvestebles()
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
