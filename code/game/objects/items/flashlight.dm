/obj/item/flashlight
	name = "flashlight"
	desc = "A source of light in the dark."
	custom_price = PAYCHECK_EASY
	icon = 'dwarfs/icons/items/equipment.dmi'
	icon_state = "flashlight"
	inhand_icon_state = "flashlight"
	worn_icon_state = "flashlight"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 4
	light_power = 1
	light_on = FALSE
	var/on = FALSE
	light_color = "#ffeac1"


/obj/item/flashlight/Initialize()
	. = ..()
	if(icon_state == "[initial(icon_state)]_on")
		on = TRUE
	update_brightness()

/obj/item/flashlight/proc/update_brightness(mob/user)
	if(on)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)
	set_light_on(on)
	if(light_system == STATIC_LIGHT)
		update_light()


/obj/item/flashlight/attack_self(mob/user)
	on = !on
	playsound(user, on ? 'sound/weapons/magin.ogg' : 'sound/weapons/magout.ogg', 40, TRUE)
	update_brightness(user)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()
	return 1

/obj/item/flashlight/suicide_act(mob/living/carbon/human/user)
	if (user.is_blind())
		user.visible_message(span_suicide("[user] is putting [src] close to [user.ru_ego()] eyes and turning it on... but [user.p_theyre()] blind!"))
		return SHAME
	user.visible_message(span_suicide("[user] is putting [src] close to [user.ru_ego()] eyes and turning it on! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (FIRELOSS)

/obj/item/flashlight/attack(mob/living/carbon/M, mob/living/carbon/human/user)
	add_fingerprint(user)
	if(istype(M) && on && (user.zone_selected in list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH)))

		if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		if(!ISADVANCEDTOOLUSER(user))
			to_chat(user, span_warning("You lack the dexterity to use this!"))
			return

		if(!M.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning("[M] has no head!"))
			return

		if(light_power < 1)
			to_chat(user, span_warning("[src] isn't bright enough for this!"))
			return

		switch(user.zone_selected)
			if(BODY_ZONE_PRECISE_EYES)
				if((M.head && M.head.flags_cover & HEADCOVERSEYES) || (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) || (M.glasses && M.glasses.flags_cover & GLASSESCOVERSEYES))
					to_chat(user, span_warning("You're going to need to remove that [(M.head && M.head.flags_cover & HEADCOVERSEYES) ? "helmet" : (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) ? "mask": "glasses"] first!"))
					return

				var/obj/item/organ/eyes/E = M.getorganslot(ORGAN_SLOT_EYES)
				if(!E)
					to_chat(user, span_warning("[M] has no eyes!"))
					return

				if(M == user)	//they're using it on themselves
					if(M.flash_act(visual = 1))
						M.visible_message(span_notice("[M] directs [src] to [M.p_their()] eyes."), span_notice("You wave the light in front of your eyes! Trippy!"))
					else
						M.visible_message(span_notice("[M] directs [src] to [M.p_their()] eyes."), span_notice("You wave the light in front of your eyes."))
				else
					user.visible_message(span_warning("[user] directs [src] to [M]'s eyes."), \
						span_danger("You direct [src] to [M]'s eyes."))
					if(M.stat == DEAD || (M.is_blind()) || !M.flash_act(visual = 1)) //mob is dead or fully blind
						to_chat(user, span_warning("[M]'s pupils don't react to the light!"))
					else //they're okay!
						to_chat(user, span_notice("[M]'s pupils narrow."))

			if(BODY_ZONE_PRECISE_MOUTH)

				if(M.is_mouth_covered())
					to_chat(user, span_warning("You're going to need to remove that [(M.head && M.head.flags_cover & HEADCOVERSMOUTH) ? "helmet" : "mask"] first!"))
					return

				var/their = M.p_their()

				var/list/mouth_organs = new
				for(var/obj/item/organ/O in M.internal_organs)
					if(O.zone == BODY_ZONE_PRECISE_MOUTH)
						mouth_organs.Add(O)
				var/organ_list = ""
				var/organ_count = LAZYLEN(mouth_organs)
				if(organ_count)
					for(var/I in 1 to organ_count)
						if(I > 1)
							if(I == mouth_organs.len)
								organ_list += ", and "
							else
								organ_list += ", "
						var/obj/item/organ/O = mouth_organs[I]
						organ_list += (O.gender == "plural" ? O.name : " [O.name]")

				var/pill_count = 0
				for(var/datum/action/item_action/hands_free/activate_pill/AP in M.actions)
					pill_count++

				if(M == user)
					var/can_use_mirror = FALSE
					if(isturf(user.loc))
						var/obj/structure/mirror/mirror = locate(/obj/structure/mirror, user.loc)
						if(mirror)
							switch(user.dir)
								if(NORTH)
									can_use_mirror = mirror.pixel_y > 0
								if(SOUTH)
									can_use_mirror = mirror.pixel_y < 0
								if(EAST)
									can_use_mirror = mirror.pixel_x > 0
								if(WEST)
									can_use_mirror = mirror.pixel_x < 0

					M.visible_message(span_notice("[M] directs [src] to [their] mouth."), \
					span_notice("You point [src] into your mouth."))
					if(!can_use_mirror)
						to_chat(user, span_notice("You can't see anything without a mirror."))
						return
					if(organ_count)
						to_chat(user, span_notice("Inside your mouth [organ_count > 1 ? "are" : "is"] [organ_list]."))
					else
						to_chat(user, span_notice("There's nothing inside your mouth."))
					if(pill_count)
						to_chat(user, span_notice("You have [pill_count] implanted pill[pill_count > 1 ? "s" : ""]."))

				else
					user.visible_message(span_notice("[user] directs [src] to [M]'s mouth."),\
						span_notice("You direct [src] to [M]'s mouth."))
					if(organ_count)
						to_chat(user, span_notice("Inside [their] mouth [organ_count > 1 ? "are" : "is"] [organ_list]."))
					else
						to_chat(user, span_notice("[M] doesn't have any organs in [their] mouth."))
					if(pill_count)
						to_chat(user, span_notice("[M] has [pill_count] pill[pill_count > 1 ? "s" : ""] implanted in [their] teeth."))

	else
		return ..()

// FUELED LAMPS

/obj/item/flashlight/fueled
	name = "torch"
	desc = "Torch."
	w_class = WEIGHT_CLASS_SMALL
	light_range = 7 // Pretty bright.
	icon_state = "flare"
	inhand_icon_state = "flare"
	worn_icon_state = "flare"
	actions_types = list()
	/// How many seconds of fuel we have left
	var/fuel = 0
	var/on_damage = 7
	var/icon_state_burned
	heat = 1000
	light_color = LIGHT_COLOR_ORANGE
	light_system = MOVABLE_LIGHT
	grind_results = list(/datum/reagent/sulfur = 15)

/obj/item/flashlight/fueled/Initialize()
	. = ..()
	fuel = rand(1600, 2000)

/obj/item/flashlight/fueled/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/fueled/process(delta_time)
	open_flame(heat)
	fuel = max(fuel -= delta_time, 0)
	if(fuel <= 0 || !on)
		turn_off()
		if(!fuel)
			if(icon_state_burned)
				icon_state = "[initial(icon_state)]_burned"
			else
				icon_state = "[initial(icon_state)]"
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/fueled/ignition_effect(atom/A, mob/user)
	. = fuel && on ? span_notice("[user] ignites [A.name] with [src.name].")  : ""

/obj/item/flashlight/fueled/proc/turn_off()
	on = FALSE
	force = initial(src.force)
	damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/flashlight/fueled/update_brightness(mob/user = null)
	..()
	if(on)
		inhand_icon_state = "[initial(inhand_icon_state)]_on"
	else
		inhand_icon_state = "[initial(inhand_icon_state)]"

/obj/item/flashlight/fueled/attack_self(mob/user)

	// Usual checks
	if(fuel <= 0)
		to_chat(user, span_warning("[src] burns out!"))
		return
	if(on)
		to_chat(user, span_warning("[src] is already burning!"))
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message(span_notice("[user] ignites [src].") , span_notice("You ignite [src]!"))
		force = on_damage
		damtype = BURN
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/fueled/get_temperature()
	return on * heat

/obj/item/flashlight/fueled/torch
	name = "torch"
	desc = "Uhghh!"
	w_class = WEIGHT_CLASS_BULKY
	light_range = 5
	icon_state = "torch"
	icon_state_burned = "torch_burned"
	inhand_icon_state = "torch"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	light_color = LIGHT_COLOR_ORANGE
	light_system = MOVABLE_LIGHT
	on_damage = 10
	slot_flags = null

/obj/item/flashlight/fueled/torch/Initialize()
	. = ..()
	fuel = rand(8000, 9000)

/obj/item/flashlight/fueled/torch/turn_off()
	. = ..()
	if(istype(loc, /obj/structure/sconce))
		loc.update_appearance()

/obj/item/flashlight/fueled/torch/lit

/obj/item/flashlight/fueled/torch/lit/Initialize()
	. = ..()
	on = TRUE
	update_brightness()
	START_PROCESSING(SSobj, src)

/obj/item/flashlight/fueled/candle
	name = "candle"
	desc = "cAndLE"
	w_class = WEIGHT_CLASS_TINY
	light_range = 3
	icon_state = "candle"
	light_color = LIGHT_COLOR_YELLOW
	light_system = MOVABLE_LIGHT
	on_damage = 4

/obj/item/flashlight/fueled/candle/turn_off()
	qdel(src) // candle disappears once it's burned out

/obj/item/flashlight/fueled/lantern
	name = "lantern"
	icon_state = "lantern"
	inhand_icon_state = "lantern"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	desc = "Brother, lamp"
	light_range = 6			// luminosity when on
	light_system = MOVABLE_LIGHT
	light_color = "#e7c16d"

/obj/item/flashlight/fueled/lantern/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/flashlight/fueled/candle))
		if(fuel)
			to_chat(user, span_warning("[src] already has a candle inside."))
			return
		var/obj/item/flashlight/fueled/candle/C = I
		fuel += C.fuel
		if(C.on && !on)
			on = TRUE
			icon_state = "lantern_on"
			damtype = BURN
			START_PROCESSING(SSobj, src)
		qdel(C)
	else
		. = ..()
