/area/dwarf
	name = "Dungeon"
	icon_state = "caves"
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE
	map_generator = /datum/map_generator/jungle_generator
	ambientsounds = AWAY_MISSION
	has_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_AWAY
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/dwarf/fortress
	name = "Fortress"
	icon_state = "fortress"
	outdoors = TRUE
	static_lighting = TRUE
	base_lighting_alpha = 0
	ambientsounds = AWAY_MISSION
	requires_power = FALSE
	sound_environment = SOUND_ENVIRONMENT_CAVE
	ambientsounds = list('sound/ambience/caves8.ogg', 'sound/ambience/caves_old.ogg')
