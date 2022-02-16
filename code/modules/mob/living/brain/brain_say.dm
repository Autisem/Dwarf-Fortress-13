/mob/living/brain/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(prob(emp_damage*4))
		if(prob(10))//10% chane to drop the message entirely
			return
		else
			message = Gibberish(message, emp_damage >= 12)//scrambles the message, gets worse when emp_damage is higher

	..()

/mob/living/brain/treat_message(message)
	if(client?.prefs?.disabled_autocap)
		message = message
	else
		message = capitalize(message)
	return message
