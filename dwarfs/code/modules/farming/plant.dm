/obj/structure/plant
	name = "plant"
	desc = "Green?"
	icon = 'dwarfs/icons/farming/growing.dmi'
	icon_state = "sample"
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	var/species = "plant" // used for icons and to whitelist plants in plots
	var/health = 40
	var/list/produced = list() // path type list of items that can be produced at the last growth stage
	var/list/harvestables = list() // list of objects that can be harvested
	var/lastcycle_produce // last time it tried to grow something
	var/produce_delta = 10 SECONDS // amount of time between each try to grow new stuff
	var/max_per_harvestable = 3 // a limit to a single type of harvestable a plant can have in harvestables
	var/max_harvestables = 10 // max amount of products a plant can have in total
	var/icon_ripe // max growth stage and has harvestables on it
	var/icon_dead // icon when plant dies
	var/dead = FALSE // to prevent spam in plantdies()
	var/growthstart // world.time when plant starts growing
	var/growthtime = 40 SECONDS // how long it takes to grow fully (no harvestables)
	var/scale // plant size
	var/state_change = 0.5 // number when the plant changes its state, if it has another one
	var/obj/structure/farm_plot/plot // if planted via seeds will have a plot assigned to it
	var/growth_mode = PLANTS_GROWTH_PERCENT

/obj/structure/plant/Initialize()
	. = ..()
	START_PROCESSING(SSplants, src)
	if(!icon_ripe)
		icon_ripe = "[species]-ripe"

	if(!icon_dead)
		icon_dead = "[species]-dead"
	lastcycle_produce = world.time
	growthstart = world.time
	icon_state = "[species]-1"
	update_appearance()

/obj/structure/plant/process(delta_time)
	if(dead)
		return
	var/needs_update = 0 // Checks if the icon needs updating so we don't redraw empty trays every time
	var/newscale = (world.time-growthstart)/(growthstart+growthtime)
	if(scale < state_change && newscale >= state_change)
		needs_update = 1
	else if(scale < 1 && newscale >= 1)
		needs_update = 1
	scale = newscale
	if(newscale >= 1)
		scale = 1
	else
		var/matrix/M = matrix()
		M.Scale(scale, scale)
		transform = M
	if(world.time >= lastcycle_produce+produce_delta)
		lastcycle_produce = world.time
		try_grow_harvestebles()
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

	if(plot)
		plot.fertlevel = clamp(plot.fertlevel-plot.fertrate, 0, plot.fertmax)
		if(!(species in plot.allowed_species))
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
	else if(length(harvestables))
		icon_state = icon_ripe
	else
		if(scale<state_change)
			icon_state = "[species]-1"
		else
			icon_state = "[species]-2"

/obj/structure/plant/proc/try_grow_harvestebles()
	return can_grow_harvestable()

/obj/structure/plant/proc/can_grow_harvestable()
	if(!length(produced))
		return FALSE
	if(length(harvestables) >= max_harvestables)
		return FALSE // no space for more stuff
	if(scale < 1)
		return FALSE
	return TRUE

/obj/structure/plant/proc/harvest(var/mob/user)
	if(!length(harvestables))
		to_chat(user, span_warning("There is nothing to harvest!"))
		return
	for(var/obj/I in harvestables)
		if(!do_after(user, 1 SECONDS, src)) // TODO: tweak time according to skill
			return
		if(prob(95)) // TODO: tweak chance according to skill; higher skill can give additional harvestables
			to_chat(user, span_notice("You harvest [I] from [src]."))
			I.forceMove(get_turf(user))
		else
			to_chat(user, span_warning("You fail to harvest [I] from [src]."))
			qdel(I)
		harvestables.Remove(I)
	update_appearance()

/obj/structure/plant/attack_hand(mob/user)
	harvest(user)
