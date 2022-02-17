/datum/element/swimming
	element_flags = ELEMENT_DETACH

/datum/element/swimming/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	var/mob/living/valid_target = target
	on_stat_change(valid_target, new_stat = valid_target.stat)
	RegisterSignal(target, COMSIG_MOB_STATCHANGE, .proc/on_stat_change)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/on_move)

/datum/element/swimming/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOB_STATCHANGE)
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	REMOVE_TRAIT(target, TRAIT_MOVE_FLYING, ELEMENT_TRAIT(type))

/datum/element/swimming/proc/on_stat_change(mob/living/simple_animal/target, new_stat)
	SIGNAL_HANDLER

	if(new_stat == CONSCIOUS)
		ADD_TRAIT(target, TRAIT_MOVE_FLYING, ELEMENT_TRAIT(type))
	else
		REMOVE_TRAIT(target, TRAIT_MOVE_FLYING, ELEMENT_TRAIT(type))

/datum/element/swimming/proc/on_move(mob/living/simple_animal/target, old_loc, dir, forced)
	SIGNAL_HANDLER

	var/turf/CT = get_turf(target)

	if(locate(/obj/effect/liquid) in CT)
		ADD_TRAIT(target, TRAIT_MOVE_FLYING, ELEMENT_TRAIT(type))
	else
		REMOVE_TRAIT(target, TRAIT_MOVE_FLYING, ELEMENT_TRAIT(type))
