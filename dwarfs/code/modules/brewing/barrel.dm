/obj/structure/barrel
	name = "barrel"
	desc = "Do a barrel roll."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "barrel"
	var/open = TRUE
	density = 1

/obj/structure/barrel/examine(mob/user)
	. = ..()
	if(!reagents.total_volume)
		. += "<br>\The [src] is empty."
	else
		var/list/r = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			r += "[R.volume] [R.name]"
		. += "\The [src] contains [r.Join(", ")]"

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
	if(!open)
		return ..()
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I
		var/transfered = I.reagents.trans_to(reagents, C.amount_per_transfer_from_this)
		if(transfered)
			to_chat(user, span_notice("You transfer [transfered]u to [src]."))
			update_appearance()
	else if(istype(I, /obj/item/stack/sheet/bark))
		var/datum/reagent/W = reagents.has_reagent(/datum/reagent/water)
		if(!W)
			to_chat(user, span_warning("[src] doesn't have water inside!"))
			return
		reagents.add_reagent(/datum/reagent/tanin, W.volume)
		reagents.remove_reagent(W.type, W.volume)
		var/obj/item/stack/B = I
		B.use(1)
		to_chat(user, span_notice("You throw a piece of bark in [src] and the water inside turns into tanin!"))
		update_appearance()
	else if(user.a_intent != INTENT_HARM)
		reagents.expose(I)
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
