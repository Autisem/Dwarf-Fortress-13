///Vatbeasts are creatures from vatgrowing and are literaly a beast in a vat, yup. They are designed to be a powerful mount roughly equal to a gorilla in power.
/mob/living/simple_animal/hostile/vatbeast
	name = "vatbeast"
	desc = "A strange molluscoidal creature carrying a busted growing vat.\nYou wonder if this burden is a voluntary undertaking in order to achieve comfort and protection, or simply because the creature is fused to its metal shell?"
	icon = 'icons/mob/vatgrowing.dmi'
	icon_state = "vat_beast"
	icon_living = "vat_beast"
	icon_dead = "vat_beast_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	mob_size = MOB_SIZE_LARGE
	gender = NEUTER
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	speak_emote = list("рычит")
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	health = 250
	maxHealth = 250
	damage_coeff = list(BRUTE = 0.7, BURN = 0.7, TOX = 1, CLONE = 2, STAMINA = 0, OXY = 1)
	melee_damage_lower = 25
	melee_damage_upper = 25
	obj_damage = 40
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	attack_sound = 'sound/weapons/punch3.ogg'
	attack_verb_continuous = "slaps"
	attack_verb_simple = "slap"
	food_type = list(/obj/item/food/fries, /obj/item/food/cheesyfries, /obj/item/food/cornchips, /obj/item/food/carrotfries)
	tame_chance = 30

/mob/living/simple_animal/hostile/vatbeast/tamed()
	. = ..()
	can_buckle = TRUE
	buckle_lying = 0
	AddElement(/datum/element/ridable, /datum/component/riding/creature/vatbeast)
	faction = list("neutral")
