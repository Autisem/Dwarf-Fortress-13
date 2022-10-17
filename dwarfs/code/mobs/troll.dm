/mob/living/simple_animal/hostile/troll
	name = "troll"
	desc = "Cute. Might kill you later."
	icon = 'dwarfs/icons/mob/hostile.dmi'
	icon_state = "troll"
	icon_living = "troll"
	icon_dead = "troll_dead"
	gender = NEUTER
	speak_chance = 0
	turns_per_move = 2
	speed = 1.5
	maxHealth = 350
	health = 350
	faction = list("mining")
	weather_immunities = list("lava","ash")
	see_in_dark = 1
	butcher_results = list(/obj/item/food/meat/slab = list(2,3), /obj/item/stack/ore/stone = list(3,6), /obj/item/stack/sheet/mineral/coal = list(1,5))
	hide_type = /obj/item/stack/sheet/animalhide/troll
	response_help_continuous = "pushes"
	response_help_simple = "pushes"
	response_disarm_continuous = "pushes"
	response_disarm_simple = "pushes"
	response_harm_continuous = "hits"
	response_harm_simple = "hits"
	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attacks"
	minbodytemp = 0
	maxbodytemp = INFINITY
	gold_core_spawnable = HOSTILE_SPAWN
	var/rockfalling_last = 0

	discovery_points = 10000

/mob/living/simple_animal/hostile/troll/Initialize()
	. = ..()
	flick("troll_spawn", src)

/mob/living/simple_animal/hostile/troll/Life()
	. = ..()
	if(target && rockfalling_last < world.time && prob(50))
		rockfalling_last = world.time + 60 SECONDS
		for(var/turf/open/T in view(7, src))
			if(prob(5))
				new /obj/effect/temp_visual/rockfall(T)
				spawn(rand(30, 60))
					for(var/mob/living/L in T.contents)
						L.apply_damage_type(20, BRUTE)
						L.Paralyze(100)
						to_chat(L, span_userdanger("A PILE OF STONE IS FALLING ON ME!"))
					T.ChangeTurf(/turf/closed/mineral/random/dwarf_lustress)

/obj/effect/temp_visual/rockfall
	icon = 'icons/mob/actions/actions_items.dmi'
	icon_state = "sniper_zoom"
	layer = BELOW_MOB_LAYER
	light_range = 2
	duration = 9

/obj/effect/temp_visual/rockfall/ex_act()
	return

/obj/effect/temp_visual/rockfall/Initialize(mapload)
	. = ..()
	INVOKE_ASYNC(src, .proc/fall)

/obj/effect/temp_visual/rockfall/proc/fall()
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, TRUE)
