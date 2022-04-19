/*
 * False Walls
 */
/obj/structure/falsewall
	name = "стена"
	desc = "Здоровенный кусок металла, который служит для разделения помещений."
	gender = FEMALE
	anchored = TRUE
	icon = 'icons/turf/walls/baywall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	layer = LOW_OBJ_LAYER
	density = TRUE
	opacity = TRUE
	max_integrity = 100
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS)
	can_be_unanchored = FALSE
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	rad_insulation = RAD_MEDIUM_INSULATION
	var/mineral = /obj/item/stack/sheet/iron
	var/mineral_amount = 2
	var/walltype = /turf/closed/wall
	var/girder_type = /obj/structure/girder/displaced
	var/opening = FALSE

/obj/structure/falsewall/attack_hand(mob/user)
	if(opening)
		return
	. = ..()
	if(.)
		return

	opening = TRUE
	update_icon()
	if(!density)
		var/srcturf = get_turf(src)
		for(var/mob/living/obstacle in srcturf) //Stop people from using this as a shield
			opening = FALSE
			return
	addtimer(CALLBACK(src, /obj/structure/falsewall/proc/toggle_open), 5)

/obj/structure/falsewall/proc/toggle_open()
	if(!QDELETED(src))
		set_density(!density)
		set_opacity(density)
		opening = FALSE
		update_icon()

/obj/structure/falsewall/update_icon()//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	if(opening)
		if(density)
			icon_state = "fwall_opening"
			smoothing_flags = NONE
			clear_smooth_overlays()
		else
			icon_state = "fwall_closing"
	else
		if(density)
			icon_state = "[base_icon_state]-[smoothing_junction]"
			smoothing_flags = SMOOTH_BITMASK
			QUEUE_SMOOTH(src)
		else
			icon_state = "fwall_open"
	return ..()

/obj/structure/falsewall/proc/ChangeToWall(delete = 1)
	var/turf/T = get_turf(src)
	T.PlaceOnTop(walltype)
	if(delete)
		qdel(src)
	return T

/obj/structure/falsewall/attackby(obj/item/W, mob/user, params)
	if(opening)
		to_chat(user, span_warning("НАДО ПОДОЖДАТЬ!"))
		return

	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(density)
			var/turf/T = get_turf(src)
			if(T.density)
				to_chat(user, span_warning("[src.name] заблокирована!"))
				return
			if(!isfloorturf(T))
				to_chat(user, span_warning("[src.name] не ощущает пола под собой!"))
				return
			user.visible_message(span_notice("[user] затягивает болты стены.") , span_notice("Затягиваю болты стены."))
			ChangeToWall()
		else
			to_chat(user, span_warning("Не могу достать до болтов! Закрыть бы её!"))

	else if(W.tool_behaviour == TOOL_WELDER)
		if(W.use_tool(src, user, 0, volume=50))
			dismantle(user, TRUE)
	else
		return ..()

/obj/structure/falsewall/proc/dismantle(mob/user, disassembled=TRUE, obj/item/tool = null)
	user.visible_message(span_notice("[user] dismantles the false wall.") , span_notice("You dismantle the false wall."))
	if(tool)
		tool.play_tool_sound(src, 100)
	else
		playsound(src, 'sound/items/welder.ogg', 100, TRUE)
	deconstruct(disassembled)

/obj/structure/falsewall/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			new girder_type(loc)
		if(mineral_amount)
			for(var/i in 1 to mineral_amount)
				new mineral(loc)
	qdel(src)

/obj/structure/falsewall/get_dumping_location(obj/item/storage/source,mob/user)
	return null

/obj/structure/falsewall/examine_status(mob/user) //So you can't detect falsewalls by examine.
	to_chat(user, span_notice("Внешнее покрытие <b>приварено</b> крепко."))
	return null

