/datum/surgery/organ_manipulation
	name = "Organ manipulation"
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	requires_real_bodypart = 1
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/manipulate_organs,
		//there should be bone fixing
		/datum/surgery_step/close
		)

/datum/surgery/organ_manipulation/soft
	possible_locs = list(BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/manipulate_organs,
		/datum/surgery_step/close
		)

/datum/surgery_step/manipulate_organs
	time = 64
	name = "manipulate organs"
	repeatable = TRUE
	implements = list(/obj/item/organ = 100)
	var/implements_extract = list(TOOL_HEMOSTAT = 100, TOOL_CROWBAR = 55, /obj/item/kitchen/fork = 35)
	var/current_type
	var/obj/item/organ/I = null

/datum/surgery_step/manipulate_organs/New()
	..()
	implements = implements + implements_extract

/datum/surgery_step/manipulate_organs/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	I = null
	if(isorgan(tool))
		current_type = "insert"
		I = tool
		if(target_zone != I.zone || target.getorganslot(I.slot))
			to_chat(user, span_warning("There is no room for [I] in [target]'s [parse_zone(target_zone)]!"))
			return -1
		var/obj/item/organ/meatslab = tool
		if(!meatslab.useable)
			to_chat(user, span_warning("[I] seems to have been chewed on, you can't use this!"))
			return -1
		display_results(user, target, span_notice("You begin to insert [tool] into [target]'s [parse_zone(target_zone)]..."),
			span_notice("[user] begins to insert [tool] into [target]'s [parse_zone(target_zone)]."),
			span_notice("[user] begins to insert something into [target]'s [parse_zone(target_zone)].") ,
			playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))

	else if(implement_type in implements_extract)
		current_type = "extract"
		var/list/organs = target.getorganszone(target_zone)
		if(!organs.len)
			to_chat(user, span_warning("There are no removable organs in [target]'s [parse_zone(target_zone)]!"))
			return -1
		else
			for(var/obj/item/organ/O in organs)
				O.on_find(user)
				organs -= O
				organs[O.name] = O

			I = tgui_input_list(user, "Remove which organ?", "Surgery", sort_list(organs))
			if(I && user && target && user.Adjacent(target) && user.get_active_held_item() == tool)
				I = organs[I]
				if(!I)
					return -1
				if(I.organ_flags & ORGAN_UNREMOVABLE)
					to_chat(user, span_warning("[I] is too well connected to take out!"))
					return -1
				display_results(user, target, span_notice("You begin to extract [I] from [target]'s [parse_zone(target_zone)]..."),
					span_notice("[user] begins to extract [I] from [target]'s [parse_zone(target_zone)]."),
					span_notice("[user] begins to extract something from [target]'s [parse_zone(target_zone)].") ,
					playsound(get_turf(target), 'sound/surgery/hemostat1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
				display_pain(target, "You can feel your [I] being removed from your [parse_zone(target_zone)]!")
			else
				return -1


/datum/surgery_step/manipulate_organs/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(current_type == "insert")
		I = tool
		user.temporarilyRemoveItemFromInventory(I, TRUE)
		I.Insert(target)
		display_results(user, target, span_notice("You insert [tool] into [target]'s [parse_zone(target_zone)]."),
			span_notice("[user] inserts [tool] into [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] inserts something into [target]'s [parse_zone(target_zone)]!") ,
			playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(target, "Your [parse_zone(target_zone)] throbs with pain as your new [tool] comes to life!")

	else if(current_type == "extract")
		if(I && I.owner == target)
			display_results(user, target, span_notice("You successfully extract [I] from [target]'s [parse_zone(target_zone)]."),
				span_notice("[user] successfully extracts [I] from [target]'s [parse_zone(target_zone)]!"),
				span_notice("[user] successfully extracts something from [target]'s [parse_zone(target_zone)]!") ,
				playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
			display_pain(target, "Your [parse_zone(target_zone)] throbs with pain, you can't feel your [I] anymore!")
			log_combat(user, target, "surgically removed [I.name] from")
			I.Remove(target)
			I.forceMove(get_turf(target))
		else
			display_results(user, target, span_warning("You can't extract anything from [target]'s [parse_zone(target_zone)]!"),
				span_notice("[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!"),
				span_notice("[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!"))
	return FALSE
