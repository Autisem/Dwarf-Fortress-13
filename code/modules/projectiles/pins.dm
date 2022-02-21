/obj/item/firing_pin
	name = "электронный ударник"
	desc = "Небольшое устройство аутентификации, которое должно быть вставлено в приемник огнестрельного оружия, чтобы позволить сделать выстрел. Правила безопасности NT требуют, чтобы все новые конструкции включали это."
	icon = 'icons/obj/device.dmi'
	icon_state = "firing_pin"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("тычет")
	attack_verb_simple = list("тычет")
	var/fail_message = span_warning("НЕПРАВИЛЬНЫЙ ПОЛЬЗОВАТЕЛЬ.")
	var/selfdestruct = FALSE // Explode when user check is failed.
	var/force_replace = FALSE // Can forcefully replace other pins.
	var/pin_removeable = FALSE // Can be replaced by any pin.
	var/obj/item/gun/gun

/obj/item/firing_pin/New(newloc)
	..()
	if(istype(newloc, /obj/item/gun))
		gun = newloc

/obj/item/firing_pin/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		if(istype(target, /obj/item/gun))
			var/obj/item/gun/G = target
			var/obj/item/firing_pin/old_pin = G.pin
			if(old_pin && (force_replace || old_pin.pin_removeable))
				to_chat(user, span_notice("Убираю [old_pin] из [G]."))
				if(Adjacent(user))
					user.put_in_hands(old_pin)
				else
					old_pin.forceMove(G.drop_location())
				old_pin.gun_remove(user)

			if(!G.pin)
				if(!user.temporarilyRemoveItemFromInventory(src))
					return
				gun_insert(user, G)
				to_chat(user, span_notice("Вставляю [src] в [G]."))
			else
				to_chat(user, span_notice("Это оружие уже имеет ударник."))

/obj/item/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/G)
	gun = G
	forceMove(gun)
	gun.pin = src
	return

/obj/item/firing_pin/proc/gun_remove(mob/living/user)
	gun.pin = null
	gun = null
	return

/obj/item/firing_pin/proc/pin_auth(mob/living/user)
	return TRUE

/obj/item/firing_pin/proc/auth_fail(mob/living/user)
	if(user)
		user.show_message(fail_message, MSG_VISUAL)
	if(selfdestruct)
		if(user)
			user.show_message("<span class='danger'>Запуск механизма самоуничтожения...</span><br>", MSG_VISUAL)
			to_chat(user, span_userdanger("[gun] взорвался!"))
		explosion(get_turf(gun), -1, 0, 2, 3)
		if(gun)
			qdel(gun)


/obj/item/firing_pin/magic
	name = "магический осколок кристалла"
	desc = "Маленький вставленый осколок позволяет магичексому оружию стрелять."

// DNA-keyed pin.
// When you want to keep your toys for yourself.
/obj/item/firing_pin/dna
	name = "генный ударник"
	desc = "Связывает вас и оружие на генном уровне. Никто, кроме вас, не сможет выстрелить."
	icon_state = "firing_pin_dna"
	fail_message = span_warning("ХРОМОСОМЫ НЕ СОВПАДАЮТ.")
	var/unique_enzymes = null

/obj/item/firing_pin/dna/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag && iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			to_chat(user, span_notice("ДНК установлено."))

/obj/item/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(user && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return TRUE
	return FALSE

/obj/item/firing_pin/dna/auth_fail(mob/living/carbon/user)
	if(!unique_enzymes)
		if(user && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			to_chat(user, span_notice("ДНК установлено."))
	else
		..()

/obj/item/firing_pin/dna/dredd
	desc = "Связывает вас и оружие на генном уровне. Никто, кроме вас, не сможет выстрелить. А если попытаются, то взорвутся."
	selfdestruct = TRUE

// Explorer Firing Pin- Prevents use on station Z-Level, so it's justifiable to give Explorers guns that don't suck.
/obj/item/firing_pin/explorer
	name = "малонаселенный ударник"
	desc = "Ударник, используемый австралийскими силами, переоборудован, чтобы предотвратить сброс оружия на станцию"
	icon_state = "firing_pin_explorer"
	fail_message = span_warning("НЕ СТРЕЛЯЕТ НА СТАНЦИИ, ДРУЖОК!")

// This checks that the user isn't on the station Z-level.
/obj/item/firing_pin/explorer/pin_auth(mob/living/user)
	var/turf/station_check = get_turf(user)
	if(!station_check||is_fortress_level(station_check.z))
		to_chat(user, span_warning("Не могу использовать оружие на станции!"))
		return FALSE
	return TRUE

// Laser tag pins
/obj/item/firing_pin/tag
	name = "ударник для лазертага"
	desc = "Работает когда одет костюм для лазертага."
	fail_message = span_warning("КОСТЮМ ОТСУТСТВУЕТ.")
	var/obj/item/clothing/suit/suit_requirement = null
	var/tagcolor = ""

/obj/item/firing_pin/tag/pin_auth(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/M = user
		if(istype(M.wear_suit, suit_requirement))
			return TRUE
	to_chat(user, span_warning("Нужно надеть [tagcolor] броню для лазертага!"))
	return FALSE

/obj/item/firing_pin/tag/red
	name = "красный ударник лазертага"
	icon_state = "firing_pin_red"
	suit_requirement = /obj/item/clothing/suit/redtag
	tagcolor = "red"

/obj/item/firing_pin/tag/blue
	name = "синий ударник лазертага"
	icon_state = "firing_pin_blue"
	suit_requirement = /obj/item/clothing/suit/bluetag
	tagcolor = "blue"

/obj/item/firing_pin/Destroy()
	if(gun)
		gun.pin = null
	return ..()
