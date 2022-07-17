//The contant in the rate of reagent transfer on life ticks
#define STOMACH_METABOLISM_CONSTANT 0.25

/obj/item/organ/stomach
	name = "желудок"
	icon_state = "stomach"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_STOMACH
	attack_verb_continuous = list("выжимает", "выдавливает", "шлёпает", "кормит")
	attack_verb_simple = list("выжимает", "выдавливает", "шлёпает", "кормит")
	desc = "Onaka ga suite imasu."

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY * 1.15 // ~13 minutes, the stomach is one of the first organs to die

	low_threshold_passed = span_info("Перед тем как утихнуть, в животе вспыхивает боль. Еда сейчас не кажется разумной идеей.")
	high_threshold_passed = span_warning("Желудок горит от постоянной боли - с трудом могу переварить идею еды прямо сейчас!")
	high_threshold_cleared = span_info("Боль в животе пока утихает, но еда все еще кажется непривлекательной.")
	low_threshold_cleared = span_info("Последние приступы боли в животе утихли.")

	food_reagents = list(/datum/reagent/consumable/nutriment/organ_tissue = 5)
	//This is a reagent user and needs more then the 10u from edible component
	reagent_vol = 1000

	///The rate that disgust decays
	var/disgust_metabolism = 1

	///The rate that the stomach will transfer reagents to the body
	var/metabolism_efficiency = 0.05 // the lowest we should go is 0.05
	var/operated = FALSE

/obj/item/organ/stomach/Initialize()
	. = ..()
	//None edible organs do not get a reagent holder by default
	if(!reagents)
		create_reagents(reagent_vol, REAGENT_HOLDER_ALIVE)
	else
		reagents.flags |= REAGENT_HOLDER_ALIVE

/obj/item/organ/stomach/on_life(delta_time, times_fired)
	. = ..()

	//Manage species digestion
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/humi = owner
		if(!(organ_flags & ORGAN_FAILING))
			humi.dna.species.handle_digestion(humi, delta_time, times_fired)

	var/mob/living/carbon/body = owner

	// digest food, sent all reagents that can metabolize to the body
	for(var/chunk in reagents.reagent_list)
		var/datum/reagent/bit = chunk

		// If the reagent does not metabolize then it will sit in the stomach
		// This has an effect on items like plastic causing them to take up space in the stomach
		if(bit.metabolization_rate <= 0)
			continue

		//Do not transfer over more then we have
		var/amount_max = bit.volume

		//If the reagent is part of the food reagents for the organ
		//prevent all the reagents form being used leaving the food reagents
		var/amount_food = food_reagents[bit.type]
		if(amount_food)
			amount_max = max(amount_max - amount_food, 0)

		// Transfer the amount of reagents based on volume with a min amount of 1u
		var/amount = max(1, amount_max)

		if(amount <= 0)
			continue

		// transfer the reagents over to the body at the rate of the stomach metabolim
		// this way the body is where all reagents that are processed and react
		// the stomach manages how fast they are feed in a drip style
		reagents.trans_id_to(body, bit.type, amount=amount)

	//Handle disgust
	if(body)
		handle_disgust(body, delta_time, times_fired)

	//If the stomach is not damage exit out
	if(damage < low_threshold)
		return

	//We are checking if we have nutriment in a damaged stomach.
	var/datum/reagent/nutri = locate(/datum/reagent/consumable/nutriment) in reagents.reagent_list
	//No nutriment found lets exit out
	if(!nutri)
		return

	// remove the food reagent amount
	var/nutri_vol = nutri.volume
	var/amount_food = food_reagents[nutri.type]
	if(amount_food)
		nutri_vol = max(nutri_vol - amount_food, 0)

	// found nutriment was stomach food reagent
	if(!(nutri_vol > 0))
		return

	//The stomach is damage has nutriment but low on theshhold, lo prob of vomit
	if(DT_PROB(0.0125 * damage * nutri_vol * nutri_vol, delta_time))
		body.vomit(damage)
		to_chat(body, span_warning("Живот крутит от боли, потому что я не могу сдерживать эту еду!"))
		return

	// the change of vomit is now high
	if(damage > high_threshold && DT_PROB(0.05 * damage * nutri_vol * nutri_vol, delta_time))
		body.vomit(damage)
		to_chat(body, span_warning("Живот крутит от боли, потому что я не могу сдерживать эту еду!"))

	if(body.nutrition <= 50)
		applyOrganDamage(1)

/obj/item/organ/stomach/get_availability(datum/species/S)
	return !(NOSTOMACH in S.inherent_traits)

/obj/item/organ/stomach/proc/handle_disgust(mob/living/carbon/human/H, delta_time, times_fired)
	if(H.disgust)
		var/pukeprob = 2.5 + (0.025 * H.disgust)
		if(H.disgust >= DISGUST_LEVEL_GROSS)
			if(DT_PROB(5, delta_time))
				H.stuttering += 1
				H.add_confusion(2)
			if(DT_PROB(5, delta_time) && !H.stat)
				to_chat(H, span_warning("Меня тошнит..."))
			H.jitteriness = max(H.jitteriness - 3, 0)
		if(H.disgust >= DISGUST_LEVEL_VERYGROSS)
			if(DT_PROB(pukeprob, delta_time)) //iT hAndLeS mOrE ThaN PukInG
				H.add_confusion(2.5)
				H.stuttering += 1
				H.vomit(10, 0, 1, 0, 1, 0)
			H.Dizzy(5)
		if(H.disgust >= DISGUST_LEVEL_DISGUSTED)
			if(DT_PROB(13, delta_time))
				H.blur_eyes(3) //We need to add more shit down here

		H.adjust_disgust(-0.25 * disgust_metabolism * delta_time)
	switch(H.disgust)
		if(0 to DISGUST_LEVEL_GROSS)
			H.clear_alert("disgust")
			SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "disgust")
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			H.throw_alert("disgust", /atom/movable/screen/alert/gross)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/gross)
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			H.throw_alert("disgust", /atom/movable/screen/alert/verygross)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/verygross)
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			H.throw_alert("disgust", /atom/movable/screen/alert/disgusted)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/disgusted)

/obj/item/organ/stomach/Remove(mob/living/carbon/M, special = 0)
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		H.clear_alert("disgust")
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "disgust")

	return ..()

/obj/item/organ/stomach/bone
	desc = "Вы не представляете, что делает этот странный шар из костей."
	metabolism_efficiency = 0.05 //very bad
	var/milk_brute_healing = 1.5
	/// How much [BURN] damage milk heals every second
	var/milk_burn_healing = 1.5

/obj/item/organ/stomach/bone/on_life(delta_time, times_fired)
	var/datum/reagent/consumable/milk/milk = locate(/datum/reagent/consumable/milk) in reagents.reagent_list
	if(milk)
		var/mob/living/carbon/body = owner
		if(milk.volume > 10)
			reagents.remove_reagent(milk.type, milk.volume - 10)
			to_chat(owner, span_warning("Лишнее молоко капает с костей!"))
		body.heal_bodypart_damage(milk_brute_healing * REAGENTS_EFFECT_MULTIPLIER * delta_time, milk_burn_healing * REAGENTS_EFFECT_MULTIPLIER * delta_time)

		reagents.remove_reagent(milk.type, milk.metabolization_rate * delta_time)
	return ..()

/obj/item/organ/stomach/bone/plasmaman
	name = "пищеварительный кристалл"
	icon_state = "stomach-p"
	desc = "Странный кристалл, отвечающий за метаболизм невидимой энергии, питающей плазмамена."
	metabolism_efficiency = 0.12
	milk_burn_healing = 0

/obj/item/organ/stomach/ethereal
	name = "Биохимическая батарея"
	icon_state = "stomach-p" //Welp. At least it's more unique in functionaliy.
	desc = "Кристаллический орган, хранящий электрический заряд эфирных существ."
	var/crystal_charge = ETHEREAL_CHARGE_FULL

/obj/item/organ/stomach/ethereal/on_life(delta_time, times_fired)
	..()
	adjust_charge(-ETHEREAL_CHARGE_FACTOR * delta_time)

/obj/item/organ/stomach/ethereal/Insert(mob/living/carbon/M, special = 0)
	..()
	RegisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, .proc/charge)
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, .proc/on_electrocute)

/obj/item/organ/stomach/ethereal/Remove(mob/living/carbon/M, special = 0)
	UnregisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	..()

/obj/item/organ/stomach/ethereal/proc/charge(datum/source, amount, repairs)
	adjust_charge(amount / 3.5)

/obj/item/organ/stomach/ethereal/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 2)
	to_chat(owner, span_notice("Поглощаю часть удара током своим телом!"))

/obj/item/organ/stomach/ethereal/proc/adjust_charge(amount)
	crystal_charge = clamp(crystal_charge + amount, ETHEREAL_CHARGE_NONE, ETHEREAL_CHARGE_DANGEROUS)

/obj/item/organ/stomach/cybernetic
	name = "базовый кибернетический желудок"
	icon_state = "stomach-c"
	desc = "Базовое устройство, имитирующее функции человеческого желудка."
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5
	var/emp_vulnerability = 80	//Chance of permanent effects if emp-ed.
	metabolism_efficiency = 0.7 // not as good at digestion

/obj/item/organ/stomach/cybernetic/tier2
	name = "кибернетический желудок"
	icon_state = "stomach-c-u"
	desc = "Электронное устройство, имитирующее функции человеческого желудка. Немного лучше справляется с отвратительной едой."
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	disgust_metabolism = 2
	emp_vulnerability = 40
	metabolism_efficiency = 0.07

/obj/item/organ/stomach/cybernetic/tier3
	name = "продвинутый кибернетический желудок"
	icon_state = "stomach-c-u2"
	desc = "Усовершенствованная версия кибернетического желудка, предназначенная для дальнейшего улучшения органических желудков. Отлично справляется с отвратительной едой."
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	disgust_metabolism = 3
	emp_vulnerability = 20
	metabolism_efficiency = 0.01

#undef STOMACH_METABOLISM_CONSTANT
