//- Are all the floors with or without air, as they should be? (regular or airless)
//- Does the area have an APC?
//- Does the area have an Air Alarm?
//- Does the area have a Request Console?
//- Does the area have lights?
//- Does the area have a light switch?
//- Does the area have enough intercoms?
//- Does the area have enough security cameras? (Use the 'Camera Range Display' verb under Debug)
//- Is the area connected to the scrubbers air loop?
//- Is the area connected to the vent air loop? (vent pumps)
//- Is everything wired properly?
//- Does the area have a fire alarm and firedoors?
//- Do all pod doors work properly?
//- Are accesses set properly on doors, pod buttons, etc.
//- Are all items placed properly? (not below vents, scrubbers, tables)
//- Does the disposal system work properly from all the disposal units in this room and all the units, the pipes of which pass through this room?
//- Check for any misplaced or stacked piece of pipe (air and disposal)
//- Check for any misplaced or stacked piece of wire
//- Identify how hard it is to break into the area and where the weak points are
//- Check if the area has too much empty space. If so, make it smaller and replace the rest with maintenance tunnels.

GLOBAL_LIST_INIT(admin_verbs_debug_mapping, list(
	/client/proc/count_objects_on_z_level,
	/client/proc/count_objects_all,
	/client/proc/cmd_assume_direct_control,	//-errorage
	/client/proc/cmd_give_direct_control,
	/client/proc/set_server_fps,	//allows you to set the ticklag.
	#ifdef TESTING
	/client/proc/see_dirty_varedits,
	#endif
	/client/proc/cmd_admin_rejuvenate,
	/datum/admins/proc/show_traitor_panel,
	/client/proc/disable_communication,
	/client/proc/cmd_show_at_list,
	/client/proc/cmd_show_at_markers,
	/client/proc/manipulate_organs,
	/client/proc/start_line_profiling,
	/client/proc/stop_line_profiling,
	/client/proc/show_line_profiling,
	/client/proc/debug_z_levels,
))
GLOBAL_PROTECT(admin_verbs_debug_mapping)

#ifdef TESTING
GLOBAL_LIST_EMPTY(dirty_vars)

/client/proc/see_dirty_varedits()
	set category = "Маппинг"
	set name = "Dirty Varedits"

	var/list/dat = list()
	dat += "<h3>Abandon all hope ye who enter here</h3><br><br>"
	for(var/thing in GLOB.dirty_vars)
		dat += "[thing]<br>"
		CHECK_TICK
	var/datum/browser/popup = new(usr, "dirty_vars", "Dirty Varedits", 900, 750)
	popup.set_content(dat.Join())
	popup.open()
#endif

/client/proc/cmd_show_at_list()
	set category = "Маппинг"
	set name = "Show roundstart AT list"
	set desc = "Displays a list of active turfs coordinates at roundstart"

	var/dat = {"<b>Coordinate list of Active Turfs at Roundstart</b>
		<br>Real-time Active Turfs list you can see in Air Subsystem at active_turfs var<br>"}

	for(var/t in GLOB.active_turfs_startlist)
		var/turf/T = t
		dat += "[ADMIN_VERBOSEJMP(T)]\n"
		dat += "<br>"

	usr << browse(dat, "window=at_list")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Roundstart Active Turfs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_show_at_markers()
	set category = "Маппинг"
	set name = "Show roundstart AT markers"
	set desc = "Places a marker on all active-at-roundstart turfs"

	var/count = 0
	for(var/obj/effect/abstract/marker/at/AT in GLOB.all_abstract_markers)
		qdel(AT)
		count++

	if(count)
		to_chat(usr, "[count] AT markers removed.", confidential = TRUE)
	else
		for(var/t in GLOB.active_turfs_startlist)
			new /obj/effect/abstract/marker/at(t)
			count++
		to_chat(usr, "[count] AT markers placed.", confidential = TRUE)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Roundstart Active Turf Markers")

/client/proc/enable_debug_verbs()
	set category = "Дбг"
	set name = "Debug verbs - Enable"
	if(!check_rights(R_DEBUG))
		return
	remove_verb(src, /client/proc/enable_debug_verbs)
	add_verb(src, list(/client/proc/disable_debug_verbs, GLOB.admin_verbs_debug_mapping))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Enable Debug Verbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/disable_debug_verbs()
	set category = "Дбг"
	set name = "Debug verbs - Disable"
	remove_verb(src, list(/client/proc/disable_debug_verbs, GLOB.admin_verbs_debug_mapping))
	add_verb(src, /client/proc/enable_debug_verbs)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Disable Debug Verbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/count_objects_on_z_level()
	set category = "Маппинг"
	set name = "Count Objects On Level"
	var/level = input("Which z-level?","Level?") as text|null
	if(!level)
		return
	var/num_level = text2num(level)
	if(!num_level)
		return
	if(!isnum(num_level))
		return

	var/type_text = input("Which type path?","Path?") as text|null
	if(!type_text)
		return
	var/type_path = text2path(type_text)
	if(!type_path)
		return

	var/count = 0

	var/list/atom/atom_list = list()

	for(var/atom/A in world)
		if(istype(A,type_path))
			var/atom/B = A
			while(!(isturf(B.loc)))
				if(B?.loc)
					B = B.loc
				else
					break
			if(B)
				if(B.z == num_level)
					count++
					atom_list += A

	to_chat(world, "There are [count] objects of type [type_path] on z-level [num_level]", confidential = TRUE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Count Objects Zlevel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/count_objects_all()
	set category = "Маппинг"
	set name = "Count Objects All"

	var/type_text = input("Which type path?","") as text|null
	if(!type_text)
		return
	var/type_path = text2path(type_text)
	if(!type_path)
		return

	var/count = 0

	for(var/atom/A in world)
		if(istype(A,type_path))
			count++

	to_chat(world, "There are [count] objects of type [type_path] in the game world", confidential = TRUE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Count Objects All") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//This proc is intended to detect lag problems relating to communication procs
GLOBAL_VAR_INIT(say_disabled, FALSE)
/client/proc/disable_communication()
	set category = "Маппинг"
	set name = "Disable all communication verbs"

	GLOB.say_disabled = !GLOB.say_disabled
	if(GLOB.say_disabled)
		message_admins("[key] used 'Disable all communication verbs', killing all communication methods.")
	else
		message_admins("[key] used 'Disable all communication verbs', restoring all communication methods.")

/client/proc/debug_z_levels()
	set name = "Debug Z-Levels"
	set category = "Маппинг"

	var/list/z_list = SSmapping.z_list
	var/list/messages = list()
	messages += "<b>World</b>: [world.maxx] x [world.maxy] x [world.maxz]<br>"

	var/list/linked_levels = list()
	var/min_x = INFINITY
	var/min_y = INFINITY
	var/max_x = -INFINITY
	var/max_y = -INFINITY

	for(var/z in 1 to max(world.maxz, z_list.len))
		if (z > z_list.len)
			messages += "<b>[z]</b>: Unmanaged (out of bounds)<br>"
			continue
		var/datum/space_level/S = z_list[z]
		if (!S)
			messages += "<b>[z]</b>: Unmanaged (null)<br>"
			continue
		var/linkage
		switch (S.linkage)
			if (UNAFFECTED)
				linkage = "no linkage"
			if (SELFLOOPING)
				linkage = "self-looping"
			if (CROSSLINKED)
				linkage = "linked at ([S.xi], [S.yi])"
				linked_levels += S
				min_x = min(min_x, S.xi)
				min_y = min(min_y, S.yi)
				max_x = max(max_x, S.xi)
				max_y = max(max_y, S.yi)
			else
				linkage = "unknown linkage '[S.linkage]'"

		messages += "<b>[z]</b>: [S.name], [linkage], traits: [json_encode(S.traits)]<br>"
		if (S.z_value != z)
			messages += "-- z_value is [S.z_value], should be [z]<br>"
		if (S.name == initial(S.name))
			messages += "-- name not set<br>"
		if (z > world.maxz)
			messages += "-- exceeds max z"

	var/grid[max_x - min_x + 1][max_y - min_y + 1]
	for(var/datum/space_level/S in linked_levels)
		grid[S.xi - min_x + 1][S.yi - min_y + 1] = S.z_value

	messages += "<table border='1'>"
	for(var/y in max_y to min_y step -1)
		var/list/part = list()
		for(var/x in min_x to max_x)
			part += "[grid[x - min_x + 1][y - min_y + 1]]"
		messages += "<tr><td>[part.Join("</td><td>")]</td></tr>"
	messages += "</table>"

	to_chat(src, messages.Join(""), confidential = TRUE)
