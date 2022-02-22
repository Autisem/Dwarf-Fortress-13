SUBSYSTEM_DEF(title)
	name = "Title"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	var/file_path
	var/icon/icon
	var/icon/previous_icon
	var/turf/closed/indestructible/splashscreen/splash_turf
	var/cached_title

/datum/controller/subsystem/title/Initialize()
	if(file_path && icon)
		return

	if(fexists("data/previous_title.dat"))
		var/previous_path = file2text("data/previous_title.dat")
		if(istext(previous_path))
			previous_icon = new(previous_icon)
	fdel("data/previous_title.dat")

	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/title_screens = list()
	var/use_rare_screens = prob(1)

	for(var/S in provisional_title_screens)
		var/list/L = splittext(S,"+")
		if((L.len == 1 && (L[1] != "exclude" && L[1] != "blank.png"))|| (L.len > 1 && ((use_rare_screens && lowertext(L[1]) == "rare"))))
			title_screens += S

	if(length(title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(title_screens)]"

	if(!file_path)
		file_path = "icons/runtime/default_title.dmi"

	ASSERT(fexists(file_path))

	icon = new(fcopy_rsc(file_path))

	if(splash_turf)
		splash_turf.icon = icon

	return ..()

/datum/controller/subsystem/title/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, icon))
				if(splash_turf)
					splash_turf.icon = icon

/datum/controller/subsystem/title/Shutdown()
	if(file_path)
		var/F = file("data/previous_title.dat")
		WRITE_FILE(F, file_path)

	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/atom/movable/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)

/datum/controller/subsystem/title/Recover()
	icon = SStitle.icon
	splash_turf = SStitle.splash_turf
	file_path = SStitle.file_path
	previous_icon = SStitle.previous_icon

/datum/controller/subsystem/title/proc/update_players_table()
	var/list/caa = list()
	var/list/cum = list()
	var/tcc = "<table><thead><tr><th class='rhead'>Role</th><th>Ready</th></tr></thead><tbody>"
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			var/role_thing = "Unknown"
			if(GLOB.disable_fucking_station_shit_please)
				caa["Выживший"] += list(player.key)
				continue
			if(player.client.prefs.job_preferences["Dwarf"])
				role_thing = "Dwarf"
			else
				for(var/j in player.client.prefs.job_preferences)
					if(player.client.prefs.job_preferences[j] == JP_HIGH)
						var/datum/job/jobdatum = SSjob.GetJob(j)
						if(jobdatum)
							role_thing = jobdatum
							break
			if(!caa[role_thing])
				caa[role_thing] = list(player.key)
			else
				caa[role_thing] += "[player.key]"
		else
			cum += "[player.key]"
	if(SSticker.current_state <= GAME_STATE_PREGAME)
		for(var/line in sort_list(caa))
			tcc += "<tr><td class='role'>[line]</td><td>[english_list(caa[line])]</td></tr>"
		tcc += "<tr><td class='role'>Not ready</td><td>"
	else
		tcc += "<tr><td class='role'>Chat-Bots</td><td>"
	tcc += "[english_list(cum)]</td></tr></tbody></table>"
	cached_title = tcc

/client/proc/show_lobby()
	usr << browse(file('html/lobby.html'), "window=pdec;display=1;is-visible=false;size=300x650;border=0;can_close=1;can_resize=1;can_minimize=1;titlebar=1;is-disabled=false;")
	winset(usr, "pdec", "pos=10,60")
	update_lobby()
	spawn(100)
		if(usr)
			winset(usr, "pdec", "is-visible=true;pos=10,60")
		SStitle.update_lobby()

/client/proc/kill_lobby()
	src << browse(null, "window=pdec")
	winset(src, "pdec", "is-disabled=true;is-visible=false")

/client/proc/update_lobby()
	src << output(SStitle.cached_title, "pdec.browser:drawit")

/datum/controller/subsystem/title/proc/update_lobby()
	update_players_table()
	for(var/mob/dead/new_player/D in GLOB.new_player_list)
		if(D?.client)
			D.client.update_lobby()
