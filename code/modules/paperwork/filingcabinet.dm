/* Filing cabinets!
 * Contains:
 *		Filing Cabinets
 *		Security Record Cabinets
 *		Medical Record Cabinets
 *		Employment Contract Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "Картотека"
	desc = "Большой шкаф с ящиками."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = TRUE
	anchored = TRUE


/obj/structure/filingcabinet/chestdrawer
	name = "Комод"
	icon_state = "chestdrawer"

/obj/structure/filingcabinet/chestdrawer/wheeled
	name = "Комод на колёсиках"
	desc = "Небольшой шкаф с ящиками. У этого есть колёсики!"
	anchored = FALSE

/obj/structure/filingcabinet/filingcabinet	//not changing the path to avoid unnecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/Initialize(mapload)
	. = ..()
	if(mapload)
		for(var/obj/item/I in loc)
			if(I.w_class < WEIGHT_CLASS_NORMAL) //there probably shouldn't be anything placed ontop of filing cabinets in a map that isn't meant to go in them
				I.forceMove(src)

/obj/structure/filingcabinet/attackby(obj/item/P, mob/user, params)
	if(P.tool_behaviour == TOOL_WRENCH && user.a_intent != INTENT_HELP)
		to_chat(user, span_notice("Начинаю [anchored ? "unwrench" : "wrench"] [src]."))
		if(P.use_tool(src, user, 20, volume=50))
			to_chat(user, span_notice("Успешно [anchored ? "unwrench" : "wrench"] [src]."))
			set_anchored(!anchored)
	else if(P.w_class < WEIGHT_CLASS_NORMAL)
		if(!user.transferItemToLoc(P, src))
			return
		to_chat(user, span_notice("Кладу [P] в [src]."))
		icon_state = "[initial(icon_state)]-open"
		sleep(5)
		icon_state = initial(icon_state)
		updateUsrDialog()
	else if(user.a_intent != INTENT_HARM)
		to_chat(user, span_warning("Не могу положить [P] в [src]!"))
	else
		return ..()


/obj/structure/filingcabinet/ui_interact(mob/user)
	. = ..()
	if(contents.len <= 0)
		to_chat(user, span_notice("[capitalize(src.name)] пуст."))
		return

	var/dat = "<center><table>"
	var/i
	for(i=contents.len, i>=1, i--)
		var/obj/item/P = contents[i]
		dat += "<tr><td><a href='?src=[REF(src)];retrieve=[REF(P)]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	user << browse("<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><title>[name]</title></head><body>[dat]</body></html>", "window=filingcabinet;size=350x300")

/obj/structure/filingcabinet/Topic(href, href_list)
	if(!usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE))
		return
	if(href_list["retrieve"])
		usr << browse("", "window=filingcabinet") // Close the menu

		var/obj/item/P = locate(href_list["retrieve"]) in src //contents[retrieveindex]
		if(istype(P) && in_range(src, usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			icon_state = "[initial(icon_state)]-open"
			addtimer(VARSET_CALLBACK(src, icon_state, initial(icon_state)), 5)
