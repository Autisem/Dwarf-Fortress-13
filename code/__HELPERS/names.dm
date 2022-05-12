/proc/lizard_name(gender)
	if(gender == MALE)
		return "[pick(GLOB.lizard_names_male)]-[pick(GLOB.lizard_names_male)]"
	else
		return "[pick(GLOB.lizard_names_female)]-[pick(GLOB.lizard_names_female)]"

/proc/ethereal_name()
	var/tempname = "[pick(GLOB.ethereal_names)] [random_capital_letter()]"
	if(prob(65))
		tempname += random_capital_letter()
	return tempname

/proc/dwarf_name()
	var/first = pick(GLOB.dwarf_first)
	var/last = ""
	for(var/i in 1 to 2)
		var/list/T = pick(GLOB.language_nouns ,GLOB.language_adjectives ,GLOB.language_verbs ,GLOB.language_prefixes)
		var/picked = pick(T)
		last+=lowertext(T[picked]["Dwarven"])
	return "[capitalize(first)] [capitalize(last)]"

/proc/plasmaman_name()
	return "[pick(GLOB.plasmaman_names)] \Roman[rand(1,99)]"

/proc/moth_name()
	return "[pick(GLOB.moth_first)] [pick(GLOB.moth_last)]"

GLOBAL_VAR(command_name)
/proc/command_name()
	if (GLOB.command_name)
		return GLOB.command_name

	var/name = "Центральное Командование"

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

	if (prob(10))
		new_station_name = pick(GLOB.fortress_prefixes) + " "
	else
		new_station_name = "Fortress "

	new_station_name += capitalize(pick(GLOB.fortress_names))

	return capitalize(new_station_name)

/proc/odd_organ_name()
	return "[pick(GLOB.gross_adjectives)], [pick(GLOB.gross_adjectives)] орган"

/**
 * returns an ic name of the tool needed
 * Arguments:
 * * tool_behaviour: the tool described!
 */
/proc/tool_behaviour_name(tool_behaviour)
	switch(tool_behaviour)
		if(TOOL_CROWBAR)
			return "a crowbar"
		if(TOOL_MULTITOOL)
			return "a multitool"
		if(TOOL_SCREWDRIVER)
			return "a screwdriver"
		if(TOOL_WIRECUTTER)
			return "a pair of wirecutters"
		if(TOOL_WRENCH)
			return "a wrench"
		if(TOOL_WELDER)
			return "a welder"
		if(TOOL_ANALYZER)
			return "an analyzer tool"
		if(TOOL_MINING)
			return "a mining implement"
		if(TOOL_SHOVEL)
			return "a digging tool"
		if(TOOL_RETRACTOR)
			return "a retractor"
		if(TOOL_HEMOSTAT)
			return "something to clamp bleeding"
		if(TOOL_CAUTERY)
			return "a cautery"
		if(TOOL_DRILL)
			return "a drilling tool"
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
