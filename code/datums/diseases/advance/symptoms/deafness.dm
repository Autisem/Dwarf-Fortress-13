/*
//////////////////////////////////////

Deafness

	Slightly noticable.
	Lowers resistance.
	Decreases stage speed slightly.
	Decreases transmittablity.
	Intense Level.

Bonus
	Causes intermittent loss of hearing.

//////////////////////////////////////
*/

/datum/symptom/deafness

	name = "Глухота"
	desc = "Вирус вызывает воспаление барабанных перепонок, вызывая периодическую глухоту."
	stealth = -1
	resistance = -2
	stage_speed = -1
	transmittable = -3
	level = 4
	severity = 4
	base_message_chance = 100
	symptom_delay_min = 25
	symptom_delay_max = 80
	threshold_descs = list(
		"Сопротивление 9" = "Вызывает постоянную глухоту, а не периодическую.",
		"Скрытность 4" = "Симптом остается скрытым до тех пор, пока не станет активным.",
	)

/datum/symptom/deafness/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stealth"] >= 4)
		suppress_warning = TRUE
	if(A.properties["resistance"] >= 9) //permanent deafness
		power = 2

/datum/symptom/deafness/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	var/obj/item/organ/ears/ears = M.getorganslot(ORGAN_SLOT_EARS)
	if(!ears)
		return //cutting off your ears to cure the deafness: the ultimate own
	switch(A.stage)
		if(3, 4)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(M, span_warning("[pick("Слышу звон в ушах.", "В ушах стреляет.")]"))
		if(5)
			if(power >= 2)
				if(ears.damage < ears.maxHealth)
					to_chat(M, span_userdanger("Уши болезненно стреляют и начинают кровоточить!"))
					ears.damage = max(ears.damage, ears.maxHealth)
					M.emote("agony")
			else
				to_chat(M, span_userdanger("В УШАХ ЗВЕНИТ!"))
				ears.deaf = min(20, ears.deaf + 15)
