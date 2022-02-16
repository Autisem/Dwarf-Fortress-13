GLOBAL_LIST_INIT(skill_types, subtypesof(/datum/skill))

/datum/skill
	var/name = "Skilling"
	var/title = "Skiller"
	var/desc = "the art of doing things"
	///Dictionary of modifier type - list of modifiers (indexed by level). 7 entries in each list for all 7 skill levels.
	var/modifiers = list(SKILL_SPEED_MODIFIER = list(1, 1, 1, 1, 1, 1, 1)) //Dictionary of modifier type - list of modifiers (indexed by level). 7 entries in each list for all 7 skill levels.
	///List Path pointing to the skill cape reward that will appear when a user finishes leveling up a skill
	var/skill_cape_path
	///List associating different messages that appear on level up with different levels
	var/list/levelUpMessages = list()
	///List associating different messages that appear on level up with different levels
	var/list/levelDownMessages = list()

/datum/skill/proc/get_skill_modifier(modifier, level)
	return modifiers[modifier][level] //Levels range from 1 (None) to 7 (Legendary)
/**
 * new: sets up some lists.
 *
 *Can't happen in the datum's definition because these lists are not constant expressions
 */
/datum/skill/New()
	. = ..()
	levelUpMessages = list(span_nicegreen("Че такое [name]? Сообщите администратору, если увидите это.") , //This first index shouldn't ever really be used
	span_nicegreen("Начинаю понимать что такое [name]!") ,
	span_nicegreen("Становится легче понимать [name]!") ,
	span_nicegreen("Гораздо лучше понимаю [name]!") ,
	span_nicegreen("Уже неплохо справляюсь с таким навыком как [name]!") ,
	"<span class='nicegreen'>После долгих практик и упорного обучения, я теперь почти \
	превосходно понимаю что такое [name]. Могу называть себя [title].</span>",
	span_nicegreen("Благодаря невероятной решимости и усилиям я достиг пика в развитии [name]. Я наконец могу считать себя легендарным [title]!")  )
	levelDownMessages = list(span_nicegreen("Как-то полностью потерял понимание [name]. Сообщите администратору, если увидите это.") ,
	span_nicegreen("Начинаю забывать что такое [name]. Нужно больше практики...") ,
	span_nicegreen("Мне становится немного хуже понятна [name]. Мне нужно продолжать практиковаться, чтобы стать лучше...") ,
	span_nicegreen("Мне становится немного хуже понятна [name]...") ,
	span_nicegreen("Теряю понимание [name] ещё сильнее...") ,
	span_nicegreen("Теперь я больше не мастер в таком навыке как [name].") ,
	span_nicegreen("Мои легендарные навыки в навыке [name] иссякают. Мне понадобится более интенсивная тренировка, чтобы восстановить утраченные навыки.")  )

/**
 * level_gained: Gives skill levelup messages to the user
 *
 * Only fires if the xp gain isn't silent, so only really useful for messages.
 * Arguments:
 * * mind - The mind that you'll want to send messages
 * * new_level - The newly gained level. Can check the actual level to give different messages at different levels, see defines in skills.dm
 * * old_level - Similar to the above, but the level you had before levelling up.
 */
/datum/skill/proc/level_gained(datum/mind/mind, new_level, old_level)//just for announcements (doesn't go off if the xp gain is silent)
	to_chat(mind.current, levelUpMessages[new_level]) //new_level will be a value from 1 to 6, so we get appropriate message from the 6-element levelUpMessages list
/**
 * level_lost: See level_gained, same idea but fires on skill level-down
 */
/datum/skill/proc/level_lost(datum/mind/mind, new_level, old_level)
	if(old_level > levelDownMessages.len)
		return
	to_chat(mind.current, levelDownMessages[old_level]) //old_level will be a value from 1 to 6, so we get appropriate message from the 6-element levelUpMessages list

/**
 * try_skill_reward: Checks to see if a user is eligable for a tangible reward for reaching a certain skill level
 *
 * Currently gives the user a special cloak when they reach a legendary level at any given skill
 * Arguments:
 * * mind - The mind that you'll want to send messages and rewards to
 * * new_level - The current level of the user. Used to check if it meets the requirements for a reward
 */
/datum/skill/proc/try_skill_reward(datum/mind/mind, new_level)
	if (new_level != SKILL_LEVEL_LEGENDARY)
		return
	if (!ispath(skill_cape_path))
		to_chat(mind.current, span_nicegreen("Мой легендарный навык [name] весьма крут, однако Ассоциация Профессионалов [title] не имеет особых символов чтобы отметить это."))
		return
	if (LAZYFIND(mind.skills_rewarded, src.type))
		to_chat(mind.current, span_nicegreen("Похоже,  Ассоциация Профессионалов [title] не хочет давать мне больше символов навыка."))
		return
	podspawn(list(
		"target" = get_turf(mind.current),
		"path" = /obj/structure/closet/supplypod,
		"style" = STYLE_BLUESPACE,
		"spawn" = skill_cape_path,
		"delays" = list(POD_TRANSIT = 150, POD_FALLING = 4, POD_OPENING = 30, POD_LEAVING = 30)
	))
	to_chat(mind.current, span_nicegreen("Мой легендарный навык привлёк Ассоциацию Профессионалов [title]. Похоже, они выслали мне особый символ, чтобы отметить это."))
	LAZYADD(mind.skills_rewarded, src.type)
