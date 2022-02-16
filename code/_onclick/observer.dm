/mob/dead/observer/DblClickOn(atom/A, params)
	if(check_click_intercept(params, A))
		return

	if(can_reenter_corpse && mind?.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (body bag, closet, mech, etc)
			return									// seems legit.

	// Things you might plausibly want to follow
	if(ismovable(A))
		ManualFollow(A)

	// Otherwise jump
	else if(A.loc)
		abstract_move(get_turf(A))
		update_parallax_contents()

/mob/dead/observer/ClickOn(atom/A, params)
	if(check_click_intercept(params,A))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["middle"])
		ShiftMiddleClickOn(A)
		return
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"])
		AltClickNoInteract(src, A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(world.time <= next_move)
		return
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/dead/observer/user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_GHOST, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(user.client)
		if(user.client.prefs.inquisitive_ghost)
			user.examinate(src)
	return FALSE

/mob/living/attack_ghost(mob/dead/observer/user)
	if(HAS_TRAIT(src, TRAIT_CLIENT_LEAVED) && !is_banned_from(user.key, ROLE_ICECREAM))
		var/ghost_role = tgui_alert(user, "Точно хочешь занять это тело? (Больше не сможешь вернуться в своё прошлое тело!)",,list("Да","Нет"))
		if(ghost_role != "Да" || !user.loc || QDELETED(user))
			return
		if(QDELETED(src) || QDELETED(user))
			return
		if(src.client)
			to_chat(user, span_warning("Тело уже занято! [prob(10) ? "Лошара." : "В следующий раз повезёт."]"))
			return
		to_chat(src, span_warning("Моё тело забрали?! Срочно нажми F1 и опиши проблему.")) //такой хуйни быть не должно.
		log_game("[key_name(user)] Ice Creamed and became [src].")
		message_admins("[key_name_admin(user)] забирает тело апатика ([ADMIN_LOOKUPFLW(src)]) себе.")
		ghostize(0)
		key = user.key
		client?.init_verbs()
		return
	return ..()
