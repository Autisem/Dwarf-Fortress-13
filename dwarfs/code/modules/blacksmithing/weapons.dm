/obj/item/blacksmith/katanus
	name = "katanus"
	desc = "To not confuse with katana."
	icon_state = "katanus"
	inhand_icon_state = "katanus"
	worn_icon_state = "katanus"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	force = 25
	throwforce = 15
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
	block_chance = 25
	atck_type = SHARP
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/sword

/obj/item/blacksmith/zwei
	name = "zweihander"
	desc = "Can even cut down trees."
	icon_state = "zwei"
	inhand_icon_state = "zwei"
	worn_icon_state = "katanus"
	inhand_x_dimension = -32
	flags_1 = CONDUCT_1
	force = 30
	throwforce = 15
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет")
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
	icon_state = "cep"
	inhand_icon_state = "cep"
	worn_icon_state = "cep"
	flags_1 = CONDUCT_1
	force = 20
	atck_type = BLUNT
	throwforce = 25
	w_class = WEIGHT_CLASS_HUGE
	//hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("hits")
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
	icon_state = "dagger"
	inhand_icon_state = "dagger"
	worn_icon_state = "dagger"
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

/obj/item/blacksmith/dwarfsord
	name = "sword"
	desc = "Regular sword."
	icon_state = "dwarfsord"
	inhand_icon_state = "dwarfsord"
	worn_icon_state = "dwarfsord"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	force = 30
	throwforce = 20
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрубает", "кромсает", "разрывает", "нарезает", "режет", "колбасит")
	block_chance = 15
	atck_type = SHARP
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/sword
