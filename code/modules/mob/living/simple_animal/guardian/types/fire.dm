//Fire
/mob/living/simple_animal/hostile/guardian/fire
	a_intent = INTENT_HELP
	melee_damage_lower = 7
	melee_damage_upper = 7
	attack_sound = 'sound/items/welder.ogg'
	attack_verb_continuous = "поджигает"
	attack_verb_simple = "поджигает"
	range = 7
	playstyle_string = span_holoparasite("As a <b>chaos</b> type, you have only light damage resistance, but will ignite any enemy you bump into. In addition, your melee attacks will cause human targets to see everyone as you.")
	magic_fluff_string = span_holoparasite("..And draw the Wizard, bringer of endless chaos!")
	tech_fluff_string = span_holoparasite("Boot sequence complete. Crowd control modules activated. Holoparasite swarm online.")
	carp_fluff_string = span_holoparasite("CARP CARP CARP! You caught one! OH GOD, EVERYTHING'S ON FIRE. Except you and the fish.")
	miner_fluff_string = span_holoparasite("You encounter... Plasma, the bringer of fire.")

/mob/living/simple_animal/hostile/guardian/fire/Initialize(mapload, theme)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/mob/living/simple_animal/hostile/guardian/fire/Life(delta_time = SSMOBS_DT, times_fired)
	. = ..()
	if(summoner)
		summoner.extinguish_mob()
		summoner.adjust_fire_stacks(-10 * delta_time)

/mob/living/simple_animal/hostile/guardian/fire/AttackingTarget()
	. = ..()
	if(. && ishuman(target) && target != summoner)
		new /datum/hallucination/delusion(target,TRUE,"custom",200,0, icon_state,icon)

/mob/living/simple_animal/hostile/guardian/fire/proc/on_entered(datum/source, AM as mob|obj)
	SIGNAL_HANDLER
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/Bumped(atom/movable/AM)
	..()
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/Bump(AM as mob|obj)
	..()
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/proc/collision_ignite(AM as mob|obj)
	if(isliving(AM))
		var/mob/living/M = AM
		if(!hasmatchingsummoner(M) && M != summoner && M.fire_stacks < 7)
			M.set_fire_stacks(7)
			M.IgniteMob()
