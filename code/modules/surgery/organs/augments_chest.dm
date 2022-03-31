/obj/item/organ/cyberimp/chest
	name = "кибернетический имплант туловища"
	desc = "Импланты для органов вашего туловища."
	icon_state = "chest_implant"
	implant_overlay = "chest_implant_overlay"
	zone = BODY_ZONE_CHEST

/obj/item/organ/cyberimp/chest/nutriment
	name = "имплант \"питательный насос\""
	desc = "Этот имплант синтезирует и закачаивает в ваш кровосток небольшое количество питательных веществ и жидкости если вы голодаете."
	icon_state = "chest_implant"
	implant_color = "#00AA00"
	var/hunger_threshold = NUTRITION_LEVEL_STARVING
	var/hydration_threshold = HYDRATION_LEVEL_THIRSTY
	var/synthesizing = 0
	var/poison_amount = 5
	slot = ORGAN_SLOT_STOMACH_AID

/obj/item/organ/cyberimp/chest/nutriment/on_life(delta_time, times_fired)
	if(synthesizing)
		return

	if(owner.nutrition <= hunger_threshold)
		synthesizing = TRUE
		to_chat(owner, span_notice("Чуство голода немного притупилось..."))
		owner.adjust_nutrition(25 * delta_time)
		addtimer(CALLBACK(src, .proc/synth_cool), 50)

	if(owner.hydration <= hydration_threshold)
		synthesizing = TRUE
		to_chat(owner, span_notice("Жажда мучает не так сильно..."))
		owner.hydration = owner.hydration + 20
		addtimer(CALLBACK(src, .proc/synth_cool), 50)

/obj/item/organ/cyberimp/chest/nutriment/proc/synth_cool()
	synthesizing = FALSE

/obj/item/organ/cyberimp/chest/nutriment/plus
	name = "имплант \"питательный насос ПЛЮС\""
	desc = "Этот имплант полностью перекрывает все ваши потребности в пище и жидкости."
	icon_state = "chest_implant"
	implant_color = "#006607"
	hunger_threshold = NUTRITION_LEVEL_HUNGRY
	hydration_threshold = HYDRATION_LEVEL_NORMAL
	poison_amount = 10

/obj/item/organ/cyberimp/chest/reviver
	name = "имплант \"Реаниматор\""
	desc = "Этот имплант постарается привести вас в чуство и исцелить если вы потеряете сознание. Для слабонервных!"
	icon_state = "chest_implant"
	implant_color = "#AD0000"
	slot = ORGAN_SLOT_HEART_AID
	var/revive_cost = 0
	var/reviving = FALSE
	COOLDOWN_DECLARE(reviver_cooldown)


/obj/item/organ/cyberimp/chest/reviver/on_life(delta_time, times_fired)
	if(reviving)
		switch(owner.stat)
			if(UNCONSCIOUS, HARD_CRIT)
				addtimer(CALLBACK(src, .proc/heal), 3 SECONDS)
			else
				COOLDOWN_START(src, reviver_cooldown, revive_cost)
				reviving = FALSE
				to_chat(owner, span_notice("Имплант \"Реаниматор\" выключается и начинает перезаряжаться. Он будет готов через [DisplayTimeText(revive_cost)]."))
		return

	if(!COOLDOWN_FINISHED(src, reviver_cooldown) || owner.suiciding)
		return

	switch(owner.stat)
		if(UNCONSCIOUS, HARD_CRIT)
			revive_cost = 0
			reviving = TRUE
			to_chat(owner, span_notice("Чувствую слабое жужжание, похоже имлант \"Реаниматор\" начал латать мои раны..."))


/obj/item/organ/cyberimp/chest/reviver/proc/heal()
	if(owner.getOxyLoss())
		owner.adjustOxyLoss(-5)
		revive_cost += 5
	if(owner.getBruteLoss())
		owner.adjustBruteLoss(-2)
		revive_cost += 40
	if(owner.getFireLoss())
		owner.adjustFireLoss(-2)
		revive_cost += 40
	if(owner.getToxLoss())
		owner.adjustToxLoss(-1)
		revive_cost += 40

/obj/item/organ/cyberimp/chest/reviver/proc/undo_heart_attack()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	H.set_heartattack(FALSE)
	if(H.stat == CONSCIOUS)
		to_chat(H, span_notice("Чувствую, что мое сердце вновь забилось!"))
