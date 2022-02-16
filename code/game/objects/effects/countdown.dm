/obj/effect/countdown
	name = "countdown"
	desc = "We're leaving together\n\
		But still it's farewell\n\
		And maybe we'll come back\n\
		To Earth, who can tell?"

	invisibility = INVISIBILITY_OBSERVER
	anchored = TRUE
	color = "#ff0000" // text color
	var/text_size = 3 // larger values clip when the displayed text is larger than 2 digits.
	var/started = FALSE
	var/displayed_text
	var/atom/attached_to

/obj/effect/countdown/Initialize()
	. = ..()
	attach(loc)

/obj/effect/countdown/examine(mob/user)
	. = ..()
	. += "<hr>This countdown is displaying: [displayed_text]."

/obj/effect/countdown/proc/attach(atom/A)
	attached_to = A
	forceMove(get_turf(A))

/obj/effect/countdown/proc/start()
	if(!started)
		START_PROCESSING(SSfastprocess, src)
		started = TRUE

/obj/effect/countdown/proc/stop()
	if(started)
		maptext = null
		STOP_PROCESSING(SSfastprocess, src)
		started = FALSE

/obj/effect/countdown/proc/get_value()
	// Get the value from our atom
	return

/obj/effect/countdown/process()
	if(!attached_to || QDELETED(attached_to))
		qdel(src)
	forceMove(get_turf(attached_to))
	var/new_val = get_value()
	if(new_val == displayed_text)
		return
	displayed_text = new_val

	if(displayed_text)
		maptext = MAPTEXT("<font size = [text_size]>[displayed_text]</font>")
	else
		maptext = null

/obj/effect/countdown/Destroy()
	attached_to = null
	STOP_PROCESSING(SSfastprocess, src)
	. = ..()

/obj/effect/countdown/flower_bud
	name = "flower bud countdown"

/obj/effect/countdown/flower_bud/get_value()
	var/obj/structure/alien/resin/flower_bud/bud = attached_to
	if(!istype(bud))
		return
	if(!bud.finish_time)
		return -1
	var/time_left = max(0, (bud.finish_time - world.time) / 10)
	return time_left
