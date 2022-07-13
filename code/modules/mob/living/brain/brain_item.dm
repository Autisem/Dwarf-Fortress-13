/obj/item/organ/brain
	name = "brain"
	desc = "Juicy piece of meat."
	icon_state = "brain"
	throw_speed = 3
	throw_range = 5
	layer = ABOVE_MOB_LAYER
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_BRAIN
	organ_flags = ORGAN_VITAL
	attack_verb_continuous = list("attacks", "slaps")
	attack_verb_simple = list("attack", "slap")

	///The brain's organ variables are significantly more different than the other organs, with half the decay rate for balance reasons, and twice the maxHealth
	decay_factor = STANDARD_ORGAN_DECAY	* 0.5		//30 minutes of decaying to result in a fully damaged brain, since a fast decay rate would be unfun gameplay-wise

	maxHealth = BRAIN_DAMAGE_DEATH
	low_threshold = 45
	high_threshold = 120

	var/suicided = FALSE
	var/mob/living/brain/brainmob = null
	var/decoy_override = FALSE	//if it's a fake brain with no brainmob assigned. Feedback messages will be faked as if it does have a brainmob. See changelings & dullahans.
	//two variables necessary for calculating whether we get a brain trauma or not
	var/damage_delta = 0

/obj/item/organ/brain/Insert(mob/living/carbon/C, special = 0,no_id_transfer = FALSE)
	. = ..()

	name = "brain"

	if(brainmob)
		if(C.key)
			C.ghostize()

		if(brainmob.mind)
			brainmob.mind.transfer_to(C)
		else
			C.key = brainmob.key

		QDEL_NULL(brainmob)

	//Update the body's icon so it doesnt appear debrained anymore
	C.update_hair()

/obj/item/organ/brain/Remove(mob/living/carbon/C, special = 0, no_id_transfer = FALSE)

	. = ..()

	if((!gc_destroyed || (owner && !owner.gc_destroyed)) && !no_id_transfer)
		transfer_identity(C)
	C.update_hair()

/obj/item/organ/brain/proc/transfer_identity(mob/living/L)
	name = "мозг [L.name]"
	if(brainmob || decoy_override)
		return
	if(!L.mind)
		return
	brainmob = new(src)
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	brainmob.timeofhostdeath = L.timeofdeath
	brainmob.suiciding = suicided
	if(L.has_dna())
		if(HAS_TRAIT(L, TRAIT_BADDNA))
			LAZYSET(brainmob.status_traits, TRAIT_BADDNA, L.status_traits[TRAIT_BADDNA])
	if(L.mind && L.mind.current)
		L.mind.transfer_to(brainmob)
	to_chat(brainmob, span_notice("You feel a bit dizzy. Probably because you are a brain?"))

/obj/item/organ/brain/attackby(obj/item/O, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)

	if(brainmob) //if we aren't trying to heal the brain, pass the attack onto the brainmob.
		O.attack(brainmob, user) //Oh noooeeeee

	if(O.force != 0 && !(O.item_flags & NOBLUDGEON))
		setOrganDamage(maxHealth) //fails the brain as the brain was attacked, they're pretty fragile.
		visible_message(span_danger("[user] hits [src.name] with [O]!"))
		to_chat(user, span_danger("You hit [src.name] with [O]!"))

/obj/item/organ/brain/examine(mob/user)
	. = ..()
	if(suicided)
		. += "<hr><span class='info'>Он начал слегка сереть. Носитель, должно быть, не смог справиться со всем этим стрессом.</span>"
		return
	if((brainmob && (brainmob.client || brainmob.get_ghost())) || decoy_override)
		if(organ_flags & ORGAN_FAILING)
			. += "<hr><span class='info'>Кажется, в нем еще есть немного энергии, но он сильно поврежден... Возможно, получится восстановить его с помощью <b>маннитола</b>.</span>"
		else if(damage >= BRAIN_DAMAGE_DEATH*0.5)
			. += "<hr><span class='info'>Можно почувствовать небольшую искру жизни, которая все еще осталась в этом мозге, но он повреждён. Возможно, получится восстановить его с помощью <b>маннитола</b>.</span>"
		else
			. += "<hr><span class='info'>Можно почувствовать маленькую искру жизни, которая все еще осталась в этом мозге.</span>"
	else
		. += "<hr><span class='info'>Он полностью мёртв.</span>"

/obj/item/organ/brain/attack(mob/living/carbon/C, mob/user)
	if(!istype(C))
		return ..()

	add_fingerprint(user)

	if(user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	var/target_has_brain = C.getorgan(/obj/item/organ/brain)

	if(!target_has_brain && C.is_eyes_covered())
		to_chat(user, span_warning("Стоит открыть [C.p_their()] голову сначала!"))
		return

	//since these people will be dead M != usr

	if(!target_has_brain)
		if(!C.get_bodypart(BODY_ZONE_HEAD) || !user.temporarilyRemoveItemFromInventory(src))
			return
		var/msg = "[C] вставляет [src] в голову [user]."
		if(C == user)
			msg = "[user] вставляет [src] в [user.p_their()] голову!"

		C.visible_message(span_danger("[msg]") ,
						span_userdanger("[msg]"))

		if(C != user)
			to_chat(C, span_notice("[user] вставляет [src] в мою голову."))
			to_chat(user, span_notice("Вставляю [src] в голову [C]."))
		else
			to_chat(user, span_notice("Вставляю [src] в свою голову.") 	)

		Insert(C)
	else
		..()

/obj/item/organ/brain/Destroy() //copypasted from MMIs.
	if(brainmob)
		QDEL_NULL(brainmob)

	if(owner?.mind) //You aren't allowed to return to brains that don't exist
		owner.mind.set_current(null)
	return ..()

/obj/item/organ/brain/on_life(delta_time, times_fired)
	if(damage >= BRAIN_DAMAGE_DEATH) //rip
		to_chat(owner, span_userdanger("Последняя искра жизни в моём мозгу угасает.."))
		owner.death()

/obj/item/organ/brain/check_damage_thresholds(mob/M)
	. = ..()
	//if we're not more injured than before, return without gambling for a trauma
	if(damage <= prev_damage)
		return

	if (owner)
		if(owner.stat < UNCONSCIOUS) //conscious or soft-crit
			var/brain_message
			if(prev_damage < BRAIN_DAMAGE_MILD && damage >= BRAIN_DAMAGE_MILD)
				brain_message = span_warning("You feel lightheaded.")
			else if(prev_damage < BRAIN_DAMAGE_SEVERE && damage >= BRAIN_DAMAGE_SEVERE)
				brain_message = span_warning("You feel less in control of your thoughts.")
			else if(prev_damage < (BRAIN_DAMAGE_DEATH - 20) && damage >= (BRAIN_DAMAGE_DEATH - 20))
				brain_message = span_warning("You can feel your mind flickering on and off...")

			if(.)
				. += "\n[brain_message]"
			else
				return brain_message

/obj/item/organ/brain/before_organ_replacement(obj/item/organ/replacement)
	. = ..()
	var/obj/item/organ/brain/replacement_brain = replacement
	if(!istype(replacement_brain))
		return
