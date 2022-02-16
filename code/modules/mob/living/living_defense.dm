
/mob/living/proc/run_armor_check(def_zone = null, attack_flag = MELEE, absorb_text = null, soften_text = null, armour_penetration, penetrated_text, silent=FALSE)
	var/armor = getarmor(def_zone, attack_flag)

	if(armor <= 0)
		return armor
	if(silent)
		return max(0, armor - armour_penetration)

	//the if "armor" check is because this is used for everything on /living, including humans
	if(armour_penetration)
		armor = max(0, armor - armour_penetration)
		if(penetrated_text)
			to_chat(src, span_userdanger("[penetrated_text]"))
		else
			to_chat(src, span_userdanger("Броня пробита!"))
	else if(armor >= 100)
		if(absorb_text)
			to_chat(src, span_notice("[absorb_text]"))
		else
			to_chat(src, span_notice("Броня поглотила удар!"))
		playsound(src, "ricochet_armor", 60)
	else
		if(soften_text)
			to_chat(src, span_warning("[soften_text]"))
		else
			to_chat(src, span_warning("Броня смягчает удар!"))
	return armor

/mob/living/proc/getarmor(def_zone, type)
	return 0

//this returns the mob's protection against eye damage (number between -1 and 2) from bright lights
/mob/living/proc/get_eye_protection()
	return 0

//this returns the mob's protection against ear damage (0:no protection; 1: some ear protection; 2: has no ears)
/mob/living/proc/get_ear_protection()
	return 0

/mob/living/proc/is_mouth_covered(head_only = 0, mask_only = 0)
	return FALSE

/mob/living/proc/is_eyes_covered(check_glasses = 1, check_head = 1, check_mask = 1)
	return FALSE
/mob/living/proc/is_pepper_proof(check_head = TRUE, check_mask = TRUE)
	return FALSE
/mob/living/proc/on_hit(obj/projectile/P)
	return BULLET_ACT_HIT

/mob/living/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	var/armor = run_armor_check(def_zone, P.flag, "","",P.armour_penetration)
	var/on_hit_state = P.on_hit(src, armor, piercing_hit)

	SEND_SIGNAL(src, COMSIG_ATOM_BULLET_ACT, P, def_zone)

	if(!P.nodamage && on_hit_state != BULLET_ACT_BLOCK)
		var/attack_direction = get_dir(P.starting, src)
		apply_damage(P.damage, P.damage_type, def_zone, armor, wound_bonus=P.wound_bonus, bare_wound_bonus=P.bare_wound_bonus, sharpness = P.sharpness, attack_direction = attack_direction)
		apply_effects(P.stun, P.knockdown, P.unconscious, P.irradiate, P.slur, P.stutter, P.eyeblur, P.drowsy, armor, P.stamina, P.jitter, P.paralyze, P.immobilize)
		if(P.dismemberment && (P.damage_type == BRUTE || P.damage_type == BURN))
			check_projectile_dismemberment(P, def_zone)
	return on_hit_state ? BULLET_ACT_HIT : BULLET_ACT_BLOCK

/mob/living/proc/check_projectile_dismemberment(obj/projectile/P, def_zone)
	return 0

/obj/item/proc/get_volume_by_throwforce_and_or_w_class()
		if(throwforce && w_class)
				return clamp((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
		else if(w_class)
				return clamp(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
		else
				return 0


/mob/living/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(isitem(AM))
		var/obj/item/thrown_item = AM
		var/zone = ran_zone(BODY_ZONE_CHEST, 65)//Hits a random part of the body, geared towards the chest
		var/nosell_hit = SEND_SIGNAL(thrown_item, COMSIG_MOVABLE_IMPACT_ZONE, src, zone, throwingdatum) // TODO: find a better way to handle hitpush and skipcatch for humans
		if(nosell_hit)
			skipcatch = TRUE
			hitpush = FALSE

		if(blocked)
			return TRUE

		var/mob/thrown_by = thrown_item.thrownby?.resolve()
		if(thrown_by)
			log_combat(thrown_by, src, "threw and hit", thrown_item)
		if(nosell_hit)
			return ..()
		visible_message(span_danger("В <b>[skloname(name, VINITELNI, gender)]</b> попадает <b>[thrown_item.name]</b>!") , \
						span_userdanger("В <b>меня</b> попадает [thrown_item.name]!"))
		if(!thrown_item.throwforce)
			return
		var/armor = run_armor_check(zone, MELEE, "Броня отражает попадание в [ru_parse_zone(parse_zone(zone))].", "Броня смягчает попадание в [ru_parse_zone(parse_zone(zone))].", thrown_item.armour_penetration)
		apply_damage(thrown_item.throwforce, thrown_item.damtype, zone, armor, sharpness = thrown_item.get_sharpness(), wound_bonus = (nosell_hit * CANT_WOUND))
		if(QDELETED(src)) //Damage can delete the mob.
			return
		if(body_position == LYING_DOWN) // physics says it's significantly harder to push someone by constantly chucking random furniture at them if they are down on the floor.
			hitpush = FALSE
		return ..()

	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1) //Item sounds are handled in the item itself
	return ..()

/mob/living/fire_act()
	adjust_fire_stacks(3)
	IgniteMob()

/mob/living/proc/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	if(user == src || anchored || !isturf(user.loc))
		return FALSE
	if(!user.pulling || user.pulling != src)
		user.start_pulling(src, supress_message = supress_message)
		return

	if(!(status_flags & CANPUSH) || HAS_TRAIT(src, TRAIT_PUSHIMMUNE))
		to_chat(user, span_warning("Не могу схватить <b>[skloname(name, VINITELNI, gender)]</b> сильнее!"))
		return FALSE

	if(user.grab_state >= GRAB_AGGRESSIVE && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("Не хочу случайно навредить <b>[skloname(name, VINITELNI, gender)]</b>!"))
		return FALSE
	grippedby(user)

//proc to upgrade a simple pull into a more aggressive grab.
/mob/living/proc/grippedby(mob/living/carbon/user, instant = FALSE)
	if(user.grab_state < GRAB_KILL)
		user.changeNext_move(CLICK_CD_GRABBING)
		var/sound_to_play = 'sound/weapons/thudswoosh.ogg'
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.dna.species.grab_sound)
				sound_to_play = H.dna.species.grab_sound
		playsound(src.loc, sound_to_play, 50, TRUE, -1)

		if(user.grab_state) //only the first upgrade is instantaneous
			var/old_grab_state = user.grab_state
			var/grab_upgrade_time = instant ? 0 : 30
			visible_message(span_danger("<b>[user]</b> начинает брать <b>[skloname(name, VINITELNI, gender)]</b> в более крепкий захват!") , \
				span_userdanger("<b>[user]</b> начинает брать меня <b>[skloname(name, VINITELNI, gender)]</b> в более крепкий захват!") , span_hear("Слышу агрессивную потасовку!") , null, user)
			to_chat(user, span_danger("Начинаю брать [skloname(name, VINITELNI, gender)] в более крепкий захват!"))
			switch(user.grab_state)
				if(GRAB_AGGRESSIVE)
					log_combat(user, src, "attempted to neck grab", addition="neck grab")
				if(GRAB_NECK)
					log_combat(user, src, "attempted to strangle", addition="kill grab")
			if(!do_mob(user, src, grab_upgrade_time))
				return FALSE
			if(!user.pulling || user.pulling != src || user.grab_state != old_grab_state)
				return FALSE
			if(user.a_intent != INTENT_GRAB)
				to_chat(user, span_warning("Надо бы сосредоточиться на захвате, чтобы схватить сильнее!"))
				return 0
		user.setGrabState(user.grab_state + 1)
		switch(user.grab_state)
			if(GRAB_AGGRESSIVE)
				var/add_log = ""
				if(HAS_TRAIT(user, TRAIT_PACIFISM))
					visible_message(span_danger("<b>[user]</b> крепко хватает <b>[skloname(name, VINITELNI, gender)]</b>!") ,
									span_danger("<b>[user]</b> крепко держит меня!") , span_hear("Слышу агрессивную потасовку!") , null, user)
					to_chat(user, span_danger("Крепко хватаю [skloname(name, VINITELNI, gender)]!"))
					add_log = " (pacifist)"
				else
					visible_message(span_danger("<b>[user]</b> хватает <b>[skloname(name, VINITELNI, gender)]</b> крепче!") , \
									span_userdanger("<b>[user]</b> хватает меня крепче!") , span_hear("Слышу агрессивную потасовку!") , null, user)
					to_chat(user, span_danger("Хватаю [skloname(name, VINITELNI, gender)] крепче!"))
				drop_all_held_items()
				stop_pulling()
				log_combat(user, src, "grabbed", addition="aggressive grab[add_log]")
			if(GRAB_NECK)
				log_combat(user, src, "grabbed", addition="neck grab")
				visible_message(span_danger("<b>[user]</b> хватает <b>[skloname(name, VINITELNI, gender)]</b> за шею!") ,\
								span_userdanger("<b>[user]</b> хватает меня за шею!") , span_hear("Слышу агрессивную потасовку!") , null, user)
				to_chat(user, span_danger("Хватаю [skloname(name, VINITELNI, gender)] за шею!"))
				if(!buckled && !density)
					Move(user.loc)
			if(GRAB_KILL)
				log_combat(user, src, "strangled", addition="kill grab")
				visible_message(span_danger("<b>[user]</b> душит <b>[skloname(name, VINITELNI, gender)]</b>!") , \
								span_userdanger("<b>[user]</b> душит меня!") , span_hear("Слышу агрессивную потасовку!") , null, user)
				to_chat(user, span_danger("Душу [skloname(name, VINITELNI, gender)]!"))
				if(!buckled && !density)
					Move(user.loc)
		user.set_pull_offsets(src, grab_state)
		return TRUE

/mob/living/attack_animal(mob/living/simple_animal/M)
	M.face_atom(src)
	if(M.melee_damage_upper == 0)
		visible_message(span_notice("<b>[M]</b> [M.friendly_verb_continuous] <b>[skloname(name, VINITELNI, gender)]</b>!") , \
						span_notice("<b>[M]</b> [M.friendly_verb_continuous] меня!") , null, COMBAT_MESSAGE_RANGE, M)
		to_chat(M, span_notice("[M.friendly_verb_simple] <b>[skloname(name, VINITELNI, gender)]</b>!"))
		return FALSE
	if(HAS_TRAIT(M, TRAIT_PACIFISM))
		to_chat(M, span_warning("Не хочу вредить!"))
		return FALSE


	if(M.attack_sound)
		playsound(loc, M.attack_sound, 50, TRUE, TRUE)
	M.do_attack_animation(src)
	visible_message(span_danger("<b>[M]</b> [M.attack_verb_continuous] <b>[skloname(name, VINITELNI, gender)]</b>!") , \
					span_userdanger("<b>[M]</b> [M.attack_verb_continuous] меня!") , null, COMBAT_MESSAGE_RANGE, M)
	to_chat(M, span_danger("[M.attack_verb_simple] <b>[skloname(name, VINITELNI, gender)]</b>!"))
	log_combat(M, src, "attacked")
	return TRUE

/mob/living/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if (user.apply_martial_art(src))
		return TRUE

/mob/living/attack_paw(mob/living/carbon/human/M, list/modifiers)
	if(isturf(loc) && istype(loc.loc, /area/start))
		to_chat(M, "No attacking people at spawn, you jackass.")
		return FALSE

	if (M.apply_martial_art(src))
		return TRUE

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if (M != src)
			M.disarm(src)
			return TRUE

	switch (M.a_intent)
		if (INTENT_HARM)
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, span_warning("Не хочу вредить!"))
				return FALSE

			if(M.is_muzzled() || M.is_mouth_covered(FALSE, TRUE))
				to_chat(M, span_warning("Ротик закрыт!"))
				return FALSE
			M.do_attack_animation(src, ATTACK_EFFECT_BITE)
			if (prob(75))
				log_combat(M, src, "attacked")
				playsound(loc, 'sound/weapons/bite.ogg', 50, TRUE, -1)
				visible_message(span_danger("<b>[M.name]</b> кусает <b>[skloname(name, VINITELNI, gender)]</b>!") , \
								span_userdanger("<b>[M.name]</b> кусает меня!") , span_hear("Слышу кусь!") , COMBAT_MESSAGE_RANGE, M)
				to_chat(M, span_danger("Кусаю [skloname(name, VINITELNI, gender)]!"))
				return TRUE
			else
				visible_message(span_danger("<b>[M.name]</b> пытается укусить <b>[skloname(name, VINITELNI, gender)]</b>!") , \
								span_danger("<b>[M.name]</b> пытается укусить меня!") , span_hear("Слышу как защелкиваются челюсти!") , COMBAT_MESSAGE_RANGE, M)
				to_chat(M, span_warning("Пытаюсь укусить [skloname(name, VINITELNI, gender)]!"))
		if (INTENT_GRAB)
			grabbedby(M)
			return FALSE
		if (INTENT_DISARM)
			if (M != src)
				M.disarm(src)
				return TRUE
	return FALSE

/mob/living/ex_act(severity, target, origin)
	if(origin)
		return
	..()

/mob/living/acid_act(acidpwr, acid_volume)
	take_bodypart_damage(acidpwr * min(1, acid_volume * 0.1))
	return TRUE

///As the name suggests, this should be called to apply electric shocks.
/mob/living/proc/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	SEND_SIGNAL(src, COMSIG_LIVING_ELECTROCUTE_ACT, shock_damage, source, siemens_coeff, flags)
	shock_damage *= siemens_coeff
	if((flags & SHOCK_TESLA) && HAS_TRAIT(src, TRAIT_TESLA_SHOCKIMMUNE))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SHOCKIMMUNE))
		return FALSE
	if(shock_damage < 1)
		return FALSE
	if(!(flags & SHOCK_ILLUSION))
		adjustFireLoss(shock_damage)
	else
		adjustStaminaLoss(shock_damage)
	visible_message(
		span_danger("<b>[src]</b> ловит разряд тока от <b>[source]</b>!") , \
		span_userdanger("Меня ударило током! <b>ЭТО ОЧЕНЬ БОЛЬНО!</b>") , \
		span_italics("Слышу щёлканье электрических разрядов.")  \
	)
	return shock_damage

/mob/living/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/obj/O in contents)
		O.emp_act(severity)

//called when the mob receives a bright flash
/mob/living/proc/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash, length = 25)
	if(HAS_TRAIT(src, TRAIT_NOFLASH))
		return FALSE
	if(get_eye_protection() < intensity && (override_blindness_check || !is_blind()))
		overlay_fullscreen("flash", type)
		addtimer(CALLBACK(src, .proc/clear_fullscreen, "flash", length), length)
		return TRUE
	return FALSE

//called when the mob receives a loud bang
/mob/living/proc/soundbang_act()
	return FALSE

//to damage the clothes worn by a mob
/mob/living/proc/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	return


/mob/living/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!used_item)
		used_item = get_active_held_item()
	..()

/**
 * Does a slap animation on an atom
 *
 * Uses do_attack_animation to animate the attacker attacking
 * then draws a hand moving across the top half of the target(where a mobs head would usually be) to look like a slap
 * Arguments:
 * * atom/A - atom being slapped
 */
/mob/living/proc/do_slap_animation(atom/slapped)
	do_attack_animation(slapped, no_effect=TRUE)
	var/image/gloveimg = image('icons/effects/effects.dmi', slapped, "slapglove", slapped.layer + 0.1)
	gloveimg.pixel_y = 10 // should line up with head
	gloveimg.pixel_x = 10
	flick_overlay(gloveimg, GLOB.clients, 10)

	// And animate the attack!
	animate(gloveimg, alpha = 175, transform = matrix() * 0.75, pixel_x = 0, pixel_y = 10, pixel_z = 0, time = 3)
	animate(time = 1)
	animate(alpha = 0, time = 3, easing = CIRCULAR_EASING|EASE_OUT)

/** Handles exposing a mob to reagents.
 *
 * If the methods include INGEST the mob tastes the reagents.
 * If the methods include VAPOR it incorporates permiability protection.
 */
/mob/living/expose_reagents(list/reagents, datum/reagents/source, methods=TOUCH, volume_modifier=1, show_message=TRUE)
	. = ..()
	if(. & COMPONENT_NO_EXPOSE_REAGENTS)
		return

	if(methods & INGEST)
		taste(source)

	var/touch_protection = (methods & VAPOR) ? get_permeability_protection() : 0
	SEND_SIGNAL(source, COMSIG_REAGENTS_EXPOSE_MOB, src, reagents, methods, volume_modifier, show_message, touch_protection)
	for(var/reagent in reagents)
		var/datum/reagent/R = reagent
		. |= R.expose_mob(src, methods, reagents[R], show_message, touch_protection)
