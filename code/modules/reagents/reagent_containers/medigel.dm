/obj/item/reagent_containers/medigel
	name = "medical gel"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "medigel"
	inhand_icon_state = "spraycan"
	worn_icon_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	item_flags = NOBLUDGEON
	obj_flags = UNIQUE_RENAME
	reagent_flags = OPENCONTAINER
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	amount_per_transfer_from_this = 10
	volume = 60
	var/can_fill_from_container = TRUE
	var/apply_type = PATCH
	var/apply_method = "spray" //the thick gel is sprayed and then dries into patch like film.
	var/self_delay = 30
	var/squirt_mode = 0
	custom_price = PAYCHECK_MEDIUM * 2

/obj/item/reagent_containers/medigel/attack_self(mob/user)
	squirt_mode = !squirt_mode
	return ..()

/obj/item/reagent_containers/medigel/attack_self_secondary(mob/user)
	squirt_mode = !squirt_mode
	return ..()

/obj/item/reagent_containers/medigel/attack(mob/M, mob/user, def_zone)
	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[src] is empty!"))
		return

	if(M == user)
		M.visible_message(span_notice("[user] attempts to [apply_method] [src] on [user.p_them()]self."))
		if(self_delay)
			if(!do_mob(user, M, self_delay))
				return
			if(!reagents || !reagents.total_volume)
				return
		to_chat(M, span_notice("You [apply_method] yourself with [src]."))

	else
		log_combat(user, M, "attempted to apply", src, reagents.log_list())
		M.visible_message(span_danger("[user] attempts to [apply_method] [src] on [M]."), \
							span_userdanger("[user] attempts to [apply_method] [src] on you."))
		if(!do_mob(user, M, CHEM_INTERACT_DELAY(3 SECONDS, user)))
			return
		if(!reagents || !reagents.total_volume)
			return
		M.visible_message(span_danger("[user] [apply_method]s [M] down with [src]."), \
							span_userdanger("[user] [apply_method]s you down with [src]."))

	if(!reagents || !reagents.total_volume)
		return

	else
		log_combat(user, M, "applied", src, reagents.log_list())
		playsound(src, 'sound/effects/spray.ogg', 30, TRUE, -6)
		reagents.trans_to(M, amount_per_transfer_from_this, transfered_by = user, methods = apply_type)
	return
