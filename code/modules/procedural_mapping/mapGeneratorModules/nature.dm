
//Contents exist primarily for the nature generator test type.


//Pine Trees
/datum/map_generator_module/pine_trees
	spawnableAtoms = list()

//Dead Trees
/datum/map_generator_module/dead_trees
	spawnableAtoms = list()

//Random assortment of bushes
/datum/map_generator_module/rand_bushes
	spawnableAtoms = list()

//Random assortment of rocks and rockpiles
/datum/map_generator_module/rand_rocks
	spawnableAtoms = list()


//Grass turfs
/datum/map_generator_module/bottom_layer/grass_turfs
	spawnableTurfs = list(/turf/open/floor/stone = 100)


//Grass tufts with a high spawn chance
/datum/map_generator_module/dense_layer/grass_tufts
	spawnableTurfs = list()
	spawnableAtoms = list()
