/*
//////////////////////////////////////

Weight Loss

	Very Very Noticable.
	Decreases resistance.
	Decreases stage speed.
	Reduced Transmittable.
	High level.

Bonus
	Decreases the weight of the mob,
	forcing it to be skinny.

//////////////////////////////////////
*/

/datum/symptom/weight_loss

	name = "Потеря веса"
	desc = "Вирус мутирует метаболизм хозяина, делая его почти неспособным получать питание из пищи.."
	stealth = -2
	resistance = 2
	stage_speed = -2
	transmittable = -2
	level = 3
	severity = 3
	base_message_chance = 100
	symptom_delay_min = 15
	symptom_delay_max = 45
	threshold_descs = list(
		"Скрытность 4" = "Симптом менее заметен."
	)

/datum/symptom/weight_loss/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stealth"] >= 4) //warn less often
		base_message_chance = 25

/datum/symptom/weight_loss/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance))
				to_chat(M, span_warning("[pick("Хочется кушать.", "Сейчас бы пожрать.")]"))
		else
			to_chat(M, span_warning("<i>[pick("Голодно...", "Убью за еду...", "Голод пожирает меня...")]</i>"))
			M.overeatduration = max(M.overeatduration - 200 SECONDS, 0)
			M.adjust_nutrition(-100)
