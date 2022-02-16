/datum/gear/ooc
	icon_base64 = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAE1SURBVFhH7ZWxSgNBFEVXAxYhGIstg41gl49IfiGdFn6DmNrGNiJY21gkH2GRn0gdCJZioY21965TjczO3dk3LBIPHHYHEvaxe997B+VgVHTJobt2xn8BSgaG8BSO4Zk71/EJt3ADX905iFIAH3wFb6qTzj18hiwkiFLABVyur09+TiLThw9eLuGKNyGUDPC1pxL9b+4QxvIiFcBAZcMshH5GXAYYxDlvQihvgK3ENDNQt/AJvsB32BqlAPYxW4lpvoOP7lzC1qQsI6ktLT+BT5u2/EXuNqwdwySlgCZtGf1tSgbU3WC2C3xi29F8G/r4BRD5gT69/tGxu5U5h/wECzhxzuAX3ME3KGM2B9T162M9BxrPiNxzIIr1HGgyIyos54DU9z6dt2FKAab8yRCasu8FFMU3BOVGCd1wY3wAAAAASUVORK5CYII="

/datum/gear/ooc/char_slot
	display_name = "Ещё один слот персонажа"
	sort_category = "OOC"
	description = "Дополнительный слот. Что тут ещё сказать, а? Максимум 20 слотов."
	cost = 500

/datum/gear/ooc/char_slot/purchase(var/client/C)
	C?.prefs?.max_slots += 1
	C?.prefs?.save_preferences()
	return TRUE

/datum/gear/ooc/purge_this_shit
	display_name = "Фатальный сброс"
	sort_category = "OOC"
	description = "Сбрасывает метакэш до нуля. Всем."
	cost = 100500

/datum/gear/ooc/purge_this_shit/purchase(var/client/C)
	var/fuck_everyone = tgui_alert(usr,"Это действие приведёт обнулению ВСЕГО метакэша. Ты уверен?","Очищение",list("Да","Нет"))
	if (fuck_everyone == "Да")
		var/datum/db_query/purge_shit = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET metacoins = '0'")
		purge_shit.warn_execute()
		for(var/client/AAA in GLOB.clients)
			AAA.update_metabalance_cache()

		if(isliving(C.mob) && C.mob.stat == CONSCIOUS)
			explosion(get_turf(C.mob), 14, 28, 56)

		to_chat(world, "<BR><BR><BR><center><span class='big bold'>[C.ckey] уничтожает банк метакэша.</span></center><BR><BR><BR>")
		return TRUE
	return FALSE

