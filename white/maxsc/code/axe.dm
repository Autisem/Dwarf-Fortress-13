/*********************Ebonumba TOPOR****************/
/obj/item/paxe
	name = "poleaxe"
	desc = "Одно из самых универсальных видов оружия."
	icon = 'white/maxsc/icons/axe.dmi'
	icon_state = "axe1"
	inhand_icon_state = "paxe1"
	lefthand_file = 'white/maxsc/icons/lefthand.dmi'
	righthand_file = 'white/maxsc/icons/righthand.dmi'
	block_chance = 10
	w_class = WEIGHT_CLASS_BULKY
	force = 9
	throwforce = 20
	armour_penetration = 0
	attack_verb_simple = list("ударяет", "рубит", "протыкает", "режет")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	custom_materials = list(/datum/material/iron=5000)
	max_integrity = 200
	var/wielded = TRUE

/obj/item/paxe/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)

/obj/item/paxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 60, 110)
	AddComponent(/datum/component/two_handed, force_wielded=19, require_twohands=TRUE)

/obj/item/paxe/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER
	wielded = TRUE

/obj/item/paxee
	name = "poleaxe of law"
	desc = "Одно из самых универсальных видов оружия. Оружие справедливости."
	icon = 'white/maxsc/icons/axe.dmi'
	icon_state = "axe1"
	inhand_icon_state = "paxe1"
	lefthand_file = 'white/maxsc/icons/lefthand.dmi'
	righthand_file = 'white/maxsc/icons/righthand.dmi'
	block_chance = 15
	w_class = WEIGHT_CLASS_BULKY
	force = 9
	throwforce = 24
	armour_penetration = 10
	attack_verb_simple = list("ударяет", "приносит справедливость", "рубит", "протыкает")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	custom_materials = list(/datum/material/iron=5000)
	max_integrity = 200
	var/charged = TRUE
	var/recharge_time = 600
	var/wielded = TRUE

/obj/item/paxee/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)

/obj/item/paxee/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 60, 110)
	AddComponent(/datum/component/two_handed,  force_wielded=20, require_twohands=TRUE)

/obj/item/paxee/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER
	wielded = TRUE

/obj/item/paxee/attack_self(mob/user)
	if (charged)
		to_chat(user, span_notice("Время нести справедливость! Меня ничто не остановит!"))
		charged = FALSE
		block_chance = 100
		armour_penetration = 100
		sleep(30)
		to_chat(user, span_warning("Выдохся."))
		block_chance = 15
		armour_penetration = 10
		addtimer(CALLBACK(src, .proc/Recharge), recharge_time)

/obj/item/paxee/proc/Recharge()
	if(!charged)
		charged = TRUE
		to_chat(loc, span_warning("Мы готовы нести справедливость!"))

/obj/item/paxee/examine(mob/living/user)
	..()
	if (charged)
		to_chat(user, "Вы чувствуете невероятную силу, исходящую из этого.")
	else
		to_chat(user, "Выглядит нормально.")

/obj/item/paxee/attack(mob/living/target, mob/living/carbon/user)
	if (istype(user, /mob/living/carbon/human/) && block_chance == 100)
		var/mob/living/carbon/human/H = user
		H.say("AD MORTEM INIMICUS!!!", ignore_spam = TRUE)
	..()

/obj/item/book/manual/wiki/security_space_law/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	. = ..()
	if (istype(target, /obj/item/paxe))
		to_chat(user, span_notice("Улучшаю алебарду властью, данною мне законом."))
		var/obj/item/paxe/I = target
		new /obj/item/paxee(I.loc)
		qdel(I)
		for (var/mob/i in GLOB.player_list)
			if (istype (i, /mob/living/carbon/human/))
				var/mob/living/carbon/human/H = i
				to_chat(H, span_warning("Чувствую высвобождение сил ебонумбы."))
