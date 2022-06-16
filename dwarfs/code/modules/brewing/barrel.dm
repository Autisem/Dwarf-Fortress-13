/obj/structure/barrel
	name = "barrel"
	desc = "Do a barrel roll."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "barrel"
	var/open = TRUE

/obj/structure/barrel/Initialize()
	. = ..()
	create_reagents(300)
	AddComponent(/datum/component/liftable, 5)

/obj/structure/barrel/update_overlays()
	. = ..()
	if(open && reagents.total_volume)
		var/mutable_appearance/M = mutable_appearance(icon, "barrel_overlay")
		M.color = mix_color_from_reagents(reagents.reagent_list)
		. += M

/obj/structure/barrel/update_icon_state()
	. = ..()
	if(open)
		icon_state = "barrel"
	else
		icon_state = "barrel_closed"

/obj/structure/barrel/AltClick(mob/user)
	open = !open
	to_chat(user, span_notice("You [open? "open" : "close"] \the [src]."))
	update_appearance()

/obj/structure/barrel/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers))
		if(!open)
			to_chat(user, span_warning("[src] has to be opened first!"))
			return
		var/obj/item/reagent_containers/C = I
		var/transfered = I.reagents.trans_to(reagents, C.amount_per_transfer_from_this)
		if(transfered)
			to_chat(user, span_notice("You transfer [transfered]u to [src]."))
			update_appearance()
	else
		. = ..()

/obj/structure/barrel/attackby_secondary(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers))
		if(!open)
			to_chat(user, span_warning("[src] has to be opened first!"))
			return
		var/obj/item/reagent_containers/C = I
		var/transfered = reagents.trans_to(C.reagents, 10)
		if(transfered)
			to_chat(user, span_notice("You take [transfered]u from [src]."))
			update_appearance()
	else
		. = ..()
