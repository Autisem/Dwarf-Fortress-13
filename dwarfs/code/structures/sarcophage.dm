/obj/structure/closet/crate/sarcophagus
	name = "sarcophagus"
	desc = "Resting place for the dead. Not recommended for sleep."
	icon = 'dwarfs/icons/structures/sarcophagus.dmi'
	icon_state = "sarcophagus"
	drag_slowdown = 4

/obj/structure/closet/crate/sarcophagus/close(mob/living/user)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/H in contents)
			if(H.stat == DEAD)
				name = "sarcophagus of [H.real_name]."
				anchored = TRUE
				locked = TRUE
				return TRUE

/obj/structure/closet/crate/sarcophagus/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/shovel) && locked)
		to_chat(user, span_notice("You start opening [src]..."))
		if(do_after(user, 30 SECONDS, src))
			anchored = FALSE
			locked = FALSE
			open(user)
	else
		. = ..()

/obj/structure/closet/crate/sarcophagus/insertion_allowed(atom/movable/AM)
	. = ..()
	if(!.)
		return .
	if(contents.len && (locate(/mob/living/carbon/human) in contents))
		return FALSE
