GLOBAL_LIST_EMPTY(dead_players_during_shift)
/mob/living/carbon/human/gib_animation()
	new /obj/effect/temp_visual/gib_animation(loc, dna.species.gib_anim)

/mob/living/carbon/human/dust_animation()
	new /obj/effect/temp_visual/dust_animation(loc, dna?.species?.dust_anim)

/mob/living/carbon/human/spawn_gibs(with_bodyparts)
	if(with_bodyparts)
		new /obj/effect/gibspawner/human(drop_location(), src)
	else
		new /obj/effect/gibspawner/human/bodypartless(drop_location(), src)

/mob/living/carbon/human/spawn_dust(just_ash = FALSE)
	if(just_ash)
		new /obj/effect/decal/cleanable/ash(loc)
	else
		new /obj/effect/decal/remains/human(loc)

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return
	stop_sound_channel(CHANNEL_HEARTBEAT)
	var/obj/item/organ/heart/H = getorganslot(ORGAN_SLOT_HEART)
	if(H)
		H.beat = BEAT_NONE

	to_chat(client, \
	"<span class='notice'><i>Пришлось погибнуть. Было ли это по моей глупости или нет? Возможно моё тело ещё реанимируют, можно подождать...\
	\nГоворят, что после смерти есть возможность получить вторую жизнь, можно попробовать найти свой шанс...</i></span>")

	. = ..()

	dizziness = 0
	jitteriness = 0

	if(!QDELETED(dna)) //The gibbed param is bit redundant here since dna won't exist at this point if they got deleted.
		dna.species.spec_death(gibbed, src)

	if(SSticker.HasRoundStarted())
		SSblackbox.ReportDeath(src)
		log_message("has died (BRUTE: [src.getBruteLoss()], BURN: [src.getFireLoss()], TOX: [src.getToxLoss()], OXY: [src.getOxyLoss()])", LOG_ATTACK)

/client/proc/show_tgui_notice(header, msg)
	tgui_alert_async(src, header, msg, list("Понимаю"))

/mob/living/carbon/proc/Drain()
	become_husk(CHANGELING_DRAIN)
	ADD_TRAIT(src, TRAIT_BADDNA, CHANGELING_DRAIN)
	blood_volume = 0
	return TRUE

/mob/living/carbon/proc/makeUncloneable()
	ADD_TRAIT(src, TRAIT_BADDNA, MADE_UNCLONEABLE)
	blood_volume = 0
	return TRUE
