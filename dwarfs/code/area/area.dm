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
	ambientsounds = list('white/valtos/sounds/lifeweb/caves8.ogg', 'white/valtos/sounds/lifeweb/caves_old.ogg')
	env_temp_relative = 20

/area/dwarf/Entered(atom/movable/M, oldloc)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.GetComponent(/datum/component/realtemp))
			H.AddComponent(/datum/component/realtemp)
