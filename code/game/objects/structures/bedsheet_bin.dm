/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "простыня"
	desc = "Удивительно мягкая льнаная простыня."
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	inhand_icon_state = "sheetwhite"
	slot_flags = ITEM_SLOT_NECK
	layer = MOB_LAYER
	plane = GAME_PLANE_FOV_HIDDEN
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET

	var/list/dream_messages = list("white")

/obj/item/bedsheet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/surgery_initiator)
	AddElement(/datum/element/bed_tuckable, 0, 0, 0)

/obj/item/bedsheet/attack_self(mob/user)
	if(!user.CanReach(src))		//No telekenetic grabbing.
		return
	if(!user.dropItemToGround(src))
		return
	if(layer == initial(layer))
		layer = ABOVE_MOB_LAYER
		to_chat(user, span_notice("Накрываю себя [src]."))
		pixel_x = 0
		pixel_y = 0
	else
		layer = initial(layer)
		to_chat(user, span_notice("Расстелаю [src] под собой."))
	add_fingerprint(user)
	return

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	inhand_icon_state = "sheetblue"
	dream_messages = list("синий")

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	inhand_icon_state = "sheetgreen"
	dream_messages = list("зеленый")

/obj/item/bedsheet/grey
	icon_state = "sheetgrey"
	inhand_icon_state = "sheetgrey"
	dream_messages = list("серый")

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	inhand_icon_state = "sheetorange"
	dream_messages = list("оранжевый")

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	inhand_icon_state = "sheetpurple"
	dream_messages = list("пурпурный")

/obj/item/bedsheet/patriot
	name = "патриотическая простыня"
	desc = "Спя на ней вы понимаете, что в жизни не ощущали большей свободы."
	icon_state = "sheetUSA"
	inhand_icon_state = "sheetUSA"
	dream_messages = list("Америка", "свобода", "фейерверки", "лысые орлы")

/obj/item/bedsheet/rainbow
	name = "радужная простыня"
	desc = "Разноцветная простыня. На самом деле это просто куча обрезков разных простыней, которые потом были сшиты вместе."
	icon_state = "sheetrainbow"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("красный", "оранжевый", "желтый", "зеленый", "синий", "пурпурный", "радуга")

/obj/item/bedsheet/red
	icon_state = "sheetred"
	inhand_icon_state = "sheetred"
	dream_messages = list("красный")

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	inhand_icon_state = "sheetyellow"
	dream_messages = list("желтый")

/obj/item/bedsheet/mime
	name = "одеяло мима"
	desc = "Успокаивающее полосатое одеяло. Складывается ощущение, что весь шум исчезает, когда ты им накрываешься."
	icon_state = "sheetmime"
	inhand_icon_state = "sheetmime"
	dream_messages = list("тишина", "жесты", "бледное лицо", "разинутый рот", "мим")

/obj/item/bedsheet/clown
	name = "одеяло клоуна"
	desc = "Радужное одеяло с вышитой на нём маской клоуна. Источает слабый запах бананов."
	icon_state = "sheetclown"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("хонк", "смех", "пранк", "шутка", "улыбающееся лицо", "клоун")

/obj/item/bedsheet/captain
	name = "одеяло капитана"
	desc = "На нем виднеется символ NanoTrasen, само одеяло вышито из инновационной ткани, имеющей гарантированную проницаемость в 0.01% для большинства нехимических веществ, популярных у современных капитанов."
	icon_state = "sheetcaptain"
	inhand_icon_state = "sheetcaptain"
	dream_messages = list("власть", "золотая ID-карта", "солнечные очки", "зеленый диск", "старинный пистолет", "капитан")

/obj/item/bedsheet/rd
	name = "простыня руководителя исследований"
	desc = "Простыня, с вышитой на ней эмблемой химического стакана. Похоже, что простыня сделана из огнестойкого материала, что, вероятно, не защитит вас в случае очередного пожара."
	icon_state = "sheetrd"
	inhand_icon_state = "sheetrd"
	dream_messages = list("власть", "серебряная ID-карта", "бомба", "мех", "лицехват", "маниакальный смех", "руководитель исследований")

// for Free Golems.
/obj/item/bedsheet/rd/royal_cape
	name = "Королевский Плащ Освободителя"
	desc = "Величественный."
	dream_messages = list("добыча ископаемых", "камень", "голем", "свобода", "делать всё что угодно")

/obj/item/bedsheet/medical
	name = "медицинское одеяло"
	desc = "Это стерилизованное* одеяло, обычно используемое в МедОтсеке.  *В случае нахождения на борту станции Вирусолога стерильность обнуляется."
	icon_state = "sheetmedical"
	inhand_icon_state = "sheetmedical"
	dream_messages = list("лечение", "жизнь", "операция", "доктор")

/obj/item/bedsheet/cmo
	name = "одеяло главврача"
	desc = "Стерилизованная простыня с крестом. На ней немного кошачьей шерсти, вероятно, оставленной Рантайм."
	icon_state = "sheetcmo"
	inhand_icon_state = "sheetcmo"
	dream_messages = list("власть", "серебряная ID-карта", "лечение", "жизнь", "операция", "кот", "главный врач")

/obj/item/bedsheet/hos
	name = "простыня главы службы безопасности"
	desc = "Простыня, украшенная эмблемой щита. И пусть преступность никогда не спит, в отличии от вас, но во сне вы всё еще ЗАКОН!"
	icon_state = "sheethos"
	inhand_icon_state = "sheethos"
	dream_messages = list("власть", "серебряная ID-карта", "наручники", "дубинка", "светошумовая", "солнечные очки", "глава службы безопасности")

/obj/item/bedsheet/hop
	name = "простыня главы персонала"
	desc = "Украшена эмблемой ключа. Для редких моментов когда никто не орет на вас по радио и вы можете отдохнуть и пообниматься с Йаном."
	icon_state = "sheethop"
	inhand_icon_state = "sheethop"
	dream_messages = list("власть", "серебряная ID-карта", "обязательства", "компьютер", "ID", "корги", "глава персонала")

/obj/item/bedsheet/ce
	name = "простыня главного инженера"
	desc = "Украшена эмблемой гаечного ключа. Обладает высокой отражающей способностью и устойчивостью к пятнам, так что вам не нужно переживать о том чтобы не заляпать её маслом."
	icon_state = "sheetce"
	inhand_icon_state = "sheetce"
	dream_messages = list("authority", "a silvery ID", "the engine", "power tools", "an APC", "a parrot", "the chief engineer")

/obj/item/bedsheet/qm
	name = "простыня квартирмейстера"
	desc = "Украшена эмблемой ящика на серебряной подкладке. Довольно жесткая, на неё просто можно лечь после тяжелого дня бюрократической возни."
	icon_state = "sheetqm"
	inhand_icon_state = "sheetqm"
	dream_messages = list("серая ID-карта", "шаттл", "ящик", "лень", "квартирмейстер")

/obj/item/bedsheet/chaplain
	name = "простыня капеллана"
	desc = "Простыня, сотканная из сердец самих богов... А, нет, погодите, это просто лён."
	icon_state = "sheetchap"
	inhand_icon_state = "sheetchap"
	dream_messages = list("зеленая ID-карта", "боги", "услышанная молитва", "культ", "капеллан")

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	inhand_icon_state = "sheetbrown"
	dream_messages = list("коричневый")

/obj/item/bedsheet/black
	icon_state = "sheetblack"
	inhand_icon_state = "sheetblack"
	dream_messages = list("черный")

/obj/item/bedsheet/centcom
	name = "простыня ЦентКома"
	desc = "Выткана из улучшенной нанонити, сохраняющей тепло, хорошо украшена, что крайне необходимо для всех официальных лиц."
	icon_state = "sheetcentcom"
	inhand_icon_state = "sheetcentcom"
	dream_messages = list("уникальная ID-карта", "власть", "артилерия", "завершение")

/obj/item/bedsheet/syndie
	name = "простыня синдиката"
	desc = "На ней вышита эмблема синдиката, а сама простыня источает ауру зла."
	icon_state = "sheetsyndie"
	inhand_icon_state = "sheetsyndie"
	dream_messages = list("зеленый диск", "красный кристалл", "светящийся меч", "перепаянная ID-карта")

/obj/item/bedsheet/cult
	name = "простыня культиста"
	desc = "Если вы будете спать на ней, то вам может присниться Нар'Си. Простыня выглядит довольно изодранной и светится от зловещего присутствия."
	icon_state = "sheetcult"
	inhand_icon_state = "sheetcult"
	dream_messages = list("том", "парящий красный кристалл", "светящийся меч", "кровавый символ", "большая гуманоидная фигура")

/obj/item/bedsheet/wiz
	name = "простыня волшебника"
	desc = "Особая зачарованная магией ткань, всё ради того чтобы вы могли провести волшебную ночь. Она даже светится!"
	icon_state = "sheetwiz"
	inhand_icon_state = "sheetwiz"
	dream_messages = list("книга", "взрыв", "молния", "посох", "скелет", "роба", "магия")

/obj/item/bedsheet/nanotrasen
	name = "Простыня NanoTrasen"
	desc = "На ней логотип NanoTrasen и она излучает ауру обязанностей."
	icon_state = "sheetNT"
	inhand_icon_state = "sheetNT"
	dream_messages = list("власть", "завершение")

/obj/item/bedsheet/ian
	icon_state = "sheetian"
	inhand_icon_state = "sheetian"
	dream_messages = list("пес", "корги", "вуф", "гаф", "аф")

/obj/item/bedsheet/cosmos
	name = "простыня космического пространства"
	desc = "Соткана из мечт тех, кто грезит о звездах."
	icon_state = "sheetcosmos"
	inhand_icon_state = "sheetcosmos"
	dream_messages = list("бесконечный космос", "Музыка Ханса Цимерра", "космические полеты", "галактика", "невозможное", "падающие звезды")
	light_power = 2
	light_range = 1.4

/obj/item/bedsheet/random
	icon_state = "random_bedsheet"
	name = "random bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"
	slot_flags = null

/obj/item/bedsheet/random/Initialize()
	..()
	var/type = pick(typesof(/obj/item/bedsheet) - /obj/item/bedsheet/random)
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/bedsheet/dorms
	icon_state = "random_bedsheet"
	name = "random dorms bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"
	slot_flags = null

/obj/item/bedsheet/dorms/Initialize()
	..()
	var/type = pickweight(list("Colors" = 80, "Special" = 20))
	switch(type)
		if("Colors")
			type = pick(list(/obj/item/bedsheet,
				/obj/item/bedsheet/blue,
				/obj/item/bedsheet/green,
				/obj/item/bedsheet/grey,
				/obj/item/bedsheet/orange,
				/obj/item/bedsheet/purple,
				/obj/item/bedsheet/red,
				/obj/item/bedsheet/yellow,
				/obj/item/bedsheet/brown,
				/obj/item/bedsheet/black))
		if("Special")
			type = pick(list(/obj/item/bedsheet/patriot,
				/obj/item/bedsheet/rainbow,
				/obj/item/bedsheet/ian,
				/obj/item/bedsheet/cosmos,
				/obj/item/bedsheet/nanotrasen))
	new type(loc)
	return INITIALIZE_HINT_QDEL
