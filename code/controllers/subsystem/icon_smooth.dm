SUBSYSTEM_DEF(icon_smooth)
	name = "Icon Smoothing"
	init_order = INIT_ORDER_ICON_SMOOTHING
	wait = 1
	priority = FIRE_PRIOTITY_SMOOTHING
	flags = SS_TICKER

	///Blueprints assemble an image of what pipes/manifolds/wires look like on initialization, and thus should be taken after everything's been smoothed
	var/list/blueprint_queue = list()
	var/list/smooth_queue = list()
	var/list/smooth_borders_queue = list()
	var/list/deferred = list()

	var/list/borders_cache = list()

/datum/controller/subsystem/icon_smooth/fire()
	var/list/cached = smooth_queue
	while(length(cached))
		var/atom/smoothing_atom = cached[length(cached)]
		cached.len--
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED))
			continue
		if(smoothing_atom.flags_1 & INITIALIZED_1)
			smoothing_atom.smooth_icon()
		else
			deferred += smoothing_atom
		if (MC_TICK_CHECK)
			return

	var/list/cached_borders = smooth_borders_queue
	while(length(cached_borders))
		var/atom/smoothing_atom = cached_borders[length(cached_borders)]
		cached_borders.len--
		if(QDELETED(smoothing_atom))
			continue
		if(smoothing_atom.flags_1 & INITIALIZED_1)
			smoothing_atom.smooth_borders()
		else
			deferred += smoothing_atom
		if (MC_TICK_CHECK)
			return

	if (!cached.len && !cached_borders.len)
		if (deferred.len)
			smooth_queue = deferred
			deferred = cached
		else
			can_fire = FALSE

/datum/controller/subsystem/icon_smooth/Initialize()
	for(var/z in 2 to world.maxz)
		smooth_zlevel(z, TRUE)

	var/list/queue = smooth_queue
	smooth_queue = list()
	var/list/queue_borders = smooth_borders_queue
	smooth_borders_queue = list()

	while(length(queue))
		var/atom/smoothing_atom = queue[length(queue)]
		queue.len--
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED) || smoothing_atom.z < 2)
			continue
		smoothing_atom.smooth_icon()
		CHECK_TICK

	while(length(queue_borders))
		var/atom/smoothing_atom = queue_borders[length(queue_borders)]
		queue_borders.len--
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_B_QUEUED) || smoothing_atom.z < 2)
			continue
		smoothing_atom.smooth_borders()
		CHECK_TICK

	queue = blueprint_queue
	blueprint_queue = list()

	for(var/item in queue)
		var/atom/movable/movable_item = item
		if(!isturf(movable_item.loc))
			continue
		var/turf/item_loc = movable_item.loc
		item_loc.add_blueprints(movable_item)

	return ..()


/datum/controller/subsystem/icon_smooth/proc/add_to_queue(atom/thing)
	if(thing.smoothing_flags & SMOOTH_QUEUED)
		return
	thing.smoothing_flags |= SMOOTH_QUEUED
	smooth_queue += thing
	if(!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/icon_smooth/proc/add_to_queue_border(atom/thing)
	if(thing.smoothing_flags & SMOOTH_B_QUEUED)
		return
	thing.smoothing_flags |= SMOOTH_B_QUEUED
	smooth_borders_queue += thing
	if(!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/icon_smooth/proc/remove_from_queues(atom/thing)
	thing.smoothing_flags &= ~SMOOTH_QUEUED
	thing.smoothing_flags &= ~SMOOTH_B_QUEUED
	smooth_queue -= thing
	smooth_borders_queue -= thing
	if(blueprint_queue)
		blueprint_queue -= thing
	deferred -= thing
