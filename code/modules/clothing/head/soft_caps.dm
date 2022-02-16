/obj/item/clothing/head/soft
	name = "кепка грузчика"
	desc = "Это бейсбольная кепка безвкусного желтого цвета."
	icon_state = "cargosoft"
	inhand_icon_state = "helmet"
	var/soft_type = "cargo"

	dog_fashion = /datum/dog_fashion/head/cargo_tech

	var/flipped = FALSE

/obj/item/clothing/head/soft/dropped()
	icon_state = "[soft_type]soft"
	flipped = FALSE
	..()

/obj/item/clothing/head/soft/verb/flipcap()
	set category = "Объект"
	set name = "Flip cap"

	flip(usr)


/obj/item/clothing/head/soft/AltClick(mob/user)
	..()
	if(user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE))
		flip(user)


/obj/item/clothing/head/soft/proc/flip(mob/user)
	if(!user.incapacitated())
		flipped = !flipped
		if(flipped)
			icon_state = "[soft_type]soft_flipped"
			to_chat(user, span_notice("Переворачиваю козырёк кепки назад."))
		else
			icon_state = "[soft_type]soft"
			to_chat(user, span_notice("Возвращаю кепку обратно на место."))
		usr.update_inv_head()	//so our mob-overlays update

/obj/item/clothing/head/soft/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_notice("ПКМ, чтобы повернуть козырёк кепки [flipped ? "вперёд" : "назад"].")

/obj/item/clothing/head/soft/red
	name = "красная кепка"
	desc = "Это бейсбольная кепка безвкусного красного цвета."
	icon_state = "redsoft"
	soft_type = "red"
	dog_fashion = null

/obj/item/clothing/head/soft/blue
	name = "синяя кепка"
	desc = "Это бейсбольная кепка безвкусного синего цвета."
	icon_state = "bluesoft"
	soft_type = "blue"
	dog_fashion = null

/obj/item/clothing/head/soft/green
	name = "зелёная кепка"
	desc = "Это бейсбольная кепка безвкусного зелёного цвета."
	icon_state = "greensoft"
	soft_type = "green"
	dog_fashion = null

/obj/item/clothing/head/soft/yellow
	name = "жёлтая кепка"
	desc = "Это бейсбольная кепка безвкусного жёлтого цвета."
	icon_state = "yellowsoft"
	soft_type = "yellow"
	dog_fashion = null

/obj/item/clothing/head/soft/grey
	name = "серая кепка"
	desc = "Это бейсбольная кепка безвкусного серого цвета."
	icon_state = "greysoft"
	soft_type = "grey"
	dog_fashion = null

/obj/item/clothing/head/soft/orange
	name = "оранжевая кепка"
	desc = "Это бейсбольная кепка безвкусного оранжевого цвета."
	icon_state = "orangesoft"
	soft_type = "orange"
	dog_fashion = null

/obj/item/clothing/head/soft/mime
	name = "белая кепка"
	desc = "Это бейсбольная кепка безвкусного белого цвета."
	icon_state = "mimesoft"
	soft_type = "mime"
	dog_fashion = null

/obj/item/clothing/head/soft/purple
	name = "фиолетовая кепка"
	desc = "Это бейсбольная кепка безвкусного фиолетового цвета."
	icon_state = "purplesoft"
	soft_type = "purple"
	dog_fashion = null

/obj/item/clothing/head/soft/black
	name = "чёрная кепка"
	desc = "Это бейсбольная кепка безвкусного чёрного цвета."
	icon_state = "blacksoft"
	soft_type = "black"
	dog_fashion = null

/obj/item/clothing/head/soft/rainbow
	name = "радужная кепка"
	desc = "Это бейсболка в яркой радуге цветов."
	icon_state = "rainbowsoft"
	soft_type = "rainbow"
	dog_fashion = null

/obj/item/clothing/head/soft/sec
	name = "кепка офицера"
	desc = "Это прочная бейсбольная шапка со вкусом красного цвета."
	icon_state = "secsoft"
	soft_type = "sec"
	armor = list(MELEE = 30, BULLET = 25, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 20, ACID = 50)
	strip_delay = 60
	dog_fashion = null

/obj/item/clothing/head/soft/paramedic
	name = "кепка парамедика"
	desc = "Это бейсбольная кепка темно-бирюзового цвета и светоотражающий крест сверху."
	icon_state = "paramedicsoft"
	soft_type = "paramedic"
	dog_fashion = null
