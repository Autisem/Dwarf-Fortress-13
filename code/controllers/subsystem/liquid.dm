SUBSYSTEM_DEF(liquids)
	name = "Жидкости"
	init_order = INIT_ORDER_LIQUIDS
	flags = SS_KEEP_TIMING
	wait = 1 SECONDS
	var/list/liquid_turfs_list = list()
	var/list/currentrun = list()

/datum/controller/subsystem/liquids/stat_entry(msg)
	msg = "L:[length(liquid_turfs_list)]"
	return ..()

/datum/controller/subsystem/liquids/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = liquid_turfs_list.Copy()

	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/turf/open/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing.spread_liquid())
			liquid_turfs_list -= thing
		if (MC_TICK_CHECK)
			return
		CHECK_TICK

/datum/controller/subsystem/liquids/Recover()
	if (istype(SSliquids.liquid_turfs_list))
		liquid_turfs_list = SSliquids.liquid_turfs_list
