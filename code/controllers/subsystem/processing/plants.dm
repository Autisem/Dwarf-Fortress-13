SUBSYSTEM_DEF(plants)
	name = "Plants"
	priority = FIRE_PRIORITY_PROCESS
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT
	wait = 1 SECONDS

	var/stat_tag = "Pl" //Used for logging
	var/list/processing = list()
	var/list/currentrun = list()


/datum/controller/subsystem/plants/stat_entry(msg)
	msg = "[stat_tag]:[length(processing)]"
	return ..()

/datum/controller/subsystem/plants/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			processing -= thing
		else if(thing.process(wait * 0.1) == PROCESS_KILL)
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return
