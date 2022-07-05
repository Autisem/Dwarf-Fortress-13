/mob/living/simple_animal/hostile/cockroach
	name = "cockroach"
	desc = "This station is just crawling with bugs."
	icon_state = "cockroach"
	icon_dead = "cockroach"
	health = 1
	maxHealth = 1
	turns_per_move = 5
	loot = list(/obj/effect/decal/cleanable/insectguts)
	minbodytemp = 270
	maxbodytemp = INFINITY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	response_disarm_continuous = "прогоняет"
	response_disarm_simple = "прогоняет"
	response_harm_continuous = "splats"
	response_harm_simple = "splat"
	speak_emote = list("трещит")
	density = FALSE
	melee_damage_lower = 0
	melee_damage_upper = 0
	obj_damage = 0
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "трещит"
	verb_ask = "трещит вопросительно"
	verb_exclaim = "трещит громко"
	verb_yell = "трещит громко"
	del_on_death = TRUE
	environment_smash = ENVIRONMENT_SMASH_NONE
	faction = list("neutral")
	var/squish_chance = 50
	// Randomizes hunting intervals, minumum 5 turns
	var/time_to_hunt = 5


/mob/living/simple_animal/hostile/cockroach/Initialize()
	. = ..()
	add_cell_sample()
	make_squashable()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	time_to_hunt = rand(5,10)

/mob/living/simple_animal/hostile/cockroach/proc/make_squashable()
	AddComponent(/datum/component/squashable, squash_chance = 50, squash_damage = 1)

/mob/living/simple_animal/hostile/cockroach/Life(delta_time = SSMOBS_DT, times_fired) // Cockroaches are predators to space ants
	. = ..()
	turns_since_scan++
	if(turns_since_scan > time_to_hunt)
		turns_since_scan = 0
		var/list/target_types = list(/obj/effect/decal/cleanable/ants)
		for(var/obj/effect/decal/cleanable/ants/potential_target in view(2, get_turf(src)))
			if(potential_target.type in target_types)
				hunt(potential_target)
				return


/obj/projectile/glockroachbullet
	damage = 10 //same damage as a hivebot
	damage_type = BRUTE

/obj/item/ammo_casing/glockroach
	name = "0.9mm bullet casing"
	desc = "A... 0.9mm bullet casing? What?"
	projectile_type = /obj/projectile/glockroachbullet

/mob/living/simple_animal/hostile/cockroach/glockroach
	name = "glockroach"
	desc = "HOLY SHIT, THAT COCKROACH HAS A GUN!"
	icon_state = "glockroach"
	melee_damage_lower = 5
	melee_damage_upper = 5
	obj_damage = 20
	gold_core_spawnable = HOSTILE_SPAWN
	projectilesound = 'sound/weapons/gun/pistol/shot.ogg'
	projectiletype = /obj/projectile/glockroachbullet
	casingtype = /obj/item/ammo_casing/glockroach
	ranged = TRUE
	faction = list("hostile")

/mob/living/simple_animal/hostile/cockroach/death(gibbed)
	if(SSticker.mode && SSticker.mode.station_was_nuked) //If the nuke is going off, then cockroaches are invincible. Keeps the nuke from killing them, cause cockroaches are immune to nukes.
		return
	..()

/mob/living/simple_animal/hostile/cockroach/ex_act() //Explosions are a terrible way to handle a cockroach.
	return FALSE

/mob/living/simple_animal/hostile/cockroach/hauberoach
	name = "hauberoach"
	desc = "Is that cockroach wearing a tiny yet immaculate replica 19th century Prussian spiked helmet? ...Is that a bad thing?"
	icon_state = "hauberoach"
	attack_verb_continuous = "таранит колючками"
	attack_verb_simple = "таранит колючками"
	melee_damage_lower = 5
	melee_damage_upper = 20
	obj_damage = 20
	gold_core_spawnable = HOSTILE_SPAWN
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	faction = list("hostile")
	atck_type = PIERCE
	squish_chance = 0 // manual squish if relevant

/mob/living/simple_animal/hostile/cockroach/hauberoach/Initialize()
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 10, max_damage = 15, flags = (CALTROP_BYPASS_SHOES | CALTROP_SILENT))

/mob/living/simple_animal/hostile/cockroach/hauberoach/make_squashable()
	AddComponent(/datum/component/squashable, squash_chance = 100, squash_damage = 1, squash_callback = /mob/living/simple_animal/hostile/cockroach/hauberoach/.proc/on_squish)

///Proc used to override the squashing behavior of the normal cockroach.
/mob/living/simple_animal/hostile/cockroach/hauberoach/proc/on_squish(mob/living/cockroach, mob/living/living_target)
	if(!istype(living_target))
		return FALSE //We failed to run the invoke. Might be because we're a structure. Let the squashable element handle it then!
	if(!HAS_TRAIT(living_target, TRAIT_PIERCEIMMUNE))
		living_target.visible_message(span_danger("[living_target] steps onto [cockroach]'s spike!"), span_userdanger("You step onto [cockroach]'s spike!"))
		return TRUE
	living_target.visible_message(span_notice("[living_target] squashes [cockroach], not even noticing its spike."), span_notice("You squashed [cockroach], not even noticing its spike."))
	return FALSE
