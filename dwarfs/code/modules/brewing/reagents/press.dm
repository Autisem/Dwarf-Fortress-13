/obj/structure/press
	name = "Fluid press"
	desc = "Used by dwarves (and not only) to extract sweet (and sour) juices"
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "press_open"
	density = 1
	anchored = 1
	layer = ABOVE_MOB_LAYER
	var/max_items = 10 // how much fruits it can hold
	var/max_volume = 500 // sus
	var/time_to_juice = 1 SECONDS
	var/busy_juicing = FALSE

/obj/structure/press/Initialize()
	. = ..()
	create_reagents(max_volume)

/obj/structure/press/examine(mob/user)
	. = ..()
	if(length(contents))
		.+="<br>It has "
		for(var/obj/O in uniquePathList(contents))
			var/amt = count_by_type(contents, O.type)
			.+="[amt] [O.name][amt > 1 ? "s" : ""]"
		.+=" in it."
	if(reagents.total_volume)
		.+="<br>It has [reagents.get_reagent_names()] in it."
	if(!length(contents) && !reagents.total_volume)
		.+="<br>It's empty."

/obj/structure/press/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/growable))
		var/obj/item/growable/G = I
		if(!G.juice_type)
			to_chat(user, span_warning("[G] cannot be juiced."))
			return FALSE
		if(length(contents) >= max_items)
			to_chat(user, span_warning("[G] doesn't fit anymore!"))
			return FALSE
		G.forceMove(src)
		to_chat(user, span_notice("You add [G] to [src]."))
		icon_state = "press_open_item"
		update_appearance()
	else if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I
		var/transfered = reagents.trans_to(C, 10, transfered_by=user)
		if(!transfered)
			return FALSE
		to_chat(user, span_notice("You take [transfered]u from [src]."))
		update_appearance()
	else
		return ..()

/obj/structure/press/proc/squeeze()
	if(!length(contents))
		return
	var/list/item_types = list()
	var/types_amount = 0
	for(var/obj/item/I in contents)
		if(!(I.type in item_types))
			item_types.Add(I.type)
			types_amount++
	var/obj/item/growable/G = contents[length(contents)]
	var/datum/reagent/R = G.juice_type
	if(types_amount > 1)
		R = /datum/reagent/blood
	var/volume = rand(1, G.juice_volume)
	G.juice_volume -= volume
	reagents.add_reagent(R, volume)
	if(G.juice_volume <= 0)
		for(var/i in 1 to rand(1, 2))
			new G.seed_type(get_turf(src))
		qdel(G)

/obj/structure/press/update_overlays()
	. = ..()
	switch(icon_state)
		if("press_working")
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/32x64.dmi', "working_overlay")
			var/obj/item/growable/G = contents[length(contents)]
			var/_color = initial(G.juice_type.color)
			M.color = _color
			. += M
		if("press_open_item")
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/32x64.dmi', "item_overlay")
			var/obj/item/growable/G = contents[length(contents)]
			var/_color = initial(G.juice_type.color)
			M.color = _color
			. += M
		if("press_finished")
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/32x64.dmi', "finished_overlay")
			var/_color = mix_color_from_reagents(reagents.reagent_list)
			M.color = _color
			. += M

/obj/structure/press/attack_hand(mob/user)
	var/list/choices = list("Juice"=icon('icons/hud/radial.dmi', "radial_juice"), "Eject"=icon('icons/hud/radial.dmi', "radial_eject"))
	var/answer = show_radial_menu(user, src, choices)
	if(answer == "Eject")
		if(!length(contents))
			to_chat(user, span_warning("[src] is empty!"))
			return
		for(var/obj/item/I in contents)
			I.forceMove(get_turf(user))
		if(reagents.maximum_volume)
			icon_state = "press_finished"
		else
			icon_state = "press_open"
		update_appearance()
		to_chat(user, span_notice("You remove everything from [src]."))
	else if(answer == "Juice")
		if(!length(contents))
			to_chat(user, span_warning("There is nothing to juice!"))
			return
		if(busy_juicing)
			to_chat(user, span_warning("[src] is already being used!"))
			return
		icon_state = "press_working"
		update_appearance()
		to_chat(user, span_notice("You start juicing [src]'s contents..."))
		while(length(contents))
			if(!do_after(user, time_to_juice, src))
				break
			squeeze()
		to_chat(user, span_notice("You finish working at [src]..."))
		if(!length(contents))
			icon_state = "press_finished"
			update_appearance()
		else
			icon_state = "press_open_item"
			update_appearance()
