GLOBAL_LIST(admin_objective_list) //Prefilled admin assignable objective list
GLOBAL_LIST_EMPTY(objectives)

/datum/objective
	var/datum/mind/owner				//The primary owner of the objective. !!SOMEWHAT DEPRECATED!! Prefer using 'team' for new code.
	var/datum/team/team					//An alternative to 'owner': a team. Use this when writing new code.
	var/name = "generic objective" 		//Name for admin prompts
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/team_explanation_text			//For when there are multiple owners.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = FALSE				//currently only used for custom objectives.
	var/martyr_compatible = FALSE		//If the objective is compatible with martyr objective, i.e. if you can still do it while dead.
	var/reward = 5

/datum/objective/New(text)
	GLOB.objectives += src
	if(text)
		explanation_text = text

//Apparently objectives can be qdel'd. Learn a new thing every day
/datum/objective/Destroy()
	return ..()

/datum/objective/proc/get_owners() // Combine owner and team into a single list.
	. = (team?.members) ? team.members.Copy() : list()
	if(owner)
		. += owner

/datum/objective/proc/admin_edit(mob/admin)
	return

//Shared by few objective types
/datum/objective/proc/admin_simple_target_pick(mob/admin)
	var/list/possible_targets = list()
	var/def_value
	for(var/datum/mind/possible_target in SSticker.minds)
		if ((possible_target != src) && ishuman(possible_target.current))
			possible_targets += possible_target.current

	possible_targets = list("Ничего", "Random") + sortNames(possible_targets)


	if(target?.current)
		def_value = target.current

	var/mob/new_target = input(admin,"Select target:", "Objective target", def_value) as null|anything in possible_targets
	if (!new_target)
		return

	if (new_target == "Ничего.")
		target = null
	else if (new_target == "Random")
		find_target()
	else
		target = new_target.mind

	update_explanation_text()

/datum/objective/proc/considered_escaped(datum/mind/M)
	if(!considered_alive(M))
		return FALSE
	if(M.force_escaped)
		return TRUE
	if(SSticker.force_ending || SSticker.mode.station_was_nuked) // Just let them win.
		return TRUE
	var/area/current_area = get_area(M.current)
	if(!current_area || istype(current_area, /area/shuttle/escape/brig)) // Fails if they are in the shuttle brig
		return FALSE
	var/turf/current_turf = get_turf(M.current)
	return current_turf.onCentCom() || current_turf.onSyndieBase()

/datum/objective/proc/check_completion()
	return completed

/datum/objective/proc/is_unique_objective(possible_target, dupe_search_range)
	if(!islist(dupe_search_range))
		stack_trace("Non-list passed as duplicate objective search range")
		dupe_search_range = list(dupe_search_range)

	for(var/A in dupe_search_range)
		var/list/objectives_to_compare
		if(istype(A,/datum/mind))
			var/datum/mind/M = A
			objectives_to_compare = M.get_all_objectives()
		else if(istype(A,/datum/antagonist))
			var/datum/antagonist/G = A
			objectives_to_compare = G.objectives
		else if(istype(A,/datum/team))
			var/datum/team/T = A
			objectives_to_compare = T.objectives
		for(var/datum/objective/O in objectives_to_compare)
			if(istype(O, type) && O.get_target() == possible_target)
				return FALSE
	return TRUE

/datum/objective/proc/get_target()
	return target

//dupe_search_range is a list of antag datums / minds / teams
/datum/objective/proc/find_target(dupe_search_range, blacklist)
	var/list/datum/mind/owners = get_owners()
	if(!dupe_search_range)
		dupe_search_range = get_owners()
	var/list/possible_targets = list()
	var/try_target_late_joiners = FALSE
	for(var/I in owners)
		var/datum/mind/O = I
		if(O.late_joiner)
			try_target_late_joiners = TRUE
	for(var/datum/mind/possible_target in GLOB.alive_player_list)
		if(is_valid_target(possible_target) && !(possible_target in owners) && ishuman(possible_target.current) && (possible_target.current.stat != DEAD) && is_unique_objective(possible_target,dupe_search_range))
			if (!(possible_target in blacklist))
				possible_targets += possible_target
	if(try_target_late_joiners)
		var/list/all_possible_targets = possible_targets.Copy()
		for(var/I in all_possible_targets)
			var/datum/mind/PT = I
			if(!PT.late_joiner)
				possible_targets -= PT
		if(!possible_targets.len)
			possible_targets = all_possible_targets
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	if(target?.assigned_role in list("Russian Officer", "Trader", "Hacker","Veteran", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Chief Engineer", "Research Director", "Chief Medical Officer", "Field Medic", "AI", "Cyborg"))
		reward+=reward
	update_explanation_text()
	return target

/datum/objective/proc/is_valid_target(possible_target)
	return TRUE

/datum/objective/escape/escape_with_identity/is_valid_target(possible_target)
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!M)
			continue
	return TRUE

/datum/objective/proc/find_target_by_role(role, role_type=FALSE,invert=FALSE)//Option sets either to check assigned role or special role. Default to assigned., invert inverts the check, eg: "Don't choose a Ling"
	var/list/datum/mind/owners = get_owners()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in GLOB.alive_player_list)
		if(!(possible_target in owners) && ishuman(possible_target.current))
			var/is_role = FALSE
			if(role_type)
				if(possible_target.special_role == role)
					is_role = TRUE
			else
				if(possible_target.assigned_role == role)
					is_role = TRUE

			if(invert)
				if(is_role)
					continue
				possible_targets += possible_target
				break
			else if(is_role)
				possible_targets += possible_target
				break
	if(length(possible_targets))
		target = pick(possible_targets)
	update_explanation_text()
	return target

/datum/objective/proc/update_explanation_text()
	if(team_explanation_text && LAZYLEN(get_owners()) > 1)
		explanation_text = team_explanation_text

/datum/objective/proc/give_special_equipment(special_equipment)
	var/datum/mind/receiver = pick(get_owners())
	if(receiver?.current)
		if(ishuman(receiver.current))
			var/mob/living/carbon/human/H = receiver.current
			var/list/slots = list("backpack" = ITEM_SLOT_BACKPACK)
			for(var/eq_path in special_equipment)
				var/obj/O = new eq_path
				H.equip_in_one_of_slots(O, slots)

/datum/objective/protect//The opposite of killing a dude.
	name = "protect"
	martyr_compatible = TRUE
	var/target_role_type = FALSE
	var/human_check = TRUE
	reward = 20

/datum/objective/protect/find_target_by_role(role, role_type=FALSE,invert=FALSE)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/protect/check_completion()
	var/obj/item/organ/brain/brain_target
	if(human_check)
		brain_target = target.current?.getorganslot(ORGAN_SLOT_BRAIN)
	//Protect will always suceed when someone suicides
	return !target || considered_alive(target, enforce_human = human_check) || brain_target?.suicided

/datum/objective/protect/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Защитить [target.name], на должности [ru_job_parse(!target_role_type ? target.assigned_role : target.special_role)]."
	else
		explanation_text = "Ничего."

/datum/objective/protect/admin_edit(mob/admin)
	admin_simple_target_pick(admin)

/datum/objective/survive
	name = "survive"
	explanation_text = "Выжить."
	reward = 5

/datum/objective/survive/check_completion()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!considered_alive(M))
			return FALSE
	return TRUE

/datum/objective/martyr
	name = "martyr"
	explanation_text = "Погибнуть красиво."
	reward = 15

/datum/objective/martyr/check_completion()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(considered_alive(M))
			return FALSE
		if(M.current?.suiciding) //killing yourself ISN'T glorious.
			return FALSE
	return TRUE

GLOBAL_LIST_EMPTY(possible_items)
/datum/objective/steal
	name = "steal"
	var/datum/objective_item/targetinfo = null //Save the chosen item datum so we can access it later.
	var/obj/item/steal_target = null //Needed for custom objectives (they're just items, not datums).
	martyr_compatible = FALSE
	reward = 15

/datum/objective/steal/get_target()
	return steal_target

/datum/objective/steal/New()
	..()
	if(!GLOB.possible_items.len)//Only need to fill the list when it's needed.
		for(var/I in subtypesof(/datum/objective_item/steal))
			new I

/datum/objective/steal/find_target(dupe_search_range)
	var/list/datum/mind/owners = get_owners()
	if(!dupe_search_range)
		dupe_search_range = get_owners()
	var/approved_targets = list()
	check_items:
		for(var/datum/objective_item/possible_item in GLOB.possible_items)
			if(!is_unique_objective(possible_item.targetitem,dupe_search_range))
				continue
			for(var/datum/mind/M in owners)
				if(M.current.mind.assigned_role in possible_item.excludefromjob)
					continue check_items
			approved_targets += possible_item
	if (length(approved_targets))
		return set_target(pick(approved_targets))
	return set_target(null)

/datum/objective/steal/proc/set_target(datum/objective_item/item)
	if(item)
		targetinfo = item
		steal_target = targetinfo.targetitem
		explanation_text = "Украсть [targetinfo.name]"
		give_special_equipment(targetinfo.special_equipment)
		return steal_target
	else
		explanation_text = "Ничего."
		return

/datum/objective/steal/admin_edit(mob/admin)
	var/list/possible_items_all = GLOB.possible_items
	var/new_target = input(admin,"Select target:", "Objective target", steal_target) as null|anything in sortNames(possible_items_all)+"custom"
	if (!new_target)
		return

	if (new_target == "custom") //Can set custom items.
		var/custom_path = input(admin,"Search for target item type:","Type") as null|text
		if (!custom_path)
			return
		var/obj/item/custom_target = pick_closest_path(custom_path, make_types_fancy(subtypesof(/obj/item)))
		var/custom_name = initial(custom_target.name)
		custom_name = stripped_input(admin,"Enter target name:", "Objective target", custom_name)
		if (!custom_name)
			return
		steal_target = custom_target
		explanation_text = "Украсть [custom_name]."

	else
		set_target(new_target)

/datum/objective/steal/check_completion()
	var/list/datum/mind/owners = get_owners()
	if(!steal_target)
		return TRUE
	for(var/datum/mind/M in owners)
		if(!isliving(M.current))
			continue

		var/list/all_items = M.current.GetAllContents()	//this should get things in cheesewheels, books, etc.

		for(var/obj/I in all_items) //Check for items
			if(istype(I, steal_target))
				if(!targetinfo) //If there's no targetinfo, then that means it was a custom objective. At this point, we know you have the item, so return 1.
					return TRUE
				else if(targetinfo.check_special_completion(I))//Returns 1 by default. Items with special checks will return 1 if the conditions are fulfilled.
					return TRUE

			if(targetinfo && (I.type in targetinfo.altitems)) //Ok, so you don't have the item. Do you have an alternative, at least?
				if(targetinfo.check_special_completion(I))//Yeah, we do! Don't return 0 if we don't though - then you could fail if you had 1 item that didn't pass and got checked first!
					return TRUE
	return FALSE

GLOBAL_LIST_EMPTY(possible_items_special)
/datum/objective/steal/special //ninjas are so special they get their own subtype good for them
	name = "steal special"
	reward = 15

/datum/objective/steal/special/New()
	..()
	if(!GLOB.possible_items_special.len)
		for(var/I in subtypesof(/datum/objective_item/special) + subtypesof(/datum/objective_item/stack))
			new I

/datum/objective/steal/special/find_target(dupe_search_range)
	return set_target(pick(GLOB.possible_items_special))

/datum/objective/protect_object
	name = "protect object"
	var/obj/protect_target

/datum/objective/protect_object/proc/set_target(obj/O)
	protect_target = O
	update_explanation_text()

/datum/objective/protect_object/update_explanation_text()
	. = ..()
	if(protect_target)
		explanation_text = "Защитить [protect_target] любой ценой."
	else
		explanation_text = "Ничего."

/datum/objective/protect_object/check_completion()
	return !QDELETED(protect_target)

//Created by admin tools
/datum/objective/custom
	name = "custom"
	reward = 5

/datum/objective/custom/admin_edit(mob/admin)
	var/expl = stripped_input(admin, "Custom objective:", "Objective", explanation_text)
	if(expl)
		explanation_text = expl

//Ideally this would be all of them but laziness and unusual subtypes
/proc/generate_admin_objective_list()
	GLOB.admin_objective_list = list()

	var/list/allowed_types = sort_list(list(
		/datum/objective/protect,
		/datum/objective/escape,
		/datum/objective/survive,
		/datum/objective/martyr,
		/datum/objective/steal,
		/datum/objective/custom
	),/proc/cmp_typepaths_asc)

	for(var/T in allowed_types)
		var/datum/objective/X = T
		GLOB.admin_objective_list[initial(X.name)] = T
