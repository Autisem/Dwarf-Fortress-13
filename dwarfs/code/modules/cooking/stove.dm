// TODO: add particle effects when working; add sounds; add light changes when lighting up

/obj/structure/stove
	name = "stove"
	desc = "Cook cock"
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "stove_closed_empty"
	density = 1
	anchored = 1
	var/open = FALSE
	var/fuel = 0
	var/working = FALSE
	var/heat = 373.15
	/// To remember which is placed where
	var/obj/item/reagent_containers/glass/cooking_pot/left_item
	var/obj/item/reagent_containers/glass/cooking_pot/right_item

/obj/structure/stove/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/stove/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/stove/update_icon_state()
	. = ..()
	if(working)
		icon_state = "stove_working"
	else if(open)
		if(fuel)
			icon_state = "stove_open_fueled"
		else
			icon_state = "stove_open_empty"
	else
		if(fuel)
			icon_state = "stove_closed_fueled"
		else
			icon_state = "stove_closed_empty"

/obj/structure/stove/update_overlays()
	. = ..()
	if(!contents.len)
		return
	if(left_item)
		var/mutable_appearance/M = mutable_appearance('dwarfs/icons/items/kitchen.dmi', "[left_item.open ? "cooking_pot_world_open" : "cooking_pot_world_closed"]")
		if(left_item.reagents.total_volume && left_item.open)
			var/mutable_appearance/O = mutable_appearance('dwarfs/icons/items/kitchen.dmi', "cooking_pot_world_overlay")
			O.color = mix_color_from_reagents(left_item.reagents.reagent_list)
			M.overlays+=O
		M.pixel_x = clamp(10 - 16, -(world.icon_size/2), world.icon_size/2)
		.+=M
	if(right_item)
		var/mutable_appearance/M = mutable_appearance('dwarfs/icons/items/kitchen.dmi', "[right_item.open ? "cooking_pot_world_open" : "cooking_pot_world_closed"]")
		if(right_item.reagents.total_volume && right_item.open)
			var/mutable_appearance/O = mutable_appearance('dwarfs/icons/items/kitchen.dmi', "cooking_pot_world_overlay")
			O.color = mix_color_from_reagents(right_item.reagents.reagent_list)
			M.overlays+=O
		M.pixel_x = clamp(24 - 16, -(world.icon_size/2), world.icon_size/2)
		.+=M

/obj/structure/stove/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/cooking_pot))
		if(left_item)
			to_chat(user, span_warning("This place is already occupied by [left_item]."))
			return TRUE
		I.forceMove(src)
		left_item = I
		update_appearance()
	else if(I.get_temperature())
		if(!fuel)
			to_chat(user, span_warning("[src] has no fuel."))
			return TRUE
		if(open)
			to_chat(user, span_warning("[src] has to be closed first."))
			return TRUE
		if(working)
			to_chat(user, span_warning("[src] is already lit."))
			return TRUE
		working = TRUE
		update_appearance()
		to_chat(user, span_notice("You light up [src]."))
	else
		. = ..()

/obj/structure/stove/attackby_secondary(obj/item/I, mob/user, params)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(istype(I, /obj/item/reagent_containers/glass/cooking_pot))
		if(right_item)
			to_chat(user, span_warning("This place is already occupied by [right_item]."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		I.forceMove(src)
		right_item = I
		update_appearance()
	else
		. = ..()

/obj/structure/stove/attack_hand(mob/user)
	if(!left_item)
		return
	if(!user.put_in_active_hand(left_item, FALSE, FALSE))
		user.dropItemToGround(left_item)
		return
	left_item = null
	update_appearance()

/obj/structure/stove/attack_hand_secondary(mob/user, list/modifiers)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!right_item)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!user.put_in_active_hand(right_item, FALSE, FALSE))
		user.dropItemToGround(right_item)
		return
	right_item = null
	update_appearance()

/obj/structure/stove/AltClick(mob/user)
	if(working)
		to_chat(user, span_warning("Cannot open while [src] is working."))
		return
	open = !open
	update_appearance()
	to_chat(user, span_notice("You [open?"open":"close"] [src]."))

/obj/structure/stove/process(delta_time)
	if(!working)
		return
	if(!fuel)
		working = FALSE
		visible_message(span_notice("[src]'s flames die out."))
		update_appearance()
		return
	fuel = clamp(fuel--, 0, fuel)
	for(var/obj/item/reagent_containers/R in contents)
		if(R.reagents.total_volume)
			R.reagents.expose_temperature(heat)
