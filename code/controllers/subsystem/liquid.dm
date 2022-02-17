SUBSYSTEM_DEF(liquids)
	name = "Жидкости"
	init_order = INIT_ORDER_LIQUIDS
	flags = SS_KEEP_TIMING
	wait = 1 SECONDS
	var/list/lava_turfs_list = list()
	var/list/currentrun = list()

/datum/controller/subsystem/liquids/stat_entry(msg)
	msg = "L:[length(lava_turfs_list)]"
	return ..()

/datum/controller/subsystem/liquids/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = lava_turfs_list.Copy()

	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/turf/open/lava/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing.spread_lava())
			lava_turfs_list -= thing
		if (MC_TICK_CHECK)
			return
		CHECK_TICK

/datum/controller/subsystem/liquids/Recover()
	if (istype(SSliquids.lava_turfs_list))
		lava_turfs_list = SSliquids.lava_turfs_list
