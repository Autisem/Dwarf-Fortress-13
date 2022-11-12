/datum/skill/combat
	name = "Generic combat"
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

/datum/skill/martial
    name = "Martial Arts"
    desc = "Wrestling and martial arts - are dwarven last resort, but those tho master it will never get down easily. Increases bare hand combat stats"
    title = "Martial Artist"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(40, 30, 20, 15, 12, 10, 8, 6, 4, 2, 0))

/datum/skill/combat/shield
    name = "Shield Combat"
    desc = "Wielding a shield and put it into a good use - may be much harder than you'd think. Increases shield related stats"
    title = "Shield user"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(20, 10, 5, 0, 0, 0, 0, 0, 0, 0, 0),
            SKILL_PARRY_MODIFIER=list(8, 12, 15, 17, 19, 20, 25, 30, 36, 44, 55),
            SKILL_DAMAGE_MODIFIER=list(0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4))
    exp_per_parry = 17
    exp_per_attack = 2

/datum/skill/combat/dagger
    name = "Dagger Combat"
    desc = "Small arms as daggers - prefered by the nobles, one quick precise slash may end ones life. Increases dagger combat stats"
    title = "Knife user"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(30, 28, 25, 22, 18, 15, 10, 5, 3, 0, 0),
            SKILL_PARRY_MODIFIER=list(0, 2, 6, 12, 16, 22, 28, 32, 36, 40, 35),
            SKILL_DAMAGE_MODIFIER=list(0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 3))
    exp_per_parry = 7
    exp_per_attack = 7

/datum/skill/combat/sword
    name = "Sword Combat"
    desc = "Mastering sword takes a long time, but there is always way higher. Increases sword combat stats."
    title = "Swordsdwarf"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(40, 35, 30, 26, 22, 16, 14, 10, 4, 1, 0),
            SKILL_PARRY_MODIFIER=list(0, 1, 3, 8, 13, 18, 23, 26, 31, 35, 40),
            SKILL_DAMAGE_MODIFIER=list(0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 4))
    exp_per_parry = 7
    exp_per_attack = 7

/datum/skill/combat/longsword
    name = "Greatsword Combat"
    desc = "Using one of those giant swords effectievely requires a lot of strenght and experience. Increases two-handed swords combat stats"
    title = "Swordsmeister"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(50, 40, 45, 40, 35, 30, 25, 20, 15, 10, 5),
            SKILL_PARRY_MODIFIER=list(5, 8, 11, 15, 19, 23, 27, 30, 34, 40, 48),
            SKILL_DAMAGE_MODIFIER=list(0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4))
    exp_per_parry = 7
    exp_per_attack = 7

/datum/skill/combat/hammer
    name = "Greathammer Combat"
    desc = "Although dwarf knows the principes of using the hammer from the very young ages - to deal a devastating blows one requires knowledge and experience. Increases warhammers combat stats"
    title = "Hammerdwarf"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(50, 40, 42, 36, 31, 26, 21, 17, 14, 9, 3),
            SKILL_PARRY_MODIFIER=list(3, 5, 9, 12, 17, 21, 25, 27, 30, 34, 38),
            SKILL_DAMAGE_MODIFIER=list(0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 4))
    exp_per_parry = 7
    exp_per_attack = 7

/datum/skill/combat/flail
    name = "Mace Combat"
    desc = "Using flail provides a great opportunity to make your oponent think twice their moves. Increases flails combat stats"
    title = "Macedwarf"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(30, 26, 21, 19, 14, 11, 9, 6, 4, 2, 0),
            SKILL_PARRY_MODIFIER=list(0, 0, 1, 6, 9, 12, 15, 17, 20, 22, 25),
            SKILL_DAMAGE_MODIFIER=list(0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3))
    exp_per_parry = 7
    exp_per_attack = 7

/datum/skill/combat/spear
    name = "Spear Combat"
    desc = "Spear - too long for a dwarf to use easily, provides a great piercing force at the great distance. Increases spears combat stats"
    title = "Speardwarf"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(15, 13, 11, 9, 7, 5, 3, 0, 0, 0, 0),
            SKILL_PARRY_MODIFIER=list(0, 0, 3, 5, 9, 13, 16, 19, 22, 25, 30),
            SKILL_DAMAGE_MODIFIER=list(0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 5))
    exp_per_parry = 7
    exp_per_attack = 7

/datum/skill/combat/halberd
    name = "Halberd Combat"
    desc = "The art of using long polearm-like weapons similar to a spear. Although the spear may be easier to use and learn this weapon has more potential."
    title = "Guisarmier"
    modifiers = list(
            SKILL_MISS_MODIFIER=list(28, 20, 15, 10, 7, 4, 2, 0, 0, 0, 0),
            SKILL_PARRY_MODIFIER=list(0, 0, 0, 1, 5, 7, 10, 13, 15, 18, 22),
            SKILL_DAMAGE_MODIFIER=list(0, 0, 0, 1, 2, 2, 2, 3, 3, 4, 6))
    exp_per_parry = 7
    exp_per_attack = 7

