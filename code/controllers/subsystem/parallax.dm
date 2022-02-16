SUBSYSTEM_DEF(parallax)
	name = "Parallax"
	wait = 2
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND
	priority = FIRE_PRIORITY_PARALLAX
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun
	var/planet_x_offset = 128
	var/planet_y_offset = 128
	var/random_layer
	var/random_parallax_color
	var/random_space


//These are cached per client so needs to be done asap so people joining at roundstart do not miss these.
/datum/controller/subsystem/parallax/PreInit()
	. = ..()
	random_space = pick(/atom/movable/screen/parallax_layer/layer_1, /atom/movable/screen/parallax_layer/layer_1_2, /atom/movable/screen/parallax_layer/layer_1_3, /atom/movable/screen/parallax_layer/layer_1_4, /atom/movable/screen/parallax_layer/layer_1_5)
	if(prob(70))	//70% chance to pick a special extra layer
		random_layer = pick(/atom/movable/screen/parallax_layer/random/space_gas, /atom/movable/screen/parallax_layer/nebula)
		random_parallax_color = pick(COLOR_TEAL, COLOR_GREEN, COLOR_SILVER, COLOR_YELLOW, COLOR_CYAN, COLOR_ORANGE, COLOR_PURPLE)//Special color for random_layer1. Has to be done here so everyone sees the same color.
	planet_y_offset = rand(100, 160)
	planet_x_offset = rand(100, 160)


/datum/controller/subsystem/parallax/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/client/processing_client = currentrun[currentrun.len]
		currentrun.len--
		if (QDELETED(processing_client) || !processing_client.eye)
			if (MC_TICK_CHECK)
				return
			continue

		var/atom/movable/movable_eye = processing_client.eye
		if(!istype(movable_eye))
			continue

		for (movable_eye; isloc(movable_eye.loc) && !isturf(movable_eye.loc); movable_eye = movable_eye.loc);

		if(movable_eye == processing_client.movingmob)
			if (MC_TICK_CHECK)
				return
			continue
		if(!isnull(processing_client.movingmob))
			LAZYREMOVE(processing_client.movingmob.client_mobs_in_contents, processing_client.mob)
		LAZYADD(movable_eye.client_mobs_in_contents, processing_client.mob)
		processing_client.movingmob = movable_eye
		if (MC_TICK_CHECK)
			return
	currentrun = null
