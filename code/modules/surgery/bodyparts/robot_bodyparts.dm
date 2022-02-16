#define ROBOTIC_LIGHT_BRUTE_MSG "повреждена"
#define ROBOTIC_MEDIUM_BRUTE_MSG "помята"
#define ROBOTIC_HEAVY_BRUTE_MSG "разваливается"

#define ROBOTIC_LIGHT_BURN_MSG "обгорела"
#define ROBOTIC_MEDIUM_BURN_MSG "обуглилась"
#define ROBOTIC_HEAVY_BURN_MSG "тлеет"

//For ye whom may venture here, split up arm / hand sprites are formatted as "l_hand" & "l_arm".
//The complete sprite (displayed when the limb is on the ground) should be named "borg_l_arm".
//Failure to follow this pattern will cause the hand's icons to be missing due to the way get_limb_icon() works to generate the mob's icons using the aux_zone var.

/obj/item/bodypart/l_arm/robot
	name = "левая рука киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("шлёпает", "бьёт")
	attack_verb_simple = list("шлёпает", "бьёт")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_l_arm"
	status = BODYPART_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/r_arm/robot
	name = "правая рука киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("шлёпает", "бьёт")
	attack_verb_simple = list("шлёпает", "бьёт")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_r_arm"
	status = BODYPART_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/l_leg/robot
	name = "левая нога киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("пинает", "давит")
	attack_verb_simple = list("пинает", "давит")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_l_leg"
	status = BODYPART_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/r_leg/robot
	name = "правая нога киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	attack_verb_continuous = list("пинает", "давит")
	attack_verb_simple = list("пинает", "давит")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_r_leg"
	status = BODYPART_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/chest/robot
	name = "туловище киборга"
	desc = "Тяжело укрепленный корпус, содержащий логические платы киборга, с отверстием под стандартную ячейку питания."
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_chest"
	status = BODYPART_ROBOTIC

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	var/wired = FALSE
	var/obj/item/stock_parts/cell/cell = null

/obj/item/bodypart/chest/robot/get_cell()
	return cell

/obj/item/bodypart/chest/robot/handle_atom_del(atom/A)
	if(A == cell)
		cell = null
	return ..()

/obj/item/bodypart/chest/robot/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/bodypart/chest/robot/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/cell))
		if(cell)
			to_chat(user, span_warning("Уже вставил ячейку питания!"))
			return
		else
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, span_notice("Вставил ячейку питания."))
	else if(istype(W, /obj/item/stack/cable_coil))
		if(wired)
			to_chat(user, span_warning("Уже вставил провод!"))
			return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			wired = TRUE
			to_chat(user, span_notice("Вставил провод."))
		else
			to_chat(user, span_warning("Мне нужен 1 кусок провода, чтобы присоединить его сюда!"))
	else
		return ..()

/obj/item/bodypart/chest/robot/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(!wired)
		return
	. = TRUE
	I.play_tool_sound(src)
	to_chat(user, span_notice("Отрезаю провода в [src]."))
	new /obj/item/stack/cable_coil(drop_location(), 1)
	wired = FALSE

/obj/item/bodypart/chest/robot/screwdriver_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(!cell)
		to_chat(user, span_warning("В [src] не установлен источник питания!"))
		return
	I.play_tool_sound(src)
	to_chat(user, span_notice("Извлечь [cell] из [src]."))
	cell.forceMove(drop_location())
	cell = null


/obj/item/bodypart/chest/robot/examine(mob/user)
	. = ..()
	if(cell)
		. += {"<hr>Имеет вставленный [cell].\n
		<span class='info'>Можно использовать <b>отвертку</b> чтобы извлечь [cell].</span>"}
	else
		. += "<hr><span class='info'>Имеет пустой слот для <b>ячейки питания</b>.</span>"
	if(wired)
		. += "<hr>Всё подключено [cell ? " и готово для использования" : ""].\n"+\
		span_info("Можно использовать <b>кусачки</b> чтобы извлечь проводку.")
	else
		. += "<hr><span class='info'>Имеет пару гнезд, которые необходимо <b>подключить</b>.</span>"

/obj/item/bodypart/chest/robot/drop_organs(mob/user, violent_removal)
	if(wired)
		new /obj/item/stack/cable_coil(drop_location(), 1)
		wired = FALSE
	if(cell)
		cell.forceMove(drop_location())
		cell = null
	..()


/obj/item/bodypart/head/robot
	name = "голова киборга"
	desc = "Стандартная укрепленная черепная коробка, с подключаемой к позвоночнику нейронным сокетом и сенсорными стыковочными узлами."
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_head"
	status = BODYPART_ROBOTIC

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/l_arm/robot/surplus
	name = "бюджетный протез левой руки"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/r_arm/robot/surplus
	name = "бюджетный протез правой руки"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/l_leg/robot/surplus
	name = "бюджетный протез левой ноги"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/r_leg/robot/surplus
	name = "бюджетный протез правой ноги"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20


#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG
