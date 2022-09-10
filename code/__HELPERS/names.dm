/proc/dwarf_name()
	var/first = pick(GLOB.dwarf_first)
	var/last = ""
	for(var/i in 1 to 2)
		var/list/T = pick(GLOB.language_nouns ,GLOB.language_adjectives ,GLOB.language_verbs ,GLOB.language_prefixes)
		var/picked = pick(T)
		last+=lowertext(T[picked]["Dwarven"])
	return "[capitalize(first)] [capitalize(last)]"

GLOBAL_VAR(command_name)
/proc/command_name()
	if (GLOB.command_name)
		return GLOB.command_name

	var/name = "Main Fortress"

	GLOB.command_name = name
	return name

/proc/change_command_name(name)

	GLOB.command_name = name

	return name

/proc/station_name()
	if(!GLOB.station_name)
		var/newname
		var/config_station_name = CONFIG_GET(string/stationname)
		if(config_station_name)
			newname = config_station_name
		else
			newname = new_station_name()

		set_station_name(newname)

	return GLOB.station_name

/proc/set_station_name(newname)
	GLOB.station_name = newname

	var/config_server_name = CONFIG_GET(string/servername)
	if(config_server_name)
		world.name = "[config_server_name][config_server_name == GLOB.station_name ? "" : ": [GLOB.station_name]"]"
	else
		world.name = GLOB.station_name

/proc/new_station_name()
	var/new_station_name = ""
	for(var/i in 1 to 2)
		new_station_name += GLOB.language_nouns[pick(GLOB.language_nouns)]["Dwarven"]

	if(prob(30))
		new_station_name += " the "
		new_station_name += GLOB.language_adjectives[pick(GLOB.language_adjectives)]["Dwarven"]

	if(prob(30))
		new_station_name += " of "
		new_station_name += GLOB.language_nouns[pick(GLOB.language_nouns)]["Dwarven"]

	return capitalize(new_station_name)

/proc/odd_organ_name()
	return "[pick(GLOB.gross_adjectives)], [pick(GLOB.gross_adjectives)] organ"

/**
 * returns an ic name of the tool needed
 * Arguments:
 * * tool_behaviour: the tool described!
 */
/proc/tool_behaviour_name(tool_behaviour)
	switch(tool_behaviour)
		if(TOOL_CROWBAR)
			return "a crowbar"
		if(TOOL_SCREWDRIVER)
			return "a screwdriver"
		if(TOOL_WRENCH)
			return "a wrench"
		if(TOOL_ANALYZER)
			return "an analyzer tool"
		if(TOOL_AXE)
			return "an axe tool"
		if(TOOL_PICKAXE)
			return "a pickaxe tool"
		if(TOOL_SHOVEL)
			return "a digging tool"
		if(TOOL_RETRACTOR)
			return "a retractor"
		if(TOOL_HEMOSTAT)
			return "something to clamp bleeding"
		if(TOOL_CAUTERY)
			return "a cautery"
		if(TOOL_SCALPEL)
			return "a fine cutting tool"
		if(TOOL_SAW)
			return "a saw"
		if(TOOL_BONESET)
			return "a bone setter"
		if(TOOL_KNIFE)
			return "a cutting tool"
		if(TOOL_BLOODFILTER)
			return "a blood filter"
		if(TOOL_ROLLINGPIN)
			return "a rolling pin"
		else
			return "something... but the gods didn't set this up right (Please report this bug)"
