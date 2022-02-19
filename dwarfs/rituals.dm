/datum/ritual
	var/name = "ritual"
	var/true_name = "basetirual" // to identify ritual in dwarf altar.perform_rite()
	var/desc = "govno"
	var/cost = 0

/datum/ritual/summon_seeds
	name = "Ritual of earth"
	true_name = "seeds"
	desc = "Summons helpful seeds."
	cost = 150

/datum/ritual/summon_dwarf
	name = "Ritual of mitosis"
	true_name = "dwarf"
	desc = "Summons a new worker."
	cost = 300

/datum/ritual/summon_frog
	name = "Ritual of quack"
	true_name = "frog"
	desc = "Quack."
	cost = 500

/datum/ritual/summon_tools
	name = "Ritual of metal"
	true_name = "tools"
	desc = "In the name of metal!"
	cost = 800
