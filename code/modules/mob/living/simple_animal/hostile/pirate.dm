/mob/living/simple_animal/hostile/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "pirate_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pushes"
	response_help_simple = "push"
	speed = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "бьёт"
	attack_verb_simple = "бьёт"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 7.5
	speak_emote = list("яррает")
	del_on_death = 1
	faction = list("pirate")


/mob/living/simple_animal/hostile/pirate/melee
	name = "Pirate Swashbuckler"
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"
	melee_damage_lower = 30
	melee_damage_upper = 30
	armour_penetration = 35
	attack_verb_continuous = "режет"
	attack_verb_simple = "режет"
	attack_sound = 'sound/weapons/blade1.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	var/obj/effect/light_emitter/red_energy_sword/sord

	footstep_type = FOOTSTEP_MOB_SHOE

/mob/living/simple_animal/hostile/pirate/melee/space
	name = "Space Pirate Swashbuckler"
	icon_state = "piratespace"
	icon_living = "piratespace"
	icon_dead = "piratespace_dead"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	speed = 1

/mob/living/simple_animal/hostile/pirate/melee/space/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)

/mob/living/simple_animal/hostile/pirate/melee/Initialize()
	. = ..()
	sord = new(src)

/mob/living/simple_animal/hostile/pirate/melee/Destroy()
	QDEL_NULL(sord)
	return ..()

/mob/living/simple_animal/hostile/pirate/melee/Initialize()
	. = ..()
	set_light(2)
