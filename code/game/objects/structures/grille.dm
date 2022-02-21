/obj/structure/grille
	desc = "A flimsy framework of metal rods."
	name = "grille"
	icon = 'icons/obj/smooth_structures/grille.dmi'
	icon_state = "grille-0"
	base_icon_state = "grille"
	density = TRUE
	anchored = TRUE
	pass_flags_self = PASSGRILLE
	flags_1 = CONDUCT_1 | RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	armor = list(MELEE = 50, BULLET = 70, LASER = 70, ENERGY = 100, BOMB = 10, BIO = 100, RAD = 100, FIRE = 0, ACID = 0)
	max_integrity = 50
	integrity_failure = 0.4
	appearance_flags = KEEP_TOGETHER
	smoothing_flags = SMOOTH_BITMASK
	can_be_unanchored = TRUE
	canSmoothWith = list(SMOOTH_GROUP_GRILLE)
	smoothing_groups = list(SMOOTH_GROUP_GRILLE)
	var/holes = 0 //bitflag

	var/rods_type = /obj/item/stack/rods
	var/rods_amount = 2
	var/rods_broken = TRUE
	var/grille_type = null

/obj/structure/grille/Destroy()
	update_cable_icons_on_turf(get_turf(src))
	return ..()

/obj/structure/grille/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	var/ratio = obj_integrity / max_integrity
	ratio = CEILING(ratio*4, 1) * 25

	if(ratio > 75)
		return

	if(broken)
		holes = (holes | 16) //16 is the biggest hole
		update_icon()
		return

	holes = (holes | (1 << rand(0,3))) //add random holes between 1 and 8

	update_icon()

/obj/structure/grille/update_icon()
	if(QDELETED(src))
		return
	for(var/i = 0; i < 5; i++)
		var/mask = 1 << i
		if(holes & mask)
			filters += filter(type="alpha", icon = icon('icons/obj/smooth_structures/grille.dmi', "broken_[i]"), flags = MASK_INVERSE)
	return ..()

/obj/structure/grille/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(anchored)
		. += span_notice("Это прикручено на месте <b>винтами</b>. Стержни выглядят так, как будто они могут быть <b>прокушены</b>.")
	if(!anchored)
		. += span_notice("Это выглядит <i>открученым</i>. Стержни выглядят так, как будто они могут быть <b>прокушены</b>.")

/obj/structure/grille/Bumped(atom/movable/AM)
	if(!ismob(AM))
		return
	var/mob/M = AM
	shock(M, 70)

/obj/structure/grille/attack_animal(mob/user)
	. = ..()
	if(!.)
		return
	if(!shock(user, 70) && !QDELETED(src)) //Last hit still shocks but shouldn't deal damage to the grille
		take_damage(rand(5,10), BRUTE, MELEE, 1)

/obj/structure/grille/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/grille/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message(span_warning("[user] бьёт [src].") , null, null, COMBAT_MESSAGE_RANGE)
	log_combat(user, src, "hit")
	if(!shock(user, 70))
		take_damage(rand(5,10), BRUTE, MELEE, 1)

/obj/structure/grille/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!. && istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/grille/CanAStarPass(to_dir, atom/movable/caller)
	. = !density
	if(istype(caller))
		. = . || (caller.pass_flags & PASSGRILLE)

/obj/structure/grille/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)
	if(W.tool_behaviour == TOOL_WIRECUTTER)
		if(!shock(user, 100))
			W.play_tool_sound(src, 100)
			deconstruct()
	else if((W.tool_behaviour == TOOL_SCREWDRIVER) && (isturf(loc) || anchored))
		if(!shock(user, 90))
			W.play_tool_sound(src, 100)
			set_anchored(!anchored)
			user.visible_message(span_notice("[user] [anchored ? "прикручивает" : "откручивает"] [src.name].") , \
				span_notice("[anchored ? "прикручиваю [src.name] к полу" : "откручиваю [src.name] от пола"]."))
			if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
				QUEUE_SMOOTH(src)
			return
	else if(istype(W, /obj/item/stack/rods) && broken)
		var/obj/item/stack/rods/R = W
		if(!shock(user, 90))
			user.visible_message(span_notice("[user] чинит решетку.") , \
				span_notice("Чиню решетку."))
			new grille_type(src.loc)
			R.use(1)
			qdel(src)
			return

//window placing begin
	else if(is_glass_sheet(W))
		if (!broken)
			var/obj/item/stack/ST = W
			if (ST.get_amount() < 2)
				to_chat(user, span_warning("Надо бы хотя бы парочку листов стекла!"))
				return
			var/dir_to_set = SOUTHWEST
			if(!anchored)
				to_chat(user, span_warning("Надо бы прикрутить [src] к полу!"))
				return
			for(var/obj/structure/window/WINDOW in loc)
				to_chat(user, span_warning("Здесь уже есть окно!"))
				return
			to_chat(user, span_notice("Начинаю ставить окно..."))
			if(do_after(user,20, target = src))
				if(!src.loc || !anchored) //Grille broken or unanchored while waiting
					return
				for(var/obj/structure/window/WINDOW in loc) //Another window already installed on grille
					return
				var/obj/structure/window/WD
				if(istype(W, /obj/item/stack/sheet/plasmarglass))
					WD = new/obj/structure/window/plasma/reinforced/fulltile(drop_location()) //reinforced plasma window
				else if(istype(W, /obj/item/stack/sheet/plasmaglass))
					WD = new/obj/structure/window/plasma/fulltile(drop_location()) //plasma window
				else if(istype(W, /obj/item/stack/sheet/rglass))
					WD = new/obj/structure/window/reinforced/fulltile(drop_location()) //reinforced window
				else if(istype(W, /obj/item/stack/sheet/titaniumglass))
					WD = new/obj/structure/window/shuttle(drop_location())
				else if(istype(W, /obj/item/stack/sheet/plastitaniumglass))
					WD = new/obj/structure/window/plasma/reinforced/plastitanium(drop_location())
				else
					WD = new/obj/structure/window/fulltile(drop_location()) //normal window
				WD.setDir(dir_to_set)
				WD.ini_dir = dir_to_set
				WD.set_anchored(FALSE)
				WD.state = 0
				ST.use(2)
				to_chat(user, span_notice("Ставлю [WD] на [src]."))
			return
//window placing end

	else if(istype(W, /obj/item/shard) || !shock(user, 70))
		return ..()

/obj/structure/grille/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'sound/effects/grillehit.ogg', 80, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 80, TRUE)


/obj/structure/grille/deconstruct(disassembled = TRUE)
	if(!loc) //if already qdel'd somehow, we do nothing
		return
	if(!(flags_1&NODECONSTRUCT_1))
		var/obj/R = new rods_type(null, rods_amount)
		transfer_fingerprints_to(R)
		R.forceMove(drop_location())
		qdel(src)
	..()

/obj/structure/grille/obj_break()
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		set_density(FALSE)
		broken = TRUE
		var/obj/R = new rods_type(null, rods_amount)
		transfer_fingerprints_to(R)
		R.forceMove(drop_location())
		rods_amount = 1
		rods_broken = FALSE
		grille_type = /obj/structure/grille

/obj/structure/grille/proc/repair_grille()
	if(broken)
		icon_state = "grille"
		set_density(TRUE)
		obj_integrity = max_integrity
		broken = FALSE
		rods_amount = 2
		rods_broken = TRUE
		return TRUE
	return FALSE

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user, prb)
	if(!anchored || broken)		// anchored/broken grilles are never connected
		return FALSE
	if(!prob(prb))
		return FALSE
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE

	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src, 1, TRUE))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()

			return TRUE
		else
			return FALSE
	return FALSE

/obj/structure/grille/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isobj(AM))
		if(prob(50) && anchored && !broken)
			var/obj/O = AM
			if(O.throwforce != 0)//don't want to let people spam tesla bolts, this way it will break after time
				var/turf/T = get_turf(src)
				var/obj/structure/cable/C = T.get_cable_node()
				if(C)
					playsound(src, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
					C.add_delayedload(C.newavail() * 0.0375) // you can gain up to 3.5 via the 4x upgrades power is halved by the pole so thats 2x then 1X then .5X for 3.5x the 3 bounces shock.
	return ..()

/obj/structure/grille/get_dumping_location(datum/component/storage/source,mob/user)
	return null

/obj/structure/grille/broken // Pre-broken grilles for map placement
	icon_state = "grille_broken"
	density = FALSE
	obj_integrity = 20
	broken = TRUE
	rods_amount = 1
	rods_broken = FALSE
	grille_type = /obj/structure/grille

/obj/structure/grille/broken/Initialize()
	. = ..()
	holes = (holes | 16)
	update_icon()
