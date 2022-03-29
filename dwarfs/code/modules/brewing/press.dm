/obj/structure/press
	name = "juicer"
	desc = "juicy?"
	icon = 'dwarfs/icons/structures/FluidPress.dmi'
	icon_state = "press_open"
	density = 1
	anchored = 1
	var/max_items = 10 // how much fruits it can hold
	var/list/held_items = list() // list of held items
	var/max_volume = 500 // sus
	var/time_to_juice = 1 SECONDS
	var/busy_juicing = FALSE

/obj/structure/press/Initialize()
	. = ..()
	create_reagents(max_volume)

/obj/structure/press/examine(mob/user)
	. = ..()
	if(length(held_items))
		.+="<br>It has [jointext(held_items, ", ")] in it."
	if(reagents.total_volume)
		.+="<br>It has [reagents.get_reagent_names()] in it."
	if(!length(held_items) && !reagents.total_volume)
		.+="<br>It's empty."

/obj/structure/press/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/growable))
		var/obj/item/growable/G = I
		if(!G.juice_type)
			to_chat(user, span_warning("[G] cannot be juiced."))
			return
		if(length(held_items) > max_items)
			to_chat(user, span_warning("[G] doesn't fit anymore!"))
			return
		held_items.Add(G)
		G.forceMove(src)
		to_chat(user, span_notice("You add [G] to [src]."))
		icon_state = "press_open_item"
		update_appearance()
	else
		return ..()

/obj/structure/press/proc/squeeze()
	if(!length(held_items))
		return
	var/list/item_types = list()
	var/types_amount = 0
	for(var/obj/item/I in held_items)
		if(!(I.type in item_types))
			item_types.Add(I.type)
			types_amount++
	var/obj/item/growable/G = held_items[length(held_items)]
	var/datum/reagent/R = G.juice_type
	if(types_amount > 1)
		R = /datum/reagent/blood
	var/volume = rand(1, G.juice_volume)
	G.juice_volume -= volume
	reagents.add_reagent(R, volume)
	if(G.juice_volume <= 0)
		held_items.Remove(G)
		for(var/i in 1 to rand(1, 2))
			new G.seed_type(get_turf(src))
		qdel(G)

/obj/structure/press/update_overlays()
	. = ..()
	switch(icon_state)
		if("press_working")
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/FluidPress.dmi', "working_overlay")
			M.color = initial(held_items[length(held_items)].juice_type.color)
			. += M
		if("press_open_item")
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/FluidPress.dmi', "item_overlay")
			M.color = initial(held_items[length(held_items)].juice_type.color)
			. += M
		if("press_finished")
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/FluidPress.dmi', "finished_overlay")
			M.color = mix_color_from_reagents(reagents.reagent_list)
			. += M

/obj/structure/press/attack_hand(mob/user)
	var/list/choices = list("Juice"=icon('icons/hud/radial.dmi', "radial_juice"), "Eject"=icon('icons/hud/radial.dmi', "radial_eject"))
	var/answer = show_radial_menu(user, src, choices)
	if(answer == "Eject")
		if(!length(held_items))
			to_chat(user, span_warning("[src] is empty!"))
			return
		for(var/obj/item/I in held_items)
			held_items.Remove(I)
			I.forceMove(get_turf(src))
		icon_state = "press_open"
		update_appearance()
		to_chat(user, span_notice("You remove everything from [src]."))
	else if(answer == "Juice")
		if(!length(held_items))
			to_chat(user, span_warning("There is nothing to juice!"))
			return
		if(busy_juicing)
			to_chat(user, span_warning("[src] is already being used!"))
			return
		icon_state = "press_working"
		update_appearance()
		to_chat(user, span_notice("You start juicing [src]'s contents..."))
		while(length(held_items))
			if(!do_after(user, time_to_juice, src))
				break
			squeeze()
		to_chat(user, span_notice("You finish working at [src]..."))
		if(!length(held_items))
			icon_state = "press_finished"
			update_appearance()
		else
			icon_state = "press_open_item"
			update_appearance()
