/datum/map_generator/cave_generator/dwarven
	name = "Dwarfs"
	open_turf_types = list(/turf/open/floor/stone/raw=1)
	closed_turf_types = list(/turf/closed/mineral/random/dwarf_lustress=1)

	feature_spawn_list = null

	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/goliath/beast/ancient=15, /mob/living/simple_animal/hostile/shrooman=20,
		/mob/living/simple_animal/hostile/shrooman/fighter=20, /mob/living/simple_animal/hostile/froggernaut=5
	)

	flora_spawn_list = list(
		/obj/structure/flora/tree/boxplanet/glikodil=1, /obj/structure/flora/tree/boxplanet/svetosvin=1,
		/obj/structure/flora/tree/boxplanet/kartoshmel=1
	)

	mob_spawn_chance = 1
	flora_spawn_chance = 2

	initial_closed_chance = 45
	smoothing_iterations = 20
	birth_limit = 4
	death_limit = 3

/datum/map_generator/cave_generator/dwarven/upper
	name = "Upper Dwarfs"

/datum/map_generator/cave_generator/dwarven/middle
	name = "Middle Dwarfs"

/datum/map_generator/cave_generator/dwarven/bottom
	name = "Bottom Dwarfs"

/area/dwarf/cavesgen
	name = "Caverns"
	icon_state = "cavesgen"
	outdoors = TRUE
	static_lighting = TRUE
	base_lighting_alpha = 0
	ambientsounds = AWAY_MISSION
	requires_power = FALSE
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	sound_environment = SOUND_ENVIRONMENT_CAVE
	ambientsounds = list('white/valtos/sounds/lifeweb/caves8.ogg', 'white/valtos/sounds/lifeweb/caves_old.ogg')
	map_generator = /datum/map_generator/cave_generator/dwarven

/area/dwarf/cavesgen/upper_level
	map_generator = /datum/map_generator/cave_generator/dwarven/upper

/area/dwarf/cavesgen/middle_level
	map_generator = /datum/map_generator/cave_generator/dwarven/middle

/area/dwarf/cavesgen/bottom_level
	map_generator = /datum/map_generator/cave_generator/dwarven/bottom
