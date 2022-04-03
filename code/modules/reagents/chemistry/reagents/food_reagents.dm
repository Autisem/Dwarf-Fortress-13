///////////////////////////////////////////////////////////////////
					//Food Reagents
//////////////////////////////////////////////////////////////////


// Part of the food code. Also is where all the food
// 	condiments, additives, and such go.


/datum/reagent/consumable
	name = "Поглощаемые вещества"
	taste_description = "универсальная еда"
	taste_mult = 4
	impure_chem = /datum/reagent/water
	inverse_chem_val = 0.1
	inverse_chem = null
	failed_chem = /datum/reagent/consumable/nutriment
	/// How much nutrition this reagent supplies
	var/nutriment_factor = 1 * REAGENTS_METABOLISM
	var/quality = 0 //affects mood, typically higher for mixed drinks with more complex recipes'
	///The amount a robot will pay for a glass of this (20 units but can be higher if you pour more, be frugal!)
	var/glass_price

/datum/reagent/consumable/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	current_cycle++
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_nutrition(nutriment_factor * REM * delta_time)
	if(length(reagent_removal_skip_list))
		return
	holder.remove_reagent(type, metabolization_rate * delta_time)

/datum/reagent/consumable/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & INGEST) || !quality || HAS_TRAIT(exposed_mob, TRAIT_AGEUSIA))
		return
	switch(quality)
		if (DRINK_NICE)
			SEND_SIGNAL(exposed_mob, COMSIG_ADD_MOOD_EVENT, "quality_drink", /datum/mood_event/quality_nice)
		if (DRINK_GOOD)
			SEND_SIGNAL(exposed_mob, COMSIG_ADD_MOOD_EVENT, "quality_drink", /datum/mood_event/quality_good)
		if (DRINK_VERYGOOD)
			SEND_SIGNAL(exposed_mob, COMSIG_ADD_MOOD_EVENT, "quality_drink", /datum/mood_event/quality_verygood)
		if (DRINK_FANTASTIC)
			SEND_SIGNAL(exposed_mob, COMSIG_ADD_MOOD_EVENT, "quality_drink", /datum/mood_event/quality_fantastic)
		if (FOOD_AMAZING)
			SEND_SIGNAL(exposed_mob, COMSIG_ADD_MOOD_EVENT, "quality_food", /datum/mood_event/amazingtaste)

	if(reagent_state == LIQUID)
		exposed_mob.hydration += max(0.5, nutriment_factor) * hydration_factor

/datum/reagent/consumable/nutriment
	name = "Питательные вещества"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	var/brute_heal = 1
	var/burn_heal = 0
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/nutriment/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(30, delta_time))
		M.heal_bodypart_damage(brute = brute_heal, burn = burn_heal)
		. = TRUE
	..()

/datum/reagent/consumable/nutriment/on_new(list/supplied_data)
	// taste data can sometimes be ("соль" = 3, "чипсы" = 1)
	// and we want it to be in the form ("соль" = 0.75, "чипсы" = 0.25)
	// which is called "normalizing"
	if(!supplied_data)
		supplied_data = data

	// if data isn't an associative list, this has some WEIRD side effects
	// TODO probably check for assoc list?

	data = counterlist_normalise(supplied_data)

/datum/reagent/consumable/nutriment/on_merge(list/newdata, newvolume)
	. = ..()
	if(!islist(newdata) || !newdata.len)
		return

	// data for nutriment is one or more (flavour -> ratio)
	// where all the ratio values adds up to 1

	var/list/taste_amounts = list()
	if(data)
		taste_amounts = data.Copy()

	counterlist_scale(taste_amounts, volume)

	var/list/other_taste_amounts = newdata.Copy()
	counterlist_scale(other_taste_amounts, newvolume)

	counterlist_combine(taste_amounts, other_taste_amounts)

	counterlist_normalise(taste_amounts)

	data = taste_amounts

/datum/reagent/consumable/nutriment/get_taste_description(mob/living/taster)
	return data

/datum/reagent/consumable/nutriment/vitamin
	name = "Витамин"
	description = "All the best vitamins, minerals, and carbohydrates the body needs in pure form."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	brute_heal = 1
	burn_heal = 1

/datum/reagent/consumable/nutriment/vitamin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.satiety < 600)
		M.satiety += 30 * REM * delta_time
	. = ..()

/// The basic resource of vat growing.
/datum/reagent/consumable/nutriment/protein
	name = "Протеин"
	description = "A natural polyamide made up of amino acids. An essential constituent of mosts known forms of life."
	brute_heal = 0.8 //Rewards the player for eating a balanced diet.
	nutriment_factor = 9 * REAGENTS_METABOLISM //45% as calorie dense as corn oil.
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/nutriment/organ_tissue
	name = "Органная Ткань"
	description = "Natural tissues that make up the bulk of organs, providing many vitamins and minerals."
	taste_description = "rich earthy pungent"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/cooking_oil
	name = "Кулинарное Масло"
	description = "A variety of cooking oil derived from fat or plants. Used in food preparation and frying."
	color = "#EADD6B" //RGB: 234, 221, 107 (based off of canola oil)
	taste_mult = 0.8
	taste_description = "масло"
	nutriment_factor = 7 * REAGENTS_METABOLISM //Not very healthy on its own
	metabolization_rate = 10 * REAGENTS_METABOLISM
	penetrates_skin = NONE
	var/fry_temperature = 450 //Around ~350 F (117 C) which deep fryers operate around in the real world
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/cooking_oil/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(!holder || (holder.chem_temp <= fry_temperature))
		return
	if(!isitem(exposed_obj) || istype(exposed_obj, /obj/item/food/deepfryholder))
		return
	if(exposed_obj.resistance_flags & INDESTRUCTIBLE)
		exposed_obj.loc.visible_message(span_notice("Горячее масло не оказало эффекта на [exposed_obj]!"))
		return
	exposed_obj.loc.visible_message(span_warning("[exposed_obj] быстро обжарился благодаря вылитому горячему маслу! Каким то образом."))
	var/obj/item/food/deepfryholder/fry_target = new(exposed_obj.drop_location(), exposed_obj)
	fry_target.fry(volume)
	fry_target.reagents.add_reagent(/datum/reagent/consumable/cooking_oil, reac_volume)

/datum/reagent/consumable/cooking_oil/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & (VAPOR|TOUCH)) || isnull(holder) || (holder.chem_temp < fry_temperature)) //Directly coats the mob, and doesn't go into their bloodstream
		return

	var/oil_damage = ((holder.chem_temp / fry_temperature) * 0.33) //Damage taken per unit
	if(methods & TOUCH)
		oil_damage *= max(1 - touch_protection, 0)
	var/FryLoss = round(min(38, oil_damage * reac_volume))
	if(!HAS_TRAIT(exposed_mob, TRAIT_OIL_FRIED))
		exposed_mob.visible_message(span_warning("Кипящее масло шипит, покрывая [exposed_mob]!") , \
		span_userdanger("Облит кипящим маслом!"))
		if(FryLoss)
			exposed_mob.emote("agony")
		playsound(exposed_mob, 'sound/machines/fryer/deep_fryer_emerge.ogg', 25, TRUE)
		ADD_TRAIT(exposed_mob, TRAIT_OIL_FRIED, "cooking_oil_react")
		addtimer(CALLBACK(exposed_mob, /mob/living/proc/unfry_mob), 3)
	if(FryLoss)
		exposed_mob.adjustFireLoss(FryLoss)

/datum/reagent/consumable/cooking_oil/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf) || isgroundlessturf(exposed_turf) || (reac_volume < 5))
		return

	exposed_turf.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = reac_volume * 1.5 SECONDS)
	exposed_turf.name = "deep-fried [initial(exposed_turf.name)]"
	exposed_turf.add_atom_colour(color, TEMPORARY_COLOUR_PRIORITY)

/datum/reagent/consumable/sugar
	name = "Сахар"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 1.5 // stop sugar drowning out other flavours
	nutriment_factor = 10 * REAGENTS_METABOLISM
	metabolization_rate = 2 * REAGENTS_METABOLISM
	overdose_threshold = 60 // Hyperglycaemic shock
	taste_description = "сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/sugar/overdose_start(mob/living/M)
	to_chat(M, span_userdanger("Впадаю в гипергликемический шок! Нужно завязывать со сладостами!"))
	M.AdjustSleeping(600)
	. = TRUE

/datum/reagent/consumable/sugar/overdose_process(mob/living/M, delta_time, times_fired)
	M.AdjustSleeping(40 * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/consumable/virus_food
	name = "Пища для Вируса"
	description = "A mixture of water and milk. Virus cells can use this mixture to reproduce."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#899613" // rgb: 137, 150, 19
	taste_description = "водянистое молоко"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/soysauce
	name = "Соевый Соус"
	description = "A salty sauce made from the soy plant."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300" // rgb: 121, 35, 0
	taste_description = "умами"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/ketchup
	name = "Кетчуп"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#731008" // rgb: 115, 16, 8
	taste_description = "кетчуп"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY


/datum/reagent/consumable/capsaicin
	name = "Масло Капсаицина"
	description = "This is what makes chilis hot."
	color = "#B31008" // rgb: 179, 16, 8
	taste_description = "горячие перцы"
	taste_mult = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/capsaicin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/heating = 0
	switch(current_cycle)
		if(1 to 15)
			heating = 5
			if(holder.has_reagent(/datum/reagent/cryostylane))
				holder.remove_reagent(/datum/reagent/cryostylane, 5 * REM * delta_time)
		if(15 to 25)
			heating = 10
		if(25 to 35)
			heating = 15
		if(35 to INFINITY)
			heating = 20
	M.adjust_bodytemperature(heating * 1.5 * REM * delta_time)
	..()

/datum/reagent/consumable/frostoil
	name = "Морозное Масло"
	description = "A special oil that noticeably chills the body. Extracted from chilly peppers and slimes."
	color = "#8BA6E9" // rgb: 139, 166, 233
	taste_description = "мята"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/frostoil/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/cooling = 0
	switch(current_cycle)
		if(1 to 15)
			cooling = -10
			if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
				holder.remove_reagent(/datum/reagent/consumable/capsaicin, 5 * REM * delta_time)
		if(15 to 25)
			cooling = -20
		if(25 to 35)
			cooling = -30
			if(prob(1))
				M.emote("shiver")
		if(35 to INFINITY)
			cooling = -40
			if(prob(5))
				M.emote("shiver")
	M.adjust_bodytemperature(cooling * 1.5 * REM * delta_time, 50)
	..()

/datum/reagent/consumable/frostoil/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(reac_volume < 1)
		return
	if(isopenturf(exposed_turf))
		var/turf/open/exposed_open_turf = exposed_turf
		exposed_open_turf.MakeSlippery(wet_setting=TURF_WET_ICE, min_wet_time=100, wet_time_to_add=reac_volume SECONDS) // Is less effective in high pressure/high heat capacity environments. More effective in low pressure.

/datum/reagent/consumable/condensedcapsaicin
	name = "Конденсированный Капсаицин"
	description = "A chemical agent used for self-defense and in police work."
	color = "#B31008" // rgb: 179, 16, 8
	taste_description = "жгучая агония"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/condensedcapsaicin/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!ishuman(exposed_mob))
		return

	var/mob/living/carbon/victim = exposed_mob
	if(methods & (TOUCH|VAPOR))
		var/pepper_proof = victim.is_pepper_proof()

		//check for protection
		//actually handle the pepperspray effects
		if (!(pepper_proof)) // you need both eye and mouth protection
			if(prob(5))
				victim.emote("agony")
			victim.blur_eyes(5) // 10 seconds
			victim.blind_eyes(3) // 6 seconds
			victim.set_confusion(max(exposed_mob.get_confusion(), 5)) // 10 seconds
			victim.Knockdown(3 SECONDS)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/reagent/pepperspray)
			addtimer(CALLBACK(victim, /mob/proc/remove_movespeed_modifier, /datum/movespeed_modifier/reagent/pepperspray), 10 SECONDS)
		victim.update_damage_hud()
	if(methods & INGEST)
		if(!holder.has_reagent(/datum/reagent/consumable/milk))
			if(prob(15))
				to_chat(exposed_mob, span_danger("[pick("Голова Болит.", "Во рту будто пожар.", "Чувствую головокружение.")]"))
			if(prob(10))
				victim.blur_eyes(1)
			if(prob(10))
				victim.Dizzy(1)
			if(prob(5))
				victim.vomit()

/datum/reagent/consumable/condensedcapsaicin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(!holder.has_reagent(/datum/reagent/consumable/milk))
		if(DT_PROB(5, delta_time))
			M.visible_message(span_warning("[M] [pick("тошнит!","кашляет!","хрипит!")]"))
	..()

/datum/reagent/consumable/salt
	name = "Столовая Соль"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	taste_description = "соль"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/salt/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	exposed_mob.hydration -= 0.04

/datum/reagent/consumable/salt/expose_turf(turf/exposed_turf, reac_volume) //Creates an umbra-blocking salt pile
	. = ..()
	if(!istype(exposed_turf) || (reac_volume < 1))
		return

	new/obj/effect/decal/cleanable/food/salt(exposed_turf)

/datum/reagent/consumable/blackpepper
	name = "Черный Перец"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	reagent_state = SOLID
	// no color (ie, black)
	taste_description = "перец"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/coco
	name = "какао порошок"
	description = "A fatty, bitter paste made from coco beans."
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/coco/on_mob_add(mob/living/carbon/M)
	.=..()
	if(isfelinid(M))
		to_chat(M, span_warning("Ваши внутренности переворачиваются от шоколада!"))
		M.vomit(20)
		M.losebreath += 20
		M.Paralyze(150)

/datum/reagent/drug/mushroomhallucinogen
	name = "Грибной Галлюциноген"
	description = "A strong hallucinogenic drug derived from certain species of mushroom."
	color = "#E700E7" // rgb: 231, 0, 231
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "грибы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 12)
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/drug/mushroomhallucinogen/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(!M.slurring)
		M.slurring = 1 * REM * delta_time
	switch(current_cycle)
		if(1 to 5)
			M.Dizzy(5 * REM * delta_time)
			M.set_drugginess(30 * REM * delta_time)
			if(DT_PROB(5, delta_time))
				M.emote(pick("twitch","giggle"))
		if(5 to 10)
			M.Jitter(10 * REM * delta_time)
			M.Dizzy(10 * REM * delta_time)
			M.set_drugginess(35 * REM * delta_time)
			if(DT_PROB(10, delta_time))
				M.emote(pick("twitch","giggle"))
		if (10 to INFINITY)
			M.Jitter(20 * REM * delta_time)
			M.Dizzy(20 * REM * delta_time)
			M.set_drugginess(40 * REM * delta_time)
			if(DT_PROB(16, delta_time))
				M.emote(pick("twitch","giggle"))
	..()

/datum/reagent/consumable/garlic //NOTE: having garlic in your blood stops vampires from biting you.
	name = "Чесночный Сок"
	description = "Crushed garlic. Chefs love it, but it can make you smell bad."
	color = "#FEFEFE"
	taste_description = "чеснок"
	metabolization_rate = 0.15 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/garlic/on_mob_add(mob/living/L, amount)
	. = ..()
	ADD_TRAIT(L, TRAIT_GARLIC_BREATH, type)

/datum/reagent/consumable/garlic/on_mob_delete(mob/living/L)
	. = ..()
	REMOVE_TRAIT(L, TRAIT_GARLIC_BREATH, type)

/datum/reagent/consumable/garlic/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_CULINARY_METABOLISM))
		if(DT_PROB(10, delta_time)) //stays in the system much longer than sprinkles/banana juice, so heals slower to partially compensate
			M.heal_bodypart_damage(brute = 1, burn = 1)
			. = TRUE
	..()

/datum/reagent/consumable/sprinkles
	name = "Посыпка"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	color = "#FF00FF" // rgb: 255, 0, 255
	taste_description = "каприз детства"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/sprinkles/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		M.heal_bodypart_damage(1 * REM * delta_time, 1 * REM * delta_time, 0)
		. = TRUE
	..()

/datum/reagent/consumable/cornoil
	name = "Кукурузное Масло"
	description = "An oil derived from various types of corn."
	nutriment_factor = 20 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "слайм"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/cornoil/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	exposed_turf.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = reac_volume*2 SECONDS)

/datum/reagent/consumable/enzyme
	name = "Универсальный Фермент"
	description = "A universal enzyme used in the preparation of certain chemicals and foods."
	color = "#365E30" // rgb: 54, 94, 48
	taste_description = "сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/dry_ramen
	name = "Сухой Рамен"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "сухая и дешевая лапша"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/hot_ramen
	name = "Горячий Рамен"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "сырая и дешевая лапша"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/nutraslop
	name = "Nutraslop"
	description = "Mixture of leftover prison foods served on previous days."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#3E4A00" // rgb: 62, 74, 0
	taste_description = "моё заключение"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/hot_ramen/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjust_bodytemperature(10 * 1.5 * REM * delta_time, 0, M.get_body_temp_normal())
	..()

/datum/reagent/consumable/hell_ramen
	name = "Адский Рамен"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "мокрая и дешевая лапша в огне"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/hell_ramen/on_mob_life(mob/living/carbon/target_mob, delta_time, times_fired)
	target_mob.adjust_bodytemperature(10 * 1.5 * REM * delta_time)
	..()

/datum/reagent/consumable/flour
	name = "Мука"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 0, 0, 0
	taste_description = "меловая пшеница"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/flour/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/food/flour/reagentdecal = new(exposed_turf)
	reagentdecal = locate() in exposed_turf //Might have merged with flour already there.
	if(reagentdecal)
		reagentdecal.reagents.add_reagent(/datum/reagent/consumable/flour, reac_volume)

/datum/reagent/consumable/cherryjelly
	name = "Вишневое Желе"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	color = "#801E28" // rgb: 128, 30, 40
	taste_description = "вишня"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/bluecherryjelly
	name = "Желе из Синей Вишни"
	description = "Blue and tastier kind of cherry jelly."
	color = "#00F0FF"
	taste_description = "синяя вишня"
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/rice
	name = "Рис"
	description = "tiny nutritious grains"
	reagent_state = SOLID
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#FFFFFF" // rgb: 0, 0, 0
	taste_description = "рис"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/vanilla
	name = "Ванильный Порошок"
	description = "A fatty, bitter paste made from vanilla pods."
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#FFFACD"
	taste_description = "ваниль"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/eggyolk
	name = "Яичный Желток"
	description = "It's full of protein."
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#FFB500"
	taste_description = "яйца"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/corn_starch
	name = "Кукурузный Крахмал"
	description = "A slippery solution."
	color = "#DBCE95"
	taste_description = "слайм"
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/corn_syrup
	name = "Кукурузный Сироп"
	description = "Decays into sugar."
	color = "#DBCE95"
	metabolization_rate = 3 * REAGENTS_METABOLISM
	taste_description = "сладкий слайм"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/corn_syrup/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	holder.add_reagent(/datum/reagent/consumable/sugar, 3 * REM * delta_time)
	..()

/datum/reagent/consumable/honey
	name = "Мёд"
	description = "Sweet sweet honey that decays into sugar. Has antibacterial and natural healing properties."
	color = "#d3a308"
	nutriment_factor = 15 * REAGENTS_METABOLISM
	metabolization_rate = 1 * REAGENTS_METABOLISM
	taste_description = "сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/honey/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	holder.add_reagent(/datum/reagent/consumable/sugar, 3 * REM * delta_time)
	if(DT_PROB(33, delta_time))
		M.adjustBruteLoss(-1, 0)
		M.adjustFireLoss(-1, 0)
		M.adjustOxyLoss(-1, 0)
		M.adjustToxLoss(-1, 0)
	..()

/datum/reagent/consumable/honey/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob) || !(methods & (TOUCH|VAPOR|PATCH)))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	for(var/s in exposed_carbon.surgeries)
		var/datum/surgery/surgery = s
		surgery.speed_modifier = max(0.6, surgery.speed_modifier)

/datum/reagent/consumable/mayonnaise
	name = "Майонез"
	description = "A white and oily mixture of mixed egg yolks."
	color = "#DFDFDF"
	taste_description = "майонез"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/mold // yeah, ok, togopal, I guess you could call that a condiment
	name = "Плесень"
	description = "This condiment will make any food break the mold. Or your stomach."
	color ="#708a88"
	taste_description = "прогорклый гриб"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/tearjuice
	name = "Слезный Сок"
	description = "A blinding substance extracted from certain onions."
	color = "#c0c9a0"
	taste_description = "горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/tearjuice/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & INGEST) || !((methods & (TOUCH|PATCH|VAPOR)) && (exposed_mob.is_mouth_covered() || exposed_mob.is_eyes_covered())))
		return

	if(!exposed_mob.getorganslot(ORGAN_SLOT_EYES))	//can't blind somebody with no eyes
		to_chat(exposed_mob, span_notice("Уголки глаз намокли."))
	else
		if(!exposed_mob.eye_blurry)
			to_chat(exposed_mob, span_warning("Слезы вытекают из моих глаз!"))
		exposed_mob.blind_eyes(2)
		exposed_mob.blur_eyes(5)

/datum/reagent/consumable/tearjuice/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	..()
	if(M.eye_blurry)	//Don't worsen vision if it was otherwise fine
		M.blur_eyes(4 * REM * delta_time)
		if(DT_PROB(5, delta_time))
			to_chat(M, span_warning("Глаза болят!"))
			M.blind_eyes(2)


/datum/reagent/consumable/nutriment/stabilized
	name = "Стабилизированное Питание"
	description = "A bioengineered protien-nutrient structure designed to decompose in high saturation. In layman's terms, it won't get you fat."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/nutriment/stabilized/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.nutrition > NUTRITION_LEVEL_FULL - 25)
		M.adjust_nutrition(-3 * REM * nutriment_factor * delta_time)
	..()

////Lavaland Flora Reagents////


/datum/reagent/consumable/entpoly
	name = "Энтропический Полипниум"
	description = "An ichor, derived from a certain mushroom, makes for a bad time."
	color = "#1d043d"
	taste_description = "горький гриб"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/entpoly/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle >= 10)
		M.Unconscious(40 * REM * delta_time, FALSE)
		. = TRUE
	if(DT_PROB(10, delta_time))
		M.losebreath += 4
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM, 150)
		M.adjustToxLoss(3*REM,0)
		M.adjustStaminaLoss(10*REM,0)
		M.blur_eyes(5)
		. = TRUE
	..()


/datum/reagent/consumable/tinlux
	name = "Светящийся Лишай"
	description = "A stimulating ichor which causes luminescent fungi to grow on the skin. "
	color = "#b5a213"
	taste_description = "покалывающий гриб"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	//Lazy list of mobs affected by the luminosity of this reagent.
	var/list/mobs_affected
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/tinlux/expose_mob(mob/living/exposed_mob)
	. = ..()
	add_reagent_light(exposed_mob)

/datum/reagent/consumable/tinlux/on_mob_end_metabolize(mob/living/M)
	remove_reagent_light(M)

/datum/reagent/consumable/tinlux/proc/on_living_holder_deletion(mob/living/source)
	SIGNAL_HANDLER
	remove_reagent_light(source)

/datum/reagent/consumable/tinlux/proc/add_reagent_light(mob/living/living_holder)
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj = living_holder.mob_light(2)
	LAZYSET(mobs_affected, living_holder, mob_light_obj)
	RegisterSignal(living_holder, COMSIG_PARENT_QDELETING, .proc/on_living_holder_deletion)

/datum/reagent/consumable/tinlux/proc/remove_reagent_light(mob/living/living_holder)
	UnregisterSignal(living_holder, COMSIG_PARENT_QDELETING)
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj = LAZYACCESS(mobs_affected, living_holder)
	LAZYREMOVE(mobs_affected, living_holder)
	if(mob_light_obj)
		qdel(mob_light_obj)


/datum/reagent/consumable/vitfro
	name = "Витриумная Пена"
	description = "A bubbly paste that heals wounds of the skin."
	color = "#d3a308"
	nutriment_factor = 3 * REAGENTS_METABOLISM
	taste_description = "фруктовый гриб"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/vitfro/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(55, delta_time))
		M.adjustBruteLoss(-1, 0)
		M.adjustFireLoss(-1, 0)
		. = TRUE
	..()

/datum/reagent/consumable/clownstears
	name = "Слезы Клоуна"
	description = "The sorrow and melancholy of a thousand bereaved clowns, forever denied their Honkmechs."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#eef442" // rgb: 238, 244, 66
	taste_description = "скорбный гудок"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW


/datum/reagent/consumable/liquidelectricity
	name = "Жидкое Электричество"
	description = "The blood of Ethereals, and the stuff that keeps them going. Great for them, horrid for anyone else."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#97ee63"
	taste_description = "чистое электричество"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/astrotame
	name = "Astrotame"
	description = "A space age artifical sweetener."
	nutriment_factor = 0
	metabolization_rate = 2 * REAGENTS_METABOLISM
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 8
	taste_description = "сладость"
	overdose_threshold = 17
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/astrotame/overdose_process(mob/living/carbon/M, delta_time, times_fired)
	if(M.disgust < 80)
		M.adjust_disgust(10 * REM * delta_time)
	..()
	. = TRUE

/datum/reagent/consumable/secretsauce
	name = "Тайный Соус"
	description = "What could it be?"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300"
	taste_description = "... неописуемо"
	quality = FOOD_AMAZING
	taste_mult = 100
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/nutriment/peptides
	name = "Пептиды"
	color = "#BBD4D9"
	taste_description = "мятная глазурь"
	description = "These restorative peptides not only speed up wound healing, but are nutritious as well!"
	nutriment_factor = 10 * REAGENTS_METABOLISM // 33% less than nutriment to reduce weight gain
	brute_heal = 3
	burn_heal = 1
	inverse_chem = /datum/reagent/peptides_failed//should be impossible, but it's so it appears in the chemical lookup gui
	inverse_chem_val = 0.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/caramel
	name = "Карамель"
	description = "Who would have guessed that heated sugar could be so delicious?"
	nutriment_factor = 10 * REAGENTS_METABOLISM
	color = "#D98736"
	taste_mult = 2
	taste_description = "карамель"
	reagent_state = SOLID
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/char
	name = "Уголь"
	description = "Essence of the grill. Has strange properties when overdosed."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#C8C8C8"
	taste_mult = 6
	taste_description = "дым"
	overdose_threshold = 15
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/char/overdose_process(mob/living/M, delta_time, times_fired)
	if(DT_PROB(13, delta_time))
		M.say(pick_list_replacements(BOOMER_FILE, "boomer"), forced = /datum/reagent/consumable/char)
	..()
	return

/datum/reagent/consumable/bbqsauce
	name = "Соус Барбекю"
	description = "Sweet, smoky, savory, and gets everywhere. Perfect for grilling."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#78280A" // rgb: 120 40, 10
	taste_mult = 2.5 //sugar's 1.5, capsacin's 1.5, so a good middle ground.
	taste_description = "дымчатая сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/consumable/chocolatepudding
	name = "Шоколадный Пудинг"
	description = "A great dessert for chocolate lovers."
	color = "#800000"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "сладкий шоколад"
	glass_icon_state = "chocolatepudding"
	glass_name = "chocolate pudding"
	glass_desc = "Tasty."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/vanillapudding
	name = "Ванильный Пудинг"
	description = "A great dessert for vanilla lovers."
	color = "#FAFAD2"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "сладкая ваниль"
	glass_icon_state = "vanillapudding"
	glass_name = "vanilla pudding"
	glass_desc = "Tasty."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/laughsyrup
	name = "Сироп Хохотача"
	description = "The product of juicing Laughin' Peas. Fizzy, and seems to change flavour based on what it's used with!"
	color = "#803280"
	nutriment_factor = 5 * REAGENTS_METABOLISM
	taste_mult = 2
	taste_description = "fizzy sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/gravy
	name = "Подлива"
	description = "A mixture of flour, water, and the juices of cooked meat."
	taste_description = "gravy"
	color = "#623301"
	taste_mult = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/pancakebatter
	name = "блинное тесто"
	description = "A very milky batter. 5 units of this on the griddle makes a mean pancake."
	taste_description = "milky batter"
	color = "#fccc98"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/consumable/cornmeal
	name = "Cornmeal"
	description = "Ground cornmeal, for making corn related things."
	taste_description = "raw cornmeal"
	color = "#ebca85"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/yoghurt
	name = "Йогурт"
	description = "Creamy natural yoghurt, with applications in both food and drinks."
	taste_description = "йогурт"
	color = "#efeff0"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/cornmeal_batter
	name = "Cornmeal Batter"
	description = "An eggy, milky, corny mixture that's not very good raw."
	taste_description = "raw batter"
	color = "#ebca85"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/peanut_butter
	name = "Peanut Butter"
	description = "A rich, creamy spread produced by grinding peanuts."
	taste_description = "peanuts"
	color = "#D9A066"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/vinegar
	name = "Vinegar"
	description = "Useful for pickling, or putting on chips."
	taste_description = "acid"
	color = "#661F1E"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//A better oil, representing choices like olive oil, argan oil, avocado oil, etc.
/datum/reagent/consumable/quality_oil
	name = "Quality Oil"
	description = "A high quality oil, suitable for dishes where the oil is a key flavour."
	taste_description = "olive oil"
	color = "#DBCF5C"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
