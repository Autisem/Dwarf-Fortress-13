

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M)
	// so that martial arts don't double dip
	if (..())
		return TRUE
	switch(M.a_intent)
		if("help")
			if (stat == DEAD)
				return
			visible_message(span_notice("[M] [response_help_continuous] [name].") , \
							span_notice("[M] [response_help_continuous] you.") , null, null, M)
			to_chat(M, span_notice("You [response_help_simple] [name]."))
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
			if(pet_bonus)
				funpet(M)

		if("grab")
			grabbedby(M)

		if("disarm")
			M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
			var/shove_dir = get_dir(M, src)
			if(!Move(get_step(src, shove_dir), shove_dir))
				log_combat(M, src, "shoved", "failing to move it")
				M.visible_message(span_danger("[M.name] shoves [name]!") ,
					span_danger("You shove [name]!") , span_hear("You hear aggressive shuffling!") , COMBAT_MESSAGE_RANGE, list(src))
				to_chat(src, span_userdanger("You're shoved by [M.name]!"))
				return TRUE
			log_combat(M, src, "shoved", "pushing it")
			M.visible_message(span_danger("[M.name] shoves [name], pushing [p_them()]!") ,
				span_danger("You shove [name], pushing [p_them()]!") , span_hear("You hear aggressive shuffling!") , COMBAT_MESSAGE_RANGE, list(src))
			to_chat(src, span_userdanger("You're pushed by [name]!"))
			return TRUE

		if("harm")
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, span_warning("You don't want to hurt [name]!"))
				return
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			do_damaged_animation(M)
			visible_message(span_danger("[M] [response_harm_continuous] [name]!") ,\
							span_userdanger("[M] [response_harm_continuous] you!") , null, COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_danger("You [response_harm_simple] [name]!"))
			playsound(loc, attacked_sound, 25, TRUE, -1)
			attack_threshold_check(harm_intent_damage, attack_type = BLUNT)
			log_combat(M, src, "attacked")
			updatehealth()
			return TRUE

/**
*This is used to make certain mobs (pet_bonus == TRUE) emote when pet, make a heart emoji at their location, and give the petter a moodlet.
*
*/
/mob/living/simple_animal/proc/funpet(mob/petter)
	new /obj/effect/temp_visual/heart(loc)
	if(prob(33))
		manual_emote("[pet_bonus_emote]")
	SEND_SIGNAL(petter, COMSIG_ADD_MOOD_EVENT, src, /datum/mood_event/pet_animal, src)

/mob/living/simple_animal/attack_paw(mob/living/carbon/human/M)
	if(..()) //successful monkey bite.
		if(stat != DEAD)
			var/damage = rand(1, 3)
			attack_threshold_check(damage)
			return 1
	if (M.a_intent == INTENT_HELP)
		if (health > 0)
			visible_message(span_notice("[M.name] [response_help_continuous] [name].") , \
							span_notice("[M.name] [response_help_continuous] you.") , null, COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_notice("You [response_help_simple] [name]."))
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)

/mob/living/simple_animal/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		return attack_threshold_check(damage, M.melee_damage_type)

/mob/living/simple_animal/proc/attack_threshold_check(damage, damagetype = BRUTE, armorcheck = BLUNT, actuallydamage = TRUE, attack_type = BLUNT)
	var/temp_damage = damage
	temp_damage -= temp_damage*(armor.getRating(attack_type)/100)

	if(temp_damage >= 0 && temp_damage <= force_threshold)
		visible_message(span_warning("[capitalize(src.name)] looks unharmed!"))
		return FALSE
	else
		if(actuallydamage)
			apply_damage(damage, damagetype, null, getarmor(null, armorcheck))
		return TRUE

/mob/living/simple_animal/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	var/temp_damage = Proj.damage - Proj.damage*(armor.getRating(Proj.flag)/100)
	apply_damage(temp_damage, Proj.damage_type)
	Proj.on_hit(src, 0, piercing_hit)
	return BULLET_ACT_HIT

/mob/living/simple_animal/ex_act(severity, target, origin)
	if(origin)
		return
	..()
	if(QDELETED(src))
		return
	var/bomb_armor = getarmor(null, BLUNT)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			if(prob(bomb_armor))
				adjustBruteLoss(500)
			else
				gib()
				return
		if (EXPLODE_HEAVY)
			var/bloss = 60
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			adjustBruteLoss(bloss)

		if(EXPLODE_LIGHT)
			var/bloss = 30
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			adjustBruteLoss(bloss)

/mob/living/simple_animal/do_attack_animation(atom/A, visual_effect_icon, used_item, no_effect)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(attack_vis_effect && !iswallturf(A)) // override the standard visual effect.
			visual_effect_icon = attack_vis_effect
		else if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()
