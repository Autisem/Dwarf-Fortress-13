/obj/item/clothing/suit/armor
	allowed = null
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	armor = list(SHARP = 35, PIERCE = 30, BLUNT = 30, FIRE = 50, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate/plasteel)

/obj/item/clothing/suit/armor/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/datum/component/armor_plate/plasteel/ap = GetComponent(/datum/component/armor_plate/plasteel)
		if(ap?.amount)
			var/mutable_appearance/armor_overlay = mutable_appearance('icons/mob/clothing/suit.dmi', "armor_plasteel_[ap.amount]")
			. += armor_overlay
