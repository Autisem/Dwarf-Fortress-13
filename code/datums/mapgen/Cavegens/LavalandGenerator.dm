/datum/map_generator/cave_generator/lavaland
	open_turf_types = list(/turf/open/floor/stone = 1)
	closed_turf_types =  list(/turf/closed/mineral/random =1 )


	feature_spawn_list = list(/obj/structure/geyser/random = 1)
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast/random = 50, \
		SPAWN_MEGAFAUNA = 4
	)

	initial_closed_chance = 45
	smoothing_iterations = 50
	birth_limit = 4
	death_limit = 3
