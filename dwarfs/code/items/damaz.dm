/obj/item/damaz
	name = "Damaz Kron"
	desc = "A book of grudges."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "damaz"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'

/obj/item/damaz/proc/can_use(mob/user) // for altar
	var/allowed = isdwarf(user)
	if(!allowed)
		to_chat(user, span_warning("Thy are not worthy!"))
	return allowed

/obj/item/damaz/ui_act(action, list/params)
	. = ..()
	switch(action)
		if("add_entry")
			var/new_entry = input(usr, "Enter new entry", "New entry") as text|null
			if(!new_entry)
				return
			GLOB.damaz_entries += list(list("content"=new_entry, "author"=usr.name, "fortress"=GLOB.station_name))
		if("remove_entry")
			var/index = text2num(params["entry"])+1
			GLOB.damaz_entries[index] = "to_remove"
			GLOB.damaz_entries.Remove("to_remove")

/obj/item/damaz/ui_data(mob/user)
	var/list/data = list()
	var/mob/current_king
	for(var/obj/item/clothing/head/helmet/dwarf_crown/C in GLOB.dwarf_crowns)
		if(C.assigned_count)
			current_king = C.assigned_count
	data["king"] = (user == current_king)
	data["entries"] = GLOB.damaz_entries
	data["admin"] = user.client.holder
	return data

/obj/item/damaz/ui_interact(mob/user, datum/tgui/ui)
	if(!ishuman(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Damaz")
		ui.open()
