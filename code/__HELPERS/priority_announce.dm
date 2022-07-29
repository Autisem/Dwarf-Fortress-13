/proc/priority_announce(text, title = "", sound, type, sender_override, has_important_message)
	if(!text)
		return

	var/announcement
	//announcement += "<hr class='veryalert'>"

	if(type == "Priority")
		announcement += "<h1 class='alert'>Priority Announcement</h1>"
		if (title && length(title) > 0)
			announcement += "<h2 class='alert'>[html_encode(title)]</h2>"
	else if(type == "Captain")
		announcement += "<h1 class='alert'>Captain Announcement</h1>"

	else
		if(!sender_override)
			announcement += "<h1 class='alert'>[command_name()]</h1>"
		else
			announcement += "<h1 class='alert'>[sender_override]</h1>"
		if (title && length(title) > 0)
			announcement += "<h2 class='alert'>[html_encode(title)]</h2>"

	announcement += span_alert("<big>[html_encode(text)]</big>")
	announcement += "\n\n"

	var/s = sound(sound)
	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && M.can_hear() && (is_fortress_level(M.z) || is_marx_level(M.z)))
			to_chat(M, announcement)
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				SEND_SOUND(M, s)

/proc/minor_announce(message, title = "Attention!", alert, html_encode = TRUE)
	if(!message)
		return

	if (html_encode)
		title = html_encode(title)
		message = html_encode(message)

	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && M.can_hear() && (is_fortress_level(M.z) || is_marx_level(M.z)))
			to_chat(M, "<h1 class='alert'>[title]</h1><span class='alert'><big>[message]</big></span>\n\n")
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				if(alert)
					SEND_SOUND(M, sound('sound/misc/notice1.ogg'))
				else
					SEND_SOUND(M, sound('sound/misc/notice2.ogg'))
