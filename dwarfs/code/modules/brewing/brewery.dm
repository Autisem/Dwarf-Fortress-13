/obj/structure/brewery
	name = "brewery"
	desc = "Looks like a distillery but who am I to tell you."
	anchored = 1
	density = 1
	layer = ABOVE_MOB_LAYER
	icon = 'dwarfs/icons/structures/32x64.dmi'

/obj/structure/brewery/spawner

/obj/structure/brewery/spawner/Initialize()
	. = ..()
	var/turf/T = locate(x+1, y, z)
	if(!istype(T, /turf/open))
		qdel(src)
		return
	var/obj/structure/brewery/l/L = new(get_turf(src))
	var/obj/structure/brewery/r/R = new (T)
	L.right = R
	R.left = L
	qdel(src)

/obj/structure/brewery/l
	icon_state = "brewery_l_closed_empty"
	var/obj/structure/brewery/right
	var/open = FALSE
	var/fuel = 0
	var/working = FALSE
	var/temp = 373.15

/obj/structure/brewery/l/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)
	if(right)
		QDEL_NULL(right)

/obj/structure/brewery/l/Initialize()
	. = ..()
	create_reagents(150, _allowed_reagents=list(/datum/reagent/wort, /datum/reagent/consumable/ethanol))
	START_PROCESSING(SSprocessing, src)

/obj/structure/brewery/l/AltClick(mob/user)
	if(working)
		to_chat(user, span_warning("Cannot open [src] while it's working."))
		return
	open = !open
	update_appearance()
	to_chat(user, span_notice("You [open?"open":"close"] [src]."))


/obj/structure/brewery/l/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet/mineral/coal))
		I.forceMove(src)
		fuel += 30
		update_appearance()
	else if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I
		var/vol = C.reagents.trans_to(src, C.amount_per_transfer_from_this, transfered_by=user)
		if(!vol)
			return TRUE
		to_chat(user, span_notice("You transfer [vol]u from [C]."))
	else
		return ..()

/obj/structure/brewery/l/attackby_secondary(obj/item/I, mob/user, params)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I
		var/vol = reagents.trans_to(C, C.amount_per_transfer_from_this, transfered_by=user)
		if(!vol)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		to_chat(user, span_notice("You transfer [vol]u from [src]."))

/obj/structure/brewery/l/attack_hand(mob/user)
	if(!fuel)
		to_chat(user, span_warning("[src] has no fuel."))
		return
	if(!reagents.total_volume)
		to_chat(user, span_warning("[src] has nothing to brew."))
		return
	if(open)
		to_chat(user, span_warning("[src] has to be closed firts."))
		return
	working = !working
	to_chat(user, span_notice("You [working?"light up":"extinguish"] [src]."))
	update_appearance()

/obj/structure/brewery/l/update_icon_state()
	. = ..()
	if(working)
		icon_state = "brewery_l_working"
	else if(open)
		if(fuel)
			icon_state = "brewery_l_open_fueled"
		else
			icon_state = "brewery_l_open_empty"
	else
		if(fuel)
			icon_state = "brewery_l_closed_fueled"
		else
			icon_state = "brewery_l_closed_empty"


/obj/structure/brewery/l/process(delta_time)
	if(!working)
		return
	fuel = clamp(fuel--, 0, fuel)
	if(!fuel)
		working = FALSE
		update_appearance()
		return
	reagents.expose_temperature(temp)
	var/datum/reagent/young = reagents.has_reagent(/datum/reagent/consumable/ethanol/young)
	if(young)
		right.reagents.add_reagent(young.type, young.volume)
		reagents.remove_reagent(young.type, young.volume)

/obj/structure/brewery/r
	icon_state = "brewery_r_empty"
	var/obj/structure/brewery/left

/obj/structure/brewery/r/Initialize()
	. = ..()
	create_reagents(150)

/obj/structure/brewery/r/Destroy()
	. = ..()
	if(left)
		QDEL_NULL(left)

/obj/structure/brewery/r/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I
		var/vol = C.reagents.trans_to(src, C.amount_per_transfer_from_this, transfered_by=user)
		if(!vol)
			return TRUE
		to_chat(user, span_notice("You transfer [vol]u from [C]."))
	else
		return ..()

/obj/structure/brewery/r/attackby_secondary(obj/item/I, mob/user, params)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I
		var/vol = reagents.trans_to(C, C.amount_per_transfer_from_this, transfered_by=user)
		if(!vol)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		to_chat(user, span_notice("You transfer [vol]u from [src]."))
