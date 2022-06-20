/datum/map_generator/cave_generator
	var/name = "Пещеры"
	///Weighted list of the types that spawns if the turf is open
	var/open_turf_types = list(/turf/open/floor/stone = 1)
	///Weighted list of the types that spawns if the turf is closed
	var/closed_turf_types =  list(/turf/closed/mineral/random = 1)


	///Weighted list of extra features that can spawn in the area, such as geysers.
	var/list/feature_spawn_list = list(/obj/structure/geyser/random = 1)
	///Weighted list of mobs that can spawn in the area.
	var/list/mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast/random = 50, \
		SPAWN_MEGAFAUNA = 4)
	///Weighted list of flora that can spawn in the area.
	var/list/flora_spawn_list


	///Base chance of spawning a mob
	var/mob_spawn_chance = 6
	///Base chance of spawning flora
	var/flora_spawn_chance = 2
	///Base chance of spawning features
	var/feature_spawn_chance = 0.1
	///Unique ID for this spawner
	var/string_gen

	///Chance of cells starting closed
	var/initial_closed_chance = 45
	///Amount of smoothing iterations
	var/smoothing_iterations = 20
	///How much neighbours does a dead cell need to become alive
	var/birth_limit = 4
	///How little neighbours does a alive cell need to die
	var/death_limit = 3

/datum/map_generator/cave_generator/generate_terrain(list/turfs)
	. = ..()
	var/start_time = REALTIMEOFDAY
	string_gen = rustg_cnoise_generate("[initial_closed_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	for(var/i in turfs) //Go through all the turfs and generate them
		var/turf/gen_turf = i

		var/area/A = gen_turf.loc
		if(!(A.area_flags & CAVES_ALLOWED))
			continue

		var/closed = text2num(string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x])

		var/stored_flags
		if(gen_turf.turf_flags & NO_RUINS)
			stored_flags |= NO_RUINS

		var/turf/new_turf = pickweight(closed ? closed_turf_types : open_turf_types)

		new_turf = gen_turf.ChangeTurf(new_turf, initial(new_turf.baseturfs), CHANGETURF_DEFER_CHANGE)

		new_turf.flags_1 |= stored_flags

		if(!closed)//Open turfs have some special behavior related to spawning flora and mobs.

			var/turf/open/new_open_turf = new_turf

			///Spawning isn't done in procs to save on overhead on the 60k turfs we're going through.

			//FLORA SPAWNING HERE
			var/atom/spawned_flora
			if(flora_spawn_list && prob(flora_spawn_chance))
				var/can_spawn = TRUE

				if(!(A.area_flags & FLORA_ALLOWED))
					can_spawn = FALSE
				if(can_spawn)
					spawned_flora = pickweight(flora_spawn_list)
					spawned_flora = new spawned_flora(new_open_turf)

			//FEATURE SPAWNING HERE
			var/atom/spawned_feature
			if(feature_spawn_list && prob(feature_spawn_chance))
				var/can_spawn = TRUE

				if(!(A.area_flags & FLORA_ALLOWED)) //checks the same flag because lol dunno
					can_spawn = FALSE

				var/atom/picked_feature = pickweight(feature_spawn_list)

				for(var/obj/structure/F in range(7, new_open_turf))
					if(istype(F, picked_feature))
						can_spawn = FALSE

				if(can_spawn)
					spawned_feature = new picked_feature(new_open_turf)

			//MOB SPAWNING HERE

			if(mob_spawn_list && !spawned_flora && !spawned_feature && prob(mob_spawn_chance))
				var/can_spawn = TRUE

				if(!(A.area_flags & MOB_SPAWN_ALLOWED))
					can_spawn = FALSE

				var/atom/picked_mob = pickweight(mob_spawn_list)

				picked_mob = pickweight(mob_spawn_list - SPAWN_MEGAFAUNA) //What if we used 100% of the brain...and did something (slightly) less shit than a while loop?

				for(var/thing in urange(12, new_open_turf)) //prevents mob clumps
					if(!ishostile(thing) && !istype(thing, /obj/structure/spawner))
						continue
					if(ispath(picked_mob, /mob/living/simple_animal/hostile/asteroid) || istype(thing, /mob/living/simple_animal/hostile/asteroid))
						can_spawn = FALSE //if the random is a standard mob, avoid spawning if there's another one within 12 tiles
						break
				if(can_spawn)
					new picked_mob(new_open_turf)
		CHECK_TICK

	to_chat(world, span_green(" -- #<b>[name]</b>:> <b>[(REALTIMEOFDAY - start_time)/10]</b> -- "))
	log_world("[name] is done job for [(REALTIMEOFDAY - start_time)/10]s!")
