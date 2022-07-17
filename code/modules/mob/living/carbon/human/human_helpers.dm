
/mob/living/carbon/human/canBeHandcuffed()
	if(num_hands < 2)
		return FALSE
	return TRUE

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a separate proc as it'll be useful elsewhere
/mob/living/carbon/human/get_visible_name()
	var/face_name = get_face_name("")
	if(name_override)
		return name_override
	if(face_name)
		return face_name
	return "Unknown"

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when Fluacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name(if_no_face="Unknown")
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		return if_no_face
	if( head && (head.flags_inv&HIDEFACE) )
		return if_no_face		//Likewise for hats
	var/obj/item/bodypart/O = get_bodypart(BODY_ZONE_HEAD)
	if( !O || (HAS_TRAIT(src, TRAIT_DISFIGURED)) || (O.brutestate+O.burnstate)>2 || !real_name || HAS_TRAIT(src, TRAIT_INVISIBLE_MAN)) //disfigured. use id-name if possible
		return if_no_face
	return real_name

/mob/living/carbon/human/reagent_check(datum/reagent/R, delta_time, times_fired)
	return dna.species.handle_chemicals(R, src, delta_time, times_fired)
	// if it returns 0, it will run the usual on_mob_life for that reagent. otherwise, it will stop after running handle_chemicals for the species.


/mob/living/carbon/human/can_track(mob/living/user)
	if(istype(head, /obj/item/clothing/head))
		var/obj/item/clothing/head/hat = head
		if(hat.blockTracking)
			return 0

	return ..()

/mob/living/carbon/human/can_use_guns(obj/item/G)
	. = ..()
	if(G.trigger_guard == TRIGGER_GUARD_NORMAL)
		if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS))
			to_chat(src, span_warning("Мои мясистые пальцы слишком большие, чтобы нажать на курок!"))
			return FALSE
	if(HAS_TRAIT(src, TRAIT_NOGUNS))
		to_chat(src, span_warning("Не могу заставить себя использовать оружие дальнего боя!"))
		return FALSE

/mob/living/carbon/human/get_policy_keywords()
	. = ..()
	. += "[dna.species.type]"

/mob/living/carbon/human/can_see_reagents()
	. = ..()
	if(.) //No need to run through all of this if it's already true.
		return
	if(isclothing(glasses) && (glasses.clothing_flags & SCAN_REAGENTS))
		return TRUE
	if(isclothing(head) && (head.clothing_flags & SCAN_REAGENTS))
		return TRUE
	if(isclothing(wear_mask) && (wear_mask.clothing_flags & SCAN_REAGENTS))
		return TRUE

/mob/living/carbon/human/get_biological_state()
	return dna.species.get_biological_state()

///Returns death message for mob examine text
/mob/living/carbon/human/proc/generate_death_examine_text()
	//var/mob/dead/observer/ghost = get_ghost(TRUE, TRUE)
	var/t_on = p_they(TRUE)
	if(key || !getorgan(/obj/item/organ/brain))
		return "<span class='deadsay'>[t_on] не реагирует на происходящее вокруг; нет признаков жизни и души...</span>\n" //Default death message
	//The death mob has a brain and no client/player that is assigned to the mob
	/*
	if(!ghost?.can_reenter_corpse)  //And there is no ghost that could reenter the body
		//There is no way this mob can in any normal way get a player, so they lost the will to live
		return "<span class='deadsay'>[t_on] не реагирует на происходящее вокруг; нет признаков жизни и желания души жить...</span>\n"
	*/
	//This mob has a ghost linked that could still reenter the body, so the soul only departed
	return "<span class='deadsay'>[t_on] не реагирует на происходящее вокруг; нет признаков жизни и души...</span>\n"
