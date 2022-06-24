/obj/item/mop
	desc = "Мир \"janitalia\" не был бы полным без швабры."
	name = "швабра"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 8
	throwforce = 10
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("моет", "лупит", "бьёт", "ударяет")
	attack_verb_simple = list("моет", "лупит", "бьёт", "ударяет")
	resistance_flags = FLAMMABLE
	var/mopcount = 0
	var/mopcap = 15
	var/mopspeed = 15
	force_string = "крепкая... против микробов"
	var/insertable = TRUE

/obj/item/mop/Initialize()
	. = ..()
	create_reagents(mopcap)


/obj/item/mop/proc/clean(turf/A, mob/living/cleaner)
	if(reagents.has_reagent(/datum/reagent/water, 1) || reagents.has_reagent(/datum/reagent/water/holywater, 1) || reagents.has_reagent(/datum/reagent/space_cleaner, 1))
		// If there's a cleaner with a mind, let's gain some experience!
		if(cleaner?.mind)
			var/total_experience_gain = 0
			for(var/obj/effect/decal/cleanable/cleanable_decal in A)
				//it is intentional that the mop rounds xp but soap does not, USE THE SACRED TOOL
				total_experience_gain += max(round(cleanable_decal.beauty / CLEAN_SKILL_BEAUTY_ADJUSTMENT, 1), 0)
			cleaner.mind.adjust_experience(/datum/skill/cleaning, total_experience_gain)
		A.wash(CLEAN_SCRUB)

	reagents.expose(A, TOUCH, 10)	//Needed for proper floor wetting.
	var/val2remove = 1
	if(cleaner?.mind)
		val2remove = round(cleaner.mind.get_skill_modifier(/datum/skill/cleaning, SKILL_SPEED_MODIFIER),0.1)
	reagents.remove_any(val2remove)			//reaction() doesn't use up the reagents


/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(reagents.total_volume < 0.1)
		to_chat(user, span_warning("Швабра сухая!"))
		return

	var/turf/T = get_turf(A)

	if(istype(A, /obj/item/reagent_containers/glass/bucket))
		return

	if(T)
		user.visible_message(span_notice("[user] начинает мыть [T] используя [src.name].") , span_notice("Начинаю мыть [T] используя [src.name]..."))
		var/clean_speedies = 1
		if(user.mind)
			clean_speedies = user.mind.get_skill_modifier(/datum/skill/cleaning, SKILL_SPEED_MODIFIER)
		if(do_after(user, mopspeed*clean_speedies, target = T))
			to_chat(user, span_notice("Заканчиваю мыть пол."))
			clean(T, user)


/obj/effect/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	else
		return ..()

/obj/item/mop/cyborg
	insertable = FALSE

/obj/item/mop/advanced
	desc = "Самый передовой инструмент в арсенале хранителя, в комплекте с конденсатором для смачивания! Просто подумайте обо всех внутренностях, которые вы очистите с этим!"
	name = "продвинутая швабра"
	mopcap = 10
	icon_state = "advmop"
	inhand_icon_state = "mop"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 12
	throwforce = 14
	throw_range = 4
	mopspeed = 8
	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	/// Amount of reagent to refill per second
	var/refill_rate = 0.5
	var/refill_reagent = /datum/reagent/water //Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING

/obj/item/mop/advanced/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj,src)
	to_chat(user, span_notice("Устанавливаю переключатель конденсатора в положение '[refill_enabled ? "ВКЛ" : "ВЫКЛ"]'."))
	playsound(user, 'sound/machines/click.ogg', 30, TRUE)

/obj/item/mop/advanced/process(delta_time)
	var/amadd = min(mopcap - reagents.total_volume, refill_rate * delta_time)
	if(amadd > 0)
		reagents.add_reagent(refill_reagent, amadd)

/obj/item/mop/advanced/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Переключатель конденсатора сейчас в положении <b>[refill_enabled ? "ВКЛ" : "ВЫКЛ"]</b>.</span>"

/obj/item/mop/advanced/Destroy()
	if(refill_enabled)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/mop/advanced/cyborg
	insertable = FALSE
