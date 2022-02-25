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

// /obj/structure/farm_plot/muddy
// 	name = "muddy plot"
// 	desc = "A pile of mud collected together to grow cave plants in."
// 	allowed_seeds = list()

// /obj/structure/farm_plot/soil
// 	name = "soil plot"
// 	desc = "A pile of dirt collected together to grow surface plants in."
// 	allowed_seeds = list()

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
	icon_state = "hydrotray"
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
	///Current age
	var/age = 0
	///Is it dead?
	var/dead = FALSE
	///Its health
	var/plant_health
	///Last time it was harvested
	var/lastproduce = 0
	///Used for timing of cycles.
	var/lastcycle = 0
	///About 10 seconds / cycle
	var/cycledelay = 200
	///Ready to harvest?
	var/harvest = FALSE
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
	.+=fert_text
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

	if(myseed && (myseed.loc != src))
		myseed.forceMove(src)

	if(world.time >= (lastcycle + cycledelay))
		lastcycle = world.time
		if(myseed && !dead)
			// Advance age
			age++

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
			if(plant_health <= 0)
				plantdies()

			// If the plant is too old, lose health fast
			if(age > myseed.lifespan)
				adjustHealth(-rand(1,3))

			// Harvest code
			if(age > myseed.production && (age - lastproduce) > myseed.production && (!harvest && !dead))
				if(myseed && myseed.yield != -1) // Unharvestable shouldn't be harvested
					harvest = TRUE
				else
					lastproduce = age

		if (needs_update)
			update_appearance()
	return

/obj/structure/farm_plot/proc/update_plant_overlay()
	var/mutable_appearance/plant_overlay = mutable_appearance(myseed.growing_icon, layer = OBJ_LAYER + 0.01)
	if(dead)
		plant_overlay.icon_state = myseed.icon_dead
	else if(harvest)
		if(!myseed.icon_harvest)
			plant_overlay.icon_state = "[myseed.icon_grow][myseed.growthstages]"
		else
			plant_overlay.icon_state = myseed.icon_harvest
	else
		var/t_growthstate = clamp(round((age / myseed.growthstage) * myseed.growthstages), 1, myseed.growthstages)
		plant_overlay.icon_state = "[myseed.icon_grow][t_growthstate]"
	return plant_overlay

/**
 * Plant Death Proc.
 * Cleans up various stats for the plant upon death, including pests, harvestability, and plant health.
 */
/obj/structure/farm_plot/proc/plantdies()
	plant_health = 0
	harvest = FALSE
	lastproduce = 0
	if(!dead)
		update_appearance()
		dead = TRUE

/obj/structure/farm_plot/attackby(obj/item/O, mob/user, params)
	//Called when mob user "attacks" it with object O
	if(istype(O, /obj/item/seeds))
		if(!myseed)
			if(!user.transferItemToLoc(O, src))
				return
			to_chat(user, span_notice("You plant [O]."))
			dead = FALSE
			myseed = O
			TRAY_NAME_UPDATE
			age = 1
			plant_health = myseed.health
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
				age = 0
				plant_health = 0
				lastproduce = 0
				if(harvest)
					harvest = FALSE //To make sure they can't just put in another seed and insta-harvest it
				qdel(myseed)
				myseed = null
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
	if(harvest)
		return myseed.harvest(user)

	else if(dead)
		dead = FALSE
		to_chat(user, span_notice("You remove the dead plant from [src]."))
		QDEL_NULL(myseed)
		update_appearance()
		TRAY_NAME_UPDATE
	else
		if(user)
			user.examinate(src)

/**
 * Update Tray Proc
 * Handles plant harvesting on the tray side, by clearing the sead, names, description, and dead stat.
 * Shuts off autogrow if enabled.
 * Sends messages to the cleaer about plants harvested, or if nothing was harvested at all.
 * * User - The mob who clears the tray.
 */
/obj/structure/farm_plot/proc/update_tray(mob/user)
	harvest = FALSE
	lastproduce = age
	if(myseed.getYield() <= 0)
		to_chat(user, span_warning("You fail to harvest anything useful!"))
	else
		to_chat(user, span_notice("You harvest [myseed.getYield()] items from the [myseed.plantname]."))
	update_appearance()

/**
 * Adjust Health.
 * Raises the tray's plant_health stat by a given amount, with total health determined by the seed's endurance.
 * * adjustamt - Determines how much the plant_health will be adjusted upwards or downwards.
 */
/obj/structure/farm_plot/proc/adjustHealth(adjustamt)
	if(myseed && !dead)
		plant_health = clamp(plant_health + adjustamt, 0, myseed.health)

/**
 * Spawn Plant.
 * Upon using strange reagent on a tray, it will spawn a killer tomato or killer tree at random.
 */
/obj/structure/farm_plot/proc/spawnplant() // why would you put strange reagent in a hydro tray you monster I bet you also feed them blood
	var/list/livingplants = list(/mob/living/simple_animal/hostile/tree, /mob/living/simple_animal/hostile/killertomato)
	var/chosen = pick(livingplants)
	var/mob/living/simple_animal/hostile/C = new chosen
	C.faction = list("plants")
