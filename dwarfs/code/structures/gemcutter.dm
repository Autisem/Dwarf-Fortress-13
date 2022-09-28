/obj/structure/gemcutter
	name = "gem cutter"
	desc = "Makes items that don't shine to do so."
	icon = 'dwarfs/icons/structures/32x48.dmi'
	icon_state = "gemcutter"
	anchored = TRUE
	density = TRUE
	layer = TABLE_LAYER
	var/busy = FALSE

/obj/structure/gemcutter/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/stack/ore/gem))
		icon_state = "gemcutter_on"
		if(busy)
			to_chat(user, span_notice("Currently busy."))
			return
		busy = TRUE
		if(!do_after(user, 15 SECONDS, target = src))
			busy = FALSE
			icon_state = "gemcutter"
			return
		busy = FALSE
		var/obj/item/stack/ore/gem/G = I
		new G.cut_type(loc)
		to_chat(user, span_notice("You process [G] on \a [src]"))
		qdel(G)
		icon_state = "gemcutter"
	else
		..()
