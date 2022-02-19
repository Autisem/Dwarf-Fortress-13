/obj/structure/gemcutter
	name = "стол ювелира"
	desc = "У дворфов нет имени Александр в списке имен."
	icon = 'white/rashcat/icons/dwarfs/objects/tools.dmi'
	icon_state = "gemcutter_off"
	anchored = TRUE
	density = TRUE
	layer = TABLE_LAYER
	var/busy = FALSE

/obj/structure/gemcutter/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/gem) && !istype(I, /obj/item/gem/cut))
		icon_state = "gemcutter_on"
		if(busy)
			to_chat(user, span_notice("Сейчас занято."))
			return
		busy = TRUE
		if(!do_after(user, 15 SECONDS, target = src))
			busy = FALSE
			icon_state = "gemcutter_off"
			return
		busy = FALSE
		var/obj/item/gem/G = I
		new G.cut_type(loc)
		to_chat(user, span_notice("Обрабатываю [G] на [src]"))
		qdel(G)
		icon_state = "gemcutter_off"
	else
		..()
