/* Kitchen tools
 * Contains:
 * Fork
 * Kitchen knives
 * Ritual Knife
 * Bloodletter
 * Butcher's cleaver
 * Combat Knife
 * Rolling Pins
 * Plastic Utensils
 */

/obj/item/kitchen
	icon = 'icons/obj/tools.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'

/obj/item/kitchen/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_APC_SHOCKING, INNATE_TRAIT)

/obj/item/kitchen/knife
	name = "kitchen knife"
	icon = 'dwarfs/icons/items/kitchen.dmi'
	icon_state = "kitchen_knife"
	inhand_icon_state = "knife"
	worn_icon_state = "knife"
	desc = "A general purpose Chef's Knife. Guaranteed to stay sharp for years to come."
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	throw_speed = 3
	throw_range = 6
	attack_verb_continuous = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	atck_type = SHARP
	var/bayonet = FALSE //Can this be attached to a gun?
	wound_bonus = -5
	bare_wound_bonus = 10
	tool_behaviour = TOOL_KNIFE

/obj/item/kitchen/knife/Initialize()
	. = ..()
	AddElement(/datum/element/eyestab)
	set_butchering()

///Adds the butchering component, used to override stats for special cases
/obj/item/kitchen/knife/proc/set_butchering()
	AddComponent(/datum/component/butchering, 80 - force)

/obj/item/kitchen/knife/suicide_act(mob/user)
	user.visible_message(pick(span_suicide("[user] is slitting [user.p_their()] wrists with the [src.name]! It looks like [user.p_theyre()] trying to commit suicide.") , \
						span_suicide("[user] is slitting [user.p_their()] throat with the [src.name]! It looks like [user.p_theyre()] trying to commit suicide.") , \
						span_suicide("[user] is slitting [user.p_their()] stomach open with the [src.name]! It looks like [user.p_theyre()] trying to commit seppuku.")))
	return (BRUTELOSS)

/obj/item/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	icon_state = "rolling_pin"
	worn_icon_state = "rolling_pin"
	force = 8
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 1.5)
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("bashes", "batters", "bludgeons", "thrashes", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "thrash", "whack")
	custom_price = PAYCHECK_EASY * 1.5
	tool_behaviour = TOOL_ROLLINGPIN

/obj/item/kitchen/rollingpin/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins flattening [user.p_their()] head with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS
