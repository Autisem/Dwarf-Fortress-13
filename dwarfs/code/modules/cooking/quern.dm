/obj/structure/quern
	name = "quern"
	desc = "Rotational sus."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "millstone"
	var/max_volume = 150
	var/work_time = 10 SECONDS
	var/open = FALSE
	var/busy_operating = FALSE

/obj/structure/quern/Initialize()
	. = ..()
	create_reagents(max_volume)

/obj/structure/quern/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/growable))
		var/obj/item/growable/G = I
		if(!G.grain_type)
			return TRUE
		if(contents.len || reagents.total_volume)
			to_chat(user, span_warning("[src] is already full."))
			return TRUE
		G.forceMove(src)
	else if(istype(I, /obj/item/reagent_containers/sack))
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src] is empty."))
			return TRUE
		if(!open)
			to_chat(user, span_warning("[src] has to be opened first."))
			return TRUE
		var/obj/item/reagent_containers/sack/S = I
		var/vol = reagents.trans_to(S, S.amount_per_transfer_from_this, transfered_by=user)
		if(vol)
			to_chat(user, span_notice("You scoop [vol]u from [src]"))
	update_appearance()

/obj/structure/quern/attack_hand(mob/user)
	if(!contents.len || !reagents.has_reagent_subtype(/datum/reagent/grain))
		to_chat(user, span_warning("[src] has nothing to grind."))
		return
	if(busy_operating)
		to_chat(user, "Somebody is already working on [src].")
		return
	busy_operating = TRUE
	icon_state = "millstone_working"
	to_chat(user, span_notice("You start working at [src]."))
	if(do_after(user, work_time, src))
		if(contents.len)
			var/obj/item/growable/G = contents[1]
			for(var/i in 1 to rand(1,2))
				new G.seed_type(get_turf(src))
			reagents.add_reagent(G.grain_type, G.grain_volume)
			qdel(G)
		else // has grain reagents
			var/datum/reagent/grain/G =  reagents.has_reagent_subtype(/datum/reagent/grain)
			var/vol = G.volume*G.flour_ratio
			reagents.remove_reagent(G.type, vol)
			reagents.add_reagent(G.flour_type, vol)
	busy_operating = FALSE
	icon_state = "millstone"
	to_chat(user, span_notice("You finish working at [src]."))

/obj/structure/quern/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	open = !open
	to_chat(user, span_notice("You [open?"close":"open"] [src]."))
	update_appearance()

/obj/structure/quern/update_icon(updates)
	. = ..()
	if(open)
		if(contents.len)
			icon_state = "millstone_open_grain"
		else if(reagents.total_volume)
			icon_state = "millstone_open_flour"
		else
			icon_state = "millstone_open"
	else
		icon_state = "milltone"
