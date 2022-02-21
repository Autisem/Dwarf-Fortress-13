///////////////////////////////////////////////

/obj/structure/flora/tree/boxplanet
	name = "что-то"
	desc = "АААААААААААААААААААААААААААА"
	icon = 'white/valtos/icons/mineflora.dmi'
	icon_state = null
	pixel_x = 0

/obj/structure/flora/tree/boxplanet/kartoshmel
	name = "rat potato"
	desc = "Amazing plant which... is unknown to the world."
	icon_state = "kartoshmel"
	var/mob_type
	var/spawned_mobs = 0
	var/max_spawn = 1
	var/cooldown = 0

/obj/structure/flora/tree/boxplanet/kartoshmel/Initialize()
	mob_type = rand(1, 5)
	. = ..()

/obj/structure/flora/tree/boxplanet/kartoshmel/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/flora/tree/boxplanet/kartoshmel/process()
	if(cooldown < world.time - 480)
		cooldown = world.time
		if(max_spawn > spawned_mobs)
			spawned_mobs++
			var/turf/T = get_turf(src)
			switch(mob_type)
				if(1)
					new /mob/living/simple_animal/hostile/rat(T)
				if(2)
					new /mob/living/simple_animal/hostile/rat(T)
				if(3)
					new /mob/living/simple_animal/hostile/rat(T)
				if(4)
					new /mob/living/simple_animal/hostile/faithless(T)
				if(5)
					new /mob/living/simple_animal/hostile/faithless(T)
		else
			STOP_PROCESSING(SSobj, src)


/obj/structure/flora/tree/boxplanet/glikodil
	name = "healroot"
	desc = "Its leaves have healing properties."
	icon_state = "glikodil"
	var/has_cure = TRUE
	var/needs_sharp_harvest = TRUE
	var/harvest = /obj/item/glikoleaf
	var/harvest_amount = 1
	var/harvested = FALSE
	var/harvest_time = 60

/obj/structure/flora/tree/boxplanet/glikodil/attackby(obj/item/W, mob/user, params)
	if(has_cure && needs_sharp_harvest && W.get_sharpness())
		user.visible_message(span_notice("[user] starts collecting [src] using [W].") ,span_notice("You start collecting [src] with [W]."))
		if(do_after(user, harvest_time, target = src))
			new /obj/item/glikoleaf(loc)
			has_cure = FALSE
	else
		..()

/obj/structure/flora/tree/boxplanet/glikodil/attack_hand(mob/user)
	. = ..()
	if(has_cure)
		has_cure = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.adjustBruteLoss(-25)
			H.adjustFireLoss(-25)
			H.remove_CC()
			H.bodytemperature = H.get_body_temp_normal()
			visible_message(span_notice("[H] touches [src] and his wounds start to heal."))
		else
			visible_message(span_warning("Seems it works on humans only. <b>[capitalize(user)]</b> eats [src]."))
			qdel(src)
		spawn(rand(600, 3600))
			has_cure = TRUE
	else
		to_chat(user, span_notice("Can't find any more leaves."))

/obj/item/glikoleaf
	name = "healroot leaf"
	desc = "A leaf with healing properties."
	icon = 'white/valtos/icons/mineflora.dmi'
	icon_state = "glikoleaf"
	w_class = WEIGHT_CLASS_TINY

/obj/item/glikoleaf/attack(mob/living/M, mob/living/user)
	. = ..()
	M.adjustBruteLoss(-25)
	M.adjustFireLoss(-25)
	M.remove_CC()
	visible_message(span_notice("[M] applies [src] to \himself."))
	qdel(src)

/obj/structure/flora/tree/boxplanet/svetosvin
	name = "lightpig"
	desc = "It glows. Hopefully its not radioactive."
	icon_state = "svetosvin"
	light_color = "#00aaff"
	light_power = 1
	light_range = 5
	var/cooldown = 0

/obj/structure/flora/tree/boxplanet/svetosvin/Bump(atom/A)
	. = ..()
	if(isliving(A))
		var/mob/living/L = A
		L.electrocute_act(15, src)
		L.Paralyze(5 SECONDS)
		playsound(L, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/effect/flora_spawner
	invisibility = SEE_INVISIBLE_OBSERVER
	icon = 'white/valtos/icons/mineflora.dmi'
	icon_state = "kartoshmel"
	maptext = "GEN"
	var/generating_type = /obj/structure/flora/tree/boxplanet/kartoshmel
	var/list/planted_things = list()
	var/cooldown = 0

/obj/effect/flora_spawner/process()
	if(cooldown < world.time - 600 && planted_things.len <= 10)
		cooldown = world.time
		if(prob(100 - (planted_things.len * 10)))
			var/list/possible_turfs = list()
			for(var/turf/T in RANGE_TURFS(7, src))
				if(istype(T, /turf/open/floor/stone/raw))
					possible_turfs += T
			planted_things += new generating_type(pick(possible_turfs))
			if(prob(20))
				new /obj/effect/step_trigger/ambush(pick(possible_turfs))
			list_clear_nulls(planted_things)
			return

/obj/effect/flora_spawner/Initialize()
	. = ..()
	generating_type = pick(/obj/structure/flora/tree/boxplanet/kartoshmel, /obj/structure/flora/tree/boxplanet/glikodil, /obj/structure/flora/tree/boxplanet/svetosvin)
	START_PROCESSING(SSobj, src)

/obj/effect/flora_spawner/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/step_trigger/ambush
	mobs_only = TRUE
	var/amb_chance = 90

/obj/effect/step_trigger/ambush/Trigger(atom/A)
	if(!ishuman(A))
		return
	if(prob(amb_chance))
		amb_chance = 0
		var/msg = pick("ЗАСАДА!", "ЗДЕСЬ КТО-ТО ЕСТЬ!", "МОНСТРЫ!")
		var/turf/T = get_turf(A)
		T.visible_message(span_userdanger("[msg]"))
		playsound(A.loc, 'white/valtos/sounds/ambush.ogg', 50)
		for(var/obj/structure/flora/tree/boxplanet/kartoshmel/K in orange(7, src))
			K.spawned_mobs = 0
			START_PROCESSING(SSobj, K)
		qdel(src)
	else
		amb_chance += 10

/obj/machinery/power_restarter
	name = "большой ржавый рубильник"
	desc = "Если приглядеться, то за толстым слоем ржавчины и крови можно разглядеть надпись \"ПЕРЕЗАГРУЗКА ЭНЕРГОСЕТИ\". К чему бы это?"
	icon = 'white/valtos/icons/switch.dmi'
	icon_state = "switch-off"
	var/is_turned = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/power_restarter/attackby(obj/item/W, mob/user, params)
	electrocute_mob(user, get_area(src), src, 1.7, TRUE)
	return

/obj/machinery/power_restarter/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	add_fingerprint(user)
	if(is_turned)
		to_chat(user, span_danger("Рубильник не поддаётся!"))
		return
	user.visible_message(span_warning("<b>[user]</b> дёргает рубильник!"))
	is_turned = TRUE
	icon_state = "switch-on"
	SSmachines.makepowernets()
	log_admin("[key_name(user)] has remade the powernet. Рубильник called.")
	message_admins("[key_name_admin(user)] has remade the powernets. Рубильник called.")
	use_power(5)
	playsound(src.loc, 'white/valtos/sounds/leveron.ogg', 50, TRUE)
	spawn(3000)
		icon_state = "switch-off"
		is_turned = FALSE
		playsound(src.loc, 'white/valtos/sounds/leveroff.ogg', 90, TRUE)
		var/turf/T = get_turf(src)
		T.visible_message(span_notice("<b>[src]</b> возвращается на место!"))
