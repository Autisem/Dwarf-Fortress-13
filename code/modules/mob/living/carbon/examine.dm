/mob/living/carbon/examine(mob/user)
	var/t_they 	= p_they(TRUE)
	var/t_their 	= p_their()

	. = list("<span class='info'>Это же [icon2html(src, user)] <EM>[src]</EM>!<hr>")
	var/list/obscured = check_obscured_slots()

	if (handcuffed)
		. += "<span class='warning'>[t_they] [icon2html(handcuffed, user)] в наручниках!</span>\n"
	if (head)
		. += "На голове у н[t_their] [head.get_examine_string(user)].\n"
	if(wear_mask && !(obscured & ITEM_SLOT_MASK))
		. += "На [t_their] лице [wear_mask.get_examine_string(user)].\n"
	if(wear_neck && !(obscured & ITEM_SLOT_NECK))
		. += "На шее у н[t_their] [wear_neck.get_examine_string(user)].\n"

	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "В [t_their] [get_held_index_name(get_held_index_of_item(I))] он держит [I.get_examine_string(user)].\n"

	if (back)
		. += "На [t_their] спине [back.get_examine_string(user)].\n"
	var/appears_dead = FALSE
	if (stat == DEAD)
		appears_dead = TRUE
		if(getorgan(/obj/item/organ/brain))
			. += "<span class='deadsay'>[t_they] не реагирует на происходящее вокруг; нет признаков жизни...</span>\n"
		else if(get_bodypart(BODY_ZONE_HEAD))
			. += "<span class='deadsay'>Похоже, что у н[t_their] нет мозга...</span>\n"

	var/list/msg = list("<span class='warning'>")
	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	var/list/disabled = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.bodypart_disabled)
			disabled += BP
		missing -= BP.body_zone
		for(var/obj/item/I in BP.embedded_objects)
			if(I.isEmbedHarmless())
				msg += "<B>Из [t_their] [BP.name] торчит [icon2html(I, user)] [I]!</B>\n"
			else
				msg += "<B>У н[t_their] застрял [icon2html(I, user)] [I] в [BP.name]!</B>\n"
		for(var/i in BP.wounds)
			var/datum/wound/W = i
			msg += "[W.get_examine_description(user)]\n"

	for(var/X in disabled)
		var/obj/item/bodypart/BP = X
		var/damage_text
		if(!(BP.get_damage(include_stamina = FALSE) >= BP.max_damage)) //Stamina is disabling the limb
			damage_text = "вялая"
		else
			damage_text = (BP.brute_dam >= BP.burn_dam) ? BP.heavy_brute_msg : BP.heavy_burn_msg
		msg += "<B>[capitalize(t_their)] [BP.name] [damage_text]!</B>\n"

	for(var/t in missing)
		if(t==BODY_ZONE_HEAD)
			msg += "<span class='deadsay'><B>[p_they(TRUE)] [parse_zone(t)] отсутствует!</B></span>\n"
			continue
		msg += "<span class='warning'><B>[p_they(TRUE)] [parse_zone(t)] отсутствует!</B></span>\n"

	var/temp = getBruteLoss()
	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		if(temp)
			if (temp < 25)
				msg += "[t_they] имеет незначительные ушибы.\n"
			else if (temp < 50)
				msg += "[t_they] <b>тяжело</b> ранен!\n"
			else
				msg += "<B>[t_they] смертельно ранен!</B>\n"

		temp = getFireLoss()
		if(temp)
			if (temp < 25)
				msg += "[t_they] немного подгорел.\n"
			else if (temp < 50)
				msg += "[t_they] имеет <b>серьёзные</b> ожоги!\n"
			else
				msg += "<B>[t_they] имеет смертельные ожоги!</B>\n"

	if(HAS_TRAIT(src, TRAIT_DUMB))
		msg += "[t_they] имеет глупое выражение лица.\n"

	if(fire_stacks > 0)
		msg += "[t_they] в чем-то горючем.\n"
	if(fire_stacks < 0)
		msg += "[t_they] выглядит мокро.\n"

	if(pulledby?.grab_state)
		msg += "[t_they] удерживается захватом [pulledby].\n"

	var/scar_severity = 0
	for(var/i in all_scars)
		var/datum/scar/S = i
		if(S.is_visible(user))
			scar_severity += S.severity

	switch(scar_severity)
		if(1 to 4)
			msg += "\n<span class='smallnoticeital'>[t_they] похоже имеет шрамы... Стоит присмотреться, чтобы разглядеть ещё.</span>\n"
		if(5 to 8)
			msg += "\n<span class='notice'><i>[t_they] имеет несколько серьёзных шрамов... Стоит присмотреться, чтобы разглядеть ещё.</i></span>\n"
		if(9 to 11)
			msg += "\n<span class='notice'><b><i>[t_they] имеет множество ужасных шрамов... Стоит присмотреться, чтобы разглядеть ещё.</i></b></span>\n"
		if(12 to INFINITY)
			msg += "\n<span class='notice'><b><i>[t_they] имеет разорванное в хлам тело состоящее из шрамов... Стоит присмотреться, чтобы разглядеть ещё?</i></b></span>\n"

	msg += "</span>"

	. += msg.Join("")

	if(!appears_dead)
		switch(stat)
			if(SOFT_CRIT)
				. += "[t_they] не реагирует на происходящее вокруг.\n"
			if(UNCONSCIOUS, HARD_CRIT)
				. += "[t_they] едва в сознании.\n"

	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		. += trait_exam

	var/datum/component/mood/mood = src.GetComponent(/datum/component/mood)
	if(mood)
		switch(mood.shown_mood)
			if(-INFINITY to MOOD_LEVEL_SAD4)
				. += "[t_they] выглядит убито, будто сейчас расплачется."
			if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
				. += "[t_they] выглядит расстроено."
			if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
				. += "[t_they] выглядит немного не в себе."
			if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
				. += "[t_they] выглядит немного на веселе."
			if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
				. += "[t_they] выглядит очень весело."
			if(MOOD_LEVEL_HAPPY4 to INFINITY)
				. += "[t_they] в экстазе."
	. += "</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/mob/living/carbon/examine_more(mob/user)
	if(!all_scars)
		return ..()

	var/list/visible_scars
	for(var/i in all_scars)
		var/datum/scar/S = i
		if(S.is_visible(user))
			LAZYADD(visible_scars, S)

	if(!visible_scars)
		return ..()

	var/msg = list("<span class='notice'><i>Всматриваюсь в <b>[src]</b> и замечаю следующее...</i></span>\n")
	for(var/i in visible_scars)
		var/datum/scar/S = i
		var/scar_text = S.get_examine_description(user)
		if(scar_text)
			msg += "[scar_text]\n"

	return msg
