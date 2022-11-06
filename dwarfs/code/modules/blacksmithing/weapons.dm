/obj/item/zwei
	name = "zweihander"
	desc = "A long sword, made too big for a dwarf to wield it easily."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "zweihander"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand_96x32.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand_96x32.dmi'
	inhand_icon_state = "zweihander"
	inhand_x_dimension = -32
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

/obj/item/zwei/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/zwei/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(2 SECONDS)

/obj/item/flail
	name = "flail"
	desc = "Flail to crush your enemies. Lies comfy in one hand."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "cep"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "cep"
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

/obj/item/flail/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(1 SECONDS)

/obj/item/dagger
	name = "dagger"
	desc = "Dagger - a rare choice for a dwarven warrior. Made for swift cuts and stings."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "dagger"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "dagger"
	force = 8
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 0
	atck_type = SHARP
	max_integrity = 20
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/dagger

/obj/item/dagger/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(0.6 SECONDS)
/*
/obj/item/dagger/Initialize()
	. = ..()
	AddComponent(/datum/component/attack_toggle,\
		attacks=list(SHARP,PIERCE),\
		damages=list(20, 3),\
		cooldowns=list(CLICK_CD_MELEE, CLICK_CD_RAPID),\
		attack_verbs_simple=list(list("attack","slash"), list("pierce","poke","stab")),\
		attack_verbs_continuous=list(list("attacks","slashes"), list("pierces","pokes","stabs"))\
	)
*/
/obj/item/sword
	name = "sword"
	desc = "A straight sword with double edge. More commonly found in human cities."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "sword"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "sword"
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

/obj/item/sword/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(1 SECONDS)

/obj/item/spear
	name = "spear"
	desc = "Spears usually found in dwarven hold barracks but make a great weapon to keep a bigger enemy at the distance."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "spear"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "spear"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	force = 20
	throwforce = 30
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/pierce_slow.ogg'
	block_chance = 5
	reach = 2
	atck_type = PIERCE
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/spear

/obj/item/spear/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, use_grades=TRUE, inhand_icon_wielded="spear_w")

/obj/item/spear/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(1.2 SECONDS)

/obj/item/warhammer
	name = "warhammer"
	desc = "Warhammer makes a great choice for the dwarven warrior. As a natural miners and blacksmiths - it have all same principes of use as common dwarven tools."
	icon = 'dwarfs/icons/items/weapons.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	icon_state = "warhammer"
	w_class = WEIGHT_CLASS_HUGE
	atck_type = BLUNT
	force = 20
	reach = 2
	skill = /datum/skill/combat/hammer

/obj/item/warhammer/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/warhammer/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(1.5 SECONDS)

/obj/item/halberd
	name = "halberd"
	desc = "Pointy stick with bladee. Robustester."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "halberd"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "halberd"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	force = 20
	throwforce = 5
	reach = 2
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/pierce_slow.ogg'
	block_chance = 15
	atck_type = PIERCE
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/halberd

/obj/item/halberd/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, use_grades=TRUE, inhand_icon_wielded="halberd_w")

/obj/item/halberd/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(1.2 SECONDS)

/obj/item/scepter
	name = "scepter"
	desc = "King's scepter. For him to rule, for you to obey." // also  "King's second most important tool. You hit peasants with it."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "king_scepter"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "king_scepter"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/whip.ogg'
	block_chance = 20
	atck_type = BLUNT
	max_integrity = 50
	resistance_flags = FIRE_PROOF

/obj/item/scepter/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.changeNext_move(0.6 SECONDS)
