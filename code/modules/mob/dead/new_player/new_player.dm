/mob/dead/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.

	flags_1 = NONE

	invisibility = INVISIBILITY_ABSTRACT

	density = FALSE
	stat = DEAD
	hud_type = /datum/hud/new_player
	hud_possible = list()

	var/mob/living/new_character	//for instant transfer once the round is set up

	//Used to make sure someone doesn't get spammed with messages if they're ineligible for roles
	var/ineligible_for_roles = FALSE

/mob/dead/new_player/Initialize()
	if(client && SSticker.state == GAME_STATE_STARTUP)
		var/atom/movable/screen/splash/S = new(client, TRUE, TRUE)
		S.Fade(TRUE)

	if(length(GLOB.newplayer_start))
		forceMove(pick(GLOB.newplayer_start))
	else
		forceMove(locate(1,1,1))

	ComponentInitialize()

	. = ..()

	GLOB.new_player_list += src

/mob/dead/new_player/Destroy()
	GLOB.new_player_list -= src
	return ..()

/mob/dead/new_player/prepare_huds()
	return

/mob/dead/new_player/Topic(href, href_list[])
	if(src != usr)
		return

	if(!client)
		return

	if(client.interviewee)
		return FALSE

	if(href_list["late_join"]) //This still exists for queue messages in chat
		if(!SSticker?.IsRoundInProgress())
			to_chat(usr, span_boldwarning("Раунд ещё не начался или уже завершился..."))
			return
		LateChoices()

	if(href_list["SelectedJob"])
		if(!SSticker?.IsRoundInProgress())
			to_chat(usr, span_danger("Раунд ещё не начался или уже завершился..."))
			return

		if(SSlag_switch.measures[DISABLE_NON_OBSJOBS])
			to_chat(usr, span_notice("Нельзя!"))
			return

		//Determines Relevent Population Cap
		var/relevant_cap
		var/hpc = CONFIG_GET(number/hard_popcap)
		var/epc = CONFIG_GET(number/extreme_popcap)
		if(hpc && epc)
			relevant_cap = min(hpc, epc)
		else
			relevant_cap = max(hpc, epc)

		if(SSticker.queued_players.len && !(ckey(key) in GLOB.admin_datums))
			if((living_player_count() >= relevant_cap) || (src != SSticker.queued_players[1]))
				to_chat(usr, span_warning("Полновато здесь."))
				return

		AttemptLateSpawn(href_list["SelectedJob"])
		return

	if(href_list["viewpoll"])
		var/datum/poll_question/poll = locate(href_list["viewpoll"]) in GLOB.polls
		poll_player(poll)

	if(href_list["votepollref"])
		var/datum/poll_question/poll = locate(href_list["votepollref"]) in GLOB.polls
		vote_on_poll_handler(poll, href_list)

//When you cop out of the round (NB: this HAS A SLEEP FOR PLAYER INPUT IN IT)
/mob/dead/new_player/proc/make_me_an_observer(force_observe=FALSE)
	if(QDELETED(src) || !src.client)
		ready = PLAYER_NOT_READY
		return FALSE

	var/less_input_message
	if(SSlag_switch.measures[DISABLE_DEAD_KEYLOOP])
		less_input_message = " - Заметка: Призраки на данный момент ограничены."
	var/this_is_like_playing_right = tgui_alert(usr, "Действительно хочешь следить? У меня не будет возможности зайти в этот раунд (исключая частые ивенты и спаунеры)![less_input_message]","Странный господин",list("Да","Нет"))

	if(QDELETED(src) || !src.client || this_is_like_playing_right != "Да")
		ready = PLAYER_NOT_READY
		src << browse(null, "window=playersetup") //closes the player setup window
		return FALSE

	var/mob/dead/observer/observer = new()
	spawning = TRUE

	client.kill_lobby()

	observer.started_as_observer = TRUE
	close_spawn_windows()
	var/obj/effect/landmark/observer_start/O = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	to_chat(src, span_notice("Телепортируемся!"))
	if (O)
		observer.forceMove(O.loc)
	else
		to_chat(src, span_notice("Что-то сломалось и тебя забросило немного не там, где нужно. Ничего страшного."))
		stack_trace("There's no freaking observer landmark available on this map or you're making observers before the map is initialised")
	observer.key = key
	observer.client = client
	observer.set_ghost_appearance()
	if(observer.client && observer.client.prefs)
		observer.real_name = observer.client.prefs.real_name
		observer.name = observer.real_name
		observer.client.init_verbs()
	observer.update_icon()
	observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	deadchat_broadcast(" становится призраком.", "<b>[observer.real_name]</b>", follow_target = observer, turf_target = get_turf(observer), message_type = DEADCHAT_DEATHRATTLE)
	QDEL_NULL(mind)
	qdel(src)

	SStitle.update_lobby()

	return TRUE

/proc/get_job_unavailable_error_message(retval, jobtitle)
	switch(retval)
		if(JOB_AVAILABLE)
			return "[jobtitle] доступен."
		if(JOB_UNAVAILABLE_GENERIC)
			return "[jobtitle] недоступен."
		if(JOB_UNAVAILABLE_BANNED)
			return "Тебе нельзя быть [jobtitle]."
		if(JOB_UNAVAILABLE_UNBUYED)
			return "Роль [jobtitle] сначала нужно купить."
		if(JOB_UNAVAILABLE_PLAYTIME)
			return "Ты не наиграл достаточно времени для [jobtitle]."
		if(JOB_UNAVAILABLE_ACCOUNTAGE)
			return "Твой аккаунт слишком молодой для [jobtitle]."
		if(JOB_UNAVAILABLE_SLOTFULL)
			return "[jobtitle] уже достаточно на станции."
	return "Error: Unknown job availability."

/mob/dead/new_player/proc/IsJobUnavailable(rank, latejoin = FALSE)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)
		return JOB_UNAVAILABLE_GENERIC
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		if(job.title == "Assistant")
			if(isnum(client.player_age) && client.player_age <= 14) //Newbies can always be assistants
				return JOB_AVAILABLE
			for(var/datum/job/J in SSjob.occupations)
				if(J && J.current_positions < J.total_positions && J.title != job.title)
					return JOB_UNAVAILABLE_SLOTFULL
		else
			return JOB_UNAVAILABLE_SLOTFULL
	if(is_banned_from(ckey, rank))
		return JOB_UNAVAILABLE_BANNED
	if(QDELETED(src))
		return JOB_UNAVAILABLE_GENERIC
	if(!job.player_old_enough(client))
		return JOB_UNAVAILABLE_ACCOUNTAGE
	if(job.required_playtime_remaining(client))
		return JOB_UNAVAILABLE_PLAYTIME
	if(latejoin && !job.special_check_latejoin(client))
		return JOB_UNAVAILABLE_GENERIC
	if(job.metalocked && !(job.type in client.prefs.jobs_buyed))
		return JOB_UNAVAILABLE_UNBUYED
	return JOB_AVAILABLE

/mob/dead/new_player/proc/AttemptLateSpawn(rank)
	var/error = IsJobUnavailable(rank)
	if(error != JOB_AVAILABLE)
		tgui_alert(usr, get_job_unavailable_error_message(error, rank))
		return FALSE

	//Remove the player from the join queue if he was in one and reset the timer
	SSticker.queued_players -= src
	SSticker.queue_delay = 4

	SSjob.AssignRole(src, rank, 1)

	var/mob/living/character = create_character(TRUE) //creates the human and transfers vars and mind

	var/is_captain = FALSE
	// If we don't have an assigned cap yet, check if this person qualifies for some from of captaincy.
	if(!SSjob.assigned_captain && ishuman(character) && SSjob.chain_of_command[rank] && !is_banned_from(ckey, list("Captain")))
		is_captain = TRUE
	// If we already have a captain, are they a "Captain" rank and are we allowing multiple of them to be assigned?
	else if(SSjob.always_promote_captain_job && (rank == "Captain"))
		is_captain = TRUE

	var/equip = SSjob.EquipRank(character, rank, TRUE, is_captain)
	if(isliving(equip)) //Borgs get borged in the equip, so we need to make sure we handle the new mob.
		character = equip

	var/datum/job/job = SSjob.GetJob(rank)

	if(job && !job.override_latejoin_spawn(character))
		SSjob.SendToLateJoin(character)

		character.update_parallax_teleport()

	SSticker.minds += character.mind
	character.client.init_verbs() // init verbs for the late join
	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character	//Let's retypecast the var to be human,

	if(humanc)	//These procs all expect humans
		humanc.increment_scar_slot()
		humanc.load_persistent_scars()

	GLOB.joined_player_list += character.ckey

	SStitle.update_lobby()

	log_manifest(character.mind.key,character.mind,character,latejoin = TRUE)

/mob/dead/new_player/proc/LateChoices()
	var/list/dat = list()
	if(SSlag_switch.measures[DISABLE_NON_OBSJOBS])
		dat += "<div class='notice red' style='font-size: 125%'>Разрешено только следить на данный момент.</div><br>"
	dat += "<div class='notice'>Длительность истории: [DisplayTimeText(world.time - SSticker.round_start_time)]</div>"
	for(var/datum/job/prioritized_job in SSjob.prioritized_jobs)
		if(prioritized_job.current_positions >= prioritized_job.total_positions)
			SSjob.prioritized_jobs -= prioritized_job
	dat += "<table><tr><td valign='top'>"
	var/column_counter = 0
	// render each category's available jobs
	for(var/category in GLOB.position_categories)
		// position_categories contains category names mapped to available jobs and an appropriate color
		var/cat_color = GLOB.position_categories[category]["color"]
		dat += "<fieldset style='width: 206px; border: 2px solid [cat_color]; display: inline'>"
		dat += "<legend align='center' style='color: #ffffff;'>[GLOB.position_categories[category]["runame"]]</legend>"
		var/list/dept_dat = list()
		for(var/job in GLOB.position_categories[category]["jobs"])
			var/datum/job/job_datum = SSjob.name_occupations[job]
			if(job_datum && IsJobUnavailable(job_datum.title, TRUE) == JOB_AVAILABLE)
				var/command_bold = ""
				if(job_datum in SSjob.prioritized_jobs)
					dept_dat += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'><span class='priority'>[job_datum.ru_title] ([job_datum.current_positions])</span></a>"
				else
					dept_dat += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'>[job_datum.ru_title] ([job_datum.current_positions])</a>"
		if(!dept_dat.len)
			dept_dat += span_nopositions("Нет свободных позиций.")
		dat += jointext(dept_dat, "")
		dat += "</fieldset><br>"
		column_counter++
		if(column_counter > 0 && (column_counter % 3 == 0))
			dat += "</td><td valign='top'>"
	dat += "</td></tr></table></center>"
	dat += "</div></div>"
	var/datum/browser/popup = new(src, "latechoices", "Выбери свою судьбу", 350, 350)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE) // 0 is passed to open so that it doesn't use the onclose() proc

/mob/dead/new_player/proc/create_character(transfer_after)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/H = new(loc)

	var/frn = CONFIG_GET(flag/force_random_names)
	var/admin_anon_names = SSticker.anonymousnames
	if(!frn)
		frn = is_banned_from(ckey, "Appearance")
		if(QDELETED(src))
			return
	if(frn)
		client.prefs.random_character()
		client.prefs.real_name = client.prefs.pref_species.random_name(gender,1)

	if(admin_anon_names)//overrides random name because it achieves the same effect and is an admin enabled event tool
		client.prefs.random_character()
		client.prefs.real_name = anonymous_name(src)

	var/is_antag
	if(mind in GLOB.pre_setup_antags)
		is_antag = TRUE

	client.prefs.copy_to(H, antagonist = is_antag, is_latejoiner = transfer_after)

	client.kill_lobby()

	H.dna.update_dna_identity()
	if(mind)
		if(transfer_after)
			mind.late_joiner = TRUE
		mind.active = FALSE					//we wish to transfer the key manually
		mind.original_character_slot_index = client.prefs.default_slot
		mind.transfer_to(H) //won't transfer key since the mind is not active
		mind.set_original_character(H)

	H.name = real_name
	client.init_verbs()
	. = H
	new_character = .
	if(transfer_after)
		transfer_character()

/mob/dead/new_player/proc/transfer_character()
	. = new_character
	if(.)
		new_character.key = key		//Manually transfer the key to log them in,
		new_character.stop_sound_channel(CHANNEL_LOBBYMUSIC)
		new_character = null
		qdel(src)

/mob/dead/new_player/proc/ViewManifest()
	if(!client)
		return
	if(world.time < client.crew_manifest_delay)
		return
	client.crew_manifest_delay = world.time + (1 SECONDS)

	var/dat = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'></head><body>"
	dat += "<h4>Список персонала</h4>"

	src << browse(dat, "window=manifest;size=387x420;can_close=1")

/mob/dead/new_player/Move()
	return 0


/mob/dead/new_player/proc/close_spawn_windows()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window
	src << browse(null, "window=preferences") //closes job selection
	src << browse(null, "window=mob_occupation")
	src << browse(null, "window=pdec")
	src << browse(null, "window=latechoices") //closes late job selection

// Used to make sure that a player has a valid job preference setup, used to knock players out of eligibility for anything if their prefs don't make sense.
// A "valid job preference setup" in this situation means at least having one job set to low, or not having "return to lobby" enabled
// Prevents "antag rolling" by setting antag prefs on, all jobs to never, and "return to lobby if preferences not available"
// Doing so would previously allow you to roll for antag, then send you back to lobby if you didn't get an antag role
// This also does some admin notification and logging as well, as well as some extra logic to make sure things don't go wrong
/mob/dead/new_player/proc/check_preferences()
	if(!client)
		return FALSE //Not sure how this would get run without the mob having a client, but let's just be safe.
	if(client.prefs.joblessrole != RETURNTOLOBBY)
		return TRUE
	// If they have antags enabled, they're potentially doing this on purpose instead of by accident. Notify admins if so.
	var/has_antags = FALSE
	if(client.prefs.be_special.len > 0)
		has_antags = TRUE
	if(client.prefs.job_preferences.len == 0)
		if(!ineligible_for_roles)
			to_chat(src, span_danger("You have no jobs enabled, along with return to lobby if job is unavailable. This makes you ineligible for any round start role, please update your job preferences."))
		ineligible_for_roles = TRUE
		ready = PLAYER_NOT_READY
		if(has_antags)
			log_admin("[src.ckey] just got booted back to lobby with no jobs, but antags enabled.")
			message_admins("[src.ckey] just got booted back to lobby with no jobs enabled, but antag rolling enabled. Likely antag rolling abuse.")

		return FALSE //This is the only case someone should actually be completely blocked from antag rolling as well
	return TRUE

/**
 * Prepares a client for the interview system, and provides them with a new interview
 *
 * This proc will both prepare the user by removing all verbs from them, as well as
 * giving them the interview form and forcing it to appear.
 */
/mob/dead/new_player/proc/register_for_interview()
	// First we detain them by removing all the verbs they have on client
	for (var/v in client.verbs)
		var/procpath/verb_path = v
		if (!(verb_path in GLOB.stat_panel_verbs))
			remove_verb(client, verb_path)

	// Then remove those on their mob as well
	for (var/v in verbs)
		var/procpath/verb_path = v
		if (!(verb_path in GLOB.stat_panel_verbs))
			remove_verb(src, verb_path)

	// Then we create the interview form and show it to the client
	var/datum/interview/I = GLOB.interviews.interview_for_client(client)
	if (I)
		I.ui_interact(src)

	// Add verb for re-opening the interview panel, and re-init the verbs for the stat panel
	add_verb(src, /mob/dead/new_player/proc/open_interview)
