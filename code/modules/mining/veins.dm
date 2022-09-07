/datum/vein
	var/turf/my_turf

/datum/vein/New(turf/my_turf)
	if(!my_turf)
		CRASH("Created new vein without turf.")
	src.my_turf = my_turf

/datum/vein/proc/generate(ore_type=null, ore_check=TRUE)
	if(!ore_type)
		CRASH("Tried to generate a vein withour ore type.")
	if(ore_check)
		var/list/nearby = circlerangeturfs(my_turf, 25)
		for(var/turf/closed/mineral/M in nearby)
			if(M.mineralType)
				return FALSE
	return TRUE

/datum/vein/cluster
	var/core_radius
	var/outer_radius
	// Ore chance in core_radius
	var/core_spread_chance = 90
	// Ore chance in outer_radius
	var/outer_spread_chance = 40

/datum/vein/cluster/New(turf/my_turf)
	. = ..()
	core_radius = rand(0,2)
	outer_radius = core_radius+rand(1,3)

/datum/vein/cluster/generate(ore_type=null, ore_check=TRUE)
	if(!..())
		return
	var/list/core = circlerangeturfs(my_turf, core_radius)
	var/list/outer = circlerangeturfs(my_turf, outer_radius) - core
	// var/list/clear = circlerangeturfs(my_turf, outer_radius+1)
	var/obj/item/stack/ore/O = ore_type
	// var/core_count = 0
	// var/outer_count = 0
	for(var/turf/closed/mineral/M in core)
		if(prob(core_spread_chance))
			// core_count++
			M.mineralType = ore_type
			M.mineralAmt = rand(1, 5)
			M.draw_ore(M.smoothing_junction)
			M.name = initial(O.name)
	for(var/turf/closed/mineral/M in outer)
		if(prob(outer_spread_chance))
			// outer_count++
			M.mineralType = ore_type
			M.mineralAmt = rand(1, 5)
			M.draw_ore(M.smoothing_junction)
			M.name = initial(O.name)
	// for(var/turf/closed/mineral/M in clear)
	// 	if(!M.mineralType)
	// 		M.ScrapeAway()
	// log_world("Ore cluster generated. Core radius: [core_radius]; Outer radius: [outer_radius]; Core: [core_count]; Outer: [outer_count]")

/datum/vein/line
	var/direction
	var/core_length
	var/outer_length
	var/core_width
	var/outer_width
	var/core_spread_chance = 80
	var/outer_spread_chance = 30

/datum/vein/line/New(turf/my_turf)
	. = ..()
	direction = rand(0, 1) // 0 is horizontal, 1 is vertical
	core_length = rand(3, 8)
	outer_length = core_length+rand(1, 5)
	core_width = rand(0, 1)
	outer_width = rand(2, 5)
	if(outer_length/outer_width < 2)
		outer_width = round(outer_length/2)

/datum/vein/line/generate(ore_type, ore_check)
	if(!..())
		return
	var/list/core = RECT_TURFS((direction ? core_length : core_width), (direction ? core_width : core_length), my_turf)
	var/list/outer = RECT_TURFS((direction ? outer_length : outer_width), (direction ? outer_width : outer_length), my_turf) - core
	// var/list/clear = RECT_TURFS((direction ? outer_length+1 : outer_width+1), (direction ? outer_width+1 : outer_length+1), my_turf)
	var/obj/item/stack/ore/O = ore_type
	// var/core_count = 0
	// var/outer_count = 0
	for(var/turf/closed/mineral/M in core)
		if(prob(core_spread_chance))
			// core_count++
			M.mineralType = ore_type
			M.mineralAmt = rand(1, 5)
			M.draw_ore(M.smoothing_junction)
			M.name = initial(O.name)
	for(var/turf/closed/mineral/M in outer)
		if(prob(outer_spread_chance))
			// outer_count++
			M.mineralType = ore_type
			M.mineralAmt = rand(1, 5)
			M.draw_ore(M.smoothing_junction)
			M.name = initial(O.name)
	// for(var/turf/closed/mineral/M in clear)
	// 	if(!M.mineralType)
	// 		M.ScrapeAway()
	// log_world("Ore line generated. Core: [core_count]; Outer: [outer_count]")
