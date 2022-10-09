/obj/item/log
	name = "log"
	desc = "Flat."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "log"
	throw_range = 0
	w_class = WEIGHT_CLASS_BULKY

/obj/item/log/get_fuel()
	return 50 // 5 planks

/obj/item/log/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	pixel_x += rand(-8,8)
	pixel_y += rand(-8,8)

/obj/item/log/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_AXE)
		to_chat(user, span_notice("You start cutting [src] into planks..."))
		var/cutting_time = 10 SECONDS * user.mind.get_skill_modifier(/datum/skill/logging, SKILL_SPEED_MODIFIER)
		if(!I.use_tool(src, user, cutting_time))
			return
		var/my_turf = get_turf(src)
		user.mind.adjust_experience(/datum/skill/logging, 12)
		var/plank_amt = rand(4, 6)
		new /obj/item/stack/sheet/planks(my_turf, plank_amt)
		qdel(src)
	else
		return ..()

/obj/item/log/large
	name = "large log"
	desc = "Big flat."
	icon_state = "large_log"
	density = 1
	w_class = WEIGHT_CLASS_GIGANTIC
	var/small_log_type = /obj/item/log

/obj/item/log/large/get_fuel()
	return 3 * 50 // 3 logs each 5 planks

/obj/item/log/large/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	pixel_x = rand(-3,3)
	pixel_y = rand(-3,3)

/obj/item/log/large/pickup(mob/user)
	to_chat(user, span_notice("You start lifting [src]..."))
	if(!do_after(user, 10 SECONDS, src))
		return FALSE
	. = ..()

/obj/item/log/large/dropped(mob/user, silent)
	. = ..()
	dir = user.dir

/obj/item/log/large/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_AXE)
		to_chat(user, span_notice("You start cutting [src] into pieces..."))
		var/cutting_time = 10 SECONDS * user.mind.get_skill_modifier(/datum/skill/logging, SKILL_SPEED_MODIFIER)
		if(!I.use_tool(src, user, cutting_time))
			return
		var/my_turf = get_turf(src)
		user.mind.adjust_experience(/datum/skill/logging, 12)
		for(var/i in 1 to 3)
			new small_log_type(my_turf)
		qdel(src)
	else
		return ..()

/obj/item/log/towercap
	name = "towercap log"
	icon_state = "towercap_log"

/obj/item/log/large/towercap
	name = "large towercap log"
	icon_state = "large_towercap"
	small_log_type = /obj/item/log/towercap
