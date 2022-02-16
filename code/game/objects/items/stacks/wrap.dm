

/*
 * Wrapping Paper
 */

/obj/item/stack/wrapping_paper
	name = "оберточная бумага"
	desc = "Оберните пакеты этой праздничной бумагой, чтобы сделать подарки."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "wrap_paper"
	item_flags = NOBLUDGEON
	amount = 25
	max_amount = 25
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/wrapping_paper

/obj/item/stack/wrapping_paper/use(used, transfer, check = TRUE)
	var/turf/T = get_turf(src)
	. = ..()
	if(QDELETED(src) && !transfer)
		new /obj/item/c_tube(T)

/obj/item/stack/wrapping_paper/small
	desc = "Оберните пакеты этой праздничной бумагой, чтобы сделать подарки. Этот рулон выглядит немного скудно."
	amount = 10
	merge_type = /obj/item/stack/wrapping_paper/small

/*
 * Package Wrap
 */

/obj/item/stack/package_wrap
	name = "упаковщик"
	singular_name = "упаковочный лист"
	desc = "Вы можете использовать это, чтобы обернуть что-то в неё."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "deliveryPaper"
	item_flags = NOBLUDGEON
	amount = 25
	max_amount = 25
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 5)
	merge_type = /obj/item/stack/package_wrap

/obj/item/stack/package_wrap/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins wrapping [user.ru_na()]self in <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use(3))
		var/obj/structure/big_delivery/P = new /obj/structure/big_delivery(get_turf(user.loc))
		P.icon_state = "deliverypackage5"
		user.forceMove(P)
		P.add_fingerprint(user)
		return OXYLOSS
	else
		to_chat(user, span_warning("Не хватает обёрточной бумаги для суицида! Лох!"))
		return SHAME

/obj/item/proc/can_be_package_wrapped() //can the item be wrapped with package wrapper into a delivery package
	return TRUE

/obj/item/storage/can_be_package_wrapped()
	return FALSE

/obj/item/storage/box/can_be_package_wrapped()
	return TRUE

/obj/item/small_delivery/can_be_package_wrapped()
	return FALSE

/obj/item/stack/package_wrap/afterattack(obj/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!istype(target))
		return
	if(target.anchored)
		return

	if(isitem(target))
		var/obj/item/I = target
		if(!I.can_be_package_wrapped())
			return
		if(user.is_holding(I))
			if(!user.dropItemToGround(I))
				return
		else if(!isturf(I.loc))
			return
		if(use(1))
			var/obj/item/small_delivery/P = new /obj/item/small_delivery(get_turf(I.loc))
			if(user.Adjacent(I))
				P.add_fingerprint(user)
				I.add_fingerprint(user)
				user.put_in_hands(P)
			I.forceMove(P)
			var/size = round(I.w_class)
			P.name = "[weightclass2text(size)] размера упаковка"
			P.w_class = size
			size = min(size, 5)
			P.icon_state = "deliverypackage[size]"

	else if(istype (target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if(O.opened)
			return
		if(!O.delivery_icon) //no delivery icon means unwrappable closet (e.g. body bags)
			to_chat(user, span_warning("Не могу обернуть это!"))
			return
		if(use(3))
			var/obj/structure/big_delivery/P = new /obj/structure/big_delivery(get_turf(O.loc))
			P.icon_state = O.delivery_icon
			O.forceMove(P)
			P.add_fingerprint(user)
			O.add_fingerprint(user)
		else
			to_chat(user, span_warning("Надо бы больше обёрточной бумаги!"))
			return
	else
		to_chat(user, span_warning("Эта штука не подойдёт для сортировочной машины, куда это будет отправлено!"))
		return

	user.visible_message(span_notice("<b>[user]</b> оборачивает <b>[target]</b> в красивую и модную упаковку."))
	user.log_message("has used [name] on [key_name(target)]", LOG_ATTACK, color="blue")

/obj/item/stack/package_wrap/use(used, transfer = FALSE, check = TRUE)
	var/turf/T = get_turf(src)
	. = ..()
	if(QDELETED(src) && !transfer)
		new /obj/item/c_tube(T)

/obj/item/stack/package_wrap/small
	desc = "Вы можете использовать это, чтобы обернуть предметы. Этот рулон выглядит немного скудно."
	w_class = WEIGHT_CLASS_SMALL
	amount = 5
	merge_type = /obj/item/stack/package_wrap/small

/obj/item/c_tube
	name = "картонная труба"
	desc = "Труба... картонная. Дебил?"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "c_tube"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 5
