/obj/structure/plant
	name = "plant"
	desc = "Green?"
	icon = 'dwarfs/icons/farming/growing.dmi'
	icon_state = "sample"
	var/species = "plant"
	var/health = 15
	var/list/produced = list()
	var/list/harvestables = list()
	var/icon_ripe
	var/icon_dead
	var/growthstages = 5
	var/growthdelta = 1 MINUTES
	var/growthstage = 1
	var/dead = FALSE
	var/lastcycle
	var/obj/structure/farm_plot/plot

/obj/structure/plant/Initialize()
	. = ..()
	START_PROCESSING(SSplants, src)
	if(!icon_ripe)
		icon_ripe = "[species]-ripe"

	if(!icon_dead)
		icon_dead = "[species]-dead"
	lastcycle = world.time

/obj/structure/plant/process(delta_time)
	var/needs_update = 0 // Checks if the icon needs updating so we don't redraw empty trays every time
	var/time_until = lastcycle+growthdelta // time to advance age
	if(plot?.fertlevel)
		time_until = time_until*0.8 // fertilizer makes plants grow 20% faster
	if(world.time >= time_until && health>0)
		if(growthstage == growthstages)
			grow_harvestebles()
			update_appearance()
		// Advance age
		growthstage = clamp(growthstage+1, 1, growthstages)
		lastcycle = world.time
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

//Health & Age///////////////////////////////////////////////////////////

	// Plant dies if plant_health <= 0
	if(health <= 0 && !dead)
		plantdies()
		dead = TRUE
		update_appearance()

	if(plot)
		plot.fertlevel = clamp(plot.fertlevel-plot.fertrate, 0, plot.fertmax)
		if(!(species in plot.allowed_species))
			health-= rand(1,3)

	if (needs_update)
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
	else if(length(harvestables) && growthstage == growthstages)
		icon_state = icon_ripe
	else
		icon_state = "[species][growthstage]"

/obj/structure/plant/proc/grow_harvestebles()
	return
