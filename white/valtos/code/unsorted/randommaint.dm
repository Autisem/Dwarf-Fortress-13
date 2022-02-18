/datum/map_generator/station_maints_generator
	var/name = "Техтоннели"
	var/list/turf_types = list(/turf/open/floor/plating = 90, /turf/open/floor/plasteel = 1, /turf/open/floor/plasteel/dark = 1, /turf/closed/wall = 1)
	var/list/garbage_types = list(
		/obj/structure/grille = 80,
		/obj/structure/girder = 5,
		/obj/structure/grille/broken = 10,
		/obj/item/shard = 10,
		/obj/effect/gibspawner/generic = 1,
		/obj/effect/spawner/structure/window/hollow = 5,
		/mob/living/simple_animal/hostile/cockroach = 1,
		/obj/effect/decal/cleanable/cum = 1,
	)

	///Unique ID for this spawner
	var/string_gen

	///Chance of cells starting closed
	var/initial_garbage_chance = 45

	///Amount of smoothing iterations
	var/smoothing_iterations = 20

	///How much neighbours does a dead cell need to become alive
	var/birth_limit = 4

	///How little neighbours does a alive cell need to die
	var/death_limit = 3

/datum/map_generator/station_maints_generator/generate_terrain(list/turfs)
	. = ..()
	var/start_time = REALTIMEOFDAY
	string_gen = rustg_cnoise_generate("[initial_garbage_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	// double iterations

	for(var/i in turfs)

		if(!istype(i, /turf/open/genturf))
			continue

		var/turf/gen_turf = i

		var/garbage_turf = text2num(string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x])

		var/turf/new_turf = pickweight(turf_types)

		new_turf = gen_turf.ChangeTurf(new_turf, initial(new_turf.baseturfs), CHANGETURF_DEFER_CHANGE)

		if(garbage_turf)
			var/atom/picked_garbage = pickweight(garbage_types)
			new picked_garbage(new_turf)

		CHECK_TICK

	to_chat(world, span_green(" -- #<b>[name]</b>:> <b>[(REALTIMEOFDAY - start_time)/10]</b> -- "))
	log_world("[name] is done job for [(REALTIMEOFDAY - start_time)/10]s!")
