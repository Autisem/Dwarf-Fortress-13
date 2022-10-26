/obj/item/clothing/under
	name = "under"
	icon = 'icons/obj/clothing/under/default.dmi'
	worn_icon = 'icons/mob/clothing/under/default.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	permeability_coefficient = 0.9
	slot_flags = ITEM_SLOT_ICLOTHING
	armor = list(SHARP = 0, PIERCE = 0, BLUNT = 0, FIRE = 0, ACID = 0, WOUND = 5)
	equip_sound = 'sound/items/equip/jumpsuit_equip.ogg'
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound =  'sound/items/handling/cloth_pickup.ogg'
	limb_integrity = 30
	var/fitted = FEMALE_UNIFORM_FULL // For use in alternate clothing styles for women
	var/can_adjust = TRUE
	var/adjusted = NORMAL_STYLE
	var/alt_covers_chest = FALSE // for adjusted/rolled-down jumpsuits, FALSE = exposes chest and arms, TRUE = exposes arms only
	var/obj/item/clothing/accessory/attached_accessory
	var/mutable_appearance/accessory_overlay
	var/mutantrace_variation = NO_MUTANTRACE_VARIATION //Are there special sprites for specific situations? Don't use this unless you need to.
	var/freshly_laundered = FALSE

/obj/item/clothing/under/worn_overlays(isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damageduniform")
		if(HAS_BLOOD_DNA(src))
			. += mutable_appearance('icons/effects/blood.dmi', "uniformblood")
		if(accessory_overlay)
			. += accessory_overlay

/obj/item/clothing/under/attackby(obj/item/I, mob/user, params)
	if(!attach_accessory(I, user))
		return ..()

/obj/item/clothing/under/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_w_uniform()

/obj/item/clothing/under/equipped(mob/user, slot)
	..()
	if(adjusted)
		adjusted = NORMAL_STYLE
		fitted = initial(fitted)
		if(!alt_covers_chest)
			body_parts_covered |= CHEST

	if(mutantrace_variation && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(DIGITIGRADE in H.dna.species.species_traits)
			adjusted = DIGITIGRADE_STYLE
		H.update_inv_w_uniform()

	if(slot == ITEM_SLOT_ICLOTHING && freshly_laundered)
		freshly_laundered = FALSE
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "fresh_laundry", /datum/mood_event/fresh_laundry)

	if(attached_accessory && slot != ITEM_SLOT_HANDS && ishuman(user))
		var/mob/living/carbon/human/H = user
		attached_accessory.on_uniform_equip(src, user)
		if(attached_accessory.above_suit)
			H.update_inv_wear_suit()

/obj/item/clothing/under/dropped(mob/user)
	if(attached_accessory)
		attached_accessory.on_uniform_dropped(src, user)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(attached_accessory.above_suit)
				H.update_inv_wear_suit()
	..()

/obj/item/clothing/under/proc/attach_accessory(obj/item/I, mob/user, notifyAttach = 1, params)
	. = FALSE
	if(istype(I, /obj/item/clothing/accessory))
		var/obj/item/clothing/accessory/A = I
		if(attached_accessory)
			if(user)
				to_chat(user, span_warning("<b>[src.name]</b> already has something attached to it."))
			return
		else

			if(!A.can_attach_accessory(src, user)) //Make sure the suit has a place to put the accessory.
				return
			if(user && !user.temporarilyRemoveItemFromInventory(I))
				return
			if(!A.attach(src, user))
				return

			if(user && notifyAttach)
				to_chat(user, span_notice("You attach <b>[I.name]</b> to <b>[src.name]</b>."))

			var/accessory_color = attached_accessory.icon_state
			if(I.worn_icon)
				accessory_overlay = mutable_appearance(I.worn_icon, "[accessory_color]")
			else
				accessory_overlay = mutable_appearance('icons/mob/clothing/accessories.dmi', "[accessory_color]")

			var/list/click_params = params2list(params)
			if(click_params && click_params["icon-x"] && click_params["icon-y"])
				var/cx = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
				var/cy = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
				accessory_overlay.transform = matrix(accessory_overlay.transform).Translate(cx, cy)

			accessory_overlay.alpha = attached_accessory.alpha
			accessory_overlay.color = attached_accessory.color

			if(ishuman(loc))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform()
				H.update_inv_wear_suit()

			return TRUE

/obj/item/clothing/under/proc/remove_accessory(mob/user)
	if(!isliving(user))
		return
	if(!can_use(user))
		return

	if(attached_accessory)
		var/obj/item/clothing/accessory/A = attached_accessory
		attached_accessory.detach(src, user)
		if(user.put_in_hands(A))
			to_chat(user, span_notice("You remove <b>[A.name]</b> from <b>[src.name]</b>."))
		else
			to_chat(user, span_notice("You remove <b>[A.name]</b> from <b>[src.name]</b> and it falls onto floor."))

		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()


/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(freshly_laundered)
		. += "<hr>Looks fresh and clean."
	if(can_adjust)
		if(adjusted == ALT_STYLE)
			. += "<hr>RMB on [src.name] to wear it normally."
		else
			. += "<hr>RMB on [src.name] to wear it casually."
	if(attached_accessory)
		. += "<hr>Wow! It has [attached_accessory] attached."

/obj/item/clothing/under/AltClick(mob/user)
	. = ..()
	if(.)
		return

	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE))
		return
	if(attached_accessory)
		remove_accessory(user)
	else
		rolldown()

/obj/item/clothing/under/verb/jumpsuit_adjust()
	set name = "Adjust Suit"
	set category = null
	set src in usr
	rolldown()

/obj/item/clothing/under/proc/rolldown()
	if(!can_use(usr))
		return
	if(!can_adjust)
		to_chat(usr, span_warning("Cannot adjust this suit!"))
		return
	if(toggle_jumpsuit_adjust())
		to_chat(usr, span_notice("You will wear it casually now."))
	else
		to_chat(usr, span_notice("You will wear it normally now."))
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.update_inv_w_uniform()
		H.update_body()

/obj/item/clothing/under/proc/toggle_jumpsuit_adjust()
	if(adjusted == DIGITIGRADE_STYLE)
		return
	adjusted = !adjusted
	if(adjusted)
		if(fitted != FEMALE_UNIFORM_TOP)
			fitted = NO_FEMALE_UNIFORM
		if(!alt_covers_chest) // for the special snowflake suits that expose the chest when adjusted (and also the arms, realistically)
			body_parts_covered &= ~CHEST
			body_parts_covered &= ~ARMS
	else
		fitted = initial(fitted)
		if(!alt_covers_chest)
			body_parts_covered |= CHEST
			body_parts_covered |= ARMS
			if(!LAZYLEN(damage_by_parts))
				return adjusted
			for(var/zone in list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)) // ugly check to make sure we don't reenable protection on a disabled part
				if(damage_by_parts[zone] > limb_integrity)
					for(var/part in zone2body_parts_covered(zone))
						body_parts_covered &= part
	return adjusted

/obj/item/clothing/under/rank
	dying_key = DYE_REGISTRY_UNDER
