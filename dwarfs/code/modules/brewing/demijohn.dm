/obj/structure/demijohn
	name = "demijohn"
	desc = "A rigid container used in brewing."
	density = 1
	layer = ABOVE_MOB_LAYER
	// icon = ''
	// icon_state = ""
	var/max_volume = 300
	var/datum/reagent/target_reagent // what are we making right now; block everything else
	var/datum/reagent/conv_reagent // what are we converting right now
	var/last_conv // world.time when it tried to convert liquids
	var/start_conv
	var/wait_before_start = 1 MINUTES // amount of time to wait before starting the work; also wait before starting to convert a converted product (juice->wine->vinegar)

/obj/structure/demijohn/Initialize()
	. = ..()
	create_reagents(max_volume)
	START_PROCESSING(SSprocessing, src)

/obj/structure/demijohn/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/demijohn/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I
		var/transfered = C.reagents.trans_to(src, C.amount_per_transfer_from_this, transfered_by=user)
		if(!transfered)
			return
		start_conv = world.time // each time you add something the timer will reset
		to_chat(user, "You transfer [transfered]u to [src].")
		update_appearance()
	else
		return ..()

/obj/structure/demijohn/attackby_secondary(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = weapon
		var/transfered = reagents.trans_to(C, 10, transfered_by=user)
		if(!transfered)
			return
		start_conv = world.time // each time you take something the timer will reset
		to_chat(user, "You take [transfered]u from [src].")
		update_appearance()
	else
		return ..()

// /obj/structure/demijohn/update_overlays()
// 	. = ..()
// 	if(reagents.total_volume)
// 		var/mutable_appearance/M = mutable_appearance('', "demijohn_liquid_overlay")
// 		M.color = mix_color_from_reagents(reagents.reagent_list)
		. += M

/obj/structure/demijohn/update_icon(updates)
	. = ..()
	if(reagents.total_volume)
		icon_state = "demijohn_liquid"
	else
		icon_state = "demijohn_empty"

/obj/structure/demijohn/process(delta_time)
	if(!reagents.total_volume)
		return
	if(!target_reagent)
		if(reagents.reagent_list.len > 1)
			target_reagent = /datum/reagent/blood  // if there are multiple liquids produce bad quality mixed alcohol
		else if(istype(reagents.reagent_list[1], /datum/reagent/consumable/juice) || istype(reagents.reagent_list[1], /datum/reagent/consumable/ethanol/wine))
			conv_reagent = reagents.reagent_list[1]
			target_reagent = conv_reagent.convtype
		else
			return
	if(world.time < start_conv+wait_before_start) // don't do anything until left untouched for wait_before_start
		return
	if(world.time >= last_conv+conv_reagent.conv_delta)
		last_conv = world.time
		var/to_conv = conv_reagent.conv_amt * conv_reagent.conv_rate
		reagents.remove_reagent(conv_reagent, to_conv)
		reagents.add_reagent(target_reagent, to_conv)
		update_appearance()
		if(!reagents.get_reagent(conv_reagent.type))
			start_conv = world.time
			conv_reagent = null
			target_reagent = null
