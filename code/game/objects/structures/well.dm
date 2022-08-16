/obj/structure/well
	name = "well"
	desc = "Get water here."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "well"
	var/working = FALSE
	//IMPORTANT: work_time should be somewhat the same as "well_working" animation duration otherwise it will look crappy
	var/work_time = 3.9 SECONDS

/obj/structure/well/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bucket))
		if(contents.len)
			to_chat(user, span_warning("[src] already has a bucket!"))
			return
		I.forceMove(src)
		to_chat(user, span_notice("You attach [I] to [src]."))
		update_appearance()
	else
		return ..()

/obj/structure/well/attack_hand(mob/user)
	if(!contents.len)
		to_chat(user, span_warning("[src] doesn't have a bucket!"))
		return
	var/obj/item/reagent_containers/glass/bucket/B = contents[1]
	if(B.reagents.total_volume == B.volume)//bucket is full
		to_chat(user, span_notice("You remove [B] from [src]."))
		var/mob/living/carbon/human/H = user
		H.put_in_active_hand(B)
		update_appearance()
	else//has unfilled volume
		if(working)
			to_chat(user, span_warning("Somebody is already operating [src]!"))
			return
		working = TRUE//busy!!
		to_chat(user, span_notice("You start working at [src]..."))
		flick("well_working", src)
		if(do_after(user, work_time, src))
			B.reagents.add_reagent(/datum/reagent/water, B.volume - B.reagents.total_volume)
		working = FALSE
		update_appearance()

/obj/structure/well/update_icon_state()
	. = ..()
	if(!contents.len)
		icon_state = "well"
	else
		var/obj/item/reagent_containers/glass/bucket/B = contents[1]
		if(B.reagents.total_volume == B.volume)//bucket is full
			icon_state = "well_water"
		else//has unfilled volume
			icon_state = "well_bucket"

