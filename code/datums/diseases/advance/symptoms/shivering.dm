#define SHIVERING_CHANGE "shivering"

/*
//////////////////////////////////////

Shivering

	No change to hidden.
	Increases resistance.
	Increases stage speed.
	Little transmittable.
	Low level.

Bonus
	Cools down your body.

//////////////////////////////////////
*/

/datum/symptom/shivering
	name = "Дрожь"
	desc = "Вирус подавляет терморегуляцию организма, охлаждая его."
	stealth = 0
	resistance = 2
	stage_speed = 3
	transmittable = 2
	level = 2
	severity = 2
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/unsafe = FALSE //over the cold threshold
	threshold_descs = list(
		"Скорость 5" = "Увеличивает скорость охлаждения; температура хозяина может упасть ниже безопасного уровня.",
		"Скорость 10" = "Еще больше увеличивает скорость охлаждения."
	)

/datum/symptom/shivering/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 5) //dangerous cold
		power = 1.5
		unsafe = TRUE
	if(A.properties["stage_rate"] >= 10)
		power = 2.5

/datum/symptom/shivering/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	if(!unsafe || A.stage < 4)
		to_chat(M, span_warning("[pick("Холодно.", "Дрожу.")]"))
	else
		to_chat(M, span_userdanger("[pick("Кровь холодная.", "Вены заледенели.", "Не могу согреться.", "Сильно дрожу." )]"))
	set_body_temp(A.affected_mob, A)

/**
 * set_body_temp Sets the body temp change
 *
 * Sets the body temp change to the mob based on the stage and resistance of the disease
 * arguments:
 * * mob/living/M The mob to apply changes to
 * * datum/disease/advance/A The disease applying the symptom
 */
/datum/symptom/shivering/proc/set_body_temp(mob/living/M, datum/disease/advance/A)
	// Get the max amount of change allowed before going under cold damage limit, 5 over the cold damage limit
	var/change_limit = (340.15 - 5) - M.get_body_temp_normal(apply_change=FALSE)
	if(unsafe) // when unsafe the shivers can cause (cold?)burn damage (not wounds)
		change_limit -= 20
	M.add_body_temperature_change(SHIVERING_CHANGE, max(-((6 * power) * A.stage), change_limit))

/// Update the body temp change based on the new stage
/datum/symptom/shivering/on_stage_change(datum/disease/advance/A)
	. = ..()
	if(.)
		set_body_temp(A.affected_mob, A)

/// remove the body temp change when removing symptom
/datum/symptom/shivering/End(datum/disease/advance/A)
	var/mob/living/carbon/M = A.affected_mob
	if(M)
		M.remove_body_temperature_change(SHIVERING_CHANGE)

#undef SHIVERING_CHANGE
