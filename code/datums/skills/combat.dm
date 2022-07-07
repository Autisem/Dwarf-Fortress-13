/datum/skill/martial
	name = "Martial Arts"
	desc = "Fight using your fists."
	title = "Martial Artist"
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0)
	)

/datum/skill/combat
	name = "Generic combat"
	desc = "Somebody forgot to set description of this skill."
	title = "Combatant"
	/*****************************************IMPORTANT*************************************************/
	//EVERY SKILL UNDER combat/... HAS TO HAVE THE SAME MODIFIERS AS PARENT OTHERWISE SHIT WILL FUCK UP//
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)
	var/exp_per_parry = 7
	var/exp_per_attack = 7

/datum/skill/combat/shield
	name = "Shield Combat"
	title = "Shieldman"
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)
	exp_per_attack = 2
	exp_per_parry = 17

/datum/skill/combat/dagger
	name = "Dagger Combat"
	title = "Knifeman"
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)

/datum/skill/combat/sword
	name = "Sword Combat"
	title = "Swordsman"
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)

/datum/skill/combat/longsword
	name = "Longsword Combat"
	title = "Swordsman"
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)

/datum/skill/combat/hammer
	name = "Hammer Combat"
	title = "Hammer Fighter"
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)

/datum/skill/combat/flail
	name = "Flail Combat"
	title = "Wrecker"
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)

/datum/skill/combat/spear
	name = "Spear Combat"
	title = "Spearman"
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)
