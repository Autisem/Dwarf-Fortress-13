#define FILE_ANTAG_REP "data/AntagReputation.json"
#define FILE_RECENT_MAPS "data/RecentMaps.json"

#define KEEP_ROUNDS_MAP 3

SUBSYSTEM_DEF(persistence)
	name = "Память системы"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE

	var/list/saved_messages = list()
	var/list/saved_modes = list(1,2,3)
	var/list/saved_maps = list()
	var/list/blocked_maps = list()
	var/list/antag_rep = list()
	var/list/antag_rep_change = list()
	var/list/picture_logging_information = list()
	var/list/obj/structure/sign/painting/painting_frames = list()
	var/list/paintings = list()

/datum/controller/subsystem/persistence/Initialize()
	LoadPoly()
	LoadRecentModes()
	LoadRecentMaps()
	if(CONFIG_GET(flag/use_antag_rep))
		LoadAntagReputation()
	LoadRandomizedRecipes()
	return ..()

/datum/controller/subsystem/persistence/proc/LoadPoly()
	for(var/mob/living/simple_animal/parrot/poly/P in GLOB.alive_mob_list)
		twitterize(P.speech_buffer, "polytalk")
		break //Who's been duping the bird?!

/datum/controller/subsystem/persistence/proc/LoadRecentModes()
	var/json_file = file("data/RecentModes.json")
	if(!fexists(json_file))
		return
	var/list/json = r_json_decode(file2text(json_file))
	if(!json)
		return
	saved_modes = json["data"]

/datum/controller/subsystem/persistence/proc/LoadRecentMaps()
	var/map_sav = FILE_RECENT_MAPS
	if(!fexists(FILE_RECENT_MAPS))
		return
	var/list/json = json_decode(file2text(map_sav))
	if(!json)
		return
	saved_maps = json["data"]

	//Convert the mapping data to a shared blocking list, saves us doing this in several places later.
	for(var/map in config.maplist)
		var/datum/map_config/VM = config.maplist[map]
		var/run = 0
		if(VM.map_name == SSmapping.config.map_name)
			run++
		for(var/name in SSpersistence.saved_maps)
			if(VM.map_name == name)
				run++
		if(run >= 2) //If run twice in the last KEEP_ROUNDS_MAP + 1 (including current) rounds, disable map for voting and rotation.
			blocked_maps += VM.map_name

/datum/controller/subsystem/persistence/proc/LoadAntagReputation()
	var/json = file2text(FILE_ANTAG_REP)
	if(!json)
		var/json_file = file(FILE_ANTAG_REP)
		if(!fexists(json_file))
			WARNING("Failed to load antag reputation. File likely corrupt.")
			return
		return
	antag_rep = r_json_decode(json)

/datum/controller/subsystem/persistence/proc/CollectData()
	CollectRoundtype()
	CollectMaps()
	if(CONFIG_GET(flag/use_antag_rep))
		CollectAntagReputation()
	SaveRandomizedRecipes()
	SaveScars()

/datum/controller/subsystem/persistence/proc/remove_duplicate_trophies(list/trophies)
	var/list/ukeys = list()
	. = list()
	for(var/trophy in trophies)
		var/tkey = "[trophy["path"]]-[trophy["message"]]"
		if(ukeys[tkey])
			continue
		else
			. += list(trophy)
			ukeys[tkey] = TRUE

/datum/controller/subsystem/persistence/proc/CollectRoundtype()
	saved_modes[3] = saved_modes[2]
	saved_modes[2] = saved_modes[1]
	saved_modes[1] = SSticker.mode.config_tag
	var/json_file = file("data/RecentModes.json")
	var/list/file_data = list()
	file_data["data"] = saved_modes
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/CollectMaps()
	if(length(saved_maps) > KEEP_ROUNDS_MAP) //Get rid of extras from old configs.
		saved_maps.Cut(KEEP_ROUNDS_MAP+1)
	var/mapstosave = min(length(saved_maps)+1, KEEP_ROUNDS_MAP)
	if(length(saved_maps) < mapstosave) //Add extras if too short, one per round.
		saved_maps += mapstosave
	for(var/i = mapstosave; i > 1; i--)
		saved_maps[i] = saved_maps[i-1]
	saved_maps[1] = SSmapping.config.map_name
	var/json_file = file(FILE_RECENT_MAPS)
	var/list/file_data = list()
	file_data["data"] = saved_maps
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/CollectAntagReputation()
	var/ANTAG_REP_MAXIMUM = CONFIG_GET(number/antag_rep_maximum)

	for(var/p_ckey in antag_rep_change)
//		var/start = antag_rep[p_ckey]
		antag_rep[p_ckey] = max(0, min(antag_rep[p_ckey]+antag_rep_change[p_ckey], ANTAG_REP_MAXIMUM))

//		WARNING("AR_DEBUG: [p_ckey]: Committed [antag_rep_change[p_ckey]] reputation, going from [start] to [antag_rep[p_ckey]]")

	antag_rep_change = list()

	fdel(FILE_ANTAG_REP)
	text2file(json_encode(antag_rep), FILE_ANTAG_REP)


/datum/controller/subsystem/persistence/proc/LoadRandomizedRecipes()
	var/json_file = file("data/RandomizedChemRecipes.json")
	var/json
	if(fexists(json_file))
		json = r_json_decode(file2text(json_file))

	for(var/randomized_type in subtypesof(/datum/chemical_reaction/randomized))
		var/datum/chemical_reaction/randomized/R = new randomized_type
		var/loaded = FALSE
		if(R.persistent && json)
			var/list/recipe_data = json["[R.type]"]
			if(recipe_data)
				if(R.LoadOldRecipe(recipe_data) && (daysSince(R.created) <= R.persistence_period))
					loaded = TRUE
		if(!loaded) //We do not have information for whatever reason, just generate new one
			if(R.persistent)
				log_game("Resetting persistent [randomized_type] random recipe.")
			R.GenerateRecipe()

		if(!R.HasConflicts()) //Might want to try again if conflicts happened in the future.
			add_chemical_reaction(R)
		else
			log_game("Randomized recipe [randomized_type] resulted in conflicting recipes.")

/datum/controller/subsystem/persistence/proc/SaveRandomizedRecipes()
	var/json_file = file("data/RandomizedChemRecipes.json")
	var/list/file_data = list()

	//asert globchems done
	for(var/randomized_type in subtypesof(/datum/chemical_reaction/randomized))
		var/datum/chemical_reaction/randomized/R = get_chemical_reaction(randomized_type) //ew, would be nice to add some simple tracking
		if(R?.persistent)
			var/recipe_data = list()
			recipe_data["timestamp"] = R.created
			recipe_data["required_reagents"] = R.required_reagents
			recipe_data["required_catalysts"] = R.required_catalysts
			recipe_data["required_temp"] = R.required_temp
			recipe_data["is_cold_recipe"] = R.is_cold_recipe
			recipe_data["results"] = R.results
			recipe_data["required_container"] = "[R.required_container]"
			file_data["[R.type]"] = recipe_data

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/SaveScars()
	for(var/i in GLOB.joined_player_list)
		var/mob/living/carbon/human/ending_human = get_mob_by_ckey(i)
		if(!istype(ending_human) || !ending_human.mind?.original_character_slot_index || !ending_human.client || !ending_human.client.prefs || !ending_human.client.prefs.persistent_scars)
			continue

		var/mob/living/carbon/human/original_human = ending_human.mind.original_character.resolve()

		if(!original_human)
			continue

		if(original_human.stat == DEAD || !original_human.all_scars || original_human != ending_human)
			original_human.save_persistent_scars(TRUE)
		else
			original_human.save_persistent_scars()
