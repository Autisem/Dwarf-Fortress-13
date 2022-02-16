#define LOCKER_FULL -1
//password stuff
#define MODE_OPTIONAL 1
#define MODE_PASSWORD 2
#define MODE_CARD 3
#define PASSWORD_LENGHT 3

/obj/structure/closet
	name = "шкаф"
	desc = "Это наиболее распространенный вид хранилища."
	icon = 'icons/obj/closet.dmi'
	icon_state = "generic"
	density = TRUE
	drag_slowdown = 1.5		// Same as a prone mob
	max_integrity = 200
	integrity_failure = 0.25
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 70, ACID = 60)
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	interaction_flags_atom = null

	/// Controls whether a door overlay should be applied using the icon_door value as the icon state
	var/enable_door_overlay = TRUE
	var/has_opened_overlay = TRUE
	var/has_closed_overlay = TRUE
	var/icon_door = null
	var/icon_door_override = FALSE //override to have open overlay use icon different to its base's
	var/secure = FALSE //secure locker or not, also used if overriding a non-secure locker with a secure door overlay to add fancy lights
	var/opened = FALSE
	var/welded = FALSE
	var/reinforced = FALSE
	var/locked = FALSE
	var/large = TRUE
	var/wall_mounted = 0 //never solid (You can always pass over it)
	var/breakout_time = 1200
	var/message_cooldown
	var/can_weld_shut = TRUE
	var/horizontal = FALSE
	var/allow_objects = FALSE
	var/allow_dense = FALSE
	var/dense_when_open = FALSE //if it's dense when open or not
	var/max_mob_size = MOB_SIZE_HUMAN //Biggest mob_size accepted by the container
	var/mob_storage_capacity = 3 // how many human sized mob/living can fit together inside a closet.
	var/storage_capacity = 30 //This is so that someone can't pack hundreds of items in a locker/crate then open it in a populated area to crash clients.
	var/cutting_tool = /obj/item/weldingtool
	var/open_sound = 'sound/machines/closet_open.ogg'
	var/close_sound = 'sound/machines/closet_close.ogg'
	var/open_sound_volume = 35
	var/close_sound_volume = 50
	var/material_drop = /obj/item/stack/sheet/iron
	var/material_drop_amount = 2
	var/delivery_icon = "deliverycloset" //which icon to use when packagewrapped. null to be unwrappable.
	var/anchorable = TRUE
	var/icon_welded = "welded"
	var/icon_reinforced = "reinforced"

	var/hack_progress = 0
	var/airtight_when_welded = TRUE
	var/airtight_when_closed = FALSE
	/// Protection against weather that being inside of it provides.
	var/list/weather_protection = null
	/// How close being inside of the thing provides complete pressure safety. Must be between 0 and 1!
	contents_pressure_protection = 0
	/// How insulated the thing is, for the purposes of calculating body temperature. Must be between 0 and 1!
	contents_thermal_insulation = 0
	/// Whether a skittish person can dive inside this closet. Disable if opening the closet causes "bad things" to happen or that it leads to a logical inconsistency.
	var/divable = TRUE
	/// true whenever someone with the strong pull component is dragging this, preventing opening
	var/strong_grab = FALSE
	/// passwords
	var/open_mode = MODE_OPTIONAL
	var/password = ""
	var/keypad_input = ""
	var/busy_hacked = FALSE

/obj/structure/closet/Initialize(mapload)
	if(mapload && !opened && isturf(loc))		// if closed, any item at the crate's loc is put in the contents
		addtimer(CALLBACK(src, .proc/take_contents), 0)
	if(locked && secure)
		create_password()
	. = ..()
	update_icon()
	PopulateContents()

/obj/structure/closet/proc/create_password()
	var/pass = ""
	for(var/i in 1 to 3)
		pass+="[rand(0,9)]"
	password = pass

/obj/structure/closet/ui_interact(mob/user, datum/tgui/ui)
	if(isobserver(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LockerPad", name)
		ui.open()

/obj/structure/closet/ui_data(mob/user)
	var/list/data = list()
	var/shown_input = keypad_input
	for(var/i in 1 to PASSWORD_LENGHT-length(keypad_input))
		shown_input+="_ "

	data["keypad"] = shown_input

	return data

/obj/structure/closet/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("keypad")
			switch(params["digit"])
				if("C")
					playsound(src, 'white/maxsc/sound/numpad-button.ogg', 20, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
					keypad_input = ""
				if("E")
					if(length(keypad_input) != PASSWORD_LENGHT || keypad_input != password)
						playsound(src, 'white/maxsc/sound/numpad-error.ogg', 20, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
						return
					if(keypad_input == password && locked)
						locked = FALSE
						keypad_input = ""
						usr.visible_message(span_notice("[usr] [locked ? "блокирует" : "разблокировывает"] [src].") ,
							span_notice("[locked ? "Блокирую" : "Разблокировываю"] [src]."))
						playsound(src, 'white/valtos/sounds/locker.ogg', 25, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
						update_icon()
				if("0","1","2","3","4","5","6","7","8","9")
					if(length(keypad_input) >= PASSWORD_LENGHT)
						playsound(src, 'white/maxsc/sound/numpad-error.ogg', 20, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
						return
					playsound(src, 'white/maxsc/sound/numpad-button.ogg', 20, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
					keypad_input+=params["digit"]
			ui_interact(usr) //quicker ui update

//USE THIS TO FILL IT, NOT INITIALIZE OR NEW
/obj/structure/closet/proc/PopulateContents()
	return

/obj/structure/closet/Destroy()
	dump_contents()
	return ..()

/obj/structure/closet/update_icon()
	. = ..()
	if (istype(src, /obj/structure/closet/supplypod))
		return
	if(!opened)
		layer = OBJ_LAYER
	else
		layer = BELOW_OBJ_LAYER

/obj/structure/closet/update_overlays()
	. = ..()
	closet_update_overlays(.)

/obj/structure/closet/proc/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(enable_door_overlay)
		if(opened && has_opened_overlay)
			. += "[icon_door_override ? icon_door : icon_state]_open"
			var/mutable_appearance/door_blocker = mutable_appearance(icon, "[icon_door || icon_state]_open", plane = EMISSIVE_PLANE)
			door_blocker.color = GLOB.em_block_color
			. += door_blocker // If we don't do this the door doesn't block emissives and it looks weird.
		else if(has_closed_overlay)
			. += "[icon_door || icon_state]_door"

	if(opened)
		return

	if(welded)
		. += icon_welded

	if(broken || !secure)
		return

	if(reinforced)
		. += icon_reinforced

	//Overlay is similar enough for both that we can use the same mask for both
	. += emissive_appearance(icon, "locked", alpha = src.alpha)
	. += locked ? "locked" : "unlocked"

/obj/structure/closet/examine(mob/user)
	. = ..()
	if(welded)
		. += "<hr><span class='notice'>Это приварено.</span>"
	if(reinforced)
		. += "<hr><span class='notice'>Шкаф укреплён пласталью.</span>"
	if(anchored)
		. += "<hr><span class='notice'>Это <b>прикручено</b> к полу.</span>"
	if(opened)
		. += "<hr><span class='notice'>Детали <b>сварены</b> вместе.</span>"
	else if(secure && !opened)
		. += "<hr><span class='notice'>Alt-лкм чтобы [locked ? "разблокировать" : "заблокировать"].</span>"
	if(isliving(user))
		var/mob/living/L = user
		if(HAS_TRAIT(L, TRAIT_SKITTISH))
			. += "<hr><span class='notice'>Ctrl-Shift-лкм [src] чтобы запрыгнуть внутрь.</span>"

/obj/structure/closet/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(wall_mounted)
		return TRUE

/obj/structure/closet/proc/can_open(mob/living/user, force = FALSE)
	if(force)
		return TRUE
	if(welded || locked)
		return FALSE
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		if(L.anchored || horizontal && L.mob_size > MOB_SIZE_TINY && L.density)
			if(user)
				to_chat(user, span_danger("Что-то сверху [src], мешает его открыть.")  )
			return FALSE
	return TRUE

/obj/structure/closet/proc/can_close(mob/living/user)
	var/turf/T = get_turf(src)
	for(var/obj/structure/closet/closet in T)
		if(closet != src && !closet.wall_mounted)
			return FALSE
	for(var/mob/living/L in T)
		if(L.anchored || horizontal && L.mob_size > MOB_SIZE_TINY && L.density)
			if(user)
				to_chat(user, span_danger("Внутри [src] что-то большое, оно мешает закрыть его."))
			return FALSE
	return TRUE

/obj/structure/closet/dump_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
		if(throwing) // you keep some momentum when getting out of a thrown closet
			step(AM, dir)
	if(throwing)
		throwing.finalize(FALSE)

/obj/structure/closet/proc/take_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in L)
		if(AM != src && insert(AM) == LOCKER_FULL) // limit reached
			break
	for(var/i in reverseRange(L.GetAllContents()))
		var/atom/movable/thing = i
		SEND_SIGNAL(thing, COMSIG_TRY_STORAGE_HIDE_ALL)

/obj/structure/closet/proc/open(mob/living/user, force = FALSE)
	if(!can_open(user, force))
		return
	if(opened)
		return
	welded = FALSE
	locked = FALSE
	playsound(loc, open_sound, open_sound_volume, TRUE, -3)
	opened = TRUE
	if(!dense_when_open)
		set_density(FALSE)
	dump_contents()
	update_icon()
	after_open(user, force)
	return TRUE

///Proc to override for effects after opening a door
/obj/structure/closet/proc/after_open(mob/living/user, force = FALSE)
	return

/obj/structure/closet/proc/insert(atom/movable/inserted)
	if(length(contents) >= storage_capacity)
		return LOCKER_FULL
	if(!insertion_allowed(inserted))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_CLOSET_INSERT, inserted) & COMPONENT_CLOSET_INSERT_INTERRUPT)
		return TRUE
	inserted.forceMove(src)
	return TRUE

/obj/structure/closet/proc/insertion_allowed(atom/movable/AM)
	if(ismob(AM))
		if(!isliving(AM)) //let's not put ghosts or camera mobs inside closets...
			return FALSE
		var/mob/living/L = AM
		if(L.anchored || L.buckled || L.incorporeal_move || L.has_buckled_mobs())
			return FALSE
		if(L.mob_size > MOB_SIZE_TINY) // Tiny mobs are treated as items.
			if(horizontal && L.density)
				return FALSE
			if(L.mob_size > max_mob_size)
				return FALSE
			var/mobs_stored = 0
			for(var/mob/living/M in contents)
				if(++mobs_stored >= mob_storage_capacity)
					return FALSE
		L.stop_pulling()

	else if(istype(AM, /obj/structure/closet))
		return FALSE
	else if(isobj(AM))
		if((!allow_dense && AM.density) || AM.anchored || AM.has_buckled_mobs())
			return FALSE
		else if(isitem(AM) && !HAS_TRAIT(AM, TRAIT_NODROP))
			return TRUE
	else
		return FALSE

	return TRUE

/obj/structure/closet/proc/close(mob/living/user)
	if(!opened || !can_close(user))
		return FALSE
	take_contents()
	playsound(loc, close_sound, close_sound_volume, TRUE, -3)
	opened = FALSE
	set_density(TRUE)
	update_appearance()
	after_close(user)
	return TRUE

///Proc to override for effects after closing a door
/obj/structure/closet/proc/after_close(mob/living/user)
	return

/obj/structure/closet/proc/toggle(mob/living/user)
	if(opened)
		return close(user)
	else
		return open(user)

/obj/structure/closet/deconstruct(disassembled = TRUE)
	if(ispath(material_drop) && material_drop_amount && !(flags_1 & NODECONSTRUCT_1))
		new material_drop(loc, material_drop_amount)
	qdel(src)

/obj/structure/closet/obj_break(damage_flag)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		bust_open()

/obj/structure/closet/attackby(obj/item/W, mob/user, params)
	if(user in src)
		return
	if(src.tool_interact(W,user))
		return TRUE // No afterattack
	else
		return ..()

/obj/structure/closet/proc/tool_interact(obj/item/W, mob/user)//returns TRUE if attackBy call shouldn't be continued (because tool was used/closet was of wrong type), FALSE if otherwise
	. = TRUE
	if(opened)
		if(istype(W, cutting_tool))
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return

				to_chat(user, span_notice("Начинаю резать <b>[src.name]</b> на части..."))
				if(W.use_tool(src, user, 40, volume=50))
					if(!opened)
						return
					user.visible_message(span_notice("[user] разрезает <b>[src.name]</b>.") ,
									span_notice("Режу <b>[src.name]</b> с помощью [W].") ,
									span_hear("Слышу сварку."))
					deconstruct(TRUE)
				return
			else // for example cardboard box is cut with wirecutters
				user.visible_message(span_notice("[user] разрезает <b>[src.name]</b>.") , \
									span_notice("Режу <b>[src.name]</b> с помощью [W]."))
				deconstruct(TRUE)
				return
		if(user.transferItemToLoc(W, drop_location())) // so we put in unlit welder too
			return
	else if(W.tool_behaviour == TOOL_WELDER && can_weld_shut)
		if(!W.tool_start_check(user, amount=0))
			return

		to_chat(user, span_notice("Начинаю [welded ? "разваривать":"заваривать"] <b>[src.name]</b>..."))
		if(W.use_tool(src, user, 40, volume=50))
			if(opened)
				return
			welded = !welded
			after_weld(welded)
			user.visible_message(span_notice("[user] [welded ? "заваривает" : "разваривает"] <b>[src.name]</b>.") ,
							span_notice("[welded ? "Завариваю" : "Развариваю"] <b>[src.name]</b> используя [W].") ,
							span_hear("Слышу сварку."))
			log_game("[key_name(user)] [welded ? "welded":"unwelded"] closet [src] with [W] at [AREACOORD(src)]")
			update_icon()
	else if(W.tool_behaviour == TOOL_WRENCH && anchorable)
		if(isinspace() && !anchored)
			return
		set_anchored(!anchored)
		W.play_tool_sound(src, 75)
		user.visible_message(span_notice("<b>[user]</b> [anchored ? "прикручивает" : "откручивает"] <b>[src.name]</b> [anchored ? "к полу" : "от пола"].") , \
						span_notice("[anchored ? "Прикручиваю" : "Откручиваю"] <b>[src.name]</b> [anchored ? "к полу" : "от полу"].") , \
						span_hear("Слышу трещотку."))
	else if(istype(W, /obj/item/stack/sheet/plasteel) && secure)
		if(reinforced)
			to_chat(user, span_warning("Уже укреплено. Если поставить больше, то шкаф развалится."))
			return
		var/obj/item/stack/S = W
		if(!S.use(5))
			to_chat(user, span_warning("Нужно 5 листов пластали для укрепления шкафа."))
			return
		user.visible_message(span_notice("<b>[user]</b> укрепляет <b>[src.name]</b> пласталью.") , \
						span_notice("Укрепляю <b>[src.name]</b> пласталью. Теперь ему не страшны копья.") , \
						span_hear("Слышу лязг метала."))
		armor = armor.modifyRating(melee = 10, bullet = 10, laser = 10, energy = 10, bomb = 10, fire = 10)
		reinforced = TRUE
		update_icon()
		return
	else if(W.tool_behaviour == TOOL_SCREWDRIVER && secure)
		if(!locked)
			var/list/choices = list(
				"Пароль и ID-Карта" = icon('white/valtos/icons/radial.dmi', "pai"),
				"Только ID-Карта" = icon('white/valtos/icons/radial.dmi', "i"),
				"Только Пароль" = icon('white/valtos/icons/radial.dmi', "p"),
			)
			var/answer = show_radial_menu(user, src, choices, require_near=TRUE)
			if(!answer)
				return
			var/list/l = list("Пароль и ID-Карта"=MODE_OPTIONAL, "Только ID-Карта"=MODE_CARD, "Только Пароль"=MODE_PASSWORD)
			open_mode = l[answer]
			to_chat(user, span_notice("Меняю режим на [lowertext(answer)]."))
			user.visible_message(span_warning("[user] блокирует <b>[src]</b> используя [W].") ,
									span_warning("Блокирую <b>[src]</b>."))
			locked = TRUE
			playsound(src, 'white/valtos/sounds/locker.ogg', 25, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
			update_icon()
			return
	else if(W.tool_behaviour == TOOL_MULTITOOL && secure)
		if(!locked && password)
			to_chat(user, span_notice("Пароль: [password]."))
		if(locked && open_mode == MODE_PASSWORD | open_mode == MODE_OPTIONAL)
			ui_interact(user)
	else if(istype(W, /obj/item/closet_hacker) && locked && secure && password)
		if(length(keypad_input)>=PASSWORD_LENGHT)
			return
		var/obj/item/closet_hacker/H = W
		if(!busy_hacked)
			busy_hacked = TRUE
			to_chat(user, span_notice("Начинаю взлом [src]."))
			if(do_after(user, H.hack_time, src))
				keypad_input+=password[length(keypad_input)+1]
				playsound(src, 'white/maxsc/sound/numpad-button.ogg', 20, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
			to_chat(user, span_notice("Заканчиваю взлом [src]."))
			busy_hacked = FALSE
	else
		return FALSE

/obj/structure/closet/proc/after_weld(weld_state)
	return

/obj/structure/closet/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O) || O.anchored || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated() || user.body_position == LYING_DOWN)
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb onto it
		return ..()
	if(!opened)
		return
	if(!isturf(O.loc))
		return

	var/actuallyismob = 0
	if(isliving(O))
		actuallyismob = 1
	else if(!isitem(O))
		return
	var/turf/T = get_turf(src)
	var/list/targets = list(O, src)
	add_fingerprint(user)
	user.visible_message(span_warning("[user] [actuallyismob ? "Пытаюсь ":""]вставить[O] в [src].") , \
		span_warning("[actuallyismob ? "Пытаюсь ":""]вставить [O] в [src].") , \
		span_hear("Слышу лязг."))
	if(actuallyismob)
		if(do_after_mob(user, targets, 40))
			user.visible_message(span_notice("[user] вставляет [O] в [src].") , \
				span_notice("Вставляю [O] в [src].") , \
				span_hear("Cлышу громкий металлический удар."))
			var/mob/living/L = O
			L.Paralyze(40)
			if(istype(src, /obj/structure/closet/supplypod/extractionpod))
				O.forceMove(src)
			else
				O.forceMove(T)
				close()
	else
		O.forceMove(T)
	return 1

/obj/structure/closet/relaymove(mob/living/user, direction)
	if(user.stat || !isturf(loc))
		return
	if(locked)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, span_warning("[capitalize(src.name)] дверь не поддается!"))
		return
	container_resist_act(user)


/obj/structure/closet/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(user.body_position == LYING_DOWN && get_dist(src, user) > 0)
		return

	if(!toggle(user))
		togglelock(user)


/obj/structure/closet/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/closet/verb/verb_toggleopen()
	set src in view(1)
	set category = "Объект"
	set name = "Toggle Open"

	if(!usr.canUseTopic(src, BE_CLOSE) || !isturf(loc))
		return

	if(iscarbon(usr))
		return toggle(usr)
	else
		to_chat(usr, span_warning("This mob type can't use this verb."))

// Objects that try to exit a locker by stepping were doing so successfully,
// and due to an oversight in turf/Enter() were going through walls.  That
// should be independently resolved, but this is also an interesting twist.
/obj/structure/closet/Exit(atom/movable/AM)
	open()
	if(AM.loc == src)
		return FALSE
	return TRUE

/obj/structure/closet/container_resist_act(mob/living/user)
	if(opened)
		return
	if(ismovable(loc))
		user.changeNext_move(CLICK_CD_BREAKOUT)
		user.last_special = world.time + CLICK_CD_BREAKOUT
		var/atom/movable/AM = loc
		AM.relay_container_resist_act(user, src)
		return
	if(!welded && !locked)
		open()
		return

	//okay, so the closet is either welded or locked... resist!!!
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_warning("[capitalize(src.name)] начинает сильно трястись!") , \
		span_notice("Упираюсь спиной в [src] и начинаю толкать дверь... (это займёт примерно [DisplayTimeText(breakout_time)].)") , \
		span_hear("Слышу стук от [src]."))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src || opened || (!locked && !welded) )
			return
		//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting
		user.visible_message(span_danger("[user] успешно вырвался из хватки [src]!") ,
							span_notice("Успешно вырвался из захвата [src]!"))
		bust_open()
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, span_warning("Не могу вырваться из захвата [src]!"))

/obj/structure/closet/proc/bust_open()
	SIGNAL_HANDLER
	welded = FALSE //applies to all lockers
	locked = FALSE //applies to critter crates and secure lockers only
	broken = TRUE //applies to secure lockers only
	open()

/obj/structure/closet/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE) || !isturf(loc))
		return
	if(opened || !secure)
		return
	else
		togglelock(user)

/obj/structure/closet/CtrlShiftClick(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_SKITTISH))
		return ..()
	if(!user.canUseTopic(src, BE_CLOSE) || !isturf(user.loc))
		return
	dive_into(user)

/obj/structure/closet/proc/togglelock(mob/living/user, silent)
	if(secure && !broken)
		if(open_mode == MODE_PASSWORD)
			if(iscarbon(user))
				add_fingerprint(user)
			if(locked)
				INVOKE_ASYNC(src, /datum/.proc/ui_interact, user)
			else
				locked = !locked
				playsound(src, 'white/valtos/sounds/locker.ogg', 25, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
				user.visible_message(span_notice("[user] [locked ? "блокирует" : "разблокировывает"] [src].") ,
								span_notice("[locked ? "Блокирую" : "Разблокировываю"] [src]."))
				update_icon()
			return
		else if(!silent)
			to_chat(user, span_alert("Доступ запрещён."))
	else if(secure && broken)
		to_chat(user, span_warning("<b>[src.name]</b> сломан!"))

/obj/structure/closet/get_remote_view_fullscreens(mob/user)
	if(user.stat == DEAD || !(user.sight & (SEEOBJS|SEEMOBS)))
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, 1)

/obj/structure/closet/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if (!(. & EMP_PROTECT_CONTENTS))
		for(var/obj/O in src)
			O.emp_act(severity)
	if(secure && !broken && !(. & EMP_PROTECT_SELF))
		if(prob(50 / severity))
			locked = !locked
			update_icon()
		if(prob(20 / severity) && !opened)
			if(!locked)
				open()

/obj/structure/closet/contents_explosion(severity, target)
	for(var/thing in contents)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += thing
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += thing
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += thing

/obj/structure/closet/AllowDrop()
	return TRUE

/obj/structure/closet/return_temperature()
	return

#undef LOCKER_FULL
/obj/structure/closet/proc/dive_into(mob/living/user)
	var/turf/T1 = get_turf(user)
	var/turf/T2 = get_turf(src)
	if(!opened)
		if(locked)
			togglelock(user, TRUE)
		if(!open(user))
			to_chat(user, span_warning("Это не сдвинется с места!"))
			return
	step_towards(user, T2)
	T1 = get_turf(user)
	if(T1 == T2)
		user.set_resting(TRUE) //so people can jump into crates without slamming the lid on their head
		if(!close(user))
			to_chat(user, span_warning("Не могу заставить [src] закрыться!"))
			user.set_resting(FALSE)
			return
		user.set_resting(FALSE)
		togglelock(user)
		T1.visible_message(span_warning("[user] прыгает в [src]!"))

#undef MODE_PASSWORD
#undef MODE_OPTIONAL
#undef MODE_CARD
#undef PASSWORD_LENGHT
