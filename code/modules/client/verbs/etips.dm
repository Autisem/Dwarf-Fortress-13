/client/verb/toggle_tips()
	set name = "Tips near cursor"
	set desc = "Toggles examine hover-over tooltips"
	set category = "Settings"

	prefs.enable_tips = !prefs.enable_tips
	prefs.save_preferences()
	to_chat(usr, span_danger("Examine tooltips [prefs.enable_tips ? "en" : "dis"]abled."))

/client/verb/change_tip_delay()
	set name = "Tips: delay"
	set desc = "Sets the delay in milliseconds before examine tooltips appear"
	set category = "Settings"

	var/indelay = stripped_input(usr, "Enter the tooltip delay in milliseconds (default: 500)", "Enter tooltip delay", "", 10)
	indelay = text2num(indelay)
	if(usr)//is this what you mean?
		prefs.tip_delay = indelay
		prefs.save_preferences()
		to_chat(usr, span_danger("Tooltip delay set to [indelay] milliseconds."))
