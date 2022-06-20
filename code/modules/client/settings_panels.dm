////////////////////////////////////////////////
//
//
// chat settings
//
//
////////////////////////////////////////////////

/datum/chat_settings_panel/New(user)
	ui_interact(user)

/datum/chat_settings_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChatSettingsPanel")
		ui.open()

/datum/chat_settings_panel/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/chat_settings_panel/ui_data(mob/user)
	. = list()
	.["ghost"] = list()
	for(var/key in GLOB.ghost_chat_settings_list_desc)
		.["ghost"] += list(list(
			"key" = GLOB.ghost_chat_settings_list_desc[key],
			"enabled" = !(user.client.prefs.chat_toggles & GLOB.ghost_chat_settings_list_desc[key]),
			"desc" = key,
			"type" = "chat"
		))
	for(var/key in GLOB.ghost_events_settings_list_desc)
		.["ghost"] += list(list(
			"key" = GLOB.ghost_events_settings_list_desc[key],
			"enabled" = (user.client.prefs.toggles & GLOB.ghost_events_settings_list_desc[key]),
			"desc" = key,
			"type" = "events"
		))
	.["ic"] = list()
	for(var/key in GLOB.ic_settings_list_desc)
		.["ic"] += list(list(
			"key" = GLOB.ic_settings_list_desc[key],
			"enabled" = !(user.client.prefs.chat_toggles & GLOB.ic_settings_list_desc[key]),
			"desc" = key,
			"type" = "chat"
		))
	.["chat"] = list()
	for(var/key in GLOB.chat_settings_list_desc)
		.["chat"] += list(list(
			"key" = GLOB.chat_settings_list_desc[key],
			"enabled" = !(user.client.prefs.chat_toggles & GLOB.chat_settings_list_desc[key]),
			"desc" = key,
			"type" = "chat"
		))

/datum/chat_settings_panel/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch (action)
		if ("chat")
			var/key = params["key"]
			if (key)
				usr.client.prefs.chat_toggles ^= key
		if ("events")
			var/key = params["key"]
			if (key)
				usr.client.prefs.toggles ^= key
	. = TRUE

////////////////////////////////////////////////
//
//
// sound settings
//
//
////////////////////////////////////////////////

/datum/sound_panel/New(user)
	ui_interact(user)

/datum/sound_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SoundPanelSettings")
		ui.open()

/datum/sound_panel/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/sound_panel/ui_data(mob/user)

	if(!usr?.client)
		return

	var/client/C = usr.client

	var/list/data = list()

	data["adminhelp"] 		= C.prefs.toggles & SOUND_ADMINHELP
	data["midi"] 			= C.prefs.toggles & SOUND_MIDI
	data["ambience"] 		= C.prefs.toggles & SOUND_AMBIENCE
	data["lobby"] 			= C.prefs.toggles & SOUND_LOBBY
	data["instruments"] 	= C.prefs.toggles & SOUND_INSTRUMENTS
	data["ship_ambience"] 	= C.prefs.toggles & SOUND_SHIP_AMBIENCE
	data["prayers"] 		= C.prefs.toggles & SOUND_PRAYERS
	data["announcements"] 	= C.prefs.toggles & SOUND_ANNOUNCEMENTS
	data["endofround"] 		= C.prefs.toggles & SOUND_ENDOFROUND
	data["jukebox"] 		= C.prefs.w_toggles & SOUND_JUKEBOX

	return data

/datum/sound_panel/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!usr?.client?.prefs)
		return

	var/client/C = usr.client

	switch(action)
		if("adminhelp")
			C.prefs.toggles ^= SOUND_ADMINHELP
		if("midi")
			C.prefs.toggles ^= SOUND_MIDI
			C?.tgui_panel?.stop_music()
			usr.stop_sound_channel(CHANNEL_ADMIN)
		if("ambience")
			C.prefs.toggles ^= SOUND_AMBIENCE
			usr.stop_sound_channel(CHANNEL_AMBIENCE)
			usr.stop_sound_channel(CHANNEL_BUZZ)
			usr.client.update_ambience_pref()
		if("lobby")
			C.prefs.toggles ^= SOUND_LOBBY
			usr.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			if(isnewplayer(usr))
				C.playtitlemusic()
		if("instruments")
			C.prefs.toggles ^= SOUND_INSTRUMENTS
		if("ship_ambience")
			C.prefs.toggles ^= SOUND_SHIP_AMBIENCE
			usr.stop_sound_channel(CHANNEL_BUZZ)
		if("prayers")
			C.prefs.toggles ^= SOUND_PRAYERS
		if("announcements")
			C.prefs.toggles ^= SOUND_ANNOUNCEMENTS
		if("endofround")
			C.prefs.toggles ^= SOUND_ENDOFROUND
		if("jukebox")
			C.prefs.w_toggles ^= SOUND_JUKEBOX
			usr.stop_sound_channel(CHANNEL_JUKEBOX)

	C.prefs.save_preferences()
	. = TRUE

/datum/hud/proc/add_emote_panel(mob/owner)
	var/atom/movable/screen/using

	using = new /atom/movable/screen/emote_button()
	using.screen_loc = ui_emotes
	using.hud = src
	infodisplay += using

/atom/movable/screen/emote_button
	name = "Emotes"
	icon = 'icons/hud/midnight_extended.dmi'
	icon_state = "emotes"
	var/cooldown = 0

/atom/movable/screen/emote_button/Click()
	ui_interact(usr)

/atom/movable/screen/emote_button/MouseEntered()
	flick(icon_state + "_anim", src)

/atom/movable/screen/emote_button/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EmoteMenu", name)
		ui.open()

/atom/movable/screen/emote_button/ui_status(mob/user)
	return UI_INTERACTIVE

/atom/movable/screen/emote_button/ui_data(mob/user)
	var/list/L = list()
	var/list/keys = list()

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key
				L.Add(list(list("name" = P.key, "name" = capitalize(P.key))))

	var/list/data = list()
	data["emotes"] = L

	return data

/atom/movable/screen/emote_button/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(cooldown <= world.time)
		cooldown = world.time + 1 SECONDS
		usr.emote("[action]")
		. = TRUE
