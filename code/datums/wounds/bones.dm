
/*
	Blunt/Bone wounds
*/
// TODO: well, a lot really, but i'd kill to get overlays and a bonebreaking effect like Blitz: The League, similar to electric shock skeletons

/datum/wound/blunt
	name = "Blunt (Bone) Wound"
	sound_effect = 'sound/effects/wounds/crack1.ogg'
	wound_type = WOUND_BLUNT
	wound_flags = (BONE_WOUND | ACCEPTS_GAUZE)

	/// Have we been taped?
	var/taped
	/// Have we been bone gel'd?
	var/gelled
	/// If we did the gel + surgical tape healing method for fractures, how many ticks does it take to heal by default
	var/regen_ticks_needed
	/// Our current counter for gel + surgical tape regeneration
	var/regen_ticks_current
	/// If we suffer severe head booboos, we can get brain traumas tied to them
	var/datum/brain_trauma/active_trauma
	/// What brain trauma group, if any, we can draw from for head wounds
	var/brain_trauma_group
	/// If we deal brain traumas, when is the next one due?
	var/next_trauma_cycle
	/// How long do we wait +/- 20% for the next trauma?
	var/trauma_cycle_cooldown
	/// If this is a chest wound and this is set, we have this chance to cough up blood when hit in the chest
	var/internal_bleeding_chance = 0

/*
	Overwriting of base procs
*/
/datum/wound/blunt/wound_injury(datum/wound/old_wound = null, attack_direction = null)
	// hook into gaining/losing gauze so crit bone wounds can re-enable/disable depending if they're slung or not
	RegisterSignal(limb, list(COMSIG_BODYPART_GAUZED, COMSIG_BODYPART_GAUZE_DESTROYED), .proc/update_inefficiencies)

	if(limb.body_zone == BODY_ZONE_HEAD && brain_trauma_group)
		processes = TRUE
		active_trauma = victim.gain_trauma_type(brain_trauma_group, TRAUMA_RESILIENCE_WOUND)
		next_trauma_cycle = world.time + (rand(100-WOUND_BONE_HEAD_TIME_VARIANCE, 100+WOUND_BONE_HEAD_TIME_VARIANCE) * 0.01 * trauma_cycle_cooldown)

	RegisterSignal(victim, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, .proc/attack_with_hurt_hand)
	if(limb.held_index && victim.get_item_for_held_index(limb.held_index) && (disabling || prob(30 * severity)))
		var/obj/item/I = victim.get_item_for_held_index(limb.held_index)
		if(istype(I, /obj/item/offhand))
			I = victim.get_inactive_held_item()

		if(I && victim.dropItemToGround(I))
			victim.visible_message(span_danger("<b>[victim]</b> бросает <b>[I]</b> в приступе боли!") , span_warning("Боль в моей <b>[limb.name]</b> заставляет меня бросить <b>[I]</b>!") , vision_distance=COMBAT_MESSAGE_RANGE)

	update_inefficiencies()

/datum/wound/blunt/remove_wound(ignore_limb, replaced)
	limp_slowdown = 0
	QDEL_NULL(active_trauma)
	if(limb)
		UnregisterSignal(limb, list(COMSIG_BODYPART_GAUZED, COMSIG_BODYPART_GAUZE_DESTROYED))
	if(victim)
		UnregisterSignal(victim, COMSIG_HUMAN_EARLY_UNARMED_ATTACK)
	return ..()

/datum/wound/blunt/handle_process(delta_time, times_fired)
	. = ..()
	if(limb.body_zone == BODY_ZONE_HEAD && brain_trauma_group && world.time > next_trauma_cycle)
		if(active_trauma)
			QDEL_NULL(active_trauma)
		else
			active_trauma = victim.gain_trauma_type(brain_trauma_group, TRAUMA_RESILIENCE_WOUND)
		next_trauma_cycle = world.time + (rand(100-WOUND_BONE_HEAD_TIME_VARIANCE, 100+WOUND_BONE_HEAD_TIME_VARIANCE) * 0.01 * trauma_cycle_cooldown)

	if(!gelled || !taped)
		return

	regen_ticks_current++
	if(victim.body_position == LYING_DOWN)
		if(DT_PROB(30, delta_time))
			regen_ticks_current += 0.5
		if(victim.IsSleeping() && DT_PROB(30, delta_time))
			regen_ticks_current += 0.5

	if(DT_PROB(severity * 1.5, delta_time))
		victim.take_bodypart_damage(rand(1, severity * 2), stamina=rand(2, severity * 2.5), wound_bonus=CANT_WOUND)
		if(prob(33))
			to_chat(victim, span_danger("Ощущаю острую боль от перелома!"))

	if(regen_ticks_current > regen_ticks_needed)
		if(!victim || !limb)
			qdel(src)
			return
		to_chat(victim, span_green("Моя [limb.name] больше не страдает от переломов!"))
		remove_wound()

/// If we're a human who's punching something with a broken arm, we might hurt ourselves doing so
/datum/wound/blunt/proc/attack_with_hurt_hand(mob/M, atom/target, proximity)
	SIGNAL_HANDLER

	if(victim.get_active_hand() != limb || victim.a_intent == INTENT_HELP || !ismob(target) || severity <= WOUND_SEVERITY_MODERATE)
		return

	// With a severe or critical wound, you have a 15% or 30% chance to proc pain on hit
	if(prob((severity - 1) * 15))
		// And you have a 70% or 50% chance to actually land the blow, respectively
		if(prob(70 - 20 * (severity - 1)))
			to_chat(victim, span_userdanger("Перелом в моей [limb.name] стреляет болью при ударе <b>[target]</b>!"))
			limb.receive_damage(brute=rand(1,5))
		else
			victim.visible_message(span_danger("<b>[victim]</b> слабо бьёт <b>[target]</b> своей сломаной рукой, отскакивая в приступе боли!") , \
			span_userdanger("Перелом в моей [limb.name] загорается от невыносимой боли, когда я пытаюсь ударить <b>[target]</b>!") , vision_distance=COMBAT_MESSAGE_RANGE)
			INVOKE_ASYNC(victim, /mob.proc/emote, "agony")
			victim.Stun(0.5 SECONDS)
			limb.receive_damage(brute=rand(3,7))
			return COMPONENT_CANCEL_ATTACK_CHAIN


/datum/wound/blunt/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(!victim || wounding_dmg < WOUND_MINIMUM_DAMAGE)
		return
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(NOBLOOD in human_victim.dna?.species.species_traits)
			return

	if(limb.body_zone == BODY_ZONE_CHEST && victim.blood_volume && prob(internal_bleeding_chance + wounding_dmg))
		var/blood_bled = rand(1, wounding_dmg * (severity == WOUND_SEVERITY_CRITICAL ? 2 : 1.5)) // 12 brute toolbox can cause up to 18/24 bleeding with a severe/critical chest wound
		switch(blood_bled)
			if(1 to 6)
				victim.bleed(blood_bled, TRUE)
			if(7 to 13)
				victim.visible_message(span_danger("<b>[victim]</b> кашляет кровью от удара в грудь.") , span_danger("Выплёвываю немного крови от удара в грудь.") , vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled, TRUE)
			if(14 to 19)
				victim.visible_message(span_danger("<b>[victim]</b> выплевывает струю крови от удара в грудь!") , span_danger("Выплёвываю струю крови от удара в грудь!") , vision_distance=COMBAT_MESSAGE_RANGE)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.bleed(blood_bled)
			if(20 to INFINITY)
				victim.visible_message(span_danger("<b>[victim]</b> заблёвывает всё кровью от удара в грудь!") , span_danger("<b>Заблёвываю всё кровью от удара в грудь!</b>") , vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.add_splatter_floor(get_step(victim.loc, victim.dir))


/datum/wound/blunt/get_examine_description(mob/user)
	if(!limb.current_gauze && !gelled && !taped)
		return ..()

	var/list/msg = list()
	if(!limb.current_gauze)
		msg += "[victim.p_their(TRUE)] [limb.name] [examine_desc]"
	else
		var/sling_condition = "отлично"
		// how much life we have left in these bandages
		switch(limb.current_gauze.absorption_capacity)
			if(0 to 25)
				sling_condition = "едва"
			if(25 to 50)
				sling_condition = "плохо"
			if(50 to 75)
				sling_condition = "слабовато"
			if(75 to INFINITY)
				sling_condition = "плотно"

		msg += "[capitalize(limb.current_gauze.name)] на [victim.p_them()] [sling_condition] держится"

	if(taped)
		msg += ", и, кажется, реформируется под хирургической лентой!"
	else if(gelled)
		msg += ", с шипящими пятнами синего костного геля, искрящегося на костях!"
	else
		msg +=  "!"
	return "<B>[msg.Join()]</B>"

/*
	New common procs for /datum/wound/blunt/
*/

/datum/wound/blunt/proc/update_inefficiencies()
	if(limb.body_zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		if(limb.current_gauze)
			limp_slowdown = initial(limp_slowdown) * limb.current_gauze.splint_factor
		else
			limp_slowdown = initial(limp_slowdown)
		victim.apply_status_effect(STATUS_EFFECT_LIMP)
	else if(limb.body_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		if(limb.current_gauze)
			interaction_efficiency_penalty = 1 + ((interaction_efficiency_penalty - 1) * limb.current_gauze.splint_factor)
		else
			interaction_efficiency_penalty = interaction_efficiency_penalty

	if(initial(disabling))
		set_disabling(!limb.current_gauze)

	limb.update_wounds()

/// Joint Dislocation (Moderate Blunt)
/datum/wound/blunt/moderate
	name = "Вывих"
	skloname = "вывиха"
	desc = "Кость пациента смещена относительно сустава, препятствуя нормальной работе конечности."
	treat_text = "Рекомендовано использование костоправа для вправления, хотя ручного перемещения путем применения агрессивного захвата к пациенту и полезного взаимодействия с пораженной конечностью может быть достаточно." //Это настолько убого звучит, что мой стрелка на моём счётчике полуляха сделала полный оборот и приземлилась обратно на ноль. Оставлю вторую половину, как есть.
	examine_desc = "неловко стоит не на своем месте"
	occur_text = "яростно дергается и перемещается в загадочное положение"
	severity = WOUND_SEVERITY_MODERATE
	viable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	interaction_efficiency_penalty = 1.5
	limp_slowdown = 3
	threshold_minimum = 35
	threshold_penalty = 15
	treatable_tool = TOOL_BONESET
	wound_flags = (BONE_WOUND)
	status_effect_type = /datum/status_effect/wound/blunt/moderate
	scar_keyword = "bluntmoderate"

/datum/wound/blunt/moderate/Destroy()
	if(victim)
		UnregisterSignal(victim, COMSIG_LIVING_DOORCRUSHED)
	return ..()

/datum/wound/blunt/moderate/wound_injury(datum/wound/old_wound, attack_direction = null)
	. = ..()
	RegisterSignal(victim, COMSIG_LIVING_DOORCRUSHED, .proc/door_crush)

/// Getting smushed in an airlock/firelock is a last-ditch attempt to try relocating your limb
/datum/wound/blunt/moderate/proc/door_crush()
	if(prob(33))
		victim.visible_message(span_danger("<b>[victim]</b> выворачивает [limb.name] и ставит на место!") , span_userdanger("Выправляю [limb.name] на место! Ух!"))
		remove_wound()

/datum/wound/blunt/moderate/try_handling(mob/living/carbon/human/user)
	if(user.pulling != victim || user.zone_selected != limb.body_zone || user.a_intent == INTENT_GRAB)
		return FALSE

	if(user.grab_state == GRAB_PASSIVE)
		to_chat(user, span_warning("Мне стоит взять <b>[victim]</b> в более сильный захват для исправления [skloname]!"))
		return TRUE

	if(user.grab_state >= GRAB_AGGRESSIVE)
		user.visible_message(span_danger("<b>[user]</b> начинает скручивать и напрягать [limb.name] <b>[victim]</b>!") , span_notice("Начинаю скручивать и напрягать [limb.name] <b>[victim]</b>...") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> начинает крутить и напрягать вывих на [limb.name]!"))
		if(user.a_intent == INTENT_HELP)
			chiropractice(user)
		else
			malpractice(user)
		return TRUE

/// If someone is snapping our dislocated joint back into place by hand with an aggro grab and help intent
/datum/wound/blunt/moderate/proc/chiropractice(mob/living/carbon/human/user)
	var/time = base_treat_time

	if(!do_after(user, time, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return

	if(prob(65))
		user.visible_message(span_danger("<b>[user]</b> вправляет [limb.name] <b>[victim]</b>!") , span_notice("Вправляю [limb.name] <b>[victim]</b> на место!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> вправляет мою [limb.name] на место!"))
		victim.emote("agony")
		limb.receive_damage(brute=20, wound_bonus=CANT_WOUND)
		qdel(src)
	else
		user.visible_message(span_danger("<b>[user]</b> крутит [limb.name] <b>[victim]</b> довольно неправильно!") , span_danger("Кручу [limb.name] <b>[victim]</b> неправильно!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> крутит мою [limb.name] неправильно!"))
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		chiropractice(user)

/// If someone is snapping our dislocated joint into a fracture by hand with an aggro grab and harm or disarm intent
/datum/wound/blunt/moderate/proc/malpractice(mob/living/carbon/human/user)
	var/time = base_treat_time

	if(!do_after(user, time, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return

	if(prob(65))
		user.visible_message(span_danger("<b>[user]</b> вправляет [limb.name] <b>[victim]</b> с отвратительным хрустом!") , span_danger("Вправляю [limb.name] <b>[victim]</b> с отвратительным хрустом!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> вправляет [limb.name] с отвратительным хрустом!"))
		victim.emote("agony")
		limb.receive_damage(brute=25, wound_bonus=30)
	else
		user.visible_message(span_danger("<b>[user]</b> крутит [limb.name] <b>[victim]</b> неправильно!") , span_danger("Кручу [limb.name] <b>[victim]</b> неправильно!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> крутит мою [limb.name] неправильно!"))
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		malpractice(user)


/datum/wound/blunt/moderate/treat(obj/item/I, mob/user)
	if(victim == user)
		victim.visible_message(span_danger("<b>[user]</b> начинает вправлять [victim.p_their()] [limb.name] используя [I].") , span_warning("Начинаю вправлять свою [limb.name] используя [I]..."))
	else
		user.visible_message(span_danger("<b>[user]</b> начинает вправлять [limb.name] <b>[victim]</b> используя [I].") , span_notice("Начинаю вправлять [limb.name] <b>[victim]</b> используя [I]..."))

	if(!do_after(user, base_treat_time * (user == victim ? 1.5 : 1), target = victim, extra_checks=CALLBACK(src, .proc/still_exists)))
		return

	if(victim == user)
		limb.receive_damage(brute=15, wound_bonus=CANT_WOUND)
		victim.visible_message(span_danger("<b>[user]</b> успешно вправляет [victim.p_their()] [limb.name]!") , span_userdanger("Вправляю свою [limb.name]!"))
	else
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		user.visible_message(span_danger("<b>[user]</b> успешно вправляет [limb.name] <b>[victim]</b>!") , span_nicegreen("Вправляю [limb.name] <b>[victim]</b>!") , victim)
		to_chat(victim, span_userdanger("<b>[user]</b> вправляет мою [limb.name]!"))

	victim.emote("agony")
	qdel(src)

/*
	Severe (Hairline Fracture)
*/

/datum/wound/blunt/severe
	name = "Трещина"
	skloname = "трещины"
	desc = "Кость треснула, вызывающая сильную боль и пониженную работоспособность конечностей."
	treat_text = "Рекомендуется хирургическое вмешательство и применение костного геля. В условиях отсутствия требуемых медикаментов рекомендуется шинирование для предотвращения ухудшения ситуации."
	examine_desc = "кажется ушибленной и сильно опухшей"
	occur_text = "разбрызгивает кусочки костей и развивает неприятный на вид синяк"

	severity = WOUND_SEVERITY_SEVERE
	interaction_efficiency_penalty = 2
	limp_slowdown = 6
	threshold_minimum = 60
	threshold_penalty = 30
	treatable_by = list(/obj/item/stack/medical/bone_gel)
	status_effect_type = /datum/status_effect/wound/blunt/severe
	scar_keyword = "bluntsevere"
	brain_trauma_group = BRAIN_TRAUMA_MILD
	trauma_cycle_cooldown = 1.5 MINUTES
	internal_bleeding_chance = 40
	wound_flags = (BONE_WOUND | ACCEPTS_GAUZE | MANGLES_BONE)
	regen_ticks_needed = 120 // ticks every 2 seconds, 240 seconds, so roughly 4 minutes default

/// Compound Fracture (Critical Blunt)
/datum/wound/blunt/critical
	name = "Перелом"
	skloname = "перелома"
	desc = "Кость пациента перенесла перелом."
	treat_text = "Немедленная фиксация пораженной конечности с последующим хирургическим вмешательством."
	examine_desc = "имеет торчащую из неё кость"
	occur_text = "трещины на части, открывая сломанные кости наружу"

	severity = WOUND_SEVERITY_CRITICAL
	interaction_efficiency_penalty = 4
	limp_slowdown = 9
	sound_effect = 'sound/effects/wounds/crack2.ogg'
	threshold_minimum = 115
	threshold_penalty = 50
	disabling = TRUE
	treatable_by = list(/obj/item/stack/medical/bone_gel)
	status_effect_type = /datum/status_effect/wound/blunt/critical
	scar_keyword = "bluntcritical"
	brain_trauma_group = BRAIN_TRAUMA_SEVERE
	trauma_cycle_cooldown = 2.5 MINUTES
	internal_bleeding_chance = 60
	wound_flags = (BONE_WOUND | ACCEPTS_GAUZE | MANGLES_BONE)
	regen_ticks_needed = 240 // ticks every 2 seconds, 480 seconds, so roughly 8 minutes default

// doesn't make much sense for "a" bone to stick out of your head
/datum/wound/blunt/critical/apply_wound(obj/item/bodypart/L, silent = FALSE, datum/wound/old_wound = null, smited = FALSE, attack_direction = null)
	if(L.body_zone == BODY_ZONE_HEAD)
		occur_text = "хрустит, обнажая обнаженный треснувший череп сквозь плоть и кровь"
		examine_desc = "имеет тревожный отступ, с торчащими кусками черепа"
	. = ..()

/// if someone is using bone gel on our wound
/datum/wound/blunt/proc/gel(obj/item/stack/medical/bone_gel/I, mob/user)
	if(gelled)
		to_chat(user, span_warning("[capitalize(limb.name)] [user == victim ? " " : "<b>[victim]</b> "] уже покрыта костным гелем!"))
		return

	user.visible_message(span_danger("<b>[user]</b> начинает примеенять [I] на [limb.name] <b>[victim]</b>...") , span_warning("Начинаю применять [I] на [limb.name] [user == victim ? " " : "<b>[victim]</b> "], игнорируя предупреждение на этикетке..."))

	if(!do_after(user, base_treat_time * 1.5 * (user == victim ? 1.5 : 1), target = victim, extra_checks=CALLBACK(src, .proc/still_exists)))
		return

	I.use(1)
	victim.emote("agony")
	if(user != victim)
		user.visible_message(span_notice("<b>[user]</b> заканчивает применять [I] на [limb.name] <b>[victim]</b>, издавая шипящий звук!") , span_notice("Заканчиваю применять [I] на [limb.name] <b>[victim]</b>!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> заканчивает применять [I] на мою [limb.name] и я начинаю чувствовать, как мои кости взрываются от боли, когда они начинают таять и преобразовываться!"))
	else
		var/painkiller_bonus = 0
		if(victim.drunkenness > 10)
			painkiller_bonus += 10
		if(victim.reagents.has_reagent(/datum/reagent/medicine/morphine))
			painkiller_bonus += 20
		if(victim.reagents.has_reagent(/datum/reagent/determination))
			painkiller_bonus += 10
		if(victim.reagents.has_reagent(/datum/reagent/consumable/ethanol/painkiller))
			painkiller_bonus += 5
		if(victim.reagents.has_reagent(/datum/reagent/medicine/mine_salve))
			painkiller_bonus += 20

		if(prob(25 + (20 * (severity - 2)) - painkiller_bonus)) // 25%/45% chance to fail self-applying with severe and critical wounds, modded by painkillers
			victim.visible_message(span_danger("<b>[victim]</b> проваливает попытку нанести [I] на [victim.p_their()] [limb.name], теряя сознание от боли!") , span_notice("Теряю сознание от боли пытаясь применить [I] на мою [limb.name] перед тем как закончить!"))
			victim.AdjustUnconscious(5 SECONDS)
			return
		victim.visible_message(span_notice("<b>[victim]</b> успешно применяет [I] на [victim.p_their()] [limb.name], скорчившись от боли!") , span_notice("Заканчиваю применять [I] на мою [limb.name], осталось перетерпеть адскую боль!"))

	limb.receive_damage(25, stamina=100, wound_bonus=CANT_WOUND)
	if(!gelled)
		gelled = TRUE

/datum/wound/blunt/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/bone_gel))
		gel(I, user)

/datum/wound/blunt/get_scanner_description(mob/user)
	. = ..()

	. += "<div class='ml-3'>"

	if(!gelled)
		. += "Альтернативное лечение: Нанесите костный гель непосредственно на поврежденную конечность, затем нанесите хирургическую ленту, чтобы начать регенерацию кости. Это мучительно больно и медленно, и рекомендуется только в тяжелых обстоятельствах.\n"
	else if(!taped)
		. += "<span class='notice'>Продолжить альтернативное лечение: Нанесите хирургическую ленту непосредственно на поврежденную конечность, чтобы начать регенерацию кости. Обратите внимание, это одновременно мучительно больно и медленно.</span>\n"
	else
		. += "<span class='notice'>Заметка: Регенерация костей в действии. Кость регенерировала на [round(regen_ticks_current*100/regen_ticks_needed)]%.</span>\n"

	if(limb.body_zone == BODY_ZONE_HEAD)
		. += "Обнаружена черепно-мозговая травма: Пациент будет страдать от случайных приступов [severity == WOUND_SEVERITY_SEVERE ? "незначительных" : "серьёзных"] травм головного мозга, пока кость не будет восстановлена."
	else if(limb.body_zone == BODY_ZONE_CHEST && victim.blood_volume)
		. += "Обнаружена травма грудной клетки: Дальнейшее повреждение груди может усилить внутреннее кровотечение, пока не будет восстановлена кость."
	. += "</div>"
