/mob/living/simple_animal/hostile/cat_butcherer
	name = "Cat Surgeon"
	desc = "A man with the quest of chasing endless feline tail."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "cat_butcher"
	icon_living = "cat_butcher"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	speed = 0
	stat_attack = HARD_CRIT
	robust_searching = 1
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "режет пилой"
	attack_verb_simple = "режет пилой"
	attack_sound = 'sound/weapons/circsawhit.ogg'
	a_intent = INTENT_HARM
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	faction = list("hostile")
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = 1

/mob/living/simple_animal/hostile/cat_butcherer/AttackingTarget()
	. = ..()
	if(. && prob(35) && iscarbon(target))
		var/mob/living/carbon/human/L = target
		var/obj/item/organ/tail/cat/tail = L.getorgan(/obj/item/organ/tail/cat)
		if(!QDELETED(tail))
			visible_message(span_notice("[capitalize(src.name)] severs [L] tail in one swift swipe!") , span_notice("You sever [L] tail in one swift swipe."))
			tail.Remove(L)
			var/obj/item/organ/tail/cat/dropped_tail = new(target.drop_location())
			dropped_tail.color = L.hair_color
		return 1
