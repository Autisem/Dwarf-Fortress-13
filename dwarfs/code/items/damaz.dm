/obj/item/damaz
	name = "Damaz Kron"
	desc = "A book of grudges."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "damaz"
	var/list/entries = list()

/obj/item/damaz/proc/load_entries()
	var/savefile/S = new("data/damaz_entries.sav")
	S["ENTRIES"] >> entries
	if(!islist(entries))
		entries = list()

/obj/item/damaz/proc/save_entries()
	var/savefile/S = new("data/damaz_entries.sav")
	S["ENTRIES"] << entries

/obj/item/damaz/Initialize()
	. = ..()
	load_entries()

/obj/item/damaz/proc/can_use(mob/user) // for altar
	var/allowed = isdwarf(user)
	if(!allowed)
		to_chat(user, span_warning("Thy are not worthy!"))
	return allowed

/obj/item/damaz/ui_act(action, list/params)
	. = ..()
	//basically just add entry
	var/new_entry = input(usr, "Enter new entry", "New entry") as text|null
	if(!new_entry)
		return
	entries += list(list("content"=new_entry, "author"=usr.name, "fortress"=GLOB.station_name))
	save_entries()

/obj/item/damaz/ui_data(mob/user)
	var/list/data = list()
	var/mob/current_king
	for(var/obj/item/clothing/head/helmet/dwarf_crown/C in GLOB.dwarf_crowns)
		if(C.assigned_count)
			current_king = C.assigned_count
	data["king"] = (user == current_king)
	data["entries"] = entries
	return data

/obj/item/damaz/ui_interact(mob/user, datum/tgui/ui)
	if(!ishuman(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Damaz")
		ui.open()
