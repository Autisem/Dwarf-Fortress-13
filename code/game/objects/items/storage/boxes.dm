/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *		Action Figure Boxes
 *		Various paper bags.
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/storage/box
	name = "коробка"
	desc = "Это просто обычная коробка."
	icon_state = "box"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/cardboardbox_drop.ogg'
	pickup_sound =  'sound/items/handling/cardboardbox_pickup.ogg'
	var/foldable = /obj/item/stack/sheet/cardboard
	var/illustration = "writing"

/obj/item/storage/box/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/box/suicide_act(mob/living/carbon/user)
	var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
	if(myhead)
		inc_metabalance(user, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить и за это тоже, сладенький.")
		user.visible_message(span_suicide("[user] puts [user.ru_ego()] head into <b>[src.name]</b>, and begins closing it! It looks like [user.p_theyre()] trying to commit suicide!"))
		myhead.dismember()
		myhead.forceMove(src)//force your enemies to kill themselves with your head collection box!
		playsound(user, "desecration-01.ogg", 50, TRUE, -1)
		return BRUTELOSS
	user.visible_message(span_suicide("[user] beating [user.ru_na()]self with <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/storage/box/update_overlays()
	. = ..()
	if(illustration)
		. += illustration

/obj/item/storage/box/attack_self(mob/user)
	..()

	if(!foldable || (flags_1 & HOLOGRAM_1))
		return
	if(contents.len)
		to_chat(user, span_warning("Не могу сложить коробку с предметами внутри!"))
		return
	if(!ispath(foldable))
		return

	to_chat(user, span_notice("Складываю [src]."))
	var/obj/item/I = new foldable
	qdel(src)
	user.put_in_hands(I)

/obj/item/storage/box/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/package_wrap))
		return FALSE
	return ..()

//Mime spell boxes

/obj/item/storage/box/mime
	name = "невидимая коробка"
	desc = "К сожалению, недостаточно большая, чтобы поймать мима."
	foldable = null
	icon_state = "box"
	inhand_icon_state = null
	alpha = 0

/obj/item/storage/box/mime/attack_hand(mob/user)
	..()
	if(user.mind.miming)
		alpha = 255

/obj/item/storage/box/mime/Moved(oldLoc, dir)
	if (iscarbon(oldLoc))
		alpha = 0
	return ..()

/obj/item/storage/box/gloves
	name = "коробка латексных перчаток"
	desc = "Содержит стерильные латексные перчатки."
	illustration = "latex"

/obj/item/storage/box/gloves/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/gloves/color/latex(src)

/obj/item/storage/box/masks
	name = "коробка стерильных масок"
	desc = "В этой коробке находятся стерильные медицинские маски."
	illustration = "sterile"

/obj/item/storage/box/masks/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/mask/surgical(src)

/obj/item/storage/box/syringes
	name = "коробка шприцев"
	desc = "Коробка со шприцами."
	illustration = "syringe"

/obj/item/storage/box/syringes/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/syringe(src)

/obj/item/storage/box/syringes/variety
	name = "коробка разнообразных шприцов"

/obj/item/storage/box/syringes/variety/PopulateContents()
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/syringe/lethal(src)
	new /obj/item/reagent_containers/syringe/piercing(src)
	new /obj/item/reagent_containers/syringe/bluespace(src)

/obj/item/storage/box/medipens
	name = "коробка МедиПенов"
	desc = "Коробка, полная адреналином МедиПенов."
	illustration = "epipen"

/obj/item/storage/box/medipens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/hypospray/medipen(src)

/obj/item/storage/box/medipens/utility
	name = "набор стимуляторов"
	desc = "Коробка с несколькими стимуляторами для экономичного майнера."
	illustration = "epipen"

/obj/item/storage/box/medipens/utility/PopulateContents()
	..() // includes regular medipens.
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/hypospray/medipen/stimpack(src)

/obj/item/storage/box/beakers
	name = "коробка химических стаканов"
	illustration = "beaker"

/obj/item/storage/box/beakers/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/glass/beaker( src )

/obj/item/storage/box/beakers/bluespace
	name = "коробка блюспейс химических стаканов"
	illustration = "beaker"

/obj/item/storage/box/beakers/bluespace/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/glass/beaker/bluespace(src)

/obj/item/storage/box/beakers/variety
	name = "коробка различных химических стаканов"

/obj/item/storage/box/beakers/variety/PopulateContents()
	new /obj/item/reagent_containers/glass/beaker(src)
	new /obj/item/reagent_containers/glass/beaker/large(src)
	new /obj/item/reagent_containers/glass/beaker/plastic(src)
	new /obj/item/reagent_containers/glass/beaker/meta(src)
	new /obj/item/reagent_containers/glass/beaker/noreact(src)
	new /obj/item/reagent_containers/glass/beaker/bluespace(src)

/obj/item/storage/box/medigels
	name = "коробка медицинских гелей"
	desc = "Коробка, полная аппликаторов медицинского геля с отвинчиваемыми крышками и точными распылительными головками."
	illustration = "medgel"

/obj/item/storage/box/medigels/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/medigel( src )

/obj/item/storage/box/bodybags
	name = "сумки для тела"
	desc = "На этикетке указано, что он содержит мешки для тела."
	illustration = "bodybags"

/obj/item/storage/box/bodybags/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/bodybag(src)

/obj/item/storage/box/rxglasses
	name = "коробка очков по рецепту"
	desc = "В этой коробке находятся очки для ботаников."
	illustration = "glasses"

/obj/item/storage/box/rxglasses/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/glasses/regular(src)

/obj/item/storage/box/drinkingglasses
	name = "коробка стаканов"
	desc = "На ней изображены стаканы."
	illustration = "drinkglass"

/obj/item/storage/box/drinkingglasses/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/drinks/drinkingglass(src)

/obj/item/storage/box/condimentbottles
	name = "коробка бутылок для приправ"
	desc = "На нем большой мазок кетчупа."
	illustration = "condiment"

/obj/item/storage/box/condimentbottles/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/condiment(src)

/obj/item/storage/box/cups
	name = "коробка бумажных стаканчиков"
	desc = "На лицевой стороне изображены бумажные стаканчики."
	illustration = "cup"

/obj/item/storage/box/cups/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/food/drinks/sillycup( src )

/obj/item/storage/box/donkpockets
	name = "коробка донк-покетов"
	desc = "<B>Инструкция:</B><I>Нагрейте в микроволновой печи. Продукт остынет, если его не съесть в течение семи минут.</I>"
	icon_state = "donkpocketbox"
	illustration=null
	var/donktype = /obj/item/food/donkpocket

/obj/item/storage/box/donkpockets/PopulateContents()
	for(var/i in 1 to 6)
		new donktype(src)

/obj/item/storage/box/donkpockets/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.set_holdable(list(/obj/item/food/donkpocket))

/obj/item/storage/box/donkpockets/donkpocketspicy
	name = "коробка донк-покетов с пряным вкусом"
	icon_state = "donkpocketboxspicy"
	donktype = /obj/item/food/donkpocket/spicy

/obj/item/storage/box/donkpockets/donkpocketteriyaki
	name = "коробка донк-покетов со вкусом терияки"
	icon_state = "donkpocketboxteriyaki"
	donktype = /obj/item/food/donkpocket/teriyaki

/obj/item/storage/box/donkpockets/donkpocketpizza
	name = "коробка донк-покетов со вкусом пиццы"
	icon_state = "donkpocketboxpizza"
	donktype = /obj/item/food/donkpocket/pizza

/obj/item/storage/box/donkpockets/donkpocketgondola
	name = "коробка донк-покетов со вкусом гондолы"
	icon_state = "donkpocketboxgondola"
	donktype = /obj/item/food/donkpocket/gondola

/obj/item/storage/box/donkpockets/donkpocketberry
	name = "коробка донк-покетов со вкусом ягод"
	icon_state = "donkpocketboxberry"
	donktype = /obj/item/food/donkpocket/berry

/obj/item/storage/box/donkpockets/donkpockethonk
	name = "коробка донк-покетов со вкусом банана"
	icon_state = "donkpocketboxbanana"
	donktype = /obj/item/food/donkpocket/honk

/obj/item/storage/box/monkeycubes
	name = "коробка кубиков с обезьянами"
	desc = "Кубики обезьяны бренда Drymate. Просто добавь воды!"
	icon_state = "monkeycubebox"
	illustration = null
	var/cube_type = /obj/item/food/monkeycube

/obj/item/storage/box/monkeycubes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7
	STR.set_holdable(list(/obj/item/food/monkeycube))

/obj/item/storage/box/monkeycubes/PopulateContents()
	for(var/i in 1 to 5)
		new cube_type(src)

/obj/item/storage/box/monkeycubes/syndicate
	desc = "Обезьяньи кубики марки Waffle Co. Просто добавьте воды и немного уловок!"
	cube_type = /obj/item/food/monkeycube/syndicate

/obj/item/storage/box/gorillacubes
	name = "коробка куба гориллы"
	desc = "Кубики гориллы бренда Waffle Co. Не насмехайтесь."
	icon_state = "monkeycubebox"
	illustration = null

/obj/item/storage/box/gorillacubes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.set_holdable(list(/obj/item/food/monkeycube))

/obj/item/storage/box/gorillacubes/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/food/monkeycube/gorilla(src)

/obj/item/storage/box/firingpins
	name = "ящик штатных бойков"
	desc = "Коробка со стандартными бойками для стрельбы из нового огнестрельного оружия."
	icon_state = "secbox"
	illustration = "firingpin"

/obj/item/storage/box/firingpins/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin(src)

/obj/item/storage/box/lasertagpins
	name = "ящик  бойков для лазертага"
	desc = "Коробка, полная бойков для лазертага, чтобы новое огнестрельное оружие требовало ношения яркой пластиковой брони, прежде чем его можно будет использовать."
	illustration = "firingpin"

/obj/item/storage/box/lasertagpins/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/firing_pin/tag/red(src)
		new /obj/item/firing_pin/tag/blue(src)

/obj/item/storage/box/handcuffs
	name = "коробка запасных наручников"
	desc = "коробка запасных наручников."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/handcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs(src)

/obj/item/storage/box/zipties
	name = "коробка запасных стяжек"
	desc = "коробка запасных стяжек."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/zipties/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/cable/zipties(src)

/obj/item/storage/box/alienhandcuffs
	name = "коробка запасных наручников"
	desc = "коробка запасных наручников."
	icon_state = "alienbox"
	illustration = "handcuff"

/obj/item/storage/box/alienhandcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new	/obj/item/restraints/handcuffs/alien(src)

/obj/item/storage/box/fakesyndiesuit
	name = "упакованные скафандр и шлем"
	desc = "Гладкая и прочная коробка, в которой хранятся копии скафандров."
	icon_state = "syndiebox"
	illustration = "syndiesuit"

/obj/item/storage/box/fakesyndiesuit/PopulateContents()
	new /obj/item/clothing/head/syndicatefake(src)
	new /obj/item/clothing/suit/syndicatefake(src)

/obj/item/storage/box/mousetraps
	name = "коробка мышеловок Pest-B-Gon"
	desc = span_alert("Храните в недоступном для детей месте.")
	illustration = "mousetrap"

/obj/item/storage/box/mousetraps/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/mousetrap(src)

/obj/item/storage/box/pillbottles
	name = "коробка пузырьков с таблетками"
	desc = "На передней панели изображены пузырьки с таблетками."
	illustration = "pillbox"

/obj/item/storage/box/pillbottles/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/storage/pill_bottle(src)

/obj/item/storage/box/matches
	name = "спичечный коробок"
	desc = "Маленькая коробочка почти, но не совсем плазменных премиальных спичек."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	inhand_icon_state = "zippo"
	worn_icon_state = "lighter"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	drop_sound = 'sound/items/handling/matchbox_drop.ogg'
	pickup_sound =  'sound/items/handling/matchbox_pickup.ogg'
	custom_price = PAYCHECK_ASSISTANT * 0.4
	illustration = null

/obj/item/storage/box/matches/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.set_holdable(list(/obj/item/match))

/obj/item/storage/box/matches/PopulateContents()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_FILL_TYPE, /obj/item/match)

/obj/item/storage/box/matches/attackby(obj/item/match/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/match))
		W.matchignite()

/obj/item/storage/box/lights
	name = "коробка сменных лампочек"
	icon = 'icons/obj/storage.dmi'
	illustration = "light"
	desc = "Эта коробка имеет такую форму, что туда вмещаются только лампочки и лампы накаливания."
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap

/obj/item/storage/box/lights/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 21
	STR.set_holdable(list(/obj/item/light/tube, /obj/item/light/bulb))
	STR.max_combined_w_class = 21
	STR.click_gather = FALSE //temp workaround to re-enable filling the light replacer with the box

/obj/item/storage/box/lights/bulbs/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/item/light/bulb(src)

/obj/item/storage/box/lights/tubes
	name = "коробка сменных трубок"
	illustration = "lighttube"

/obj/item/storage/box/lights/tubes/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/item/light/tube(src)

/obj/item/storage/box/lights/mixed
	name = "коробка сменных ламп"
	illustration = "lightmixed"

/obj/item/storage/box/lights/mixed/PopulateContents()
	for(var/i in 1 to 14)
		new /obj/item/light/tube(src)
	for(var/i in 1 to 7)
		new /obj/item/light/bulb(src)


/obj/item/storage/box/deputy
	name = "коробка с повязками Службы Безопасности"
	desc = "Выдается лицам, уполномоченным действовать в качестве работника службы безопасности."
	icon_state = "secbox"
	illustration = "depband"

/obj/item/storage/box/deputy/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/accessory/armband/deputy(src)

/obj/item/storage/box/hug
	name = "коробка объятий"
	desc = "Специальная коробка для чувствительных людей."
	gender = FEMALE
	icon_state = "hugbox"
	illustration = "heart"
	foldable = null

/obj/item/storage/box/hug/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] clamps the box of hugs on [user.ru_ego()] jugular! Guess it wasn't such a hugbox after all.."))
	return (BRUTELOSS)

/obj/item/storage/box/hug/attack_self(mob/user)
	..()
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, "rustle", 50, TRUE, -5)
	user.visible_message(span_notice("[user] обнимает <b>[skloname(name, VINITELNI, gender)]</b>.") ,span_notice("Обнимаю <b>[skloname(name, VINITELNI, gender)]</b>."))

/obj/item/storage/box/rubbershot
	name = "коробка с резиновой дробью"
	desc = "Коробка с резиновой дробью 12 калибра, предназначенная для дробовиков."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/rubbershot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/rubbershot(src)

/obj/item/storage/box/lethalshot
	name = "коробка с дробью"
	desc = "Коробка с патронами 12 калибра с дробью."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/lethalshot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/box/beanbag
	name = "коробка с резиновыми пулями"
	desc = "Коробка с травматическими пулями 12 калибра, предназначенная для дробовиков."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/beanbag/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/storage/box/papersack
	name = "бумажный мешок"
	desc = "Мешочек, аккуратно сделанный из бумаги."
	icon_state = "paperbag_None"
	inhand_icon_state = "paperbag_None"
	illustration = null
	resistance_flags = FLAMMABLE
	foldable = null
	/// A list of all available papersack reskins
	var/list/papersack_designs = list()

/obj/item/storage/box/papersack/Initialize(mapload)
	. = ..()
	papersack_designs = sort_list(list(
		"None" = image(icon = src.icon, icon_state = "paperbag_None"),
		"NanotrasenStandard" = image(icon = src.icon, icon_state = "paperbag_NanotrasenStandard"),
		"SyndiSnacks" = image(icon = src.icon, icon_state = "paperbag_SyndiSnacks"),
		"Heart" = image(icon = src.icon, icon_state = "paperbag_Heart"),
		"SmileyFace" = image(icon = src.icon, icon_state = "paperbag_SmileyFace")
		))

/obj/item/storage/box/papersack/update_icon_state()
	if(contents.len == 0)
		icon_state = "[inhand_icon_state]"
	else
		icon_state = "[inhand_icon_state]_closed"

/obj/item/storage/box/papersack/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		var/choice = show_radial_menu(user, src , papersack_designs, custom_check = CALLBACK(src, .proc/check_menu, user, W), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		if(icon_state == "paperbag_[choice]")
			return FALSE
		switch(choice)
			if("None")
				desc = "Мешок, аккуратно сделанный из бумаги."
			if("NanotrasenStandard")
				desc = "Стандартный бумажный обеденный мешок NanoTrasen для лояльных сотрудников в дороге."
			if("SyndiSnacks")
				desc = "Дизайн этого бумажного пакета - пережиток печально известной программы СиндиЗакуски.."
			if("Heart")
				desc = "Бумажный мешок с выгравированным на боку сердечком."
			if("SmileyFace")
				desc = "Бумажный мешок с грубой улыбкой на боку."
			else
				return FALSE
		to_chat(user, span_notice("Видоизменяю [src] используя ручку."))
		icon_state = "paperbag_[choice]"
		inhand_icon_state = "paperbag_[choice]"
		return FALSE
	else if(W.get_sharpness())
		if(!contents.len)
			if(inhand_icon_state == "paperbag_None")
				user.show_message(span_notice("Прорезаю дыры для глаз [src].") , MSG_VISUAL)
				new /obj/item/clothing/head/papersack(user.loc)
				qdel(src)
				return FALSE
			else if(inhand_icon_state == "paperbag_SmileyFace")
				user.show_message(span_notice("Прорезаю дыры для глаз в [src] и меняю его дизайн.") , MSG_VISUAL)
				new /obj/item/clothing/head/papersack/smiley(user.loc)
				qdel(src)
				return FALSE
	return ..()

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 * * P The pen used to interact with a menu
 */
/obj/item/storage/box/papersack/proc/check_menu(mob/user, obj/item/pen/P)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(contents.len)
		to_chat(user, span_warning("Не могу изменить [src] с предметами внутри!"))
		return FALSE
	if(!P || !user.is_holding(P))
		to_chat(user, span_warning("Мне понадобится ручка, чтобы изменить [src]!"))
		return FALSE
	return TRUE

/obj/item/storage/box/papersack/meat
	desc = "Он немного влажный и воняет бойней."

/obj/item/storage/box/papersack/meat/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/food/meat/slab(src)

/obj/item/storage/box/emptysandbags
	name = "коробка пустых мешков с песком"
	illustration = "sandbag"

/obj/item/storage/box/emptysandbags/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/emptysandbag(src)

/obj/item/storage/box/silver_sulf
	name = "коробка пластырей сульфадиазина серебра"
	desc = "Содержит пластыри, используемые для лечения ожогов."
	illustration = "firepatch"

/obj/item/storage/box/silver_sulf/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/patch/aiuri(src)

/obj/item/storage/box/fountainpens
	name = "коробка перьевых ручек"
	illustration = "fpen"

/obj/item/storage/box/fountainpens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/pen/fountain(src)

/obj/item/storage/box/stockparts/basic //for ruins where it's a bad idea to give access to an autolathe/protolathe, but still want to make stock parts accessible
	name = "коробка запасных частей"
	desc = "Содержит множество основных запасных частей."

/obj/item/storage/box/stockparts/basic/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/scanning_module = 3,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stock_parts/matter_bin = 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/stockparts/deluxe
	name = "коробка роскошных запасных частей"
	desc = "Содержит множество роскошных запасных частей."
	icon_state = "syndiebox"

/obj/item/storage/box/stockparts/deluxe/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stock_parts/capacitor/quadratic = 3,
		/obj/item/stock_parts/scanning_module/triphasic = 3,
		/obj/item/stock_parts/manipulator/femto = 3,
		/obj/item/stock_parts/micro_laser/quadultra = 3,
		/obj/item/stock_parts/matter_bin/bluespace = 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/dishdrive
	name = "Комплект привода тарелки DIY"
	desc = "Содержит все необходимое, чтобы построить свой собственный Дисковод!" //cringe
	custom_premium_price = PAYCHECK_EASY * 3

/obj/item/storage/box/dishdrive/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stack/sheet/iron/five = 1,
		/obj/item/stack/cable_coil/five = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/screwdriver = 1,
		/obj/item/wrench = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/material
	name = "коробка с материалами"
	illustration = "implant"

/obj/item/storage/box/material/PopulateContents() 	//less uranium because radioactive
	var/static/items_inside = list(
		/obj/item/stack/sheet/iron/fifty=1,\
		/obj/item/stack/sheet/glass/fifty=1,\
		/obj/item/stack/sheet/rglass=50,\
		/obj/item/stack/sheet/plasmaglass=50,\
		/obj/item/stack/sheet/titaniumglass=50,\
		/obj/item/stack/sheet/plastitaniumglass=50,\
		/obj/item/stack/sheet/plasteel=50,\
		/obj/item/stack/sheet/mineral/plastitanium=50,\
		/obj/item/stack/sheet/mineral/titanium=50,\
		/obj/item/stack/sheet/mineral/gold=50,\
		/obj/item/stack/sheet/mineral/silver=50,\
		/obj/item/stack/sheet/mineral/plasma=50,\
		/obj/item/stack/sheet/mineral/uranium=20,\
		/obj/item/stack/sheet/mineral/diamond=50,\
		/obj/item/stack/sheet/bluespace_crystal=50,\
		/obj/item/stack/sheet/mineral/bananium=50,\
		/obj/item/stack/sheet/mineral/wood=50,\
		/obj/item/stack/sheet/plastic/fifty=1,\
		/obj/item/stack/sheet/runed_metal/fifty=1
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/plastic
	name = "пластиковая коробка"
	desc = "Это прочный пластиковый корпус."
	icon_state = "plasticbox"
	foldable = null
	illustration = "writing"
	custom_materials = list(/datum/material/plastic = 1000) //You lose most if recycled.

/obj/item/storage/box/gum
	name = "упаковка жевательной резинки"
	desc = "Видимо, упаковка полностью на японском языке. Вы не можете разобрать ни слова."
	icon_state = "bubblegum_generic"
	w_class = WEIGHT_CLASS_TINY
	illustration = null
	foldable = null
	custom_price = PAYCHECK_EASY

/obj/item/storage/box/gum/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.set_holdable(list(/obj/item/food/chewable/bubblegum))
	STR.max_items = 4

/obj/item/storage/box/gum/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/chewable/bubblegum(src)

/obj/item/storage/box/gum/nicotine
	name = "упаковка никотиновой жевательной резинки"
	desc = "Разработан, чтобы помочь избавиться от никотиновой зависимости и оральной фиксации одновременно, не разрушая при этом ваши легкие. Со вкусом мяты!"
	icon_state = "bubblegum_nicotine"
	custom_premium_price = PAYCHECK_EASY * 1.5

/obj/item/storage/box/gum/nicotine/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/chewable/bubblegum/nicotine(src)

/obj/item/storage/box/gum/happiness
	name = "упаковка резинок HP +"
	desc = "Внешне самодельная упаковка со странным запахом. У него есть странный рисунок улыбающегося лица, высунувшего язык."
	icon_state = "bubblegum_happiness"
	custom_price = PAYCHECK_HARD * 3
	custom_premium_price = PAYCHECK_HARD * 3

/obj/item/storage/box/gum/happiness/Initialize()
	. = ..()
	if (prob(25))
		desc += "Вы можете смутно разобрать слово «Гемопагоприл», которое когда-то было нацарапано на нем."

/obj/item/storage/box/gum/happiness/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/chewable/bubblegum/happiness(src)

/obj/item/storage/box/gum/bubblegum
	name = "упаковка жевательной резинки"
	desc = "Упаковка, по всей видимости, полностью демоническая. Вы чувствуете, что даже открыть это было бы грехом."
	icon_state = "bubblegum_bubblegum"

/obj/item/storage/box/gum/bubblegum/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/chewable/bubblegum/bubblegum(src)
