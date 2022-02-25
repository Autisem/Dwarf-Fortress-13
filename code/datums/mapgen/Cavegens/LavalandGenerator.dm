/datum/map_generator/cave_generator/lavaland
	open_turf_types = list(/turf/open/floor/plating/asteroid/basalt/lava_land_surface = 1)
	closed_turf_types =  list(/turf/closed/mineral/random/volcanic = 1)


	feature_spawn_list = list(/obj/structure/geyser/random = 1)
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast/random = 50, \
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/random = 40, \
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/random = 30, \
		SPAWN_MEGAFAUNA = 4, /mob/living/simple_animal/hostile/asteroid/goldgrub = 10
	)

	initial_closed_chance = 45
	smoothing_iterations = 50
	birth_limit = 4
	death_limit = 3
