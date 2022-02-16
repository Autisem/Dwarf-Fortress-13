/obj/projectile/magic
	name = "пустяк"
	icon_state = "energy"
	damage = 0
	damage_type = OXY
	nodamage = TRUE
	armour_penetration = 100
	flag = MAGIC

/obj/projectile/magic/death
	name = "заряд смерти"
	icon_state = "pulse1_bl"

/obj/projectile/magic/death/on_hit(mob/living/target)
	. = ..()
	if(!istype(target))
		return

	if(target.anti_magic_check())
		target.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
		return BULLET_ACT_BLOCK

	if(target.mob_biotypes & MOB_UNDEAD) //negative energy heals the undead
		if(target.hellbound && target.stat == DEAD)
			return BULLET_ACT_BLOCK
		else if(target.stat != DEAD)
			to_chat(target, span_notice("Чувствую себя отлично!"))
		return

	target.death()

/obj/projectile/magic/resurrection
	name = "заряд воскрешения"
	icon_state = "ion"
	damage = 0
	damage_type = OXY
	nodamage = TRUE

/obj/projectile/magic/resurrection/on_hit(mob/living/carbon/target)
	. = ..()
	if(isliving(target))
		if(target.anti_magic_check())
			target.visible_message(span_warning("[capitalize(src.name)] испаряется при контакте с [target]!"))
			return BULLET_ACT_BLOCK
		if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			target.death(0)
		else
			if(target.hellbound && target.stat == DEAD)
				return BULLET_ACT_BLOCK
			else if(target.stat != DEAD)
				to_chat(target, span_notice("Чувствую себя прекрасно!"))

/obj/projectile/magic/teleport
	name = "заряд телепортации"
	icon_state = "bluespace"
	damage = 0
	damage_type = OXY
	nodamage = TRUE
	var/inner_tele_radius = 0
	var/outer_tele_radius = 6

/obj/projectile/magic/teleport/on_hit(mob/target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			M.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			return BULLET_ACT_BLOCK
	var/teleammount = 0
	var/teleloc = target
	if(!isturf(target))
		teleloc = target.loc
	for(var/atom/movable/stuff in teleloc)
		if(!stuff.anchored && stuff.loc && !isobserver(stuff))
			if(do_teleport(stuff, stuff, 10, channel = TELEPORT_CHANNEL_MAGIC))
				teleammount++
				var/datum/effect_system/smoke_spread/smoke = new
				smoke.set_up(max(round(4 - teleammount),0), stuff.loc) //Smoke drops off if a lot of stuff is moved for the sake of sanity
				smoke.start()

/obj/projectile/magic/safety
	name = "заряд безопасности"
	icon_state = "bluespace"
	damage = 0
	damage_type = OXY
	nodamage = TRUE

/obj/projectile/magic/safety/on_hit(atom/target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			M.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			return BULLET_ACT_BLOCK
	if(isturf(target))
		return BULLET_ACT_HIT

	var/turf/origin_turf = get_turf(target)
	var/turf/destination_turf = find_safe_turf()

	if(do_teleport(target, destination_turf, channel=TELEPORT_CHANNEL_MAGIC))
		for(var/t in list(origin_turf, destination_turf))
			var/datum/effect_system/smoke_spread/smoke = new
			smoke.set_up(0, t)
			smoke.start()

/obj/projectile/magic/door
	name = "заряд создания дверей"
	icon_state = "energy"
	damage = 0
	damage_type = OXY
	nodamage = TRUE
	var/list/door_types = list(/obj/structure/mineral_door/wood, /obj/structure/mineral_door/iron, /obj/structure/mineral_door/silver, /obj/structure/mineral_door/gold, /obj/structure/mineral_door/uranium, /obj/structure/mineral_door/sandstone, /obj/structure/mineral_door/transparent/diamond)

/obj/projectile/magic/door/on_hit(atom/target)
	. = ..()
	if(istype(target, /obj/machinery/door))
		OpenDoor(target)
	else
		var/turf/T = get_turf(target)
		if(isclosedturf(T) && !isindestructiblewall(T))
			CreateDoor(T)

/obj/projectile/magic/door/proc/CreateDoor(turf/T)
	var/door_type = pick(door_types)
	var/obj/structure/mineral_door/D = new door_type(T)
	T.ChangeTurf(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
	D.Open()

/obj/projectile/magic/door/proc/OpenDoor(obj/machinery/door/D)
	D.open()

/obj/projectile/magic/change
	name = "заряд изменений"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	nodamage = TRUE

/obj/projectile/magic/change/on_hit(atom/change)
	. = ..()
	if(ismob(change))
		var/mob/M = change
		if(M.anti_magic_check())
			M.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [M]!"))
			qdel(src)
			return BULLET_ACT_BLOCK
	wabbajack(change)
	qdel(src)

/proc/wabbajack(mob/living/M, randomize)

	if(!istype(M) || M.stat == DEAD || M.notransform || (GODMODE & M.status_flags))
		return

	M.notransform = TRUE
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, MAGIC_TRAIT)
	ADD_TRAIT(M, TRAIT_HANDS_BLOCKED, MAGIC_TRAIT)
	M.icon = null
	M.cut_overlays()
	M.invisibility = INVISIBILITY_ABSTRACT

	var/list/contents = M.contents.Copy()

	for(var/obj/item/W in contents)
		if(!M.dropItemToGround(W))
			qdel(W)

	var/mob/living/new_mob

	if(!randomize)
		randomize = pick("monkey","robot","slime","xeno","humanoid","animal")
	switch(randomize)
		if("monkey")
			new_mob = new /mob/living/carbon/human/species/monkey(M.loc)

		if("animal")
			var/path = pick(/mob/living/simple_animal/hostile/carp,
							/mob/living/simple_animal/hostile/bear,
							/mob/living/simple_animal/hostile/mushroom,
							/mob/living/simple_animal/hostile/retaliate/bat,
							/mob/living/simple_animal/hostile/retaliate/goat,
							/mob/living/simple_animal/hostile/killertomato,
							/mob/living/simple_animal/hostile/asteroid/basilisk/watcher,
							/mob/living/simple_animal/hostile/asteroid/goliath/beast,
							/mob/living/simple_animal/hostile/stickman,
							/mob/living/simple_animal/hostile/stickman/dog,
							/mob/living/simple_animal/hostile/gorilla,
							/mob/living/simple_animal/parrot,
							/mob/living/simple_animal/pet/dog/corgi,
							/mob/living/simple_animal/crab,
							/mob/living/simple_animal/pet/dog/pug,
							/mob/living/simple_animal/pet/cat,
							/mob/living/simple_animal/mouse,
							/mob/living/simple_animal/chicken,
							/mob/living/simple_animal/cow,
							/mob/living/simple_animal/hostile/lizard,
							/mob/living/simple_animal/pet/fox,
							/mob/living/simple_animal/butterfly,
							/mob/living/simple_animal/pet/cat/cak,
							/mob/living/simple_animal/chick)
			new_mob = new path(M.loc)

		if("humanoid")
			new_mob = new /mob/living/carbon/human(M.loc)

			if(prob(50))
				var/list/chooseable_races = list()
				for(var/speciestype in subtypesof(/datum/species))
					var/datum/species/S = speciestype
					if(initial(S.changesource_flags) & WABBAJACK)
						chooseable_races += speciestype

				if(chooseable_races.len)
					new_mob.set_species(pick(chooseable_races))

			var/datum/preferences/A = new()	//Randomize appearance for the human
			A.copy_to(new_mob, icon_updates=0)

			var/mob/living/carbon/human/H = new_mob
			H.update_body()
			H.update_hair()
			H.update_body_parts()
			H.dna.update_dna_identity()

	if(!new_mob)
		return

	// Some forms can still wear some items
	for(var/obj/item/W in contents)
		new_mob.equip_to_appropriate_slot(W)

	M.log_message("became [new_mob.real_name]", LOG_ATTACK, color="orange")

	new_mob.a_intent = INTENT_HARM

	M.wabbajack_act(new_mob)

	to_chat(new_mob, span_warning("Внезапно становлюсь [randomize]."))

	var/poly_msg = get_policy(POLICY_POLYMORPH)
	if(poly_msg)
		to_chat(new_mob, poly_msg)

	M.transfer_observers_to(new_mob)

	qdel(M)
	return new_mob

/obj/projectile/magic/animate
	name = "заряд анимации"
	icon_state = "red_1"
	damage = 0
	damage_type = BURN
	nodamage = TRUE

/obj/projectile/magic/animate/on_hit(atom/target, blocked = FALSE)
	target.animate_atom_living(firer)
	..()

/atom/proc/animate_atom_living(mob/living/owner = null)
	if((isitem(src) || isstructure(src)) && !is_type_in_list(src, GLOB.protected_objects))
		var/obj/O = src
		if(istype(O, /obj/item/gun))
			new /mob/living/simple_animal/hostile/mimic/copy/ranged(drop_location(), src, owner)
		else
			new /mob/living/simple_animal/hostile/mimic/copy(drop_location(), src, owner)

	else if(istype(src, /mob/living/simple_animal/hostile/mimic/copy))
		// Change our allegiance!
		var/mob/living/simple_animal/hostile/mimic/copy/C = src
		if(owner)
			C.ChangeOwner(owner)

/obj/projectile/magic/spellblade
	name = "энергия лезвия"
	icon_state = "lavastaff"
	damage = 15
	damage_type = BURN
	flag = MAGIC
	dismemberment = 50
	nodamage = FALSE

/obj/projectile/magic/spellblade/on_hit(target)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			M.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

/obj/projectile/magic/arcane_barrage
	name = "тайный заряд"
	icon_state = "arcane_barrage"
	damage = 20
	damage_type = BURN
	nodamage = FALSE
	armour_penetration = 0
	flag = MAGIC
	hitsound = 'sound/weapons/barragespellhit.ogg'

/obj/projectile/magic/arcane_barrage/on_hit(target)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			M.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()


/obj/projectile/magic/locker
	name = "шкафозаряд"
	icon_state = "locker"
	nodamage = TRUE
	flag = MAGIC
	var/weld = TRUE
	var/created = FALSE //prevents creation of more then one locker if it has multiple hits
	var/locker_suck = TRUE
	var/datum/weakref/locker_ref

/obj/projectile/magic/locker/Initialize()
	. = ..()
	var/obj/structure/closet/decay/locker_temp_instance = new(src)
	locker_ref = WEAKREF(locker_temp_instance)

/obj/projectile/magic/locker/prehit_pierce(atom/A)
	. = ..()
	if(isliving(A) && locker_suck)
		var/mob/living/M = A
		if(M.anti_magic_check()) // no this doesn't check if ..() returned to phase through do I care no it's magic ain't gotta explain shit
			M.visible_message(span_warning("[src] vanishes on contact with [A]!"))
			return PROJECTILE_DELETE_WITHOUT_HITTING
		var/obj/structure/closet/decay/locker_temp_instance = locker_ref.resolve()
		if(!locker_temp_instance?.insertion_allowed(M))
			return
		M.forceMove(src)
		return PROJECTILE_PIERCE_PHASE

/obj/projectile/magic/locker/on_hit(target)
	if(created)
		return ..()
	if(LAZYLEN(contents))
		var/obj/structure/closet/decay/locker_temp_instance = locker_ref.resolve()
		if(!locker_temp_instance)
			return ..()
		for(var/atom/movable/AM in contents)
			locker_temp_instance.insert(AM)
		locker_temp_instance.welded = weld
		locker_temp_instance.update_icon()
	created = TRUE
	return ..()

/obj/projectile/magic/locker/Destroy()
	locker_suck = FALSE
	RemoveElement(/datum/element/connect_loc, projectile_connections) //We do this manually so the forcemoves don't "hit" us. This behavior is kinda dumb, someone refactor this
	for(var/atom/movable/AM in contents)
		AM.forceMove(get_turf(src))
	. = ..()

/obj/structure/closet/decay
	breakout_time = 600
	icon_welded = null
	icon_state = "cursed"
	var/weakened_icon = "decursed"
	var/auto_destroy = TRUE

/obj/structure/closet/decay/Initialize()
	. = ..()
	if(auto_destroy)
		addtimer(CALLBACK(src, .proc/bust_open), 5 MINUTES)

/obj/structure/closet/decay/after_weld(weld_state)
	if(weld_state)
		unmagify()

///Fade away into nothing
/obj/structure/closet/decay/proc/decay()
	animate(src, alpha = 0, time = 30)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), 30)

/obj/structure/closet/decay/open(mob/living/user, force = FALSE)
	. = ..()
	if(.)
		unmagify()

///Give it the lesser magic icon and tell it to delete itself
/obj/structure/closet/decay/proc/unmagify()
	icon_state = weakened_icon
	update_icon()

	addtimer(CALLBACK(src, .proc/decay), 15 SECONDS)

/obj/projectile/magic/flying
	name = "заряд полёта"
	icon_state = "flight"

/obj/projectile/magic/flying/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			L.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			return BULLET_ACT_BLOCK
		var/atom/throw_target = get_edge_target_turf(L, angle2dir(Angle))
		L.throw_at(throw_target, 200, 4)

/obj/projectile/magic/antimagic
	name = "заряд антимагии"
	icon_state = "antimagic"

/obj/projectile/magic/antimagic/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			L.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			return BULLET_ACT_BLOCK
		L.apply_status_effect(STATUS_EFFECT_ANTIMAGIC)

/obj/projectile/magic/fetch
	name = "заряд извлечения"
	icon_state = "fetch"

/obj/projectile/magic/fetch/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check() || !firer)
			L.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			return BULLET_ACT_BLOCK
		var/atom/throw_target = get_edge_target_turf(L, get_dir(L, firer))
		L.throw_at(throw_target, 200, 4)

/obj/projectile/magic/sapping
	name = "заряд иссушения"
	icon_state = "sapping"

/obj/projectile/magic/sapping/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			M.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			return BULLET_ACT_BLOCK
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, src, /datum/mood_event/sapped)

/obj/projectile/magic/wipe
	name = "заряд одержимости"
	icon_state = "wipe"

/obj/projectile/magic/wipe/on_hit(target)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.anti_magic_check())
			M.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
			return BULLET_ACT_BLOCK
		for(var/x in M.get_traumas())//checks to see if the victim is already going through possession
			if(istype(x, /datum/brain_trauma/special/imaginary_friend/trapped_owner))
				M.visible_message(span_warning("[capitalize(src.name)] распадается при контакте с [target]!"))
				return BULLET_ACT_BLOCK
		to_chat(M, span_warning("Мой разум открыт для любого желающего!"))
		possession_test(M)
		return BULLET_ACT_HIT

/obj/projectile/magic/wipe/proc/possession_test(mob/living/carbon/M)
	var/datum/brain_trauma/special/imaginary_friend/trapped_owner/trauma = M.gain_trauma(/datum/brain_trauma/special/imaginary_friend/trapped_owner)
	var/poll_message = "Хотите быть [M.real_name]?"
	if(M.mind && M.mind.assigned_role)
		poll_message = "[poll_message] Профессия:[M.mind.assigned_role]."
	if(M.mind && M.mind.special_role)
		poll_message = "[poll_message] Статус:[M.mind.special_role]."
	else if(M.mind)
		var/datum/antagonist/A = M.mind.has_antag_datum(/datum/antagonist/)
		if(A)
			poll_message = "[poll_message] Статус:[A.name]."
	var/list/mob/dead/observer/candidates = poll_candidates_for_mob(poll_message, ROLE_ICECREAM, null, 100, M)
	if(M.stat == DEAD)//boo.
		return
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		to_chat(M, span_boldnotice("Был замечен призраком, и он овладел мною!"))
		var/oldkey = M.key
		M.ghostize(0)
		M.key = C.key
		trauma.friend.key = oldkey
		trauma.friend.reset_perspective(null)
		trauma.friend.Show()
		trauma.friend_initialized = TRUE
	else
		to_chat(M, span_notice("Мой разум сумел остаться незамеченным в духовном мире."))
		qdel(trauma)

/obj/projectile/magic/aoe
	name = "Заряд Области"
	desc = "Ну и что он, блять, делает?!"
	damage = 0
	var/proxdet = TRUE

/obj/projectile/magic/aoe/Range()
	if(proxdet)
		for(var/mob/living/L in range(1, get_turf(src)))
			if(L.stat != DEAD && L != firer && !L.anti_magic_check())
				return Bump(L)
	..()

/obj/projectile/magic/aoe/fireball
	name = "огненный шар"
	icon_state = "fireball"
	damage = 10
	damage_type = BRUTE
	nodamage = FALSE

	//explosion values
	var/exp_heavy = 0
	var/exp_light = 2
	var/exp_flash = 3
	var/exp_fire = 2

/obj/projectile/magic/aoe/fireball/infernal
	name = "infernal fireball"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 4
	exp_fire= 5

/obj/projectile/magic/aoe/fireball/infernal/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			return BULLET_ACT_BLOCK
	var/turf/T = get_turf(target)
	for(var/i=0, i<50, i+=10)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/explosion, T, -1, exp_heavy, exp_light, exp_flash, FALSE, FALSE, exp_fire), i)

/obj/projectile/magic/aoe/fireball/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[capitalize(src.name)] затухает при контакте с [target]!"))
			return BULLET_ACT_BLOCK
		M.take_overall_damage(0,10) //between this 10 burn, the 10 brute, the explosion brute, and the onfire burn, your at about 65 damage if you stop drop and roll immediately
	var/turf/T = get_turf(target)
	explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire)


//still magic related, but a different path

/obj/projectile/temp/chill
	name = "заряд озноба"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = FALSE
	armour_penetration = 100
	temperature = -200 // Cools you down greatly per hit
	flag = MAGIC

/obj/projectile/magic/nothing
	name = "заряд пустоты"
