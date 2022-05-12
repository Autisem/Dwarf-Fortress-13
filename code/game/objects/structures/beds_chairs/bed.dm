/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'dwarfs/icons/structures/bed.dmi'
	icon_state = "wooden"
	icon = 'icons/obj/objects.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 100
	integrity_failure = 0.35
	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 2
	var/bolts = TRUE

/obj/structure/bed/examine(mob/user)
	. = ..()
	if(bolts)
		. += "<hr><span class='notice'>It's held together by a couple of <b>bolts</b>.</span>"

/obj/structure/bed/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/bed/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bed/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		deconstruct(TRUE)
	else
		return ..()

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "каталка"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = FALSE
	resistance_flags = NONE

	var/foldabletype = /obj/item/roller

/obj/structure/bed/roller/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/roller/robo))
		var/obj/item/roller/robo/R = W
		if(R.loaded)
			to_chat(user, span_warning("У меня уже есть пассажир!"))
			return

		if(has_buckled_mobs())
			if(buckled_mobs.len > 1)
				unbuckle_all_mobs()
				user.visible_message(span_notice("[user] поднимает всех с [src]."))
			else
				user_unbuckle_mob(buckled_mobs[1],user)
		else
			R.loaded = src
			forceMove(R)
			user.visible_message(span_notice("[user] собирает [src].") , span_notice("Собираю [src]."))
		return 1
	else
		return ..()

/obj/structure/bed/roller/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
			return FALSE
		if(has_buckled_mobs())
			return FALSE
		usr.visible_message(span_notice("[usr] складывает [src.name].") , span_notice("Складываю [src.name]."))
		var/obj/structure/bed/roller/B = new foldabletype(get_turf(src))
		usr.put_in_hands(B)
		qdel(src)

/obj/structure/bed/roller/post_buckle_mob(mob/living/M)
	set_density(TRUE)
	icon_state = "up"
	//Push them up from the normal lying position
	M.pixel_y = M.base_pixel_y

/obj/structure/bed/roller/Moved()
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 100, TRUE)


/obj/structure/bed/roller/post_unbuckle_mob(mob/living/M)
	set_density(FALSE)
	icon_state = "down"
	//Set them back down to the normal lying position
	M.pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset


/obj/item/roller
	name = "каталка"
	desc = "Сборная кровать для транспортировки людей."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	w_class = WEIGHT_CLASS_NORMAL // No more excuses, stop getting blood everywhere

/obj/item/roller/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/roller/robo))
		var/obj/item/roller/robo/R = I
		if(R.loaded)
			to_chat(user, span_warning("[capitalize(R.name)] уже имеет в запасе каталку!"))
			return
		user.visible_message(span_notice("[user] забирает [src].") , span_notice("Загружаю [src] в [R]."))
		R.loaded = new/obj/structure/bed/roller(R)
		qdel(src) //"Load"
		return
	else
		return ..()

/obj/item/roller/attack_self(mob/user)
	deploy_roller(user, user.loc)

/obj/item/roller/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(isopenturf(target))
		deploy_roller(user, target)

/obj/item/roller/proc/deploy_roller(mob/user, atom/location)
	var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(location)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/roller/robo //ROLLER ROBO DA!
	name = "каталкодок"
	desc = "Сборная кровать для транспортировки людей. Держите при её при себе всегда."
	var/obj/structure/bed/roller/loaded = null

/obj/item/roller/robo/Initialize()
	. = ..()
	loaded = new(src)

/obj/item/roller/robo/examine(mob/user)
	. = ..()
	. += "<hr>Док [loaded ? "загружен" : "пуст"]."

/obj/item/roller/robo/deploy_roller(mob/user, atom/location)
	if(loaded)
		loaded.forceMove(location)
		user.visible_message(span_notice("[user] выдавливает [loaded].") , span_notice("Выдавливаю [loaded]."))
		loaded = null
	else
		to_chat(user, span_warning("Док пустой!"))

//Dog bed

/obj/structure/bed/dogbed
	name = "собачья кровать"
	icon_state = "dogbed"
	desc = "Удобная на вид кровать для собаки. Вы можете даже пристегнуть своего питомца на случай, если гравитация отключится."
	anchored = FALSE
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 10
	var/owned = FALSE

/obj/structure/bed/dogbed/ian
	desc = "Выглядит удобной!"
	name = "кроватка Яна"
	anchored = TRUE

/obj/structure/bed/dogbed/cayenne
	desc = "Кажется, немного... подозрительной."
	name = "кровать Кайенны"
	anchored = TRUE

/obj/structure/bed/dogbed/lia
	desc = "Seems kind of... fishy."
	name = "Lia's bed"
	anchored = TRUE

/obj/structure/bed/dogbed/renault
	desc = "Выглядит удобно, Лисий человек нуждается в лисичке."
	name = "кровать Рено"
	anchored = TRUE

/obj/structure/bed/dogbed/mcgriff
	desc = "McGriff's bed, because even crimefighters sometimes need a nap."
	name = "McGriff's bed"

/obj/structure/bed/dogbed/runtime
	desc = "Удобная кошачья кровать. Вы можете даже пристегнуть своего питомца на случай, если гравитация отключится."
	name = "Кровать Рантайма"
	anchored = TRUE

///Used to set the owner of a dogbed, returns FALSE if called on an owned bed or an invalid one, TRUE if the possesion succeeds
/obj/structure/bed/dogbed/proc/update_owner(mob/living/M)
	if(owned || type != /obj/structure/bed/dogbed) //Only marked beds work, this is hacky but I'm a hacky man
		return FALSE //Failed
	owned = TRUE
	name = "кровать [M]"
	desc = "Выглядит комфортно."
	return TRUE //Let any callers know that this bed is ours now

/obj/structure/bed/dogbed/buckle_mob(mob/living/M, force, check_loc)
	. = ..()
	update_owner(M)

/obj/structure/bed/alien
	name = "отдыхалка"
	desc = "Это похоже на штуки с Земли. Могут ли инопланетяне красть наши технологии?"
	icon_state = "abed"


/obj/structure/bed/maint
	name = "dirty mattress"
	desc = "An old grubby mattress. You try to not think about what could be the cause of those stains."
	icon_state = "dirty_mattress"
