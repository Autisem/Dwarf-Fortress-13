/*****************Pickaxes & Drills & Shovels****************/
/obj/item/pickaxe
	name = "pickaxe"
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "pickaxe"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 15
	throwforce = 10
	inhand_icon_state = "pickaxe"
	worn_icon_state = "pickaxe"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron=2000) //one sheet, but where can you make them?
	tool_behaviour = TOOL_MINING
	toolspeed = 1
	usesound = list('sound/effects/picaxe1.ogg', 'sound/effects/picaxe2.ogg', 'sound/effects/picaxe3.ogg')
	attack_verb_continuous = list("hits", "pierces", "slashes", "attacks")
	attack_verb_simple = list("hit", "pierce", "slash", "attacks")

/obj/item/pickaxe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging into [user.ru_ego()] chest! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/pickaxe/rusted
	name = "rusty pickaxe"
	desc = "Rusty. Pickaxe."
	attack_verb_continuous = list("ineffectively hits")
	attack_verb_simple = list("ineffectively hit")
	force = 1
	throwforce = 1

/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "shovel"
	worn_icon_state = "shovel"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 8
	tool_behaviour = TOOL_SHOVEL
	toolspeed = 1
	usesound = 'sound/effects/shovel_dig.ogg'
	throwforce = 4
	inhand_icon_state = "shovel"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=50)
	attack_verb_continuous = list("smashes", "hits", "attacks")
	attack_verb_simple = list("smash", "hit", "attack")
	sharpness = SHARP_EDGED

/obj/item/shovel/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 150, 40) //it's sharp, so it works, but barely.

/obj/item/shovel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging their own grave! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME
