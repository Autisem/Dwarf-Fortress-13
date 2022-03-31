//spears
/obj/item/spear
	icon_state = "spearglass0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "копьё"
	desc = "Случайно сконструированное, но все же смертельное оружие древнего дизайна."
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throwforce = 20
	throw_speed = 4
	embedding = list("impact_pain_mult" = 2, "remove_pain_mult" = 4, "jostle_chance" = 2.5)
	armour_penetration = 10
	custom_materials = list(/datum/material/iron=1150, /datum/material/glass=2075)
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("attack", "poke", "jab", "tear", "lacerate", "gore")
	sharpness = SHARP_EDGED // i know the whole point of spears is that they're pointy, but edged is more devastating at the moment so
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	var/war_cry = "ААААААА!!!"
	var/icon_prefix = "spearglass"
	wound_bonus = -15
	bare_wound_bonus = 15

/obj/item/spear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 70) //decent in a pinch, but pretty bad.
	AddComponent(/datum/component/jousting)
	AddComponent(/datum/component/two_handed, force_unwielded=10, force_wielded=18, icon_wielded="[icon_prefix]1")
	update_icon()

/obj/item/spear/update_icon_state()
	icon_state = "[icon_prefix]0"
	return ..()

/obj/item/spear/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] начинает глотать меч <b>[src.name]</b>! Это выглядит будто [user.p_theyre()] пытается совершить самоубийство!"))
	return BRUTELOSS

/obj/item/spear/CheckParts(list/parts_list)
	var/obj/item/shard/tip = locate() in parts_list
	if(tip)
		update_icon()
		parts_list -= tip
		qdel(tip)
	return ..()

/*
 * Bone Spear
 */
/obj/item/spear/bonespear	//Blatant imitation of spear, but made out of bone. Not valid for explosive modification.
	icon_state = "bone_spear0"
	name = "костяное копьё"
	desc = "Случайно сконструированное, но все еще смертельное оружие. Вершина современных технологий."
	force = 12
	throwforce = 22
	armour_penetration = 15				//Enhanced armor piercing

/obj/item/spear/bonespear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=12, force_wielded=20, icon_wielded="bone_spear1")

/obj/item/spear/bonespear/update_icon_state()
	icon_state = "bone_spear0"
	return ..()

/*
 * Bamboo Spear
 */
/obj/item/spear/bamboospear //Blatant imitation of spear, but all natural. Also not valid for explosive modification.
	icon_state = "bamboo_spear0"
	base_icon_state = "bamboo_spear0"
	icon_prefix = "bamboo_spear"
	name = "бамбуковое копьё"
	desc = "Бамбуковая палка с острым концом. Невероятно смертельное оружие."
	throwforce = 22	//Better to throw

/obj/item/spear/bonespear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=10, force_wielded=18, icon_wielded="[icon_prefix]1")
