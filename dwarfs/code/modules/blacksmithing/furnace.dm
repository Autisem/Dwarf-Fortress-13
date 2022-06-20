/obj/structure/furnace
	name = "smelter"
	desc = "Looks weird, probably useless."
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 0
	light_color = "#BB661E"
	var/furnacing = FALSE
	var/furnacing_type = "iron"

/obj/structure/furnace/proc/furnaced_thing()
	icon_state = "furnace"
	furnacing = FALSE
	light_range = 0

	switch(furnacing_type)
		if("iron")
			new /obj/item/blacksmith/ingot(drop_location())
		if("gold")
			new /obj/item/blacksmith/ingot/gold(drop_location())

/obj/structure/furnace/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(furnacing)
		to_chat(user, span_alert("[src] is already smelting."))
		return

	if(istype(I, /obj/item/stack/ore/iron) || istype(I, /obj/item/stack/ore/gold))
		var/obj/item/stack/S = I
		if(S.amount >= 5)
			S.use(5)
			furnacing = TRUE
			icon_state = "furnace_on"
			light_range = 3
			to_chat(user, span_notice("[src] lights up."))
			if(istype(I, /obj/item/stack/ore/gold))
				furnacing_type = "gold"
			else
				furnacing_type = "iron"
			addtimer(CALLBACK(src, .proc/furnaced_thing), 15 SECONDS)
		else
			to_chat(user, "<span class=\"alert\">You need at least 5 pieces.</span>")
