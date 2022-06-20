/obj/structure/forge
	name = "forge"
	desc = "Heats up various things, sometimes even ingots."
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "forge"
	light_range = 9
	light_color = "#BB661E"
	layer = ABOVE_MOB_LAYER
	density = TRUE
	anchored = TRUE
	var/fuel = 0
	var/fuel_consumption = 1 // consumes x fuel per /process
	var/list/fuel_values = list(/obj/item/stack/sheet/mineral/coal = 15)
	var/working = FALSE

/obj/structure/forge/update_icon_state()
	. = ..()
	if(working)
		icon_state = "forge_working"
	else if(fuel)
		icon_state = "forge_fueled"
	else
		icon_state = "forge"

/obj/structure/forge/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/forge/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/forge/process(delta_time)
	if(!working)
		return
	if(!fuel)
		working = FALSE
		update_appearance()
		return
	fuel = clamp(fuel-fuel_consumption, 0, fuel)


/obj/structure/forge/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(I.type in fuel_values)
		var/obj/item/stack/S = I
		src.visible_message(span_notice("[user] throws [S] into [src]."), span_notice("You throw [S] into [src]."))
		fuel+=S.amount*fuel_values[I.type]
		qdel(S)
		update_appearance()
	else if(I.get_temperature())
		if(!fuel)
			to_chat(user, span_warning("[src] has no fuel."))
			return
		working = TRUE
		update_appearance()
		to_chat(user, span_notice("You light up [src]."))
	else if(istype(I, /obj/item/blacksmith/tongs))
		if(!working)
			to_chat(user, span_warning("[src] has to be lit up first."))
			return
		if(I.contents.len)
			if(istype(I.contents[I.contents.len], /obj/item/blacksmith/ingot))
				if(do_after(user, 10, src))
					var/obj/item/blacksmith/ingot/N = I.contents[I.contents.len]
					N.heattemp = 350
					I.update_appearance()
					to_chat(user, span_notice("You heat up [N]."))
		else
			to_chat(user, span_warning("[I] has nothing to heat up."))
	else
		return ..()
