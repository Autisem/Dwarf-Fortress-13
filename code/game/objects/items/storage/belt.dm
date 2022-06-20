/obj/item/storage/belt
	name = "пояс"
	desc = "Может хранить разные штуки."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utility"
	inhand_icon_state = "utility"
	worn_icon_state = "utility"
	lefthand_file = 'icons/mob/inhands/equipment/belt_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/belt_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("шлёпает", "учит", "совращает")
	attack_verb_simple = list("шлёпает", "учит", "совращает")
	max_integrity = 300
	equip_sound = 'sound/items/equip/toolbelt_equip.ogg'
	var/content_overlays = FALSE //If this is true, the belt will gain overlays based on what it's holding

/obj/item/storage/belt/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins belting [user.p_them()]self with <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/storage/belt/update_overlays()
	. = ..()
	if(!content_overlays)
		return
	for(var/obj/item/I in contents)
		. += I.get_belt_overlay()

/obj/item/storage/belt/Initialize()
	. = ..()
	update_appearance()

/obj/item/storage/belt/bandolier
	name = "бандольер"
	desc = "Бандольер для хранения боеприпасов к дробовикам."
	icon_state = "bandolier"
	inhand_icon_state = "bandolier"
	worn_icon_state = "bandolier"

/obj/item/storage/belt/bandolier/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 18
	STR.max_combined_w_class = 18
	STR.display_numerical_stacking = TRUE
	STR.set_holdable(list(
		/obj/item/ammo_casing/shotgun
		))

/obj/item/storage/belt/fannypack
	name = "поясная сумка"
	desc = "Придурковатая поясная сумка для хранения мелких вещей."
	icon_state = "fannypack_leather"
	inhand_icon_state = "fannypack_leather"
	worn_icon_state = "fannypack_leather"
	dying_key = DYE_REGISTRY_FANNYPACK
	custom_price = PAYCHECK_ASSISTANT * 2

/obj/item/storage/belt/fannypack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/belt/fannypack/black
	name = "чёрная поясная сумка"
	icon_state = "fannypack_black"
	inhand_icon_state = "fannypack_black"
	worn_icon_state = "fannypack_black"

/obj/item/storage/belt/fannypack/red
	name = "красная поясная сумка"
	icon_state = "fannypack_red"
	inhand_icon_state = "fannypack_red"
	worn_icon_state = "fannypack_red"

/obj/item/storage/belt/fannypack/purple
	name = "фиолетовая поясная сумка"
	icon_state = "fannypack_purple"
	inhand_icon_state = "fannypack_purple"
	worn_icon_state = "fannypack_purple"

/obj/item/storage/belt/fannypack/blue
	name = "синяя поясная сумка"
	icon_state = "fannypack_blue"
	inhand_icon_state = "fannypack_blue"
	worn_icon_state = "fannypack_blue"

/obj/item/storage/belt/fannypack/orange
	name = "оранжевая поясная сумка"
	icon_state = "fannypack_orange"
	inhand_icon_state = "fannypack_orange"
	worn_icon_state = "fannypack_orange"

/obj/item/storage/belt/fannypack/white
	name = "белая поясная сумка"
	icon_state = "fannypack_white"
	inhand_icon_state = "fannypack_white"
	worn_icon_state = "fannypack_white"

/obj/item/storage/belt/fannypack/green
	name = "зелёная поясная сумка"
	icon_state = "fannypack_green"
	inhand_icon_state = "fannypack_green"
	worn_icon_state = "fannypack_green"

/obj/item/storage/belt/fannypack/pink
	name = "розовая поясная сумка"
	icon_state = "fannypack_pink"
	inhand_icon_state = "fannypack_pink"
	worn_icon_state = "fannypack_pink"

/obj/item/storage/belt/fannypack/cyan
	name = "голубая поясная сумка"
	icon_state = "fannypack_cyan"
	inhand_icon_state = "fannypack_cyan"
	worn_icon_state = "fannypack_cyan"

/obj/item/storage/belt/fannypack/yellow
	name = "жёлтая поясная сумка"
	icon_state = "fannypack_yellow"
	inhand_icon_state = "fannypack_yellow"
	worn_icon_state = "fannypack_yellow"
