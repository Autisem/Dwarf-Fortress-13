/datum/surgery/plastic_surgery
	name = "Пластическая хирургия"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/reshape_face, /datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)

//reshape_face
/datum/surgery_step/reshape_face
	name = "изменить лицо"
	implements = list(TOOL_SCALPEL = 100, /obj/item/kitchen/knife = 50, TOOL_WIRECUTTER = 35)
	time = 64

/datum/surgery_step/reshape_face/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user] начинает менять внешность [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Начинаю менять внешность [skloname(target.name, RODITELNI, target.gender)]..."))
	display_results(user, target, span_notice("Начинаю менять внешность [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает менять внешность [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] делает надрез на лице [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "You feel slicing pain across your face!")

/datum/surgery_step/reshape_face/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(HAS_TRAIT_FROM(target, TRAIT_DISFIGURED, TRAIT_GENERIC))
		REMOVE_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
		display_results(user, target, span_notice("Успешно изменил внешность [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно изменил внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] завершил операцию на лице [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "The pain fades, your face feels normal again!")
	else
		var/list/names = list()
		for(var/i in 1 to 10)
			names += target.dna.species.random_name(target.gender, TRUE)
		var/chosen_name = input(user, "Выберите новое имя.", "Plastic Surgery") as null|anything in names
		if(!chosen_name)
			return
		var/oldname = target.real_name
		target.real_name = chosen_name
		var/newname = target.real_name	//something about how the code handles names required that I use this instead of target.real_name
		display_results(user, target, span_notice("You alter [oldname] appearance completely, [target.ru_who()] is now [newname].") ,
			span_notice("[user] alters [oldname] appearance completely, [target.ru_who()] is now [newname]!") ,
			span_notice("[user] finishes the operation on [skloname(target.name, RODITELNI, target.gender)] face."))
		display_pain(target, "The pain fades, your face feels new and unfamiliar!")
	return ..()

/datum/surgery_step/reshape_face/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_warning("Я облажался, изуродовав внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] облажался, изуродовав внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] заверщил операцию на лице [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Your face feels horribly scarred and deformed!")
	ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
	return FALSE
