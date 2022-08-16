/datum/reagent/tanin
	name = "taning"
	color = "#571d06"

/datum/reagent/tanin/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(istype(exposed_obj, /obj/item/stack/sheet/dryhide))
		var/obj/item/stack/sheet/dryhide/D = exposed_obj
		new /obj/item/stack/sheet/leather (get_turf(D), D.leather_amount)
		qdel(D)
