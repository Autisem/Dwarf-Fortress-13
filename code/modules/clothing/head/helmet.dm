/obj/item/clothing/head/helmet
	name = "шлем"
	desc = "Стандартное снаряжение безопасности. Защищает голову от ударов."
	icon_state = "helmet"
	inhand_icon_state = "helmet"
	armor = list(MELEE = 35, BULLET = 30, LASER = 30,ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR

	dog_fashion = /datum/dog_fashion/head/helmet

	var/can_flashlight = FALSE //if a flashlight can be mounted. if it has a flashlight and this is false, it is permanently attached.
	var/obj/item/flashlight/seclite/attached_light
	var/datum/action/item_action/toggle_helmet_flashlight/alight

/obj/item/clothing/head/helmet/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate/plasteel)
	if(attached_light)
		alight = new(src)

/obj/item/clothing/head/helmet/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/datum/component/armor_plate/plasteel/ap = GetComponent(/datum/component/armor_plate/plasteel)
		if(ap?.amount)
			var/mutable_appearance/armor_overlay = mutable_appearance('icons/mob/clothing/head.dmi', "armor_plasteel_[ap.amount]")
			. += armor_overlay

/obj/item/clothing/head/helmet/Destroy()
	var/obj/item/flashlight/seclite/old_light = set_attached_light(null)
	if(old_light)
		qdel(old_light)
	return ..()


/obj/item/clothing/head/helmet/examine(mob/user)
	. = ..()
	if(attached_light)
		. += "<hr>Имеет [attached_light] [can_flashlight ? "" : "намертво "] прикрученый к нему."
		if(can_flashlight)
			. += "<hr><span class='info'>Похоже, что [attached_light] может быть <b>откручен</b> от [src].</span>"
	else if(can_flashlight)
		. += "<hr>Имеет точку для монтирования <b>фонарика</b>."


/obj/item/clothing/head/helmet/handle_atom_del(atom/A)
	if(A == attached_light)
		set_attached_light(null)
		update_helmlight()
		update_icon()
		QDEL_NULL(alight)
		qdel(A)
	return ..()


///Called when attached_light value changes.
/obj/item/clothing/head/helmet/proc/set_attached_light(obj/item/flashlight/seclite/new_attached_light)
	if(attached_light == new_attached_light)
		return
	. = attached_light
	attached_light = new_attached_light
	if(attached_light)
		attached_light.set_light_flags(attached_light.light_flags | LIGHT_ATTACHED)
		if(attached_light.loc != src)
			attached_light.forceMove(src)
	else if(.)
		var/obj/item/flashlight/seclite/old_attached_light = .
		old_attached_light.set_light_flags(old_attached_light.light_flags & ~LIGHT_ATTACHED)
		if(old_attached_light.loc == src)
			old_attached_light.forceMove(get_turf(src))


/obj/item/clothing/head/helmet/sec
	can_flashlight = TRUE

/obj/item/clothing/head/helmet/alt
	name = "пуленепробиваемый шлем"
	desc = "Боевой пуленепробиваемый шлем, который в незначительной степени защищает владельца от традиционного стрелкового оружия и взрывчатых веществ."
	icon_state = "helmetalt"
	inhand_icon_state = "helmetalt"
	armor = list(MELEE = 15, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 5)
	can_flashlight = TRUE
	dog_fashion = null

/obj/item/clothing/head/helmet/marine
	name = "tactical combat helmet"
	desc = "A tactical black helmet, sealed from outside hazards with a plate of glass and not much else."
	icon_state = "marine_command"
	inhand_icon_state = "helmetalt"
	armor = list(MELEE = 50, BULLET = 50, LASER = 30, ENERGY = 25, BOMB = 50, BIO = 100, FIRE = 40, ACID = 50, WOUND = 20)
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	can_flashlight = TRUE
	dog_fashion = null

/obj/item/clothing/head/helmet/marine/Initialize()
	set_attached_light(new /obj/item/flashlight/seclite)
	update_helmlight()
	update_icon()
	. = ..()

/obj/item/clothing/head/helmet/marine/security
	name = "marine heavy helmet"
	icon_state = "marine_security"

/obj/item/clothing/head/helmet/marine/engineer
	name = "marine utility helmet"
	icon_state = "marine_engineer"

/obj/item/clothing/head/helmet/marine/medic
	name = "marine medic helmet"
	icon_state = "marine_medic"

/obj/item/clothing/head/helmet/old
	name = "старый шлем"
	desc = "Стандартный защитный шлем. Предоставляет гораздо меньшую защиту, по сравнению с шлемами нового поколения."
	icon_state = "helmet_old"
	icon = 'white/rebolution228/icons/clothing/hats.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/hats_mob.dmi'
	armor = list(MELEE = 25, BULLET = 20, LASER = 10, ENERGY = 30, BOMB = 25, BIO = 0, RAD = 0, FIRE = 30, ACID = 30, WOUND = 10)


/obj/item/clothing/head/helmet/blueshirt
	name = "синий шлем"
	desc = "Надежный шлем синего цвета, напоминающий вам, что вы все еще должны инженеру пиво."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	custom_premium_price = PAYCHECK_HARD

/obj/item/clothing/head/helmet/riot
	name = "анти-мятежный шлем"
	desc = "Это шлем, специально разработанный для защиты от атак с близкого расстояния."
	icon_state = "riot"
	inhand_icon_state = "helmet"
	toggle_message = "Опускаю козырёк вниз"
	alt_toggle_message = "Поднимаю козырёк вверх"
	can_toggle = 1
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80, WOUND = 15)
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	strip_delay = 80
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEFACE|HIDESNOUT
	toggle_cooldown = 0
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	dog_fashion = null

/obj/item/clothing/head/helmet/attack_self(mob/user)
	if(can_toggle && !user.incapacitated())
		if(world.time > cooldown + toggle_cooldown)
			cooldown = world.time
			up = !up
			flags_1 ^= visor_flags
			flags_inv ^= visor_flags_inv
			flags_cover ^= visor_flags_cover
			icon_state = "[initial(icon_state)][up ? "up" : ""]"
			to_chat(user, span_notice("[up ? alt_toggle_message : toggle_message] [src]."))

			user.update_inv_head()
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.head_update(src, forced = 1)

/obj/item/clothing/head/helmet/justice
	name = "шлем правосудия"
	desc = "ВИИИУУУ. ВИИИУУУ. ВИИИУУУ."
	icon_state = "justice"
	toggle_message = "Выключаю свет"
	alt_toggle_message = "Включаю свет"
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	can_toggle = 1
	toggle_cooldown = 20
	dog_fashion = null
	///Looping sound datum for the siren helmet
	var/datum/looping_sound/siren/weewooloop

/obj/item/clothing/head/helmet/justice/Initialize()
	. = ..()
	weewooloop = new(src, FALSE, FALSE)

/obj/item/clothing/head/helmet/justice/Destroy()
	QDEL_NULL(weewooloop)
	return ..()

/obj/item/clothing/head/helmet/justice/attack_self(mob/user)
	. = ..()
	if(up)
		weewooloop.start()
	else
		weewooloop.stop()

/obj/item/clothing/head/helmet/justice/escape
	name = "тревожный шлем"
	desc = "ВИИИУУУ. ВИИИУУУ. ОСТАНОВИ ЭТУ ОБЕЗЬЯНУ. ВИИИУУУ."
	icon_state = "justice2"
	toggle_message = "Выключаю свет"
	alt_toggle_message = "Включаю свет"

/obj/item/clothing/head/helmet/swat
	name = "шлем спецназа"
	desc = "Чрезвычайно прочный, компактный шлем в мерзкой красной и черной полосе."
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie"
	armor = list(MELEE = 40, BULLET = 30, LASER = 30,ENERGY = 40, BOMB = 50, BIO = 90, RAD = 20, FIRE = 100, ACID = 100, WOUND = 15)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE
	strip_delay = 80
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null

/obj/item/clothing/head/helmet/police
	name = "полицейская шляпа"
	desc = "Шляпа офицера полиции. Эта шляпа подчеркивает, что ты - ЗАКОН."
	icon_state = "policehelm"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/helmet/constable
	name = "шлем констебля"
	desc = "Этот шлем такой британский."
	worn_icon = 'icons/mob/large-worn-icons/64x64/head.dmi'
	icon_state = "constable"
	inhand_icon_state = "constable"
	worn_x_dimension = 64
	worn_y_dimension = 64
	clothing_flags = LARGE_WORN_ICON
	custom_price = PAYCHECK_HARD * 1.5

/obj/item/clothing/head/helmet/swat/nanotrasen
	name = "шлем спецназа"
	desc = "Чрезвычайно прочный, космический шлем с логотипом NanoTrasen, украшенный сверху."
	icon_state = "swat"
	inhand_icon_state = "swat"

/obj/item/clothing/head/helmet/thunderdome
	name = "Thunderdome шлем"
	desc = "<i>'Да начнется битва!'</i>"
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome"
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 80
	dog_fashion = null

/obj/item/clothing/head/helmet/roman
	name = "римский шлем"
	desc = "Древний шлем из бронзы и кожи."
	flags_inv = HIDEEARS|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	armor = list(MELEE = 25, BULLET = 0, LASER = 25, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 100, ACID = 50, WOUND = 5)
	resistance_flags = FIRE_PROOF
	icon_state = "roman"
	inhand_icon_state = "roman"
	strip_delay = 100
	dog_fashion = null

/obj/item/clothing/head/helmet/roman/fake
	desc = "Древний шлем из пластика и кожи."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/head/helmet/roman/legionnaire
	name = "шлем римского легионера"
	desc = "Древний шлем из бронзы и кожи. На нем красный гребень."
	icon_state = "roman_c"
	inhand_icon_state = "roman_c"

/obj/item/clothing/head/helmet/roman/legionnaire/fake
	desc = "Древний шлем из бронзы и кожи. На нем красный гребень."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/head/helmet/gladiator
	name = "шлем гладиатора"
	desc = "Славься, Император, идущие на смерть приветствуют тебя!"
	icon_state = "gladiator"
	inhand_icon_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	dog_fashion = null

/obj/item/clothing/head/helmet/redtaghelm
	name = "красный шлем лазер-тэга"
	desc = "Они выбрали свою цель."
	icon_state = "redtaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "redtaghelm"
	armor = list(MELEE = 15, BULLET = 10, LASER = 20,ENERGY = 10, BOMB = 20, BIO = 0, RAD = 0, FIRE = 0, ACID = 50)
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/obj/item/clothing/head/helmet/bluetaghelm
	name = "синий шлем лазер-тэга"
	desc = "Им понадобится больше людей."
	icon_state = "bluetaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "bluetaghelm"
	armor = list(MELEE = 15, BULLET = 10, LASER = 20,ENERGY = 10, BOMB = 20, BIO = 0, RAD = 0, FIRE = 0, ACID = 50)
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/obj/item/clothing/head/helmet/knight
	name = "средневековый шлем"
	desc = "Классический металлический шлем."
	icon_state = "knight_green"
	inhand_icon_state = "knight_green"
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80) // no wound armor cause getting domed in a bucket head sounds like concussion city
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 80
	dog_fashion = null


/obj/item/clothing/head/helmet/knight/Initialize(mapload)
	. = ..()
	var/datum/component = GetComponent(/datum/component/wearertargeting/earprotection)
	qdel(component)

/obj/item/clothing/head/helmet/knight/blue
	icon_state = "knight_blue"
	inhand_icon_state = "knight_blue"

/obj/item/clothing/head/helmet/knight/yellow
	icon_state = "knight_yellow"
	inhand_icon_state = "knight_yellow"

/obj/item/clothing/head/helmet/knight/red
	icon_state = "knight_red"
	inhand_icon_state = "knight_red"

/obj/item/clothing/head/helmet/knight/greyscale
	name = "рыцарский шлем"
	desc = "Классический средневековый шлем, если держать его вверх ногами, то можно увидеть, что на самом деле это ведро."
	icon_state = "knight_greyscale"
	inhand_icon_state = "knight_greyscale"
	armor = list(MELEE = 35, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 40, ACID = 40)
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix

/obj/item/clothing/head/helmet/skull
	name = "черепной шлем"
	desc = "Страшный племенной шлем, он выглядит не очень удобно."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	armor = list(MELEE = 35, BULLET = 25, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	icon_state = "skull"
	inhand_icon_state = "skull"
	strip_delay = 100

/obj/item/clothing/head/helmet/durathread
	name = "дюратканевый шлем"
	desc = "Шлем из черного хлеба и кожи."
	icon_state = "durathread"
	inhand_icon_state = "durathread"
	resistance_flags = FLAMMABLE
	armor = list(MELEE = 20, BULLET = 10, LASER = 30, ENERGY = 40, BOMB = 15, BIO = 0, RAD = 0, FIRE = 40, ACID = 50, WOUND = 5)
	strip_delay = 60

/obj/item/clothing/head/helmet/rus_helmet
	name = "русский шлем"
	desc = "Он может вместить бутылку водки."
	icon_state = "rus_helmet"
	inhand_icon_state = "rus_helmet"
	armor = list(MELEE = 25, BULLET = 30, LASER = 0, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 20, FIRE = 20, ACID = 50, WOUND = 5)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/helmet

/obj/item/clothing/head/helmet/rus_ushanka
	name = "боевая ушанка"
	desc = "100% медвежья."
	icon_state = "rus_ushanka"
	inhand_icon_state = "rus_ushanka"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 50, RAD = 20, FIRE = -10, ACID = 50, WOUND = 5)

/obj/item/clothing/head/helmet/infiltrator
	name = "шлем лазутчика"
	desc = "Галактика слишком мала для нас двоих."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	armor = list(MELEE = 40, BULLET = 40, LASER = 30, ENERGY = 40, BOMB = 70, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flash_protect = FLASH_PROTECTION_WELDER
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 80

/obj/item/clothing/head/helmet/elder_atmosian
	name = "Древний Атмосианский Шлем"
	desc = "Превосходный шлем, созданный из самых крепких и редких материалов, доступных людям."
	icon_state = "h2helmet"
	inhand_icon_state = "h2helmet"
	armor = list(MELEE = 15, BULLET = 10, LASER = 30, ENERGY = 30, BOMB = 10, BIO = 10, RAD = 20, FIRE = 65, ACID = 40, WOUND = 15)
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

//LightToggle

/obj/item/clothing/head/helmet/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/head/helmet/update_icon_state()
	var/state = "[initial(icon_state)]"
	if(attached_light)
		if(attached_light.on)
			state += "-flight-on" //"helmet-flight-on" // "helmet-cam-flight-on"
		else
			state += "-flight" //etc.

	icon_state = state
	return ..()

/obj/item/clothing/head/helmet/ui_action_click(mob/user, action)
	if(istype(action, alight))
		toggle_helmlight()
	else
		..()

/obj/item/clothing/head/helmet/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/flashlight/seclite))
		var/obj/item/flashlight/seclite/S = I
		if(can_flashlight && !attached_light)
			if(!user.transferItemToLoc(S, src))
				return
			to_chat(user, span_notice("Прикрепляю [S] к [src]."))
			set_attached_light(S)
			update_icon()
			update_helmlight()
			alight = new(src)
			if(loc == user)
				alight.Grant(user)
		return
	return ..()

/obj/item/clothing/head/helmet/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(can_flashlight && attached_light) //if it has a light but can_flashlight is false, the light is permanently attached.
		I.play_tool_sound(src)
		to_chat(user, span_notice("Откручиваю [attached_light] от [src]."))
		attached_light.forceMove(drop_location())
		if(Adjacent(user))
			user.put_in_hands(attached_light)

		var/obj/item/flashlight/removed_light = set_attached_light(null)
		update_helmlight()
		removed_light.update_brightness(user)
		update_icon()
		user.update_inv_head()
		QDEL_NULL(alight)
		return TRUE

/obj/item/clothing/head/helmet/proc/toggle_helmlight()
	set name = "Переключить нашлемный фонарик"
	set category = "Объект"
	set desc = "Нажмите чтобы включить или выключить прикрепленный к шлему фонарик."

	if(!attached_light)
		return

	var/mob/user = usr
	if(user.incapacitated())
		return
	attached_light.on = !attached_light.on
	attached_light.update_brightness()
	to_chat(user, span_notice("[attached_light.on ? "Включаю":"Выключаю"] фонарик на шлеме."))

	playsound(user, 'sound/weapons/empty.ogg', 100, TRUE)
	update_helmlight()

/obj/item/clothing/head/helmet/proc/update_helmlight()
	if(attached_light)
		update_icon()

	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()
