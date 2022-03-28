/obj/structure/plant
	name = "plant"
	desc = "Green?"
	icon = 'dwarfs/icons/farming/growing.dmi'
	icon_state = "sample"
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	var/species = "plant" // used for icons and to whitelist plants in plots
	var/health = 40
	var/maxhealth = 40
	var/health_delta = 5 SECONDS // how often plant takes damage when it has to
	var/lastcycle_health // last time it took damage
	var/list/produced = list() // path type list of items and their max quantity that can be produced at the last growth stage
	var/lastcycle_produce // last time it tried to grow something
	var/produce_delta = 10 SECONDS // amount of time between each try to grow new stuff
	var/harvestable = FALSE // whether a plant is ready for harvest
	var/icon_ripe // max growth stage and has harvestables on it
	var/icon_dead // icon when plant dies
	var/growthstages = 5 // how many growth stages it has
	var/growthdelta = 5 SECONDS // how long between two growth stages
	var/growthstage = 1 // current 'age' of the plant
	var/dead = FALSE // to prevent spam in plantdies()
	var/lastcycle_growth // last time it advanced in growth
	var/lifespan = 4 // plant's max age in cycles
	var/age = 1 // plants age in cycles; cycle's length is growthdelta
	var/obj/structure/farm_plot/plot // if planted via seeds will have a plot assigned to it

/obj/structure/plant/examine(mob/user)
	. = ..()
	var/healthtext = "<br>"
	switch(health)
		if(maxhealth/2 to INFINITY)
			healthtext += "[src] looks healthy."
		if(1 to maxhealth/2)
			healthtext += "[src] looks unhealthy."
		else
			healthtext += "[src] is dead!"
	. += healthtext

/obj/structure/plant/Initialize()
	. = ..()
	pixel_x = base_pixel_x + rand(-8, 8)
	pixel_y = base_pixel_y + rand(-8, 8)
	START_PROCESSING(SSplants, src)
	if(!icon_ripe)
		icon_ripe = "[species]-ripe"

	if(!icon_dead)
		icon_dead = "[species]-dead"
	lastcycle_produce = world.time
	lastcycle_health = world.time
	update_appearance()

/obj/structure/plant/Destroy()
	. = ..()
	STOP_PROCESSING(SSplants, src)
	if(plot)
		plot.myplant = null
		plot.name = initial(plot.name)

/obj/structure/plant/process(delta_time)
	if(dead)
		return
	var/needs_update = 0 // Checks if the icon needs updating so we don't redraw empty trays every time
	var/time_until_growth = lastcycle_growth+growthdelta // time to advance age
	if(plot?.fertlevel)
		time_until_growth = time_until_growth*0.8 // fertilizer makes plants grow 20% faster
	if(world.time >= time_until_growth)
		// Advance age
		age++
		growthstage = clamp(growthstage+1, 1, growthstages)
		lastcycle_growth = world.time
		needs_update = 1
		if(growthstage == growthstages)
			produce_delta = world.time
		if(istype(src, /obj/structure/plant/garden/crop) && can_grow_harvestable())
			harvestable = TRUE
	if(world.time >= lastcycle_produce+produce_delta)
		lastcycle_produce = world.time
		if(can_grow_harvestable())
			harvestable = TRUE
			needs_update = 1

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


	if(health <= 0 && !dead)
		plantdies()
		dead = TRUE
		update_appearance()

	if(age > lifespan && world.time >= lastcycle_health+health_delta)
		lastcycle_health = world.time
		health -= rand(1,3)

	if(plot)
		plot.fertlevel = clamp(plot.fertlevel-plot.fertrate, 0, plot.fertmax)
		if(!(species in plot.allowed_species) && world.time >= lastcycle_health+health_delta)
			lastcycle_health = world.time
			health-= rand(1,3)

	if(needs_update)
		update_appearance()


/obj/structure/plant/proc/plantdies()
	if(dead)
		return
	visible_message(span_warning("[src] withers away!"))
	if(plot)
		return
	qdel(src)


/obj/structure/plant/update_appearance(updates)
	. = ..()
	if(dead)
		icon_state = icon_dead
	else if(harvestable)
		icon_state = icon_ripe
	else
		icon_state = "[species]-[growthstage]"

/obj/structure/plant/proc/can_grow_harvestable()
	if(!length(produced))
		return FALSE
	if(growthstage != growthstages)
		return FALSE
	return TRUE

/obj/structure/plant/proc/harvest(var/mob/user)
	if(!do_after(user, 1 SECONDS, src)) // TODO: tweak time according to skill
		return
	for(var/_P in produced)
		var/obj/P = _P
		var/harvested = rand(0, produced[P])// TODO: tweak numbers according to skill; higher skill can give additional harvestables
		if(plot?.fertlevel)
			harvested += 3
		if(harvested)
			for(var/i in 1 to harvested)
				new P(loc)
			to_chat(user, span_notice("You harvest [initial(P.name)] from [src]."))
		else
			to_chat(user, span_warning("You fail to harvest [initial(P.name)] from [src]."))
	update_appearance()
	harvestable = FALSE

/obj/structure/plant/attack_hand(mob/user)
	if(!harvestable)
		to_chat(user, span_warning("There is nothing to harvest!"))
		return
	if(!dead)
		harvest(user)
	else
		if(plot)
			plot.attack_hand(user)
		else
			to_chat(user, span_notice("You remove the dead plant."))
			qdel(src)
