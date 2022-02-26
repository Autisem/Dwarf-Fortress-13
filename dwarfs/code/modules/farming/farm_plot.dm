// /obj/structure/farm_plot
// 	name = "farm plot"
// 	anchored = TRUE
// 	// var/water_level = 100
// 	// var/max_water = 100
// 	var/fertilizer_level = 100
// 	var/max_fertilizer = 100
// 	var/obj/item/seeds/seed
// 	var/list/allowed_seeds
// 	icon = 'icons/obj/hydroponics/equipment.dmi'
// 	icon_state = "soil"

/obj/structure/farm_plot/muddy
	name = "muddy plot"
	desc = "A pile of mud collected together to grow cave plants in."
	allowed_seeds = list()

/obj/structure/farm_plot/soil
	name = "soil plot"
	desc = "A pile of dirt collected together to grow surface plants in."
	allowed_seeds = list()

// /obj/structure/farm_plot/attackby(obj/item/I, mob/user, params)
// 	if(istype(I, /obj/item/seeds))
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
	var/list/allowed_seeds
	///Used for timing of cycles.
	var/lastcycle = 0
	///The currently planted seed
	var/obj/item/seeds/myseed = null
	///Have we been visited by a bee recently, so bees dont overpollinate one plant
	// var/recent_bee_visit = FALSE
	///The last user to add a reagent to the tray, mostly for logging purposes.
	var/mob/lastuser


/obj/structure/farm_plot/examine(mob/user)
	. = ..()
	.+="<hr>"
	if(myseed)
		.+="There is \a [myseed.plantname] growing here."
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

/obj/structure/farm_plot/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/farm_plot/Destroy()
	if(myseed)
		QDEL_NULL(myseed)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/farm_plot/process(delta_time)
	var/needs_update = 0 // Checks if the icon needs updating so we don't redraw empty trays every time
	if(myseed)
		if(myseed.loc != src)
			myseed.forceMove(src)
		var/time_until = lastcycle+myseed.growth_delta // time to advance age
		if(fertlevel)
			time_until = time_until*0.8 // fertilizer makes plants grow 20% faster
		if(world.time >= time_until && myseed.health>0)
			// Advance age
			myseed.growthstage = clamp(myseed.growthstage+1, 1, myseed.growthstages)
			myseed.age++
			lastcycle = world.time
			needs_update = 1


//Fertilizer//////////////////////////////////////////////////////////////
			// Fertilizer depletes at a constant rate, since new nutrients can boost stats far easier.
			fertlevel = clamp(fertlevel-fertrate, 0, fertmax)

//Water//////////////////////////////////////////////////////////////////
			// // Drink random amount of water
			// waterlevel = clamp(waterlevel-waterrate, 0, watermax)

			// // If the plant is dry, it loses health pretty fast
			// if(waterlevel <= 10)
			// 	adjustHealth(-rand(0,1) / rating)
			// 	if(waterlevel <= 0)
			// 		adjustHealth(-rand(0,2) / rating)

			// // Sufficient water level and nutrient level = plant healthy
			// else if(waterlevel > 10 && reagents.total_volume > 0)
			// 	adjustHealth(rand(1,2) / rating)

//Health & Age///////////////////////////////////////////////////////////

		// Plant dies if plant_health <= 0
		if(myseed.health <= 0 && !myseed.dead)
			plantdies()

		if(!(myseed.type in allowed_seeds))
			myseed.health-= rand(1,3)

		// If the plant is too old, lose health fast
		if(myseed.age > myseed.lifespan)
			myseed.health-= rand(1,3)
		if (needs_update)
			update_appearance()

/obj/structure/farm_plot/proc/update_plant_overlay()
	var/mutable_appearance/plant_overlay = mutable_appearance(myseed.growing_icon, layer = OBJ_LAYER + 0.01)
	if(!myseed.health)
		plant_overlay.icon_state = myseed.icon_dead
	else
		plant_overlay.icon_state = "[myseed.species][myseed.growthstage]"
	return plant_overlay

/obj/structure/farm_plot/update_overlays()
	. = ..()
	if(myseed)
		.+=update_plant_overlay()

/obj/structure/farm_plot/update_appearance(updates)
	. = ..()
	update_overlays()

/**
 * Plant Death Proc.
 * Cleans up various stats for the plant upon death, including pests, harvestability, and plant health.
 */
/obj/structure/farm_plot/proc/plantdies()
	src.visible_message(span_warning("[myseed.plantname] dies!"))
	myseed.health = 0
	myseed.dead = TRUE
	update_appearance()

/obj/structure/farm_plot/attackby(obj/item/O, mob/user, params)
	//Called when mob user "attacks" it with object O
	if(istype(O, /obj/item/seeds))
		if(!myseed)
			if(!user.transferItemToLoc(O, src))
				return
			to_chat(user, span_notice("You plant [O]."))
			myseed = O
			TRAY_NAME_UPDATE
			lastcycle = world.time
			update_appearance()
			return
		else
			to_chat(user, span_warning("[capitalize(src.name)] already has seeds in it!"))
			return

	else if(istype(O, /obj/item/shovel/spade))
		user.visible_message(span_notice("[user] starts digging out [src]'s plants...") ,
			span_notice("You start digging out [src]'s plants..."))
		if(O.use_tool(src, user, 50, volume=50) || !myseed)
			user.visible_message(span_notice("[user] digs out the plants in [src]!") , span_notice("You dig out all of [src]'s plants!"))
			if(myseed) //Could be that they're just using it as a de-weeder
				myseed.age = 0
				myseed.health = 0
				QDEL_NULL(myseed)
				name = initial(name)
				desc = initial(desc)
			update_appearance()
			return
	else
		return ..()

/obj/structure/farm_plot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(myseed)
		if(length(myseed.harvestables))
			return myseed.harvest(user)

	else if(!myseed.health)
		to_chat(user, span_notice("You remove the dead plant from [src]."))
		QDEL_NULL(myseed)
		update_appearance()
		TRAY_NAME_UPDATE
	else
		if(user)
			user.examinate(src)
