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
	modifiers = list(
		SKILL_MISS_MODIFIER=list(30, 26, 24, 22, 20, 18, 16, 14, 10, 5, 0),
		SKILL_PARRY_MODIFIER=list(0, 2, 3, 4, 5, 7, 10, 13, 17, 20, 25),
		SKILL_DAMAGE_MODIFIER=list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	)

/datum/skill/combat/dagger
	name = "Dagger Combat"
	title = "Knifeman"

/datum/skill/combat/sword
	name = "Sword Combat"
	title = "Swordsman"

/datum/skill/combat/longsword
	name = "Longsword Combat"
	title = "Swordsman"

/datum/skill/combat/hammer
	name = "Hammer Combat"
	title = "Hammer Fighter"

/datum/skill/combat/flail
	name = "Flail Combat"
	title = "Wrecker"

/datum/skill/combat/spear
	name = "Spear Combat"
	title = "Spearman"
