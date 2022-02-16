/* Morgue stuff
 * Contains:
 *		Morgue
 *		Morgue tray
 *		Crematorium
 *		Creamatorium
 *		Crematorium tray
 *		Crematorium button
 */

/*
 * Bodycontainer
 * Parent class for morgue and crematorium
 * For overriding only
 */
GLOBAL_LIST_EMPTY(bodycontainers) //Let them act as spawnpoints for revenants and other ghosties.

/obj/structure/bodycontainer
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morgue1"
	density = TRUE
	anchored = TRUE
	max_integrity = 400

	var/obj/structure/tray/connected = null
	var/locked = FALSE
	dir = SOUTH
	var/message_cooldown
	var/breakout_time = 600

/obj/structure/bodycontainer/Initialize()
	. = ..()
	GLOB.bodycontainers += src
	recursive_organ_check(src)

/obj/structure/bodycontainer/Destroy()
	GLOB.bodycontainers -= src
	open()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/structure/bodycontainer/on_log(login)
	..()
	update_icon()

/obj/structure/bodycontainer/update_icon()
	return

/obj/structure/bodycontainer/relaymove(mob/living/user, direction)
	if(user.stat || !isturf(loc))
		return
	if(locked)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, span_warning("[capitalize(src.name)] не поддаётся!"))
		return
	open()

/obj/structure/bodycontainer/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bodycontainer/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(locked)
		to_chat(user, span_danger("Заблокировано."))
		return
	if(!connected)
		to_chat(user, "Здесь нет ложа. Как так?")
		return
	if(connected.loc == src)
		open()
	else
		close()
	add_fingerprint(user)

/obj/structure/bodycontainer/attackby(obj/P, mob/user, params)
	add_fingerprint(user)
	if(istype(P, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, span_notice("Царапаю что-то прикольное на [src]!"))
			return
		var/t = stripped_input(user, "Что же мы напишем?", text("[]", name), null)
		if (user.get_active_held_item() != P)
			return
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if (t)
			name = text("[]- '[]'", initial(name), t)
		else
			name = initial(name)
	else
		return ..()

/obj/structure/bodycontainer/deconstruct(disassembled = TRUE)
	if (!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/iron (loc, 5)
	recursive_organ_check(src)
	qdel(src)

/obj/structure/bodycontainer/container_resist_act(mob/living/user)
	if(!locked)
		open()
		return
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(null, \
		span_notice("Начинаю расшатывать стенки [src.name] в попытке открыть его... (это займёт примерно [DisplayTimeText(breakout_time)].)") , \
		span_hear("Слышу металлический звон исходящий от [src.name]."))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src )
			return
		user.visible_message(span_warning("[user] успешно вырывается из [src.name]!") , \
			span_notice("Успешно вылезаю из [src.name]!"))
		open()

/obj/structure/bodycontainer/proc/open()
	recursive_organ_check(src)
	playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	playsound(src, 'sound/effects/roll.ogg', 5, TRUE)
	var/turf/T = get_step(src, dir)
	if (connected)
		connected.setDir(dir)
	for(var/atom/movable/AM in src)
		AM.forceMove(T)
	update_icon()

/obj/structure/bodycontainer/proc/close()
	playsound(src, 'sound/effects/roll.ogg', 5, TRUE)
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	for(var/atom/movable/AM in connected.loc)
		if(!AM.anchored || AM == connected)
			if(ismob(AM) && !isliving(AM))
				continue
			AM.forceMove(src)
	recursive_organ_check(src)
	update_icon()

/obj/structure/bodycontainer/get_remote_view_fullscreens(mob/user)
	if(user.stat == DEAD || !(user.sight & (SEEOBJS|SEEMOBS)))
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, 2)
/*
 * Morgue
 */
/obj/structure/bodycontainer/morgue
	name = "морг"
	desc = "Используется для долговременного хранения тел и возможности восстановить их. Снабжён системой оповещения, если тело вдруг подаст признаки жизни."
	icon_state = "morgue1"
	dir = EAST
	var/beeper = TRUE
	var/beep_cooldown = 50
	var/next_beep = 0

/obj/structure/bodycontainer/morgue/Initialize()
	. = ..()
	connected = new/obj/structure/tray/m_tray(src)
	connected.connected = src

/obj/structure/bodycontainer/morgue/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Динамик [beeper ? "включен" : "отключен"]. ПКМ для смены режима.</span>"

/obj/structure/bodycontainer/morgue/AltClick(mob/user)
	..()
	beeper = !beeper
	to_chat(user, span_notice("[beeper ? "Включаю" : "Выключаю"] систему оповещений."))

/obj/structure/bodycontainer/morgue/update_icon()
	if (!connected || connected.loc != src) // Open or tray is gone.
		icon_state = "morgue0"
	else
		if(contents.len == 1)  // Empty
			icon_state = "morgue1"
		else
			icon_state = "morgue2" // Dead, brainded mob.
			var/list/compiled = get_all_contents_type(/mob/living) // Search for mobs in all contents.
			if(!length(compiled)) // No mobs?
				icon_state = "morgue3"
				return

			for(var/mob/living/M in compiled)
				var/mob/living/mob_occupant = get_mob_or_brainmob(M)
				if(mob_occupant.client && !mob_occupant.suiciding && !(HAS_TRAIT(mob_occupant, TRAIT_BADDNA)) && !mob_occupant.hellbound)
					icon_state = "morgue4" // Revivable
					if(mob_occupant.stat == DEAD && beeper)
						if(world.time > next_beep)
							playsound(src, 'sound/weapons/gun/general/empty_alarm.ogg', 50, FALSE) //Revive them you blind fucks
							next_beep = world.time + beep_cooldown
					break


/obj/item/paper/guides/jobs/medical/morgue
	name = "morgue memo"
	info = "<font size='2'>Since this station's medbay never seems to fail to be staffed by the mindless monkeys meant for genetics experiments, I'm leaving a reminder here for anyone handling the pile of cadavers the quacks are sure to leave.</font><BR><BR><font size='4'><font color=red>Red lights mean there's a plain ol' dead body inside.</font><BR><BR><font color=orange>Yellow lights mean there's non-body objects inside.</font><BR><font size='2'>Probably stuff pried off a corpse someone grabbed, or if you're lucky it's stashed booze.</font><BR><BR><font color=green>Green lights mean the morgue system detects the body may be able to be brought back to life.</font></font><BR><font size='2'>I don't know how that works, but keep it away from the kitchen and go yell at the geneticists.</font><BR><BR>- CentCom medical inspector"

/*
 * Crematorium
 */
GLOBAL_LIST_EMPTY(crematoriums)
/obj/structure/bodycontainer/crematorium
	name = "крематорий"
	desc = "Для сжигания тел и готовки прекрасного барбекю."
	icon_state = "crema1"
	dir = SOUTH
	var/id = 1
	var/temperature = 293.15
	var/heating = FALSE

/obj/structure/bodycontainer/crematorium/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Температура: <b>[round(temperature-273.15, 0.01)] &deg;C</b></span>"

/obj/structure/bodycontainer/crematorium/Destroy()
	GLOB.crematoriums.Remove(src)
	return ..()

/obj/structure/bodycontainer/crematorium/New()
	GLOB.crematoriums.Add(src)
	..()

/obj/structure/bodycontainer/crematorium/Initialize()
	. = ..()
	connected = new /obj/structure/tray/c_tray(src)
	connected.connected = src

/obj/structure/bodycontainer/crematorium/update_icon()
	if(!connected || connected.loc != src)
		icon_state = "crema0"
	else

		if(src.contents.len > 1)
			src.icon_state = "crema2"
		else
			src.icon_state = "crema1"

		if(locked)
			src.icon_state = "crema_active"

	return

/obj/structure/bodycontainer/crematorium/process()
	temperature += 100
	if(temperature > 1173.15)
		STOP_PROCESSING(SSobj, src)
		playsound(src.loc, 'sound/machines/ding.ogg', 50, TRUE)
		audible_message(span_hear("Слышу треск."))
		heating = FALSE

/obj/structure/bodycontainer/crematorium/proc/cremate(mob/user)
	if(temperature < 1173.15)
		if(!heating)
			audible_message(span_hear("Слышу как накаляется металл."))
			START_PROCESSING(SSobj, src)
			heating = TRUE
		return
	if(locked)
		return //don't let you cremate something twice or w/e
	// Make sure we don't delete the actual morgue and its tray
	var/list/conts = GetAllContents() - src - connected

	if(!conts.len)
		audible_message(span_hear("Слышу пустой гул."))
		temperature = 293.15
		return

	else
		audible_message(span_hear("Слышу дикий рёв исходящий из крематория."))

		locked = TRUE
		update_icon()

		for(var/mob/living/M in conts)
			if (M.stat != DEAD)
				M.emote("agony")
			if(user)
				log_combat(user, M, "cremated")
			else
				M.log_message("was cremated", LOG_ATTACK)

			M.death(1)
			if(M) //some animals get automatically deleted on death.
				M.ghostize()
				qdel(M)

		for(var/obj/O in conts) //conts defined above, ignores crematorium and tray
			qdel(O)

		if(!locate(/obj/effect/decal/cleanable/ash) in get_step(src, dir))//prevent pile-up
			new/obj/effect/decal/cleanable/ash/crematorium(src)

		temperature = 293.15

		sleep(30)

		if(!QDELETED(src))
			locked = FALSE
			update_icon()
			playsound(src.loc, 'sound/machines/ding.ogg', 50, TRUE) //you horrible people

/obj/structure/bodycontainer/crematorium/creamatorium
	name = "крем-а-торий"
	desc = "Хотите мороженку?"

/obj/structure/bodycontainer/crematorium/creamatorium/cremate(mob/user)
	var/list/icecreams = new()
	for(var/i_scream in get_all_contents_type(/mob/living))
		var/obj/item/food/icecream/IC = new()
		IC.set_cone_type("waffle")
		IC.add_mob_flavor(i_scream)
		icecreams += IC
	. = ..()
	for(var/obj/IC in icecreams)
		IC.forceMove(src)

/*
 * Generic Tray
 * Parent class for morguetray and crematoriumtray
 * For overriding only
 */
/obj/structure/tray
	icon = 'icons/obj/stationobjs.dmi'
	density = TRUE
	var/obj/structure/bodycontainer/connected = null
	anchored = TRUE
	pass_flags_self = LETPASSTHROW
	max_integrity = 350

/obj/structure/tray/Destroy()
	if(connected)
		connected.connected = null
		connected.update_icon()
		connected = null
	return ..()

/obj/structure/tray/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/iron (loc, 2)
	qdel(src)

/obj/structure/tray/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/tray/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if (src.connected)
		connected.close()
		add_fingerprint(user)
	else
		to_chat(user, span_warning("Эта штука не подключена ни к чему!"))

/obj/structure/tray/attackby(obj/P, mob/user, params)
	if(!istype(P, /obj/item/riding_offhand))
		return ..()

	var/obj/item/riding_offhand/riding_item = P
	var/mob/living/carried_mob = riding_item.rider
	if(carried_mob == user) //Piggyback user.
		return
	user.unbuckle_mob(carried_mob)
	MouseDrop_T(carried_mob, user)

/obj/structure/tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user)
	if(!ismovable(O) || O.anchored || !Adjacent(user) || !user.Adjacent(O) || O.loc == user)
		return
	if(!ismob(O))
		if(!istype(O, /obj/structure/closet/body_bag))
			return
	else
		var/mob/M = O
		if(M.buckled)
			return
	if(!ismob(user) || user.incapacitated())
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.body_position == LYING_DOWN)
			return
	O.forceMove(src.loc)
	if (user != O)
		visible_message(span_warning("[user] запихивает [O] в [src]."))
	return

/*
 * Crematorium tray
 */
/obj/structure/tray/c_tray
	name = "ложе крематория"
	desc = "Сюда нужно ложить тела."
	icon_state = "cremat"

/*
 * Morgue tray
 */
/obj/structure/tray/m_tray
	name = "ложе морга"
	desc = "Сюда нужно ложить тела."
	icon_state = "morguet"
	pass_flags_self = PASSTABLE

/obj/structure/tray/m_tray/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(locate(/obj/structure/table) in get_turf(mover))
		return TRUE
