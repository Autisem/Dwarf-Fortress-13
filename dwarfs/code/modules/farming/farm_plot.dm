// /obj/structure/farm_plot
// 	name = "farm plot"
// 	anchored = TRUE
// 	// var/water_level = 100
// 	// var/max_water = 100
// 	var/fertilizer_level = 100
// 	var/max_fertilizer = 100
// 	var/obj/item/growable/seeds/seed
// 	var/list/allowed_seeds
// 	icon = 'icons/obj/hydroponics/equipment.dmi'
// 	icon_state = "soil"

/obj/structure/farm_plot/muddy
	name = "muddy plot"
	desc = "A pile of mud collected together to grow cave plants in."
	allowed_species = list("sample")

/obj/structure/farm_plot/soil
	name = "soil plot"
	desc = "A pile of dirt collected together to grow surface plants in."
	allowed_species = list()

// /obj/structure/farm_plot/attackby(obj/item/I, mob/user, params)
// 	if(istype(I, /obj/item/growable/seeds))
// 		if(seed)
// 			to_chat(user, span_warning("\A [seed] is already growing here!"))
// 			return
// 		seed = I
// 		I.forceMove(src)
// 		to_chat(user, span_notice("You plant \the [seed]."))



/obj/structure/farm_plot
	name = "hydroponics tray"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "soil"
	anchored = TRUE
	pixel_z = 8
	///The amount of water in the tray (max 100)
	// var/waterlevel = 100
	// var/watermax = 100
	// var/waterrate = 1
	var/fertlevel = 0
	var/fertmax = 100
	var/fertrate = 1
	var/list/allowed_species
	///The currently planted plant
	var/obj/structure/plant/myplant = null
	///Have we been visited by a bee recently, so bees dont overpollinate one plant
	// var/recent_bee_visit = FALSE
	///The last user to add a reagent to the tray, mostly for logging purposes.
	var/mob/lastuser


/obj/structure/farm_plot/examine(mob/user)
	. = ..()
	.+="<hr>"
	if(myplant)
		.+="There is \a [myplant] growing here."
	else
		.+="It's empty."
	var/fert_text = "<br>"
	switch(fertlevel)
		if(60 to 100)
			fert_text+="There is plenty of fertilizer in it."
		if(30 to 59)
			fert_text+="There is some fertilizer in it."
		if(1 to 29)
			fert_text+="There is almost no fertilizer in it."
		else
			fert_text+="There is no fertilizer in it."
	.+=fert_text
	// var/water_text = "<br>"
	// switch(waterlevel)
	// 	if(60 to 100)
	// 		water_text+="Looks very moist."
	// 	if(30 to 59)
	// 		water_text+="Looks normal."
	// 	if(1 to 29)
	// 		water_text+="Looks a bit dry."
	// 	else
	// 		water_text+="Looks extremely dry."
	// .+=water_text

/obj/structure/farm_plot/Destroy()
	if(myplant)
		QDEL_NULL(myplant)
	return ..()


/obj/structure/farm_plot/attackby(obj/item/O, mob/user, params)
	//Called when mob user "attacks" it with object O
	if(istype(O, /obj/item/growable/seeds))
		if(!myplant)
			var/obj/item/growable/seeds/S = O
			if(!user.transferItemToLoc(O, src))
				return
			to_chat(user, span_notice("You plant [O]."))
			var/obj/structure/plant/P = new S.plant(loc)
			myplant = P
			P.plot = src
			TRAY_NAME_UPDATE
			myplant.update_appearance()
			return
		else
			to_chat(user, span_warning("[capitalize(src.name)] already has seeds in it!"))
			return

	else if(istype(O, /obj/item/shovel/spade))
		user.visible_message(span_notice("[user] starts digging out [src]'s plants...") ,
			span_notice("You start digging out [src]'s plants..."))
		if(O.use_tool(src, user, 50, volume=50) || !myplant)
			user.visible_message(span_notice("[user] digs out the plants in [src]!") , span_notice("You dig out all of [src]'s plants!"))
			if(myplant) //Could be that they're just using it as a de-weeder
				QDEL_NULL(myplant)
				name = initial(name)
				desc = initial(desc)
			update_appearance()
			return
	else if(istype(O, /obj/item/fertilizer))
		user.visible_message(span_notice("[user] adds [O] to \the [src]."), span_notice("You add [O] to \the [src]."))
		var/obj/item/fertilizer/F = O
		fertlevel = clamp(fertlevel+F.fertilizer, 0, fertmax)
		qdel(F)
	else
		return ..()

/obj/structure/farm_plot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(myplant)
		if(myplant.dead)
			to_chat(user, span_notice("You remove the dead plant from [src]."))
			QDEL_NULL(myplant)
			update_appearance()
			TRAY_NAME_UPDATE
	else
		if(user)
			user.examinate(src)
