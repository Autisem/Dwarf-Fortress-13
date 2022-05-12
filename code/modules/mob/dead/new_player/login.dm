/mob/dead/new_player/Login()
	if(!client)
		return
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.set_current(src)

	. = ..()
	if(!. || !client)
		return FALSE

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>IMPORTANT NOTICE:</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>Server says:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	sight |= SEE_TURFS

	client.playtitlemusic()

	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/lobby)
	asset_datum.send(client)

	// Check if user should be added to interview queue
	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		var/postfix
		if(tl > 0)
			postfix = "[DisplayTimeText(tl)]"
		else
			postfix = "soon"
		to_chat(src, "Please, setup your character and press \"Ready\". Story will start in [postfix].")

	// if (!GLOB.donators[ckey]) //It doesn't exist yet
	// 	load_donator(ckey)
