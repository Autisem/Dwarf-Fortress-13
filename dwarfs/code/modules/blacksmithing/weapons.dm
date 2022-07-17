/obj/item/blacksmith/zwei
	name = "zweihander"
	desc = "Can even cut down trees."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "zweihander"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand_96x32.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand_96x32.dmi'
	inhand_icon_state = "zweihander"
	inhand_x_dimension = -32
	flags_1 = CONDUCT_1
	force = 30
	throwforce = 15
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 5
	atck_type = SHARP
	max_integrity = 150
	resistance_flags = FIRE_PROOF
	reach = 2
	skill = /datum/skill/combat/longsword

/obj/item/blacksmith/zwei/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/blacksmith/zwei/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(3 SECONDS)

/obj/item/blacksmith/flail
	name = "flail"
	desc = "Spin it really fast."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "cep"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "cep"
	flags_1 = CONDUCT_1
	force = 20
	atck_type = BLUNT
	throwforce = 25
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_simple = list("hit")
	attack_verb_continuous = list("hits")
	block_chance = 0
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/flail

/obj/item/blacksmith/flail/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(3 SECONDS)

/obj/item/blacksmith/dagger
	name = "dagger"
	desc = "Quick, light and quite sharp."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "dagger"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "dagger"
	flags_1 = CONDUCT_1
	force = 8
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 0
	atck_type = SHARP
	max_integrity = 20
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/dagger

/obj/item/blacksmith/dagger/Initialize()
	. = ..()
	AddComponent(/datum/component/attack_toggle,\
		attacks=list(SHARP,PIERCE),\
		damages=list(20, 3),\
		cooldowns=list(CLICK_CD_MELEE, CLICK_CD_RAPID),\
		attack_verbs_simple=list(list("attack","slash"), list("pierce","poke","stab")),\
		attack_verbs_continuous=list(list("attacks","slashes"), list("pierces","pokes","stabs"))\
	)

/obj/item/blacksmith/sword
	name = "sword"
	desc = "Regular sword."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "sword"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "sword"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	force = 30
	throwforce = 20
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 15
	atck_type = SHARP
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/sword
