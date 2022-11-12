/datum/skill/mining
	name = "Mining"
	title = "Miner"
	desc = "A dwarf's biggest skill, after drinking."
	modifiers = list(
		SKILL_SPEED_MODIFIER = list(3,2.5,2,1.7,1.4,1.2,1.1,1,0.9,0.7,0.6),
		SKILL_AMOUNT_MIN_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3),//+This to the base min amount
		SKILL_AMOUNT_MAX_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3)//+This to the base max amount
		)
