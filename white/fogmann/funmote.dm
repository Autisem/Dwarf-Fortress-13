/datum/emote/living/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/fart/run_emote(mob/user, params)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		message = "farts violently!"
		playsound(H, pick('white/valtos/sounds/emotes/fart_1.ogg',\
							'white/valtos/sounds/emotes/fart_2.ogg',\
							'white/valtos/sounds/emotes/fart_3.ogg',\
							'white/valtos/sounds/emotes/fart_4.ogg',\
							'white/valtos/sounds/emotes/fart_5.ogg',\
							'white/valtos/sounds/emotes/fart_6.ogg',\
							'white/valtos/sounds/emotes/fart_7.ogg',\
							'white/valtos/sounds/emotes/fart_8.ogg',\
							'white/valtos/sounds/emotes/fart_9.ogg'), 50, 1)
