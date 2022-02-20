/obj/structure/closet/crate/sarcophage
	name = "sarcophage"
	desc = "Resting place for the dead. Not recommended for sleep."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "sarcophage"
	drag_slowdown = 4
	var/dead_used = FALSE

/obj/structure/closet/crate/sarcophage/close(mob/living/user)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/H in contents)
			if(H.stat == DEAD)
				name = "sarcophage of [H.real_name]."
				for(var/obj/item/W in H)
					if(!H.dropItemToGround(W))
						qdel(W)
						H.regenerate_icons()
				qdel(H)
				dead_used = TRUE
				var/turf/where_is_new = get_turf(pick(GLOB.dwarf_shkonka_list))
				new /obj/effect/mob_spawn/human/dwarf(where_is_new)
				return TRUE
