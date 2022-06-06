/datum/surgery/prosthetic_replacement
	name = "Травматология: Замена конечностей"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/add_prosthetic)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD)
	requires_bodypart = FALSE //need a missing limb
	requires_bodypart_type = 0

/datum/surgery/prosthetic_replacement/can_start(mob/user, mob/living/carbon/target)
	if(!iscarbon(target))
		return FALSE
	var/mob/living/carbon/C = target
	if(!C.get_bodypart(user.zone_selected)) //can only start if limb is missing
		return TRUE
	return FALSE



/datum/surgery_step/add_prosthetic
	name = "добавить конечность"
	implements = list(/obj/item/bodypart = 100)
	time = 32
	var/organ_rejection_dam = 0

/datum/surgery_step/add_prosthetic/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(istype(tool, /obj/item/bodypart))
		var/obj/item/bodypart/BP = tool
		if(BP.status != BODYPART_ROBOTIC)
			organ_rejection_dam = 10
			if(ishuman(target))
				if(BP.animal_origin)
					to_chat(user, span_warning("[BP] относится к другому селекционному виду."))
					return -1
				var/mob/living/carbon/human/H = target
				if(H.dna.species.id != BP.species_id)
					organ_rejection_dam = 30

		if(target_zone == BP.body_zone) //so we can't replace a leg with an arm, or a human arm with a monkey arm.
			display_results(user, target, span_notice("Вы начинаете заменять [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)] на [tool]...") ,
				span_notice("[user] начинает заменять [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)] на [tool].") ,
				span_notice("[user] начинает заменять [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]."))
		else
			to_chat(user, span_warning("[tool] не подходит к [parse_zone(target_zone)]."))
			return -1
	else if(target_zone == BODY_ZONE_L_ARM || target_zone == BODY_ZONE_R_ARM)
		display_results(user, target, span_notice("Вы начинаете присоединять [tool] к [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает присоединять [tool] к [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает присоединять [tool] к [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]."))
	else
		to_chat(user, span_warning("[tool] должно быть установлено в руку."))
		return -1

/datum/surgery_step/add_prosthetic/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(istype(tool, /obj/item/bodypart) && user.temporarilyRemoveItemFromInventory(tool))
		var/obj/item/bodypart/L = tool
		if(!L.attach_limb(target))
			display_results(user, target, span_warning("Вам не удалось заменить [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]! Тело отвергает [L]!") ,
				span_warning("[user] не удалось заменить [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!") ,
				span_warning("[user] не удалось заменить [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!"))
			return
		if(organ_rejection_dam)
			target.adjustToxLoss(organ_rejection_dam)
		display_results(user, target, span_notice("Вы успешно заменили [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)] на [tool].") ,
			span_notice("[user] успешно заменил [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)] на [tool]!") ,
			span_notice("[user] успешно заменил [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!"))
		display_pain(target, "You feel synthetic sensation wash from your [parse_zone(target_zone)], which you can feel again!", TRUE)
		return
	else
		var/obj/item/bodypart/L = target.newBodyPart(target_zone, FALSE, FALSE)
		L.is_pseudopart = TRUE
		if(!L.attach_limb(target))
			display_results(user, target, span_warning("Вам не удалось присоединить [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]! Тело отвергает [L]!") ,
				span_warning("[user] не удалось присоединить [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!") ,
				span_warning("[user] не удалось присоединить [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!"))
			L.forceMove(target.loc)
			return
		user.visible_message(span_notice("[user] успешно присоединяет [tool]!") , span_notice("Вы присоединили [tool]."))
		display_results(user, target, span_notice("Вы присоединили [tool].") ,
			span_notice("[user] успешно присоединяет [tool]!") ,
			span_notice("[user] успешно присоединяет [tool]!"))
		display_pain(target, "You feel a strange sensation from your new [parse_zone(target_zone)].", TRUE)
		qdel(tool)
	return ..() //if for some reason we fail everything we'll print out some text okay?
