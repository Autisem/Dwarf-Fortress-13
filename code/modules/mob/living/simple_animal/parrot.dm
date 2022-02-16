/* Parrots!
 * Contains
 * 		Defines
 *		Inventory (headset stuff)
 *		Attack responces
 *		AI
 *		Procs / Verbs (usable by players)
 *		Sub-types
 *		Hear & say (the things we do for gimmicks)
 */

/*
 * Defines
 */

//Only a maximum of one action and one intent should be active at any given time.
//Actions
#define PARROT_PERCH	(1<<0)	//Sitting/sleeping, not moving
#define PARROT_SWOOP	(1<<1)	//Moving towards or away from a target
#define PARROT_WANDER	(1<<2)	//Moving without a specific target in mind

//Intents
#define PARROT_STEAL	(1<<3)	//Flying towards a target to steal it/from it
#define PARROT_ATTACK	(1<<4)	//Flying towards a target to attack it
#define PARROT_RETURN	(1<<5)	//Flying towards its perch
#define PARROT_FLEE		(1<<6)	//Flying away from its attacker


/mob/living/simple_animal/parrot
	name = "попугай"
	desc = "The parrot squawks, \"It's a Parrot! BAWWK!\"" //'
	icon = 'icons/mob/animal.dmi'
	icon_state = "parrot_fly"
	icon_living = "parrot_fly"
	icon_dead = "parrot_dead"
	var/icon_sit = "parrot_sit"
	density = FALSE
	health = 80
	maxHealth = 80
	pass_flags = PASSTABLE | PASSMOB

	speak = list("Привет!","Здарова!","Крекер?","Кудах! Джордж Меллонс гриферит меня!")
	speak_emote = list("кудахчет","говорит","вскрикивает")
	emote_hear = list("кудахчет.","вопит!")
	emote_see = list("flutters its wings.")

	speak_chance = 1 //1% (1 in 100) chance every tick; So about once per 150 seconds, assuming an average tick is 1.5s
	turns_per_move = 5
	butcher_results = list(/obj/item/food/cracker = 1)
	melee_damage_upper = 10
	melee_damage_lower = 5

	response_help_continuous = "поглаживает"
	response_help_simple = "гладит"
	response_disarm_continuous = "отталкивает чуть дальше"
	response_disarm_simple = "осторожно отталкивает"
	response_harm_continuous = "забивает"
	response_harm_simple = "бьёт"
	stop_automated_movement = 1
	a_intent = INTENT_HARM //parrots now start "aggressive" since only player parrots will nuzzle.
	attack_verb_continuous = "грызёт"
	attack_verb_simple = "кусает"
	attack_vis_effect = ATTACK_EFFECT_BITE
	friendly_verb_continuous = "ворсится"
	friendly_verb_simple = "ворсится"
	mob_size = MOB_SIZE_SMALL
	gold_core_spawnable = FRIENDLY_SPAWN

	var/parrot_damage_upper = 10
	var/parrot_state = PARROT_WANDER //Hunt for a perch when created
	var/parrot_sleep_max = 25 //The time the parrot sits while perched before looking around. Mosly a way to avoid the parrot's AI in life() being run every single tick.
	var/parrot_sleep_dur = 25 //Same as above, this is the var that physically counts down
	var/parrot_dam_zone = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG) //For humans, select a bodypart to attack

	var/parrot_speed = 5 //"Delay in world ticks between movement." according to byond. Yeah, that's BS but it does directly affect movement. Higher number = slower.
	var/parrot_lastmove = null //Updates/Stores position of the parrot while it's moving
	var/parrot_stuck = 0	//If parrot_lastmove hasn't changed, this will increment until it reaches parrot_stuck_threshold
	var/parrot_stuck_threshold = 10 //if this == parrot_stuck, it'll force the parrot back to wandering

	var/list/speech_buffer = list()
	var/speech_shuffle_rate = 20
	var/list/available_channels = list()

	//Headset for Poly to yell at engineers :)
	var/obj/item/radio/headset/ears = null

	//The thing the parrot is currently interested in. This gets used for items the parrot wants to pick up, mobs it wants to steal from,
	//mobs it wants to attack or mobs that have attacked it
	var/atom/movable/parrot_interest = null

	//Parrots will generally sit on their perch unless something catches their eye.
	//These vars store their preffered perch and if they dont have one, what they can use as a perch
	var/obj/parrot_perch = null
	var/obj/desired_perches = list(/obj/structure/filingcabinet,
		/obj/machinery/smartfridge,
	)

	//Parrots are kleptomaniacs. This variable ... stores the item a parrot is holding.
	var/obj/item/held_item = null


/mob/living/simple_animal/parrot/Initialize()
	. = ..()
	parrot_sleep_dur = parrot_sleep_max //In case someone decides to change the max without changing the duration var

	add_verb(src, list(/mob/living/simple_animal/parrot/proc/steal_from_ground, \
			  /mob/living/simple_animal/parrot/proc/steal_from_mob, \
			  /mob/living/simple_animal/parrot/verb/drop_held_item_player, \
			  /mob/living/simple_animal/parrot/proc/perch_player, \
			  /mob/living/simple_animal/parrot/proc/toggle_mode,
			  /mob/living/simple_animal/parrot/proc/perch_mob_player))

	AddElement(/datum/element/simple_flying)

/mob/living/simple_animal/parrot/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(stat)
		. += pick("This parrot is no more.", "This is a late parrot.", "This is an ex-parrot.")

/mob/living/simple_animal/parrot/death(gibbed)
	if(held_item)
		held_item.forceMove(drop_location())
		held_item = null
	walk(src,0)

	if(buckled)
		buckled.unbuckle_mob(src,force=1)
	buckled = null
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y

	return ..()


/mob/living/simple_animal/parrot/get_status_tab_items()
	. = ..()
	. += ""
	. += "Held Item: [held_item]"
	. += "Mode: [a_intent]"

/mob/living/simple_animal/parrot/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()
	if(speaker != src && prob(50)) //Dont imitate ourselves
		if(!radio_freq || prob(10))
			if(speech_buffer.len >= 500)
				speech_buffer -= pick(speech_buffer)
			speech_buffer |= raw_message
	if(speaker == src && !client) //If a parrot squawks in the woods and no one is around to hear it, does it make a sound? This code says yes!
		return message

/*
 * Attack responces
 */
//Humans, monkeys, aliens
/mob/living/simple_animal/parrot/attack_hand(mob/living/carbon/M)
	..()
	if(client)
		return
	if(!stat && M.a_intent == INTENT_HARM)

		icon_state = icon_living //It is going to be flying regardless of whether it flees or attacks

		if(parrot_state == PARROT_PERCH)
			parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched

		parrot_interest = M
		parrot_state = PARROT_SWOOP //The parrot just got hit, it WILL move, now to pick a direction..

		if(health > 30) //Let's get in there and squawk it up!
			parrot_state |= PARROT_ATTACK
		else
			parrot_state |= PARROT_FLEE		//Otherwise, fly like a bat out of hell!
			drop_held_item(0)
	if(stat != DEAD && M.a_intent == INTENT_HELP)
		handle_automated_speech(1) //assured speak/emote
	return

/mob/living/simple_animal/parrot/attack_paw(mob/living/carbon/human/M)
	return attack_hand(M)

//Simple animals
/mob/living/simple_animal/parrot/attack_animal(mob/living/simple_animal/M)
	. = ..() //goodbye immortal parrots

	if(client)
		return

	if(parrot_state == PARROT_PERCH)
		parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched

	if(M.melee_damage_upper > 0 && !stat)
		parrot_interest = M
		parrot_state = PARROT_SWOOP | PARROT_ATTACK //Attack other animals regardless
		icon_state = icon_living

//Mobs with objects
/mob/living/simple_animal/parrot/attackby(obj/item/O, mob/living/user, params)
	if(!stat && !client && !istype(O, /obj/item/stack/medical) && !istype(O, /obj/item/food/cracker))
		if(O.force)
			if(parrot_state == PARROT_PERCH)
				parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched

			parrot_interest = user
			parrot_state = PARROT_SWOOP
			if(health > 30) //Let's get in there and squawk it up!
				parrot_state |= PARROT_ATTACK
			else
				parrot_state |= PARROT_FLEE
			icon_state = icon_living
			drop_held_item(0)
	else if(istype(O, /obj/item/food/cracker)) //Poly wants a cracker.
		qdel(O)
		if(health < maxHealth)
			adjustBruteLoss(-10)
		speak_chance *= 1.27 // 20 crackers to go from 1% to 100%
		speech_shuffle_rate += 10
		to_chat(user, span_notice("[capitalize(src.name)] eagerly devours the cracker."))
	..()
	return

//Bullets
/mob/living/simple_animal/parrot/bullet_act(obj/projectile/Proj)
	. = ..()
	if(!stat && !client)
		if(parrot_state == PARROT_PERCH)
			parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched

		parrot_interest = null
		parrot_state = PARROT_WANDER | PARROT_FLEE //Been shot and survived! RUN LIKE HELL!
		//parrot_been_shot += 5
		icon_state = icon_living
		drop_held_item(0)

/*
 * AI - Not really intelligent, but I'm calling it AI anyway.
 */
/mob/living/simple_animal/parrot/Life(delta_time = SSMOBS_DT, times_fired)
	..()

	//Sprite update for when a parrot gets pulled
	if(pulledby && !stat && parrot_state != PARROT_WANDER)
		if(buckled)
			buckled.unbuckle_mob(src, TRUE)
			buckled = null
		icon_state = icon_living
		parrot_state = PARROT_WANDER
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)
		return


//-----SPEECH
	/* Parrot speech mimickry!
	   Phrases that the parrot Hear()s get added to speach_buffer.
	   Every once in a while, the parrot picks one of the lines from the buffer and replaces an element of the 'speech' list. */
/mob/living/simple_animal/parrot/handle_automated_speech()
	..()
	if(speech_buffer.len && prob(speech_shuffle_rate)) //shuffle out a phrase and add in a new one
		if(speak.len)
			speak.Remove(pick(speak))

		speak.Add(pick(speech_buffer))


/mob/living/simple_animal/parrot/handle_automated_movement()
	if(!isturf(src.loc) || !(mobility_flags & MOBILITY_MOVE) || buckled)
		return //If it can't move, dont let it move. (The buckled check probably isn't necessary thanks to canmove)

	if(client && stat == CONSCIOUS && parrot_state != icon_living)
		icon_state = icon_living

//-----SLEEPING
	if(parrot_state == PARROT_PERCH)
		if(parrot_perch && parrot_perch.loc != src.loc) //Make sure someone hasn't moved our perch on us
			if(parrot_perch in view(src))
				parrot_state = PARROT_SWOOP | PARROT_RETURN
				icon_state = icon_living
				return
			else
				parrot_state = PARROT_WANDER
				icon_state = icon_living
				return

		if(--parrot_sleep_dur) //Zzz
			return

		else
			//This way we only call the stuff below once every [sleep_max] ticks.
			parrot_sleep_dur = parrot_sleep_max

			//Cycle through message modes for the headset
			if(speak.len)
				var/list/newspeak = list()

				for(var/possible_phrase in speak)
					if((possible_phrase[1] in GLOB.department_radio_prefixes) && (copytext_char(possible_phrase, 2, 3) in GLOB.department_radio_keys))
						possible_phrase = copytext_char(possible_phrase, 3) //crop out the channel prefix
					newspeak.Add(possible_phrase)
				speak = newspeak

			//Search for item to steal
			parrot_interest = search_for_item()
			if(parrot_interest)
				manual_emote("looks in [parrot_interest] direction and takes flight.")
				parrot_state = PARROT_SWOOP | PARROT_STEAL
				icon_state = icon_living
			return

//-----WANDERING - This is basically a 'I dont know what to do yet' state
	else if(parrot_state == PARROT_WANDER)
		//Stop movement, we'll set it later
		walk(src, 0)
		parrot_interest = null

		//Wander around aimlessly. This will help keep the loops from searches down
		//and possibly move the mob into a new are in view of something they can use
		if(prob(90))
			step(src, pick(GLOB.cardinals))
			return

		if(!held_item && !parrot_perch) //If we've got nothing to do.. look for something to do.
			var/atom/movable/AM = search_for_perch_and_item() //This handles checking through lists so we know it's either a perch or stealable item
			if(AM)
				if(istype(AM, /obj/item) || isliving(AM))	//If stealable item
					parrot_interest = AM
					manual_emote("turns and flies towards [parrot_interest].")
					parrot_state = PARROT_SWOOP | PARROT_STEAL
					return
				else	//Else it's a perch
					parrot_perch = AM
					parrot_state = PARROT_SWOOP | PARROT_RETURN
					return
			return

		if(parrot_interest && (parrot_interest in view(src)))
			parrot_state = PARROT_SWOOP | PARROT_STEAL
			return

		if(parrot_perch && (parrot_perch in view(src)))
			parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		else //Have an item but no perch? Find one!
			parrot_perch = search_for_perch()
			if(parrot_perch)
				parrot_state = PARROT_SWOOP | PARROT_RETURN
				return
//-----STEALING
	else if(parrot_state == (PARROT_SWOOP | PARROT_STEAL))
		walk(src,0)
		if(!parrot_interest || held_item)
			parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		if(!(parrot_interest in view(src)))
			parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		if(Adjacent(parrot_interest))

			if(isliving(parrot_interest))
				steal_from_mob()

			else //This should ensure that we only grab the item we want, and make sure it's not already collected on our perch
				if(!parrot_perch || parrot_interest.loc != parrot_perch.loc)
					held_item = parrot_interest
					parrot_interest.forceMove(src)
					visible_message(span_notice("[capitalize(src.name)] grabs [held_item]!") , span_notice("You grab [held_item]!") , span_hear("You hear the sounds of wings flapping furiously."))

			parrot_interest = null
			parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		walk_to(src, parrot_interest, 1, parrot_speed)
		if(isStuck())
			return

		return

//-----RETURNING TO PERCH
	else if(parrot_state == (PARROT_SWOOP | PARROT_RETURN))
		walk(src, 0)
		if(!parrot_perch || !isturf(parrot_perch.loc)) //Make sure the perch exists and somehow isn't inside of something else.
			parrot_perch = null
			parrot_state = PARROT_WANDER
			return

		if(Adjacent(parrot_perch))
			forceMove(parrot_perch.loc)
			drop_held_item()
			parrot_state = PARROT_PERCH
			icon_state = icon_sit
			return

		walk_to(src, parrot_perch, 1, parrot_speed)
		if(isStuck())
			return

		return

//-----FLEEING
	else if(parrot_state == (PARROT_SWOOP | PARROT_FLEE))
		walk(src,0)
		if(!parrot_interest || !isliving(parrot_interest)) //Sanity
			parrot_state = PARROT_WANDER

		walk_away(src, parrot_interest, 1, parrot_speed)
		if(isStuck())
			return

		return

//-----ATTACKING
	else if(parrot_state == (PARROT_SWOOP | PARROT_ATTACK))

		//If we're attacking a nothing, an object, a turf or a ghost for some stupid reason, switch to wander
		if(!parrot_interest || !isliving(parrot_interest))
			parrot_interest = null
			parrot_state = PARROT_WANDER
			return

		var/mob/living/L = parrot_interest
		if(melee_damage_upper == 0)
			melee_damage_upper = parrot_damage_upper
			a_intent = INTENT_HARM

		//If the mob is close enough to interact with
		if(Adjacent(parrot_interest))

			//If the mob we've been chasing/attacking dies or falls into crit, check for loot!
			if(L.stat)
				parrot_interest = null
				if(!held_item)
					held_item = steal_from_ground()
					if(!held_item)
						held_item = steal_from_mob() //Apparently it's possible for dead mobs to hang onto items in certain circumstances.
				if(parrot_perch in view(src)) //If we have a home nearby, go to it, otherwise find a new home
					parrot_state = PARROT_SWOOP | PARROT_RETURN
				else
					parrot_state = PARROT_WANDER
				return

			attack_verb_continuous = pick("claws at", "chomps")
			attack_verb_simple = pick("claw at", "chomp")
			L.attack_animal(src)//Time for the hurt to begin!
		//Otherwise, fly towards the mob!
		else
			walk_to(src, parrot_interest, 1, parrot_speed)
			if(isStuck())
				return

		return
//-----STATE MISHAP
	else //This should not happen. If it does lets reset everything and try again
		walk(src,0)
		parrot_interest = null
		parrot_perch = null
		drop_held_item()
		parrot_state = PARROT_WANDER
		return

/*
 * Procs
 */

/mob/living/simple_animal/parrot/proc/isStuck()
	//Check to see if the parrot is stuck due to things like windows or doors or windowdoors
	if(parrot_lastmove)
		if(parrot_lastmove == src.loc)
			if(parrot_stuck_threshold >= ++parrot_stuck) //If it has been stuck for a while, go back to wander.
				parrot_state = PARROT_WANDER
				parrot_stuck = 0
				parrot_lastmove = null
				return TRUE
		else
			parrot_lastmove = null
	else
		parrot_lastmove = src.loc
	return FALSE

/mob/living/simple_animal/parrot/proc/search_for_item()
	var/item
	for(var/atom/movable/AM in view(src))
		//Skip items we already stole or are wearing or are too big
		if(parrot_perch && AM.loc == parrot_perch.loc || AM.loc == src)
			continue
		if(istype(AM, /obj/item))
			var/obj/item/I = AM
			if(I.w_class < WEIGHT_CLASS_SMALL)
				item = I
		else if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			for(var/obj/item/I in C.held_items)
				if(I.w_class <= WEIGHT_CLASS_SMALL)
					item = I
					break
		if(item)
			if(!get_path_to(src, item))
				item = null
				continue
			return item

/mob/living/simple_animal/parrot/proc/search_for_perch()
	for(var/obj/O in view(src))
		for(var/path in desired_perches)
			if(istype(O, path))
				return O
	return null

//This proc was made to save on doing two 'in view' loops seperatly
/mob/living/simple_animal/parrot/proc/search_for_perch_and_item()
	for(var/atom/movable/AM in view(src))
		for(var/perch_path in desired_perches)
			if(istype(AM, perch_path))
				return AM

		//Skip items we already stole or are wearing or are too big
		if(parrot_perch && AM.loc == parrot_perch.loc || AM.loc == src)
			continue

		if(istype(AM, /obj/item))
			var/obj/item/I = AM
			if(I.w_class <= WEIGHT_CLASS_SMALL)
				return I

		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			for(var/obj/item/I in C.held_items)
				if(I.w_class <= WEIGHT_CLASS_SMALL)
					return C
	return null


/*
 * Verbs - These are actually procs, but can be used as verbs by player-controlled parrots.
 */
/mob/living/simple_animal/parrot/proc/steal_from_ground()
	set name = "Steal from ground"
	set category = "Parrot"
	set desc = "Grabs a nearby item."

	if(stat)
		return -1

	if(held_item)
		to_chat(src, span_warning("You are already holding [held_item]!"))
		return 1

	for(var/obj/item/I in view(1,src))
		//Make sure we're not already holding it and it's small enough
		if(I.loc != src && I.w_class <= WEIGHT_CLASS_SMALL)

			//If we have a perch and the item is sitting on it, continue
			if(!client && parrot_perch && I.loc == parrot_perch.loc)
				continue

			held_item = I
			I.forceMove(src)
			visible_message(span_notice("[capitalize(src.name)] grabs [held_item]!") , span_notice("You grab [held_item]!") , span_hear("You hear the sounds of wings flapping furiously."))
			return held_item

	to_chat(src, span_warning("There is nothing of interest to take!"))
	return 0

/mob/living/simple_animal/parrot/proc/steal_from_mob()
	set name = "Steal from mob"
	set category = "Parrot"
	set desc = "Steals an item right out of a person's hand!"

	if(stat)
		return -1

	if(held_item)
		to_chat(src, span_warning("You are already holding [held_item]!"))
		return 1

	var/obj/item/stolen_item = null

	for(var/mob/living/carbon/C in view(1,src))
		for(var/obj/item/I in C.held_items)
			if(I.w_class <= WEIGHT_CLASS_SMALL)
				stolen_item = I
				break

		if(stolen_item)
			C.transferItemToLoc(stolen_item, src, TRUE)
			held_item = stolen_item
			visible_message(span_notice("[capitalize(src.name)] grabs [held_item] out of [C] hand!") , span_notice("You snag [held_item] out of [C] hand!") , span_hear("You hear the sounds of wings flapping furiously."))
			return held_item

	to_chat(src, span_warning("There is nothing of interest to take!"))
	return 0

/mob/living/simple_animal/parrot/verb/drop_held_item_player()
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return

	src.drop_held_item()

	return

/mob/living/simple_animal/parrot/proc/drop_held_item(drop_gently = 1)
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return -1

	if(!held_item)
		if(src == usr) //So that other mobs won't make this message appear when they're bludgeoning you.
			to_chat(src, span_warning("You have nothing to drop!"))
		return 0


//parrots will eat crackers instead of dropping them
	if(istype(held_item, /obj/item/food/cracker) && (drop_gently))
		qdel(held_item)
		held_item = null
		if(health < maxHealth)
			adjustBruteLoss(-10)
		manual_emote("[src] eagerly downs the cracker.")
		return 1

	to_chat(src, span_notice("You drop [held_item]."))

	held_item.forceMove(drop_location())
	held_item = null
	return 1

/mob/living/simple_animal/parrot/proc/perch_player()
	set name = "Sit"
	set category = "Parrot"
	set desc = "Sit on a nice comfy perch."

	if(stat || !client)
		return

	if(icon_state == icon_living)
		for(var/atom/movable/AM in view(src,1))
			for(var/perch_path in desired_perches)
				if(istype(AM, perch_path))
					src.forceMove(AM.loc)
					icon_state = icon_sit
					parrot_state = PARROT_PERCH
					return
	to_chat(src, span_warning("There is no perch nearby to sit on!"))
	return

/mob/living/simple_animal/parrot/Moved(oldLoc, dir)
	. = ..()
	if(. && !stat && client && parrot_state == PARROT_PERCH)
		parrot_state = PARROT_WANDER
		icon_state = icon_living
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)

/mob/living/simple_animal/parrot/proc/perch_mob_player()
	set name = "Sit on Human's Shoulder"
	set category = "Parrot"
	set desc = "Sit on a nice comfy human being!"

	if(stat || !client)
		return

	if(!buckled)
		for(var/mob/living/carbon/human/H in view(src,1))
			if(H.has_buckled_mobs() && H.buckled_mobs.len >= H.max_buckled_mobs) //Already has a parrot, or is being eaten by a slime
				continue
			perch_on_human(H)
			return
		to_chat(src, span_warning("There is nobody nearby that you can sit on!"))
	else
		icon_state = icon_living
		parrot_state = PARROT_WANDER
		if(buckled)
			to_chat(src, span_notice("You are no longer sitting on [buckled] shoulder."))
			buckled.unbuckle_mob(src, TRUE)
		buckled = null
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)



/mob/living/simple_animal/parrot/proc/perch_on_human(mob/living/carbon/human/H)
	if(!H)
		return
	forceMove(get_turf(H))
	if(H.buckle_mob(src, TRUE))
		pixel_y = 9
		pixel_x = pick(-8,8) //pick left or right shoulder
		icon_state = icon_sit
		parrot_state = PARROT_PERCH
		to_chat(src, span_notice("You sit on [H] shoulder."))


/mob/living/simple_animal/parrot/proc/toggle_mode()
	set name = "Toggle mode"
	set category = "Parrot"
	set desc = "Time to bear those claws!"

	if(stat || !client)
		return

	if(a_intent != INTENT_HELP)
		melee_damage_upper = 0
		a_intent = INTENT_HELP
	else
		melee_damage_upper = parrot_damage_upper
		a_intent = INTENT_HARM
	to_chat(src, span_notice("You will now [a_intent] others."))
	return

/*
 * Sub-types
 */
/mob/living/simple_animal/parrot/poly
	name = "Поли"
	desc = "Попугайчик по имени Поли. An expert on quantum cracker theory."
	speak = list("Poly wanna cracker!", ":e Check the crystal, you chucklefucks!",":e Wire the solars, you lazy bums!",":e WHO TOOK THE DAMN HARDSUITS?",":e OH GOD ITS ABOUT TO DELAMINATE CALL THE SHUTTLE")
	gold_core_spawnable = NO_SPAWN
	speak_chance = 3
	var/memory_saved = FALSE
	var/rounds_survived = 0
	var/longest_survival = 0
	var/longest_deathstreak = 0

/mob/living/simple_animal/parrot/poly/Initialize()
	available_channels = list(":e")
	Read_Memory()
	if(rounds_survived == longest_survival)
		speak += pick("...[longest_survival].", "The things I've seen!", "I have lived many lives!", "What are you before me?")
		desc += " Old as sin, and just as loud. Claimed to be [rounds_survived]."
		speak_chance = 20 //His hubris has made him more annoying/easier to justify killing
		add_atom_colour("#EEEE22", FIXED_COLOUR_PRIORITY)
	else if(rounds_survived == longest_deathstreak)
		speak += pick("What are you waiting for!", "Violence breeds violence!", "Blood! Blood!", "Strike me down if you dare!")
		desc += " The squawks of [-rounds_survived] dead parrots ring out in your ears..."
		add_atom_colour("#BB7777", FIXED_COLOUR_PRIORITY)
	else if(rounds_survived > 0)
		speak += pick("...again?", "No, It was over!", "Let me out!", "It never ends!")
		desc += " Over [rounds_survived] shifts without a \"terrible\" \"accident\"!"
	else
		speak += pick("...alive?", "This isn't parrot heaven!", "I live, I die, I live again!", "The void fades!")

	. = ..()

/mob/living/simple_animal/parrot/poly/Life(delta_time = SSMOBS_DT, times_fired)
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory(FALSE)
		memory_saved = TRUE
	..()

/mob/living/simple_animal/parrot/poly/death(gibbed)
	if(!memory_saved)
		Write_Memory(TRUE)
	if(rounds_survived == longest_survival || rounds_survived == longest_deathstreak || prob(0.666))
		var/mob/living/simple_animal/parrot/poly/ghost/G = new(loc)
		if(mind)
			mind.transfer_to(G)
		else
			G.key = key
	..(gibbed)

/mob/living/simple_animal/parrot/poly/proc/Read_Memory()
	if(fexists("data/npc_saves/Poly.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Poly.sav")
		S["phrases"] 			>> speech_buffer
		S["roundssurvived"]		>> rounds_survived
		S["longestsurvival"]	>> longest_survival
		S["longestdeathstreak"] >> longest_deathstreak
		fdel("data/npc_saves/Poly.sav")
	else
		var/json_file = file("data/npc_saves/Poly.json")
		if(!fexists(json_file))
			return
		var/list/json = r_json_decode(file2text(json_file))
		speech_buffer = json["phrases"]
		rounds_survived = json["roundssurvived"]
		longest_survival = json["longestsurvival"]
		longest_deathstreak = json["longestdeathstreak"]
	if(!islist(speech_buffer))
		speech_buffer = list()

/mob/living/simple_animal/parrot/poly/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Poly.json")
	var/list/file_data = list()
	if(islist(speech_buffer))
		file_data["phrases"] = speech_buffer
	if(dead)
		file_data["roundssurvived"] = min(rounds_survived - 1, 0)
		file_data["longestsurvival"] = longest_survival
		if(rounds_survived - 1 < longest_deathstreak)
			file_data["longestdeathstreak"] = rounds_survived - 1
		else
			file_data["longestdeathstreak"] = longest_deathstreak
	else
		file_data["roundssurvived"] = rounds_survived + 1
		if(rounds_survived + 1 > longest_survival)
			file_data["longestsurvival"] = rounds_survived + 1
		else
			file_data["longestsurvival"] = longest_survival
		file_data["longestdeathstreak"] = longest_deathstreak
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/parrot/poly/ghost
	name = "Призрак Поли"
	desc = "Doomed to squawk the Earth."
	color = "#FFFFFF77"
	speak_chance = 20
	status_flags = GODMODE
	incorporeal_move = INCORPOREAL_MOVE_BASIC

/mob/living/simple_animal/parrot/poly/ghost/Initialize()
	memory_saved = TRUE //At this point nothing is saved
	. = ..()

/mob/living/simple_animal/parrot/poly/ghost/handle_automated_speech()
	if(ismob(loc))
		return
	..()

/mob/living/simple_animal/parrot/poly/ghost/handle_automated_movement()
	if(isliving(parrot_interest))
		if(!ishuman(parrot_interest))
			parrot_interest = null
		else if(parrot_state == (PARROT_SWOOP | PARROT_ATTACK) && Adjacent(parrot_interest))
			walk_to(src, parrot_interest, 0, parrot_speed)
			Possess(parrot_interest)
	..()

/mob/living/simple_animal/parrot/poly/ghost/proc/Possess(mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	var/datum/disease/parrot_possession/P = new
	P.parrot = src
	forceMove(H)
	H.ForceContractDisease(P, FALSE)
	parrot_interest = null
	H.visible_message(span_danger("[capitalize(src.name)] dive bombs into [H] chest and vanishes!") , span_userdanger("[capitalize(src.name)] dive bombs into your chest, vanishing! This can't be good!"))
