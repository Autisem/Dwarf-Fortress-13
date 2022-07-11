#define BEYBLADE_PUKE_THRESHOLD 30 //How confused a carbon must be before they will vomit
#define BEYBLADE_PUKE_NUTRIENT_LOSS 60 //How must nutrition is lost when a carbon pukes
#define BEYBLADE_DIZZINESS_PROBABILITY 20 //How often a carbon becomes penalized
#define BEYBLADE_DIZZINESS_VALUE 10 //How long the screenshake lasts
#define BEYBLADE_CONFUSION_INCREMENT 10 //How much confusion a carbon gets when penalized
#define BEYBLADE_CONFUSION_LIMIT 40 //A max for how penalized a carbon will be for beyblading

//The code execution of the emote datum is located at code/datums/emotes.dm
/mob/proc/emote(act, m_type = null, message = null, intentional = FALSE)
	act = lowertext(act)
	var/param = message
	var/custom_param = findchar(act, " ")
	if(custom_param)
		param = copytext(act, custom_param + length(act[custom_param]))
		act = copytext(act, 1, custom_param)

	var/list/key_emotes = GLOB.emote_list[act]

	if(!length(key_emotes))
		if(intentional)
			to_chat(src, span_notice("'[act]' does not exist. Write <b>*help</b> to show available emotes."))
		return FALSE
	var/silenced = FALSE
	for(var/datum/emote/P in key_emotes)
		if(!P.check_cooldown(src, intentional))
			silenced = TRUE
			continue
		if(P.run_emote(src, param, m_type, intentional))
			SEND_SIGNAL(src, COMSIG_MOB_EMOTE, P, act, m_type, message, intentional)
			SEND_SIGNAL(src, COMSIG_MOB_EMOTED(P.key))
			webhook_send_me(ckeyname, message)
			return TRUE
	if(intentional && !silenced)
		to_chat(src, span_notice("Emote '[act]' is impossible. Write <b>*help</b> to show available emotes."))
	return FALSE

/datum/emote/spin
	key = "spin"
	key_third_person = "spins"
	hands_use_check = TRUE
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)

/datum/emote/spin/run_emote(mob/user, params ,  type_override, intentional)
	. = ..()
	if(.)
		user.spin(20, 1)

/datum/emote/spin/check_cooldown(mob/living/carbon/user, intentional)
	. = ..()
	if(.)
		return
	if(!can_run_emote(user, intentional=intentional))
		return
	if(!iscarbon(user))
		return
	var/current_confusion = user.get_confusion()
	if(current_confusion > BEYBLADE_PUKE_THRESHOLD)
		user.vomit(BEYBLADE_PUKE_NUTRIENT_LOSS, distance = 0)
		return
	if(prob(BEYBLADE_DIZZINESS_PROBABILITY))
		to_chat(user, span_warning("You feel woozy from spinning."))
		user.Dizzy(BEYBLADE_DIZZINESS_VALUE)
		if(current_confusion < BEYBLADE_CONFUSION_LIMIT)
			user.add_confusion(BEYBLADE_CONFUSION_INCREMENT)


#undef BEYBLADE_PUKE_THRESHOLD
#undef BEYBLADE_PUKE_NUTRIENT_LOSS
#undef BEYBLADE_DIZZINESS_PROBABILITY
#undef BEYBLADE_DIZZINESS_VALUE
#undef BEYBLADE_CONFUSION_INCREMENT
#undef BEYBLADE_CONFUSION_LIMIT
