/obj/structure/smelter
	name = "smelter"
	desc = "Looks weird, probably useless."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "smelter"
	density = TRUE
	anchored = TRUE
	light_range = 0
	light_color = "#BB661E"
	var/working = FALSE
	var/fuel = 0
	var/smelting_time = 1 MINUTES
	var/timerid

/obj/structure/smelter/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/smelter/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/smelter/update_icon_state()
	. = ..()
	if(working)
		icon_state = "smelter_working"
	else if(fuel)
		icon_state = "smelter_fueled"
	else
		icon_state = "smelter"

/obj/structure/smelter/proc/_update_light()
	if(working)
		light_range = 3
	else
		light_range = 0

/obj/structure/smelter/update_appearance(updates)
	. = ..()
	_update_light()

/obj/structure/smelter/proc/smelted_thing()
	var/obj/item/I = contents[1]
	I.forceMove(get_turf(src))
	if(contents.len)
		start_smelting()

/obj/structure/smelter/proc/start_smelting()
	timerid = addtimer(CALLBACK(src, .proc/smelted_thing), smelting_time, TIMER_STOPPABLE)

/obj/structure/smelter/proc/remove_timer()
	if(active_timers)
		deltimer(timerid)

/obj/structure/smelter/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/stack/ore/iron) || istype(I, /obj/item/stack/ore/gold))
		var/obj/item/stack/S = I
		if(!S.use(5))
			to_chat(user, span_warning("You need at leat 5 pieces."))
			return
		to_chat(user, span_notice("[src] you place [S] into [src]."))
		var/obj/item/ingot_type
		if(istype(I, /obj/item/stack/ore/gold))
			ingot_type = /obj/item/blacksmith/ingot/gold
		else
			ingot_type = /obj/item/blacksmith/ingot
		new ingot_type(src)
		if(working)
			start_smelting()
	else if(I.get_temperature())
		if(!fuel)
			to_chat(user, span_warning("[src] has no fuel."))
			return
		if(working)
			to_chat(user, span_warning("[src] is already lit."))
			return
		to_chat(user, span_notice("You light up [src]."))
		working = TRUE
		if(contents.len)
			start_smelting()
		update_appearance()
	else if(istype(I, /obj/item/stack/sheet/mineral/coal))
		var/obj/item/stack/sheet/mineral/coal/C = I
		fuel += C.amount*15
		qdel(C)
		to_chat(user, span_notice("You throw [C] into [src]."))
		update_appearance()
	else
		. = ..()

/obj/structure/smelter/process(delta_time)
	if(!working)
		return
	if(!fuel)
		working = FALSE
		update_appearance()
		remove_timer()
	fuel = max(fuel-1, 0)
