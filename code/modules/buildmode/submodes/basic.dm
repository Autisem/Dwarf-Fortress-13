/datum/buildmode_mode/basic
	key = "basic"

/datum/buildmode_mode/basic/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("Left Mouse Button = Construct / Upgrade"))
	to_chat(c, span_notice("Right Mouse Button = Deconstruct / Delete / Downgrade"))
	to_chat(c, span_notice("Left Mouse Button + ctrl = R-Window"))
	to_chat(c, span_notice("Left Mouse Button + alt = Airlock"))
	to_chat(c, span_notice("Use the button in the upper left corner to"))
	to_chat(c, span_notice("change the direction of built objects."))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/basic/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")
	var/ctrl_click = pa.Find("ctrl")
	var/alt_click = pa.Find("alt")

	if(istype(object,/turf) && left_click && !alt_click && !ctrl_click)
		var/turf/T = object
		if(islava(object))
			T.PlaceOnTop(/turf/open/floor/rock)
		else if(isstrictlytype(object, /turf/open/floor/rock))
			T.PlaceOnTop(/turf/open/floor/stone)
		else if(isfloorturf(object))
			T.PlaceOnTop(/turf/closed/wall/stone)
		else if(iswallturf(object))
			return
		log_admin("Build Mode: [key_name(c)] built [T] at [AREACOORD(T)]")
		return
	else if(right_click)
		log_admin("Build Mode: [key_name(c)] deleted [object] at [AREACOORD(object)]")
		if(isturf(object))
			var/turf/T = object
			T.ScrapeAway()
		else if(isobj(object))
			qdel(object)
		return
	else if(istype(object,/turf) && ctrl_click && left_click)
		return
		// log_admin("Build Mode: [key_name(c)] built a window at [AREACOORD(object)]")
