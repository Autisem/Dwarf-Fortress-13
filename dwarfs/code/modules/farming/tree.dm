/obj/structure/plant/tree
	name = "tree"
	desc = "Big green?"
	density = TRUE

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
	produced = list(/obj/item/growable/fruit/apple)
	species = "sample"
