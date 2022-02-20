#define HAL_LINES_FILE "hallucination.json"

GLOBAL_LIST_INIT(hallucination_list, list(
	/datum/hallucination/chat = 100,
	/datum/hallucination/message = 60,
	/datum/hallucination/sounds = 50,
	/datum/hallucination/battle = 20,
	/datum/hallucination/dangerflash = 15,
	/datum/hallucination/hudscrew = 12,
	/datum/hallucination/fake_health_doll = 12,
	/datum/hallucination/fake_alert = 12,
	/datum/hallucination/weird_sounds = 8,
	/datum/hallucination/stray_bullet = 7,
	/datum/hallucination/items_other = 7,
	/datum/hallucination/husks = 7,
	/datum/hallucination/items = 4,
	/datum/hallucination/fire = 3,
	/datum/hallucination/self_delusion = 2,
	/datum/hallucination/delusion = 2,
	/datum/hallucination/shock = 1,
	/datum/hallucination/death = 1,
	/datum/hallucination/oh_yeah = 1
	))


/mob/living/carbon/proc/handle_hallucinations(delta_time, times_fired)
	if(!hallucination)
		return

	hallucination = max(hallucination - (0.5 * delta_time), 0)
	if(world.time < next_hallucination)
		return

	var/halpick = pickweight(GLOB.hallucination_list)
	new halpick(src, FALSE)

	next_hallucination = world.time + rand(100, 600)

/mob/living/carbon/proc/set_screwyhud(hud_type)
	hal_screwyhud = hud_type
	update_health_hud()

/datum/hallucination
	var/natural = TRUE
	var/mob/living/carbon/target
	var/feedback_details //extra info for investigate

/datum/hallucination/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	target = C
	natural = !forced

	// Cancel early if the target is deleted
	RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/target_deleting)

/datum/hallucination/proc/target_deleting()
	SIGNAL_HANDLER

	qdel(src)

/datum/hallucination/proc/wake_and_restore()
	target.set_screwyhud(SCREWYHUD_NONE)
	target.SetSleeping(0)

/datum/hallucination/Destroy()
	target.investigate_log("was afflicted with a hallucination of type [type] by [natural?"hallucination status":"an external source"]. [feedback_details]", INVESTIGATE_HALLUCINATIONS)

	if (target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)

	target = null
	return ..()

//Returns a random turf in a ring around the target mob, useful for sound hallucinations
/datum/hallucination/proc/random_far_turf()
	var/x_based = prob(50)
	var/first_offset = pick(-8,-7,-6,-5,5,6,7,8)
	var/second_offset = rand(-8,8)
	var/x_off
	var/y_off
	if(x_based)
		x_off = first_offset
		y_off = second_offset
	else
		y_off = first_offset
		x_off = second_offset
	var/turf/T = locate(target.x + x_off, target.y + y_off, target.z)
	return T

/obj/effect/hallucination
	invisibility = INVISIBILITY_OBSERVER
	anchored = TRUE
	var/mob/living/carbon/target = null

/obj/effect/hallucination/simple
	var/image_icon = 'icons/mob/alien.dmi'
	var/image_state = "alienh_pounce"
	var/px = 0
	var/py = 0
	var/col_mod = null
	var/image/current_image = null
	var/image_layer = MOB_LAYER
	var/active = TRUE //qdelery

/obj/effect/hallucination/simple/Initialize(mapload, mob/living/carbon/T)
	. = ..()
	target = T
	current_image = GetImage()
	if(target?.client)
		target.client.images |= current_image

/obj/effect/hallucination/simple/proc/GetImage()
	var/image/I = image(image_icon,src,image_state,image_layer,dir=src.dir)
	I.pixel_x = px
	I.pixel_y = py
	if(col_mod)
		I.color = col_mod
	return I

/obj/effect/hallucination/simple/proc/Show(update=1)
	if(active)
		if(target?.client)
			target.client.images.Remove(current_image)
		if(update)
			current_image = GetImage()
		if(target?.client)
			target.client.images |= current_image

/obj/effect/hallucination/simple/update_icon(new_state,new_icon,new_px=0,new_py=0)
	image_state = new_state
	if(new_icon)
		image_icon = new_icon
	else
		image_icon = initial(image_icon)
	px = new_px
	py = new_py
	Show()
	return ..()

/obj/effect/hallucination/simple/Moved(atom/OldLoc, Dir)
	. = ..()
	Show()

/obj/effect/hallucination/simple/Destroy()
	if(target?.client)
		target.client.images.Remove(current_image)
	active = FALSE
	return ..()

#define FAKE_FLOOD_EXPAND_TIME 20
#define FAKE_FLOOD_MAX_RADIUS 10

/obj/effect/plasma_image_holder
	icon_state = "nothing"
	anchored = TRUE
	layer = FLY_LAYER
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/hallucination/simple/xeno
	image_icon = 'icons/mob/alien.dmi'
	image_state = "alienh_pounce"

/obj/effect/hallucination/simple/xeno/Initialize(mapload, mob/living/carbon/T)
	. = ..()
	name = "alien hunter ([rand(1, 1000)])"

/obj/effect/hallucination/simple/xeno/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	update_icon("alienh_pounce")
	if(hit_atom == target && target.stat!=DEAD)
		target.Paralyze(100)
		target.visible_message(span_danger("[target] flails around wildly.") ,span_userdanger("[name] pounces on you!"))

/obj/effect/hallucination/simple/clown
	image_icon = 'icons/mob/animal.dmi'
	image_state = "clown"

/obj/effect/hallucination/simple/clown/Initialize(mapload, mob/living/carbon/T, duration)
	..(loc, T)
	name = pick(GLOB.clown_names)
	QDEL_IN(src,duration)

/obj/effect/hallucination/simple/clown/scary
	image_state = "scary_clown"

/obj/effect/hallucination/simple/bubblegum
	name = "Bubblegum"
	image_icon = 'icons/mob/lavaland/96x96megafauna.dmi'
	image_state = "bubblegum"
	px = -32

/datum/hallucination/oh_yeah
	var/obj/effect/hallucination/simple/bubblegum/bubblegum
	var/image/fakebroken
	var/image/fakerune
	var/turf/landing
	var/charged
	var/next_action = 0

/datum/hallucination/oh_yeah/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	. = ..()
	var/turf/closed/wall/wall
	for(var/turf/closed/wall/W in range(7,target))
		wall = W
		break
	if(!wall)
		return INITIALIZE_HINT_QDEL
	feedback_details += "Source: [wall.x],[wall.y],[wall.z]"

	fakebroken = image('icons/turf/floors.dmi', wall, "plating", layer = TURF_LAYER)
	landing = get_turf(target)
	var/turf/landing_image_turf = get_step(landing, SOUTHWEST) //the icon is 3x3
	fakerune = image('icons/effects/96x96.dmi', landing_image_turf, "landing", layer = ABOVE_OPEN_TURF_LAYER)
	fakebroken.override = TRUE
	if(target?.client)
		target.client.images |= fakebroken
		target.client.images |= fakerune
	target.playsound_local(wall,'sound/effects/meteorimpact.ogg', 150, 1)
	bubblegum = new(wall, target)
	addtimer(CALLBACK(src, .proc/start_processing), 10)

/datum/hallucination/oh_yeah/proc/start_processing()
	if (isnull(target))
		qdel(src)
		return
	START_PROCESSING(SSfastprocess, src)

/datum/hallucination/oh_yeah/process(delta_time)
	next_action -= delta_time

	if (next_action > 0)
		return

	if (get_turf(bubblegum) != landing && target?.stat != DEAD)
		if(!landing || (get_turf(bubblegum)).loc.z != landing.loc.z)
			qdel(src)
			return
		bubblegum.forceMove(get_step_towards(bubblegum, landing))
		bubblegum.setDir(get_dir(bubblegum, landing))
		target.playsound_local(get_turf(bubblegum), 'sound/effects/meteorimpact.ogg', 150, 1)
		shake_camera(target, 2, 1)
		if(bubblegum.Adjacent(target) && !charged)
			charged = TRUE
			target.Paralyze(80)
			target.adjustStaminaLoss(40)
			step_away(target, bubblegum)
			shake_camera(target, 4, 3)
			target.visible_message(span_warning("[target] jumps backwards, falling on the ground!") ,span_userdanger("[bubblegum] slams into you!"))
		next_action = 0.2
	else
		STOP_PROCESSING(SSfastprocess, src)
		QDEL_IN(src, 3 SECONDS)

/datum/hallucination/oh_yeah/Destroy()
	if(target?.client)
		target.client.images.Remove(fakebroken)
		target.client.images.Remove(fakerune)
	QDEL_NULL(fakebroken)
	QDEL_NULL(fakerune)
	QDEL_NULL(bubblegum)
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/hallucination/battle
	var/battle_type
	var/iterations_left
	var/hits = 0
	var/next_action = 0
	var/turf/source

/datum/hallucination/battle/New(mob/living/carbon/C, forced = TRUE, new_battle_type)
	..()

	source = random_far_turf()

	battle_type = new_battle_type
	if (isnull(battle_type))
		battle_type = pick("laser", "disabler", "esword", "gun", "stunprod", "harmbaton", "bomb")
	feedback_details += "Type: [battle_type]"
	var/process = TRUE

	switch(battle_type)
		if("disabler", "laser")
			iterations_left = rand(5, 10)
		if("esword")
			iterations_left = rand(4, 8)
			target.playsound_local(source, 'sound/weapons/saberon.ogg',15, 1)
		if("gun")
			iterations_left = rand(3, 6)
		if("stunprod") //Stunprod + cablecuff
			process = FALSE
			target.playsound_local(source, 'sound/weapons/egloves.ogg', 40, 1)
			target.playsound_local(source, get_sfx("bodyfall"), 25, 1)
			addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, 'sound/weapons/cablecuff.ogg', 15, 1), 20)
		if("harmbaton") //zap n slap
			iterations_left = rand(5, 12)
			target.playsound_local(source, 'sound/weapons/egloves.ogg', 40, 1)
			target.playsound_local(source, get_sfx("bodyfall"), 25, 1)
			next_action = 2 SECONDS
		if("bomb") // Tick Tock
			iterations_left = rand(3, 11)

	if (process)
		START_PROCESSING(SSfastprocess, src)
	else
		qdel(src)

/datum/hallucination/battle/process(delta_time)
	next_action -= (delta_time * 10)

	if (next_action > 0)
		return

	switch (battle_type)
		if ("disabler", "laser", "gun")
			var/fire_sound
			var/hit_person_sound
			var/hit_wall_sound
			var/number_of_hits
			var/chance_to_fall

			switch (battle_type)
				if ("disabler")
					fire_sound = 'sound/weapons/taser2.ogg'
					hit_person_sound = 'sound/weapons/tap.ogg'
					hit_wall_sound = 'sound/weapons/effects/searwall.ogg'
					number_of_hits = 3
					chance_to_fall = 70
				if ("laser")
					fire_sound = 'sound/weapons/laser.ogg'
					hit_person_sound = 'sound/weapons/sear.ogg'
					hit_wall_sound = 'sound/weapons/effects/searwall.ogg'
					number_of_hits = 4
					chance_to_fall = 70
				if ("gun")
					fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
					hit_person_sound = 'sound/weapons/pierce.ogg'
					hit_wall_sound = "ricochet"
					number_of_hits = 2
					chance_to_fall = 80

			target.playsound_local(source, fire_sound, 25, 1)

			if(prob(50))
				addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, hit_person_sound, 25, 1), rand(5,10))
				hits += 1
			else
				addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, hit_wall_sound, 25, 1), rand(5,10))

			next_action = rand(CLICK_CD_RANGE, CLICK_CD_RANGE + 6)

			if(hits >= number_of_hits && prob(chance_to_fall))
				addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, get_sfx("bodyfall"), 25, 1), next_action)
				qdel(src)
				return
		if ("esword")
			target.playsound_local(source, 'sound/weapons/blade1.ogg', 50, 1)

			if (hits == 4)
				target.playsound_local(source, get_sfx("bodyfall"), 25, 1)

			next_action = rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 6)
			hits += 1

			if (iterations_left == 1)
				target.playsound_local(source, 'sound/weapons/saberoff.ogg', 15, 1)
		if ("harmbaton")
			target.playsound_local(source, "swing_hit", 50, 1)
			next_action = rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 4)
		if ("bomb")
			target.playsound_local(source, 'sound/items/timer.ogg', 25, 0)
			next_action = 15

	iterations_left -= 1
	if (iterations_left == 0)
		qdel(src)

/datum/hallucination/battle/Destroy()
	. = ..()
	source = null
	STOP_PROCESSING(SSfastprocess, src)

/datum/hallucination/items_other

/datum/hallucination/items_other/New(mob/living/carbon/C, forced = TRUE, item_type)
	set waitfor = FALSE
	..()
	var/item
	if(!item_type)
		item = pick(list("esword","taser","ebow","baton","dual_esword","ttv","flash","armblade"))
	else
		item = item_type
	feedback_details += "Item: [item]"
	var/side
	var/image_file
	var/image/A = null
	var/list/mob_pool = list()

	for(var/mob/living/carbon/human/M in view(7,target))
		if(M != target)
			mob_pool += M
	if(!mob_pool.len)
		return

	var/mob/living/carbon/human/H = pick(mob_pool)
	feedback_details += " Mob: [H.real_name]"

	var/free_hand = H.get_empty_held_index_for_side(LEFT_HANDS)
	if(free_hand)
		side = "left"
	else
		free_hand = H.get_empty_held_index_for_side(RIGHT_HANDS)
		if(free_hand)
			side = "right"

	if(side)
		switch(item)
			if("esword")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
				target.playsound_local(H, 'sound/weapons/saberon.ogg',35,1)
				A = image(image_file,H,"e_sword_on_red", layer=ABOVE_MOB_LAYER)
			if("dual_esword")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
				target.playsound_local(H, 'sound/weapons/saberon.ogg',35,1)
				A = image(image_file,H,"dualsaberred1", layer=ABOVE_MOB_LAYER)
			if("taser")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
				A = image(image_file,H,"advtaserstun4", layer=ABOVE_MOB_LAYER)
			if("ebow")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
				A = image(image_file,H,"crossbow", layer=ABOVE_MOB_LAYER)
			if("baton")
				if(side == "right")
					image_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
				target.playsound_local(H, "sparks",75,1,-1)
				A = image(image_file,H,"baton", layer=ABOVE_MOB_LAYER)
			if("ttv")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/bombs_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/bombs_lefthand.dmi'
				A = image(image_file,H,"ttv", layer=ABOVE_MOB_LAYER)
			if("flash")
				if(side == "right")
					image_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
				A = image(image_file,H,"flashtool", layer=ABOVE_MOB_LAYER)
			if("armblade")
				if(side == "right")
					image_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
				target.playsound_local(H, 'sound/effects/blobattack.ogg',30,1)
				A = image(image_file,H,"arm_blade", layer=ABOVE_MOB_LAYER)
		if(target?.client)
			target.client.images |= A
			addtimer(CALLBACK(src, .proc/cleanup, item, A, H), rand(15 SECONDS, 25 SECONDS))
			return
	qdel(src)

/datum/hallucination/items_other/proc/cleanup(item, atom/image_used, has_the_item)
	if (isnull(target))
		qdel(src)
		return
	if(item == "esword" || item == "dual_esword")
		target.playsound_local(has_the_item, 'sound/weapons/saberoff.ogg',35,1)
	if(item == "armblade")
		target.playsound_local(has_the_item, 'sound/effects/blobattack.ogg',30,1)
	target.client.images.Remove(image_used)
	qdel(src)

/datum/hallucination/delusion
	var/list/image/delusions = list()

/datum/hallucination/delusion/New(mob/living/carbon/C, forced, force_kind = null , duration = 300,skip_nearby = TRUE, custom_icon = null, custom_icon_file = null, custom_name = null)
	set waitfor = FALSE
	. = ..()
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("nothing","monkey","corgi","carp","skeleton","demon","zombie")
	feedback_details += "Type: [kind]"
	var/list/nearby
	if(skip_nearby)
		nearby = get_hearers_in_view(7, target)
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(H == target)
			continue
		if(skip_nearby && (H in nearby))
			continue
		switch(kind)
			if("nothing")
				A = image('icons/effects/effects.dmi',H,"nothing")
				A.name = "..."
			if("monkey")//Monkey
				A = image('icons/mob/monkey.dmi',H,"monkey1")
				A.name = "Monkey ([rand(1,999)])"
			if("carp")//Carp
				A = image('icons/mob/carp.dmi',H,"carp")
				A.name = "Space Carp"
			if("corgi")//Corgi
				A = image('icons/mob/pets.dmi',H,"corgi")
				A.name = "Corgi"
			if("skeleton")//Skeletons
				A = image('icons/mob/human.dmi',H,"skeleton")
				A.name = "Skeleton"
			if("zombie")//Zombies
				A = image('icons/mob/human.dmi',H,"zombie")
				A.name = "Zombie"
			if("demon")//Demon
				A = image('icons/mob/mob.dmi',H,"daemon")
				A.name = "Demon"
			if("custom")
				A = image(custom_icon_file, H, custom_icon)
				A.name = custom_name
		A.override = 1
		if(target?.client)
			delusions |= A
			target.client.images |= A
	if(duration)
		QDEL_IN(src, duration)

/datum/hallucination/delusion/Destroy()
	for(var/image/I in delusions)
		if(target?.client)
			target.client.images.Remove(I)
	return ..()

/datum/hallucination/self_delusion
	var/image/delusion

/datum/hallucination/self_delusion/New(mob/living/carbon/C, forced, force_kind = null , duration = 300, custom_icon = null, custom_icon_file = null, wabbajack = TRUE) //set wabbajack to false if you want to use another fake source
	set waitfor = FALSE
	..()
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("monkey","corgi","carp","skeleton","demon","zombie","robot")
	feedback_details += "Type: [kind]"
	switch(kind)
		if("monkey")//Monkey
			A = image('icons/mob/monkey.dmi',target,"monkey1")
		if("carp")//Carp
			A = image('icons/mob/animal.dmi',target,"carp")
		if("corgi")//Corgi
			A = image('icons/mob/pets.dmi',target,"corgi")
		if("skeleton")//Skeletons
			A = image('icons/mob/human.dmi',target,"skeleton")
		if("zombie")//Zombies
			A = image('icons/mob/human.dmi',target,"zombie")
		if("demon")//Demon
			A = image('icons/mob/mob.dmi',target,"daemon")
		if("robot")//Cyborg
			A = image('icons/mob/robots.dmi',target,"robot")
			target.playsound_local(target,'sound/voice/liveagain.ogg', 75, 1)
		if("custom")
			A = image(custom_icon_file, target, custom_icon)
	A.override = 1
	if(target?.client)
		if(wabbajack)
			to_chat(target, span_hear("...wabbajack...wabbajack..."))
			target.playsound_local(target,'sound/magic/staff_change.ogg', 50, 1)
		delusion = A
		target.client.images |= A
	QDEL_IN(src, duration)

/datum/hallucination/self_delusion/Destroy()
	if(target?.client)
		target.client.images.Remove(delusion)
	return ..()

/datum/hallucination/chat

/datum/hallucination/chat/New(mob/living/carbon/C, forced = TRUE, force_radio, specific_message)
	set waitfor = FALSE
	..()
	var/target_name = target.first_name()
	var/speak_messages = list("[pick_list_replacements(HAL_LINES_FILE, "suspicion")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "conversation")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "greetings")][target.first_name()]",\
		"[pick_list_replacements(HAL_LINES_FILE, "getout")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "weird")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "didyouhearthat")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "doubt")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "aggressive")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "help")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "escape")]",\
		"У меня вирус, [pick_list_replacements(HAL_LINES_FILE, "infection_advice")]!")

	var/radio_messages = list("[pick_list_replacements(HAL_LINES_FILE, "people")] [pick_list_replacements(HAL_LINES_FILE, "accusations")]!",\
		"Помогите!",\
		"[pick_list_replacements(HAL_LINES_FILE, "threat")] в [pick_list_replacements(HAL_LINES_FILE, "location")][prob(50)?"!":"!!"]",\
		"[pick("Где [target.first_name()]?", "Аррестуйте [target.first_name()]!")]",\
		"[pick("По","Кто-нибудь, по","От")]зовите шаттл!",\
		"[pick_list_replacements(HAL_LINES_FILE, "prikols")]",\
		"У [pick_list_replacements(HAL_LINES_FILE, "jobs")] [pick_list_replacements(HAL_LINES_FILE, "tator-items")]!!!",\
		"ИИ [pick("сбойный", "уничтожен")]!!")

	var/mob/living/carbon/person = null
	var/datum/language/understood_language = target.get_random_understood_language()
	for(var/mob/living/carbon/H in view(target))
		if(H == target)
			continue
		if(!person)
			person = H
		else
			if(get_dist(target,H)<get_dist(target,person))
				person = H

	// Get person to affect if radio hallucination
	var/is_radio = !person || force_radio
	if (is_radio)
		var/list/humans = list()
		for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
			humans += H
		person = pick(humans)

	// Generate message
	var/spans = list(person.speech_span)
	var/chosen = !specific_message ? capitalize(pick(is_radio ? speak_messages : radio_messages)) : specific_message
	chosen = replacetext(chosen, "%TARGETNAME%", target_name)
	var/message = target.compose_message(person, understood_language, chosen, is_radio ? "[FREQ_COMMON]" : null, spans, face_name = TRUE)
	feedback_details += "Type: [is_radio ? "Radio" : "Talk"], Source: [person.real_name], Message: [message]"

	// Display message
	if (!is_radio && !target.client?.prefs.chat_on_map)
		var/image/speech_overlay = image('icons/mob/talk.dmi', person, "default0", layer = ABOVE_MOB_LAYER)
		INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, speech_overlay, list(target.client), 30)
	if (target.client?.prefs.chat_on_map || isdead(target))
		target.create_chat_message(person, understood_language, chosen, spans)
	to_chat(target, message)
	qdel(src)

/datum/hallucination/message

/datum/hallucination/message/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/mobpool = list()
	var/mob/living/carbon/human/other
	var/close_other = FALSE
	for(var/mob/living/carbon/human/H in oview(target, 7))
		if(get_dist(H, target) <= 1)
			other = H
			close_other = TRUE
			break
		mobpool += H
	if(!other && mobpool.len)
		other = pick(mobpool)

	var/list/message_pool = list()
	if(other)
		if(close_other) //increase the odds
			for(var/i in 1 to 5)
				message_pool.Add(span_warning("Что-то укололо меня!"))
		var/obj/item/storage/equipped_backpack = other.get_item_by_slot(ITEM_SLOT_BACK)
		if(istype(equipped_backpack))
			for(var/i in 1 to 5) //increase the odds
				message_pool.Add("<span class='notice'>[other] кладёт [pick(\
					"револьвер .357 калибра","energy sword","cryptographic sequencer","power sink","мини энергетический арбалет",\
					"гибридный тазер","электрошоковая дубинка","flash","шприцевой пистолет","циркулярная пила","tank transfer valve",\
					"ritual dagger","spellbook",\
					"импульсный карабин","запасная ID-карта капитана","ручной телепортер","hypospray","Антикварный лазерный пистолет","X-01 MultiPhase Energy Gun","station's blueprints"\
					)] в [equipped_backpack].</span>")

		message_pool.Add("<B>[other]</B> [pick("чихает","кашляет")].")

	message_pool.Add(span_notice("Что-то ползает по трубам...") , \
		span_notice("[pick("Рука", "Нога", "Спина", "Голова")] чешется.") ,\
		span_warning("Ощущаю [pick("жар","холод","сухость","сырость","головокружение","слабость")].") ,
		span_warning("В животе что-то грохочет.") ,
		span_warning("Голова болит.") ,
		span_warning("Голова гудит.") ,
		"<B>[target]</B> чихает.")
	if(prob(10))
		message_pool.Add(span_warning("Позади меня.") ,\
			span_warning("Кто-то тихо смеётся.") ,
			span_warning("Что-то движется.") ,
			span_warning("Что-то шумит на потолке.") ,
			span_warning("Что-то движется ко мне."))
	if(prob(10))
		message_pool.Add("[pick_list_replacements(HAL_LINES_FILE, "advice")]")
	var/chosen = pick(message_pool)
	feedback_details += "Message: [chosen]"
	to_chat(target, chosen)
	qdel(src)

/datum/hallucination/sounds

/datum/hallucination/sounds/New(mob/living/carbon/C, forced = TRUE, sound_type)
	set waitfor = FALSE
	..()
	var/turf/source = random_far_turf()
	if(!sound_type)
		sound_type = pick("airlock","airlock pry","console","explosion","far explosion","mech","glass","alarm","beepsky","mech","wall decon","door hack")
	feedback_details += "Type: [sound_type]"
	//Strange audio
	switch(sound_type)
		if("airlock")
			target.playsound_local(source,'sound/machines/airlock.ogg', 30, 1)
		if("airlock pry")
			target.playsound_local(source,'sound/machines/airlock_alien_prying.ogg', 100, 1)
			addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, 'sound/machines/airlockforced.ogg', 30, 1), 50)
		if("console")
			target.playsound_local(source,'sound/machines/terminal_prompt.ogg', 25, 1)
		if("explosion")
			if(prob(50))
				target.playsound_local(source,'sound/effects/explosion1.ogg', 50, 1)
			else
				target.playsound_local(source, 'sound/effects/explosion2.ogg', 50, 1)
		if("far explosion")
			target.playsound_local(source, pick(FAR_EXPLOSION_SOUNDS), 50, 1)
		if("glass")
			target.playsound_local(source, pick('sound/effects/glassbr1.ogg','sound/effects/glassbr2.ogg','sound/effects/glassbr3.ogg'), 50, 1)
		if("alarm")
			target.playsound_local(source, 'sound/machines/alarm.ogg', 100, 0)
		if("beepsky")
			target.playsound_local(source, 'white/valtos/sounds/beepsky_russian/freeze.ogg', 35, 0)
		if("mech")
			new /datum/hallucination/mech_sounds(C, forced, sound_type)
		//Deconstructing a wall
		if("wall decon")
			target.playsound_local(source, 'sound/items/welder.ogg', 50, 1)
			addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, 'sound/items/welder2.ogg', 50, 1), 105)
			addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, 'sound/items/ratchet.ogg', 50, 1), 120)
		//Hacking a door
		if("door hack")
			target.playsound_local(source, 'sound/items/screwdriver.ogg', 50, 1)
			addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, 'sound/machines/airlockforced.ogg', 30, 1), rand(40, 80))
	qdel(src)

/datum/hallucination/mech_sounds
	var/mech_dir
	var/steps_left
	var/next_action = 0
	var/turf/source

/datum/hallucination/mech_sounds/New()
	. = ..()
	mech_dir = pick(GLOB.cardinals)
	steps_left = rand(4, 9)
	source = random_far_turf()
	START_PROCESSING(SSfastprocess, src)

/datum/hallucination/mech_sounds/process(delta_time)
	next_action -= delta_time
	if (next_action > 0)
		return

	if(prob(75))
		target.playsound_local(source, 'sound/mecha/mechstep.ogg', 40, 1)
		source = get_step(source, mech_dir)
	else
		target.playsound_local(source, 'sound/mecha/mechturn.ogg', 40, 1)
		mech_dir = pick(GLOB.cardinals)

	steps_left -= 1
	if (!steps_left)
		qdel(src)
		return
	next_action = 1

/datum/hallucination/mech_sounds/Destroy()
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)

/datum/hallucination/weird_sounds

/datum/hallucination/weird_sounds/New(mob/living/carbon/C, forced = TRUE, sound_type)
	set waitfor = FALSE
	..()
	var/turf/source = random_far_turf()
	if(!sound_type)
		sound_type = pick("phone","hallelujah","laughter","hyperspace","game over","creepy","tesla")
	feedback_details += "Type: [sound_type]"
	//Strange audio
	switch(sound_type)
		if("phone")
			target.playsound_local(source, 'sound/weapons/ring.ogg', 15)
			for (var/next_rings in 1 to 3)
				addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, 'sound/weapons/ring.ogg', 15), 25 * next_rings)
		if("hyperspace")
			target.playsound_local(null, 'sound/runtime/hyperspace/hyperspace_begin.ogg', 50)
		if("hallelujah")
			target.playsound_local(source, 'sound/effects/pray_chaplain.ogg', 50)
		if("game over")
			target.playsound_local(source, 'sound/misc/compiler-failure.ogg', 50)
		if("laughter")
			if(prob(50))
				target.playsound_local(source, 'sound/voice/human/womanlaugh.ogg', 50, 1)
			else
				target.playsound_local(source, pick('sound/voice/human/manlaugh1.ogg', 'sound/voice/human/manlaugh2.ogg'), 50, 1)
		if("creepy")
		//These sounds are (mostly) taken from Hidden: Source
			target.playsound_local(source, pick(GLOB.creepy_ambience), 50, 1)
		if("tesla") //Tesla loose!
			target.playsound_local(source, 'sound/magic/lightningbolt.ogg', 35, 1)
			addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, 'sound/magic/lightningbolt.ogg', 65, 1), 30)
			addtimer(CALLBACK(target, /mob/.proc/playsound_local, source, 'sound/magic/lightningbolt.ogg', 100, 1), 60)

	qdel(src)

/datum/hallucination/hudscrew

/datum/hallucination/hudscrew/New(mob/living/carbon/C, forced = TRUE, screwyhud_type)
	set waitfor = FALSE
	..()
	//Screwy HUD
	var/chosen_screwyhud = screwyhud_type
	if(!chosen_screwyhud)
		chosen_screwyhud = pick(SCREWYHUD_CRIT,SCREWYHUD_DEAD,SCREWYHUD_HEALTHY)
	target.set_screwyhud(chosen_screwyhud)
	feedback_details += "Type: [target.hal_screwyhud]"
	QDEL_IN(src, rand(100, 250))

/datum/hallucination/hudscrew/Destroy()
	target?.set_screwyhud(SCREWYHUD_NONE)
	return ..()

/datum/hallucination/fake_alert
	var/alert_type

/datum/hallucination/fake_alert/New(mob/living/carbon/C, forced = TRUE, specific, duration = 150)
	set waitfor = FALSE
	..()
	alert_type = pick("not_enough_oxy","not_enough_tox","not_enough_co2","too_much_oxy","too_much_co2","too_much_tox","newlaw","nutrition","charge","gravity","fire","locked","hacked","temphot","tempcold","pressure")
	if(specific)
		alert_type = specific
	feedback_details += "Type: [alert_type]"
	switch(alert_type)
		if("not_enough_oxy")
			target.throw_alert(alert_type, /atom/movable/screen/alert/not_enough_oxy, override = TRUE)
		if("not_enough_tox")
			target.throw_alert(alert_type, /atom/movable/screen/alert/not_enough_tox, override = TRUE)
		if("not_enough_co2")
			target.throw_alert(alert_type, /atom/movable/screen/alert/not_enough_co2, override = TRUE)
		if("too_much_oxy")
			target.throw_alert(alert_type, /atom/movable/screen/alert/too_much_oxy, override = TRUE)
		if("too_much_co2")
			target.throw_alert(alert_type, /atom/movable/screen/alert/too_much_co2, override = TRUE)
		if("too_much_tox")
			target.throw_alert(alert_type, /atom/movable/screen/alert/too_much_tox, override = TRUE)
		if("nutrition")
			if(prob(50))
				target.throw_alert(alert_type, /atom/movable/screen/alert/fat, override = TRUE)
			else
				target.throw_alert(alert_type, /atom/movable/screen/alert/starving, override = TRUE)
		if("gravity")
			target.throw_alert(alert_type, /atom/movable/screen/alert/weightless, override = TRUE)
		if("fire")
			target.throw_alert(alert_type, /atom/movable/screen/alert/fire, override = TRUE)
		if("temphot")
			alert_type = "temp"
			target.throw_alert(alert_type, /atom/movable/screen/alert/hot, 3, override = TRUE)
		if("tempcold")
			alert_type = "temp"
			target.throw_alert(alert_type, /atom/movable/screen/alert/cold, 3, override = TRUE)
		if("pressure")
			if(prob(50))
				target.throw_alert(alert_type, /atom/movable/screen/alert/highpressure, 2, override = TRUE)
			else
				target.throw_alert(alert_type, /atom/movable/screen/alert/lowpressure, 2, override = TRUE)
		if("charge")
			target.throw_alert(alert_type, /atom/movable/screen/alert/emptycell, override = TRUE)

	addtimer(CALLBACK(src, .proc/cleanup), duration)

/datum/hallucination/fake_alert/proc/cleanup()
	target.clear_alert(alert_type, clear_override = TRUE)
	qdel(src)

///Causes the target to see incorrect health damages on the healthdoll
/datum/hallucination/fake_health_doll
	var/timer_id = null

///Creates a specified doll hallucination, or picks one randomly
/datum/hallucination/fake_health_doll/New(mob/living/carbon/human/human_mob, forced = TRUE, specific_limb, severity, duration = 500)
	. = ..()
	if(!specific_limb)
		specific_limb = pick(list(SCREWYDOLL_HEAD, SCREWYDOLL_CHEST, SCREWYDOLL_L_ARM, SCREWYDOLL_R_ARM, SCREWYDOLL_L_LEG, SCREWYDOLL_R_LEG))
	if(!severity)
		severity = rand(1, 5)
	LAZYSET(human_mob.hal_screwydoll, specific_limb, severity)
	human_mob.update_health_hud()

	timer_id = addtimer(CALLBACK(src, .proc/cleanup), duration, TIMER_STOPPABLE)

///Increments the severity of the damage seen on the doll
/datum/hallucination/fake_health_doll/proc/increment_fake_damage()
	if(!ishuman(target))
		stack_trace("Somehow [target] managed to get a fake health doll hallucination, while not being a human mob.")
	var/mob/living/carbon/human/human_mob = target
	for(var/entry in human_mob.hal_screwydoll)
		human_mob.hal_screwydoll[entry] = clamp(human_mob.hal_screwydoll[entry]+1, 1, 5)
	human_mob.update_health_hud()

///Adds a fake limb to the hallucination datum effect
/datum/hallucination/fake_health_doll/proc/add_fake_limb(specific_limb, severity)
	if(!specific_limb)
		specific_limb = pick(list(SCREWYDOLL_HEAD, SCREWYDOLL_CHEST, SCREWYDOLL_L_ARM, SCREWYDOLL_R_ARM, SCREWYDOLL_L_LEG, SCREWYDOLL_R_LEG))
	if(!severity)
		severity = rand(1, 5)
	var/mob/living/carbon/human/human_mob = target
	LAZYSET(human_mob.hal_screwydoll, specific_limb, severity)
	target.update_health_hud()

/datum/hallucination/fake_health_doll/target_deleting()
	if(isnull(timer_id))
		return
	deltimer(timer_id)
	timer_id = null
	..()

///Cleans up the hallucinations - this deletes any overlap, but that shouldn't happen.
/datum/hallucination/fake_health_doll/proc/cleanup()
	qdel(src)

//So that the associated addition proc cleans it up correctly
/datum/hallucination/fake_health_doll/Destroy()
	if(!ishuman(target))
		stack_trace("Somehow [target] managed to get a fake health doll hallucination, while not being a human mob.")
	var/mob/living/carbon/human/human_mob = target
	LAZYNULL(human_mob.hal_screwydoll)
	human_mob.update_health_hud()
	return ..()


/datum/hallucination/items/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	//Strange items

	var/obj/halitem = new

	halitem = new
	var/obj/item/l_hand = target.get_item_for_held_index(1)
	var/obj/item/r_hand = target.get_item_for_held_index(2)
	var/l = ui_hand_position(target.get_held_index_of_item(l_hand))
	var/r = ui_hand_position(target.get_held_index_of_item(r_hand))
	var/list/slots_free = list(l,r)
	if(l_hand)
		slots_free -= l
	if(r_hand)
		slots_free -= r
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.belt)
			slots_free += ui_belt
		if(!H.l_store)
			slots_free += ui_storage1
		if(!H.r_store)
			slots_free += ui_storage2
	if(slots_free.len)
		halitem.screen_loc = pick(slots_free)
		halitem.plane = ABOVE_HUD_PLANE
		switch(rand(1,6))
			if(1) //revolver
				halitem.icon = 'icons/obj/guns/projectile.dmi'
				halitem.icon_state = "revolver"
				halitem.name = "револьвер .357 калибра"
			if(2) //c4
				halitem.icon = 'icons/obj/grenade.dmi'
				halitem.icon_state = "plastic-explosive0"
				halitem.name = "C4"
				if(prob(25))
					halitem.icon_state = "plasticx40"
			if(3) //sword
				halitem.icon = 'icons/obj/transforming_energy.dmi'
				halitem.icon_state = "e_sword"
				halitem.name = "energy sword"
			if(4) //stun baton
				halitem.icon = 'icons/obj/items_and_weapons.dmi'
				halitem.icon_state = "stunbaton"
				halitem.name = "электоршоковая дубинка"
			if(5) //emag
				halitem.icon = 'icons/obj/card.dmi'
				halitem.icon_state = "emag"
				halitem.name = "cryptographic sequencer"
			if(6) //flashbang
				halitem.icon = 'icons/obj/grenade.dmi'
				halitem.icon_state = "flashbang1"
				halitem.name = "flashbang"
		feedback_details += "Type: [halitem.name]"
		if(target?.client)
			target.client.screen += halitem
		QDEL_IN(halitem, rand(150, 350))

	qdel(src)

/datum/hallucination/dangerflash

/datum/hallucination/dangerflash/New(mob/living/carbon/C, forced = TRUE, danger_type)
	set waitfor = FALSE
	..()
	//Flashes of danger

	var/list/possible_points = list()
	for(var/turf/open/floor/F in view(target,world.view))
		possible_points += F
	if(possible_points.len)
		var/turf/open/floor/danger_point = pick(possible_points)
		if(!danger_type)
			danger_type = pick("lava","chasm","anomaly")
		switch(danger_type)
			if("lava")
				new /obj/effect/hallucination/danger/lava(danger_point, target)
			if("chasm")
				new /obj/effect/hallucination/danger/chasm(danger_point, target)
			if("anomaly")
				new /obj/effect/hallucination/danger/anomaly(danger_point, target)

	qdel(src)

/obj/effect/hallucination/danger
	var/image/image

/obj/effect/hallucination/danger/proc/show_icon()
	return

/obj/effect/hallucination/danger/proc/clear_icon()
	if(image && target.client)
		target.client.images -= image

/obj/effect/hallucination/danger/Initialize(mapload, _target)
	. = ..()
	target = _target
	show_icon()
	QDEL_IN(src, rand(200, 450))

/obj/effect/hallucination/danger/Destroy()
	clear_icon()
	. = ..()

/obj/effect/hallucination/danger/lava
	name = "lava"

/obj/effect/hallucination/danger/lava/Initialize(mapload, _target)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/hallucination/danger/lava/show_icon()
	image = image('icons/turf/floors/lava.dmi', src, "lava-0", TURF_LAYER)
	if(target?.client)
		target.client.images += image

/obj/effect/hallucination/danger/lava/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(AM == target)
		target.adjustStaminaLoss(20)
		new /datum/hallucination/fire(target)

/obj/effect/hallucination/danger/chasm
	name = "chasm"

/obj/effect/hallucination/danger/chasm/Initialize(mapload, _target)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/hallucination/danger/chasm/show_icon()
	var/turf/target_loc = get_turf(target)
	image = image('icons/turf/floors/chasms.dmi', src, "chasms-[target_loc.smoothing_junction]", TURF_LAYER)
	if(target?.client)
		target.client.images += image

/obj/effect/hallucination/danger/chasm/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(AM == target)
		if(istype(target, /obj/effect/dummy/phased_mob))
			return
		to_chat(target, span_userdanger("Падаю в пропасть!"))
		target.Paralyze(40)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, target, span_notice("Но тут удивительно не глубоко.")), 15)
		QDEL_IN(src, 30)

/obj/effect/hallucination/danger/anomaly
	name = "flux wave anomaly"

/obj/effect/hallucination/danger/anomaly/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/hallucination/danger/anomaly/process(delta_time)
	if(DT_PROB(45, delta_time))
		step(src,pick(GLOB.alldirs))

/obj/effect/hallucination/danger/anomaly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/hallucination/danger/anomaly/show_icon()
	image = image('icons/effects/effects.dmi',src,"electricity2",OBJ_LAYER+0.01)
	if(target?.client)
		target.client.images += image

/obj/effect/hallucination/danger/anomaly/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(AM == target)
		new /datum/hallucination/shock(target)

/datum/hallucination/death

/datum/hallucination/death/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	target.set_screwyhud(SCREWYHUD_DEAD)
	target.Paralyze(300)
	target.silent += 10
	to_chat(target, span_deadsay("<b>[target.real_name]</b> погибает в локации <b>[get_area_name(target)]</b>."))

	var/delay = 0

	if(prob(50))
		var/mob/fakemob
		var/list/dead_people = list()
		for(var/mob/dead/observer/G in GLOB.player_list)
			dead_people += G
		if(LAZYLEN(dead_people))
			fakemob = pick(dead_people)
		else
			fakemob = target //ever been so lonely you had to haunt yourself?
		if(fakemob)
			delay = rand(20, 50)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, target, "<span class='deadsay'><b>Призрак [fakemob.name]</b> говорит, \"[pick("рест ин писс","пидорасы блять","ебать у тебя имя [target.first_name()]","красава","че, опять?","допрыгался",\
				"я[prob(50)?" блять":""] ненавижу этих [pick("культистов", "триторов", "ревенантов", "пидорасов","людей","опухоидов","педалей","натуралов")]")]\"</span>"), delay)

	addtimer(CALLBACK(src, .proc/cleanup), delay + rand(70, 90))

/datum/hallucination/death/proc/cleanup()
	if (target)
		target.set_screwyhud(SCREWYHUD_NONE)
		target.SetParalyzed(0)
		target.silent = FALSE
	qdel(src)

#define RAISE_FIRE_COUNT 3
#define RAISE_FIRE_TIME 3

/datum/hallucination/fire
	var/active = TRUE
	var/stage = 0
	var/image/fire_overlay

	var/next_action = 0
	var/times_to_lower_stamina
	var/fire_clearing = FALSE
	var/increasing_stages = TRUE
	var/time_spent = 0

/datum/hallucination/fire/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	target.set_fire_stacks(max(target.fire_stacks, 0.1)) //Placebo flammability
	fire_overlay = image('icons/mob/OnFire.dmi', target, "Standing", ABOVE_MOB_LAYER)
	if(target?.client)
		target.client.images += fire_overlay
	to_chat(target, span_userdanger("ГОРЮ!"))
	target.throw_alert("fire", /atom/movable/screen/alert/fire, override = TRUE)
	times_to_lower_stamina = rand(5, 10)
	addtimer(CALLBACK(src, .proc/start_expanding), 20)

/datum/hallucination/fire/Destroy()
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)

/datum/hallucination/fire/proc/start_expanding()
	if (isnull(target))
		qdel(src)
		return
	START_PROCESSING(SSfastprocess, src)

/datum/hallucination/fire/process(delta_time)
	if (isnull(target))
		qdel(src)
		return

	if(target.fire_stacks <= 0)
		clear_fire()

	time_spent += delta_time

	if (fire_clearing)
		next_action -= delta_time
		if (next_action < 0)
			stage -= 1
			update_temp()
			next_action += 3
	else if (increasing_stages)
		var/new_stage = min(round(time_spent / RAISE_FIRE_TIME), RAISE_FIRE_COUNT)
		if (stage != new_stage)
			stage = new_stage
			update_temp()

			if (stage == RAISE_FIRE_COUNT)
				increasing_stages = FALSE
	else if (times_to_lower_stamina)
		next_action -= delta_time
		if (next_action < 0)
			target.adjustStaminaLoss(15)
			next_action += 2
			times_to_lower_stamina -= 1
	else
		clear_fire()

/datum/hallucination/fire/proc/update_temp()
	if(stage <= 0)
		target.clear_alert("temp", clear_override = TRUE)
	else
		target.clear_alert("temp", clear_override = TRUE)
		target.throw_alert("temp", /atom/movable/screen/alert/hot, stage, override = TRUE)

/datum/hallucination/fire/proc/clear_fire()
	if(!active)
		return
	active = FALSE
	target.clear_alert("fire", clear_override = TRUE)
	if(target?.client)
		target.client.images -= fire_overlay
	QDEL_NULL(fire_overlay)
	fire_clearing = TRUE
	next_action = 0

#undef RAISE_FIRE_COUNT
#undef RAISE_FIRE_TIME

/datum/hallucination/shock
	var/image/shock_image
	var/image/electrocution_skeleton_anim

/datum/hallucination/shock/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	shock_image = image(target, target, dir = target.dir)
	shock_image.appearance_flags |= KEEP_APART
	shock_image.color = rgb(0,0,0)
	shock_image.override = TRUE
	electrocution_skeleton_anim = image('icons/mob/human.dmi', target, icon_state = "electrocuted_base", layer=ABOVE_MOB_LAYER)
	electrocution_skeleton_anim.appearance_flags |= RESET_COLOR|KEEP_APART
	to_chat(target, span_userdanger("Меня ударило током. ЭТО ОЧЕНЬ БОЛЬНО!"))
	if(target?.client)
		target.client.images |= shock_image
		target.client.images |= electrocution_skeleton_anim
	addtimer(CALLBACK(src, .proc/reset_shock_animation), 40)
	target.playsound_local(get_turf(src), "sparks", 100, 1)
	target.staminaloss += 50
	target.Stun(40)
	target.jitteriness += 1000
	target.do_jitter_animation(target.jitteriness)
	addtimer(CALLBACK(src, .proc/shock_drop), 20)

/datum/hallucination/shock/proc/reset_shock_animation()
	if(target?.client)
		target.client.images.Remove(shock_image)
		target.client.images.Remove(electrocution_skeleton_anim)

/datum/hallucination/shock/proc/shock_drop()
	target.jitteriness = max(target.jitteriness - 990, 10) //Still jittery, but vastly less
	target.Paralyze(60)

/datum/hallucination/husks
	var/image/halbody

/datum/hallucination/husks/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/possible_points = list()
	for(var/turf/open/floor/F in view(target,world.view))
		possible_points += F
	if(possible_points.len)
		var/turf/open/floor/husk_point = pick(possible_points)
		switch(rand(1,4))
			if(1)
				var/image/body = image('icons/mob/human.dmi',husk_point,"husk",TURF_LAYER)
				var/matrix/M = matrix()
				M.Turn(90)
				body.transform = M
				halbody = body
			if(2,3)
				halbody = image('icons/mob/human.dmi',husk_point,"husk",TURF_LAYER)
			if(4)
				halbody = image('icons/mob/alien.dmi',husk_point,"alienother",TURF_LAYER)

		if(target?.client)
			target.client.images += halbody
		QDEL_IN(src, rand(30,50)) //Only seen for a brief moment.

/datum/hallucination/husks/Destroy()
	target?.client?.images -= halbody
	QDEL_NULL(halbody)
	return ..()

//hallucination projectile code in code/modules/projectiles/projectile/special.dm
/datum/hallucination/stray_bullet

/datum/hallucination/stray_bullet/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/turf/startlocs = list()
	for(var/turf/open/T in view(world.view+1,target)-view(world.view,target))
		startlocs += T
	if(!startlocs.len)
		qdel(src)
		return
	var/turf/start = pick(startlocs)
	var/proj_type = pick(subtypesof(/obj/projectile/hallucination))
	feedback_details += "Type: [proj_type]"
	var/obj/projectile/hallucination/H = new proj_type(start)
	target.playsound_local(start, H.hal_fire_sound, 60, 1)
	H.hal_target = target
	H.preparePixelProjectile(target, start)
	H.fire()
	qdel(src)
