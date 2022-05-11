/obj/item/crowbar
	name = "карманный лом"
	desc = "Маленький ломик. Этот удобный инструмент полезен для многих вещей, например, для снятия напольной плитки или открывания дверей без электропитания."
	icon = 'white/valtos/icons/items.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "crowbar"
	usesound = 'sound/items/crowbar.ogg'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound =  'sound/items/handling/crowbar_pickup.ogg'

	attack_verb_continuous = list("атакует", "колотит", "бьёт", "ударяет", "вмазывает")
	attack_verb_simple = list("атакует", "колотит", "бьёт", "ударяет", "вмазывает")
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1
	var/force_opens = FALSE

/obj/item/crowbar/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is beating [user.ru_na()]self to death with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/crowbar/red
	icon_state = "crowbar_red"
	force = 8

/obj/item/crowbar/abductor
	name = "инопланетный лом"
	desc = "Жесткий лёгкий ломик. Похоже, он работает сам по себе, даже не нужно прилагать никаких усилий."
	icon = 'icons/obj/abductor.dmi'
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	icon_state = "crowbar"
	toolspeed = 0.1


/obj/item/crowbar/large
	name = "лом"
	desc = "Это большой ломик. Он не помещается в карманы, потому что он большой."
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 3
	custom_materials = list(/datum/material/iron=70)
	icon_state = "crowbar_large"
	inhand_icon_state = "crowbar"
	worn_icon_state = "crowbar"
	toolspeed = 0.7

/obj/item/crowbar/cyborg
	name = "гидравлический лом"
	desc = "Гидравлический инструмент, простой, но мощный."
	icon = 'white/Feline/icons/cyber_arm_tools.dmi'
	icon_state = "crowbar_cyborg"
	worn_icon_state = "crowbar"
	usesound = 'sound/items/jaws_pry.ogg'
	force = 10
	toolspeed = 0.5
