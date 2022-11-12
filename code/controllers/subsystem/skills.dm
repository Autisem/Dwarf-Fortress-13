/*!
This subsystem mostly exists to populate and manage the skill singletons.
*/

SUBSYSTEM_DEF(skills)
	name = "Skills"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SKILLS
	///List of level names with index corresponding to skill level
	//List of skill level names. Note that indexes can be accessed like so: level_names[SKILL_LEVEL_NOVICE]
	var/list/level_names = list("Unskilled", "Novice", "Adequate", "Competent", "Proficient", "Adept", "Expert", "Accomplished", "Master", "Grand Master", "Legendary")

/datum/controller/subsystem/skills/Initialize(timeofday)
	InitializeSkills()
	return ..()

/datum/controller/subsystem/skills/proc/InitializeSkills(timeofday)
	return
