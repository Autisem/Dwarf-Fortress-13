/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/cry/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(ishuman(H))
		if(user.gender == FEMALE)
			return pick('sound/emotes/female_crying01.ogg',\
						'sound/emotes/female_crying02.ogg',\
						'sound/emotes/female_crying03.ogg',\
						'sound/emotes/female_crying04.ogg')
		else
			return pick('sound/emotes/male_crying01.ogg',\
						'sound/emotes/male_crying02.ogg',\
						'sound/emotes/male_crying03.ogg',\
						'sound/emotes/male_crying04.ogg')

/datum/emote/living/carbon/human/dap
	key = "dap"
	key_third_person = "daps"
	message = "sadly can't find anybody to give daps to, and daps themself. Shameful."
	message_param = "give daps to %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "grumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "shakes their own hands."
	message_param = "shakes hands with %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	message = "hugs themselves."
	message_param = "hugs %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = FALSE
	vary = TRUE

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(ishuman(H))
		if(user.gender == FEMALE)
			return pick('sound/emotes/scream_female_1.ogg',\
						'sound/emotes/scream_female_2.ogg',\
						'sound/emotes/scream_female_3.ogg',\
						'sound/emotes/scream_female_4.ogg')
		else
			return pick('sound/emotes/scream_male_1.ogg',\
						'sound/emotes/scream_male_2.ogg',\
						'sound/voice/human/malescream_1.ogg',\
						'sound/voice/human/malescream_2.ogg',\
						'sound/voice/human/malescream_3.ogg',\
						'sound/voice/human/malescream_4.ogg',\
						'sound/voice/human/malescream_5.ogg',\
						'sound/voice/human/malescream_6.ogg')

/datum/emote/living/carbon/human/scream/screech //If a human tries to screech it'll just scream.
	key = "screech"
	key_third_person = "screeches"
	message = "screeches."
	emote_type = EMOTE_AUDIBLE
	vary = FALSE

/datum/emote/living/carbon/human/agony
	key = "agony"
	key_third_person = "agonizes"
	message = "screams in agony!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	vary = TRUE

/datum/emote/living/carbon/human/agony/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(user.gender == FEMALE)
		return pick('sound/emotes/agony_female_1.ogg',\
					'sound/emotes/agony_female_2.ogg',\
					'sound/emotes/agony_female_3.ogg')
	else
		return pick('sound/emotes/agony_male_1.ogg',\
					'sound/emotes/agony_male_2.ogg',\
					'sound/emotes/agony_male_3.ogg',\
					'sound/emotes/agony_male_4.ogg',\
					'sound/emotes/agony_male_5.ogg',\
					'sound/emotes/agony_male_6.ogg',\
					'sound/emotes/agony_male_7.ogg',\
					'sound/emotes/agony_male_8.ogg',\
					'sound/emotes/agony_male_9.ogg')


/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "pales for a second."

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "raises their hands."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes to %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "shrugs."

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"
	message = "wags their tail."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species || !H.dna.species.can_wag_tail(H))
		return
	if(!H.dna.species.is_wagging_tail())
		H.dna.species.start_wagging_tail(H)
	else
		H.dna.species.stop_wagging_tail(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna && H.dna.species && H.dna.species.can_wag_tail(user)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.dna || !H.dna.species)
		return
	if(H.dna.species.is_wagging_tail())
		. = null

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "their wings."

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		if(findtext(select_message_type(user,intentional), "open"))
			H.OpenWings()
		else
			H.CloseWings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.dna.species.mutant_bodyparts["wings"])
		. = "opens " + message
	else
		. = "closes " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "None"))
		return TRUE

/mob/living/carbon/human/proc/OpenWings()
	if(!dna || !dna.species)
		return
	if(dna.species.mutant_bodyparts["wings"])
		dna.species.mutant_bodyparts["wingsopen"] = dna.species.mutant_bodyparts["wings"]
		dna.species.mutant_bodyparts -= "wings"
	update_body()

/mob/living/carbon/human/proc/CloseWings()
	if(!dna || !dna.species)
		return
	if(dna.species.mutant_bodyparts["wingsopen"])
		dna.species.mutant_bodyparts["wings"] = dna.species.mutant_bodyparts["wingsopen"]
		dna.species.mutant_bodyparts -= "wingsopen"
	update_body()
	if(isturf(loc))
		var/turf/T = loc
		T.Entered(src)

//Ayy lmao

/datum/emote/living/carbon/human/dab
	key = "dab"
	key_third_person = "dabs"
	message = "dabs!"
	hands_use_check = TRUE

/datum/emote/living/carbon/human/dab/run_emote(mob/living/carbon/user, params)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/light_dab_angle = rand(35,55)
		var/light_dab_speed = rand(3,7)
		H.DabAnimation(angle = light_dab_angle , speed = light_dab_speed)
		H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
