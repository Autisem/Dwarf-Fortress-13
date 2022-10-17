/datum/skill/cooking
	name = "Cooking"
	title = "Chef"
	desc = "The art of cooking dishes."
	modifiers = list(
		SKILL_SPEED_MODIFIER=list(3,2.5,2,1.5,1.2,1,1,0.9,0.8,0.7,0.6),//How fast are we doing cooking related stuff
		SKILL_AMOUNT_MIN_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3),//+This to the base min amount
		SKILL_AMOUNT_MAX_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3)//+This to the base max amount
	)
