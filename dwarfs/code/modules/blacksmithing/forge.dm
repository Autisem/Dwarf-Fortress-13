/obj/structure/forge
	name = "forge"
	desc = "Heats up various things, sometimes even ingots."
	icon = 'white/kacherkin/icons/dwarfs/obj/forge.dmi'
	icon_state = "forge_on"
	light_range = 9
	light_color = "#BB661E"
	density = TRUE
	anchored = TRUE
	var/fuel = 180
	var/fuel_consumption = 1
	var/list/fuel_values = list(/obj/item/stack/sheet/mineral/coal = 15, /obj/item/stack/sheet/mineral/wood = 10)
	var/busy_heating = FALSE

/obj/structure/forge/Initialize(mapload)
	. = ..()
	flick("forge_start", src)
	START_PROCESSING(SSprocessing, src)

/obj/structure/forge/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/forge/process(delta_time)
	if(fuel >= fuel_consumption)
		fuel-=fuel_consumption
	else
		fuel = 0
		if(icon_state != "forge_off")
			icon_state = "forge_off"
			flick("forge_shutdown", src)

/obj/structure/forge/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(I.type in fuel_values)
		var/obj/item/stack/S = I
		src.visible_message(span_notice("[user] throws [S] into [src]."), span_notice("You throw [S] into [src]."))
		fuel+=S.amount*fuel_values[I.type]
		qdel(S)
		if(icon_state != "forge_on")
			icon_state = "forge_on"
			flick("forge_start", src)
	else if(istype(I, /obj/item/blacksmith/tongs))
		if(I.contents.len)
			if(!fuel)
				to_chat(user, span_warning("No fuel."))
				return
			if(istype(I.contents[I.contents.len], /obj/item/blacksmith/ingot))
				if(!busy_heating)
					busy_heating = TRUE
					if(do_after(user, 10, src))
						var/obj/item/blacksmith/ingot/N = I.contents[I.contents.len]
						N.heattemp = 350
						I.icon_state = "tongs_hot"
						to_chat(user, span_notice("You heat up [N]."))
					busy_heating = FALSE
		else
			to_chat(user, span_warning("Are you retarded?"))
			return
