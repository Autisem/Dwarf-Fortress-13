////////////////////////////////
//
// Donations. Reworked for /tg/ by valtos
//
////////////////////////////////

GLOBAL_LIST_INIT(donations_list, list(
	"Специальное" = list(
		new /datum/donate_info("Bible",						/obj/item/storage/book/bible,					100),
		new /datum/donate_info("Checkers Kit",				/obj/item/checkers_kit,							150),
		new /datum/donate_info("Jukebox",					/obj/machinery/turntable,						100),
		new /datum/donate_info("Boombox",					/obj/item/boombox,								150),
		new /datum/donate_info("Music Writer",				/obj/machinery/musicwriter,						450),
		new /datum/donate_info("TTS ears",					/obj/item/organ/ears/cat/tts,                   500),
		new /datum/donate_info("Glitch Gun",				/obj/item/gun/magic/glitch,						300)
	)
))

/datum/donate_info
	var/name
	var/path_to
	var/cost = 0
	var/special = null
	var/stock = 30

/datum/donate_info/New(name, path, cost, special = null, stock = 30)
	src.name = name
	src.path_to = path
	src.cost = cost
	src.special = special
	src.stock = stock

/client/verb/new_donates_panel()
	set name = "Donator panel"
	set category = "Особенное"


	if(!SSticker || SSticker.current_state < GAME_STATE_PLAYING)
		to_chat(src, span_warning("Не так быстро, игра ещё не началась!"))
		return

	if (!GLOB.donators[ckey]) //If it doesn't exist yet
		load_donator(ckey)

	var/datum/donator/D = GLOB.donators[ckey]
	if(D)
		D.ui_interact(src.mob)
	else
		D = GLOB.donators["FREEBIE"]
		if(!D)
			D = new /datum/donator("FREEBIE", 0)
	D.ui_interact(src.mob)

GLOBAL_LIST_EMPTY(donate_icon_cache)
GLOBAL_LIST_EMPTY(donators)

#define DONATIONS_SPAWN_WINDOW 6000

/datum/donator
	var/ownerkey
	var/money = 0
	var/maxmoney = 0
	var/allowed_num_items = 20
	var/selected_cat
	var/compact_mode = FALSE

/datum/donator/New(ckey, cm)
	..()
	ownerkey = ckey
	money = cm
	maxmoney = cm
	GLOB.donators[ckey] = src

/datum/donator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DonationsMenu", "Панель Благотворца")
		ui.open()

/datum/donator/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/donator/ui_data(mob/user)
	var/list/data = list()
	data["money"] = money
	data["compactMode"] = compact_mode
	return data

/datum/donator/ui_static_data(mob/user)
	var/list/data = list()

	data["categories"] = list()
	for(var/category in GLOB.donations_list)
		var/list/catsan = GLOB.donations_list[category]
		var/list/cat = list(
			"name" = category,
			"items" = (category == selected_cat ? list() : null))
		for(var/item in 1 to catsan.len)
			var/datum/donate_info/I = catsan[item]
			cat["items"] += list(list(
				"name" = I.name,
				"cost" = I.cost,
				"icon" = GetIconForProduct(I),
				"ref" = REF(I),
			))
		data["categories"] += list(cat)

	return data

/datum/donator/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("buy")
			var/datum/donate_info/prize = locate(params["ref"])
			var/mob/living/carbon/human/user = usr

			if(!SSticker || SSticker.current_state < 3)
				to_chat(user,span_warning("Игра ещё не началась!"))
				return FALSE

			if((world.time-SSticker.round_start_time) > DONATIONS_SPAWN_WINDOW)
				to_chat(user,span_warning("Нужно быть в баре."))
				return FALSE

			if(prize.cost > money)
				to_chat(user,span_warning("Недостаточно баланса."))
				return FALSE

			if(!allowed_num_items)
				to_chat(user,span_warning("Достигли максимума. Ура."))
				return FALSE

			if(!user)
				to_chat(user,span_warning("Нужно быть живым."))
				return FALSE

			if(!ispath(prize.path_to))
				return FALSE

			if(user.stat)
				return FALSE

			if(prize.stock <= 0)
				to_chat(user,span_warning("Поставки <b>[prize.name]</b> закончились."))
				return FALSE

			if(prize.special)
				if (prize.special != user.ckey)
					to_chat(user,span_warning("Этот предмет предназначен для <b>[prize.special]</b>."))
					return FALSE

			prize.stock--

			podspawn(list(
				"target" = get_turf(user),
				"path" = /obj/structure/closet/supplypod/box,
				"spawn" = prize.path_to
			))

			to_chat(user, span_info("[capitalize(prize.name)] был создан!"))

			money -= prize.cost
			allowed_num_items--
			return TRUE
		if("select")
			selected_cat = params["category"]
			return TRUE
		if("compact_toggle")
			compact_mode = !compact_mode
			return TRUE

/datum/donator/proc/GetIconForProduct(datum/donate_info/P)
	if(GLOB.donate_icon_cache[P.path_to])
		return GLOB.donate_icon_cache[P.path_to]
	GLOB.donate_icon_cache[P.path_to] = icon2base64(getFlatIcon(path2image(P.path_to), no_anim = TRUE))
	return GLOB.donate_icon_cache[P.path_to]

GLOBAL_VAR_INIT(ohshitfuck, FALSE)

/proc/load_donator(ckey)
	if(!SSdbcore.IsConnected())
		return FALSE

	if(GLOB.ohshitfuck)
		new /datum/donator(ckey, 50000)
		return TRUE

	var/datum/db_query/query_donators = SSdbcore.NewQuery("SELECT round(sum) FROM donations WHERE byond=:ckey", list("ckey" = ckey))
	query_donators.Execute()
	while(query_donators.NextRow())
		var/money = round(text2num(query_donators.item[1]))
		new /datum/donator(ckey, money)
	qdel(query_donators)
	return TRUE

/proc/check_donations(ckey)
	if (!GLOB.donators[ckey]) //If it doesn't exist yet
		return FALSE
	var/datum/donator/D = GLOB.donators[ckey]
	if(D)
		return D.maxmoney
	return FALSE

/proc/get_donator(ckey)
	if (!GLOB.donators[ckey])
		return FALSE
	var/datum/donator/D = GLOB.donators[ckey]
	if(D)
		return D
	return null

/client/proc/manage_some_donations()
	set name = "Manage Some Donations"
	set category = "Дбг"

	if(!check_rights_for(src, R_SECURED))
		return

	var/which_one = tgui_input_list(src, "ОООХ", "ОБОЖАЮ ЧЛЕН В ЖОПЕ ПО УТРАМ", list("furfag", "tailfag"))
	var/list/lte_nuclear_war = list()

	if(which_one == "furfag")
		lte_nuclear_war = GLOB.custom_race_donations
	else if (which_one == "tailfag")
		lte_nuclear_war = GLOB.custom_tails_donations
	else
		return

	var/fuckoboingo = tgui_input_list(src, "HOLY", "RETARD", sort_list(lte_nuclear_war)|"ADD SOMEONE")

	if(!fuckoboingo)
		return

	if(fuckoboingo == "ADD SOMEONE")
		var/motherlover = input(src, "Separator is - | Sample: ckey-race", "some big ass")

		if(!motherlover)
			return

		var/list/fucktorio = splittext_char(motherlover, "-")

		if(length(fucktorio?[1]) && length(fucktorio?[2]))
			LAZYADDASSOCLIST(lte_nuclear_war, ckey(fucktorio[1]), fucktorio[2])
			message_admins("[key_name_admin(src)] открывает [fucktorio[1]] доступ к [fucktorio[2]].")
		return
	else
		var/list/temp_list = list()
		for(var/fucker in lte_nuclear_war)
			if(fucker != fuckoboingo)
				continue
			temp_list += lte_nuclear_war[fucker]
		var/fuckate = tgui_input_list(src, "AHH", "DIGGER", sort_list(temp_list))
		if(!fuckate)
			return
		LAZYREMOVEASSOC(lte_nuclear_war, fuckoboingo, fuckate)
		message_admins("[key_name_admin(src)] удаляет у [fuckoboingo] доступ к [fuckate].")

	if(which_one == "furfag")
		GLOB.custom_race_donations = lte_nuclear_war
		save_races_donations()
	else if (which_one == "tailfag")
		GLOB.custom_tails_donations = lte_nuclear_war
		save_tails_donations()
	return

/proc/load_race_donations()
	var/json_file = file("data/donations/race.json")
	if(!fexists(json_file))
		return
	return json_decode(file2text(json_file))

/proc/load_tails_donations()
	var/json_file = file("data/donations/tails.json")
	if(!fexists(json_file))
		return
	return json_decode(file2text(json_file))

/proc/save_races_donations()
	if(IsAdminAdvancedProcCall())
		message_admins("[key_name_admin(usr)] сосёт хуй и лижет яйца.")
		return

	var/json_file = file("data/donations/race.json")

	fdel(json_file)

	WRITE_FILE(json_file, json_encode(GLOB.custom_race_donations))

/proc/save_tails_donations()
	if(IsAdminAdvancedProcCall())
		message_admins("[key_name_admin(usr)] сосёт хуй и лижет яйца.")
		return

	var/json_file = file("data/donations/tails.json")

	fdel(json_file)

	WRITE_FILE(json_file, json_encode(GLOB.custom_tails_donations))

GLOBAL_LIST_INIT(custom_race_donations,  load_race_donations())
GLOBAL_LIST_INIT(custom_tails_donations, load_tails_donations())
