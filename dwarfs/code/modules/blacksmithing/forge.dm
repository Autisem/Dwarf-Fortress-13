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
	if(prob(20))
		playsound(src, 'dwarfs/sounds/effects/fire_cracking_short.ogg', 100, TRUE)
	if(!fuel)
		working = FALSE
		update_appearance()
		return
	fuel = clamp(fuel-fuel_consumption, 0, fuel)


/obj/structure/forge/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(I.get_fuel())
		user.visible_message(span_notice("[user] throws [I] into [src]."), span_notice("You throw [I] into [src]."))
		fuel+=I.get_fuel()
		qdel(I)
		update_appearance()
	else if(I.get_temperature())
		if(!fuel)
			to_chat(user, span_warning("[src] has no fuel."))
			return
		working = TRUE
		update_appearance()
		to_chat(user, span_notice("You light up [src]."))
		playsound(src, 'dwarfs/sounds/effects/ignite.ogg', 50, TRUE)
	else if(istype(I, /obj/item/tongs))
		if(!working)
			to_chat(user, span_warning("[src] has to be lit up first."))
			return
		if(I.contents.len)
			if(istype(I.contents[I.contents.len], /obj/item/ingot))
				if(do_after(user, 10, src))
					var/obj/item/ingot/N = I.contents[I.contents.len]
					N.heattemp = 350
					I.update_appearance()
					to_chat(user, span_notice("You heat up [N]."))
		else
			to_chat(user, span_warning("[I] has nothing to heat up."))
	else
		return ..()
