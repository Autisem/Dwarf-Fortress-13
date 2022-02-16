/datum/game_mode/dwarfs
	name = "dwarf fortress"
	config_tag = "dwarf_fortress"
	report_type = "dwarf_fortress"
	false_report_weight = 5
	required_players = 0

	required_jobs = list()

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

/datum/game_mode/dwarfs/pre_setup()
	return 1

/datum/game_mode/dwarfs/generate_report()
	return "AAA"
