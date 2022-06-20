
/datum/map_generator_module/bottom_layer/lavaland_default
	spawnableTurfs = list(/turf/open/floor/stone = 100)

/datum/map_generator_module/bottom_layer/lavaland_mineral
	spawnableTurfs = list(/turf/closed/mineral/random/ = 100)

/datum/map_generator_module/bottom_layer/lavaland_mineral/dense
	spawnableTurfs = list(/turf/closed/mineral/random/ = 100)

/datum/map_generator_module/splatter_layer/lavaland_monsters
	spawnableTurfs = list()
	spawnableAtoms = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast = 10)

/datum/map_generator/lavaland/ground_only
	modules = list(/datum/map_generator_module/bottom_layer/lavaland_default)
	buildmode_name = "Block: Lavaland Floor"

/datum/map_generator/lavaland/dense_ores
	modules = list(/datum/map_generator_module/bottom_layer/lavaland_mineral/dense)
	buildmode_name = "Block: Lavaland Ores: Dense"

/datum/map_generator/lavaland/normal_ores
	modules = list(/datum/map_generator_module/bottom_layer/lavaland_mineral)
	buildmode_name = "Block: Lavaland Ores"
