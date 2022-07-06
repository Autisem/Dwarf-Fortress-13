/obj/item/stack/sheet/animalhide
	name = "кожа"
	desc = "Что-то пошло не так."
	icon_state = "sheet-hide"
	inhand_icon_state = "sheet-hide"
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/animalhide
	var/damaged_type

/obj/item/stack/sheet/animalhide/human
	name = "человеческая кожа"
	desc = "Побочный продукт человеческого происхождения... Мудак?"
	singular_name = "кусок человеческой кожи"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/animalhide/human

GLOBAL_LIST_INIT(human_recipes, list())

/obj/item/stack/sheet/animalhide/human/get_main_recipes()
	. = ..()
	. += GLOB.human_recipes

/obj/item/stack/sheet/animalhide/generic
	name = "кожа"
	desc = "Кусочек кожи."
	singular_name = "кусочек кожи"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/animalhide/generic

/obj/item/stack/sheet/animalhide/corgi
	name = "шкура корги"
	desc = "Побочный продукт выращивания корги."
	singular_name = "кусочек кожи корги"
	icon_state = "sheet-corgi"
	inhand_icon_state = "sheet-corgi"
	merge_type = /obj/item/stack/sheet/animalhide/corgi

GLOBAL_LIST_INIT(gondola_recipes, list ())

/obj/item/stack/sheet/animalhide/gondola
	name = "шкура гондолы"
	desc = "Чрезвычайно ценный продукт охоты на гондол."
	singular_name = "кусочек шкуры гондолы"
	icon_state = "sheet-gondola"
	inhand_icon_state = "sheet-gondola"
	merge_type = /obj/item/stack/sheet/animalhide/gondola

/obj/item/stack/sheet/animalhide/gondola/get_main_recipes()
	. = ..()
	. += GLOB.gondola_recipes

GLOBAL_LIST_INIT(corgi_recipes, list ())

/obj/item/stack/sheet/animalhide/corgi/get_main_recipes()
	. = ..()
	. += GLOB.corgi_recipes

/obj/item/stack/sheet/animalhide/cat
	name = "кошачья шкура"
	desc = "Побочный продукт разведения кошек."
	singular_name = "кусок шкуры кошки"
	icon_state = "sheet-cat"
	inhand_icon_state = "sheet-cat"
	merge_type = /obj/item/stack/sheet/animalhide/cat

/obj/item/stack/sheet/animalhide/monkey
	name = "шкура обезьяны"
	desc = "Побочный продукт разведения обезьян."
	singular_name = "кусок шкуры обезьяны"
	icon_state = "sheet-monkey"
	inhand_icon_state = "sheet-monkey"
	merge_type = /obj/item/stack/sheet/animalhide/monkey

GLOBAL_LIST_INIT(monkey_recipes, list ())

/obj/item/stack/sheet/animalhide/monkey/get_main_recipes()
	. = ..()
	. += GLOB.monkey_recipes

/obj/item/stack/sheet/animalhide/lizard
	name = "кожа ящерицы"
	desc = "Ссссссс..."
	singular_name = "кусок кожи ящерицы"
	icon_state = "sheet-lizard"
	inhand_icon_state = "sheet-lizard"
	merge_type = /obj/item/stack/sheet/animalhide/lizard

/obj/item/stack/sheet/animalhide/xeno
	name = "инопланетная шкура"
	desc = "Кожа ужасного существа."
	singular_name = "кусок кожи инопланетянина"
	icon_state = "sheet-xeno"
	inhand_icon_state = "sheet-xeno"
	merge_type = /obj/item/stack/sheet/animalhide/xeno

GLOBAL_LIST_INIT(xeno_recipes, list ())

/obj/item/stack/sheet/animalhide/xeno/get_main_recipes()
	. = ..()
	. += GLOB.xeno_recipes

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/sheet/xenochitin
	name = "инопланетный хитин"
	desc = "Кусок шкуры ужасного существа."
	singular_name = "кусок кожи инопланетянина"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/xenochitin

/obj/item/xenos_claw
	name = "инопланетный коготь"
	desc = "Коготь ужасного существа."
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "экстракт сорняков"
	desc = "Кусочек слизистой пурпурной травы."
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"

/obj/item/stack/sheet/hairlesshide
	name = "безволосая шкура"
	desc = "Эта шкура была лишена волос, но все еще нуждается в мытье и загаре."
	singular_name = "кусок безволосой шкуры"
	icon_state = "sheet-hairlesshide"
	inhand_icon_state = "sheet-hairlesshide"
	merge_type = /obj/item/stack/sheet/hairlesshide

/obj/item/stack/sheet/wethide
	name = "мокрая шкура"
	desc = "Эта шкура была очищена, но все еще нуждается в сушке."
	singular_name = "мокрая шкура"
	icon_state = "sheet-wetleather"
	inhand_icon_state = "sheet-wetleather"
	merge_type = /obj/item/stack/sheet/wethide
	/// Reduced when exposed to high temperatures
	var/wetness = 30
	/// Kelvin to start drying
	var/drying_threshold_temperature = 500

/obj/item/stack/sheet/wethide/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	AddElement(/datum/element/dryable, /obj/item/stack/sheet/leather)

/*
 * Leather SHeet
 */
/obj/item/stack/sheet/leather
	name = "кожа"
	desc = "Побочный продукт разведения животных."
	singular_name = "кусок кожи"
	icon_state = "sheet-leather"
	inhand_icon_state = "sheet-leather"
	merge_type = /obj/item/stack/sheet/leather

GLOBAL_LIST_INIT(leather_recipes, list ())

/obj/item/stack/sheet/leather/get_main_recipes()
	. = ..()
	. += GLOB.leather_recipes

/*Plates*/
/obj/item/stack/sheet/animalhide/goliath_hide
	name = "шкурные пластины голиафа"
	desc = "Осколки скалистой шкуры Голиафа могут сделать ваш костюм более стойким к атакам местной фауны."
	icon = 'icons/obj/mining.dmi'
	icon_state = "goliath_hide"
	singular_name = "шкурная пластина"
	max_amount = 6
	novariants = FALSE
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER
	merge_type = /obj/item/stack/sheet/animalhide/goliath_hide

//Step one - dehairing.

/obj/item/stack/sheet/animalhide/attackby(obj/item/W, mob/user, params)
	if(W.get_sharpness())
		playsound(loc, 'sound/weapons/slice.ogg', 50, TRUE, -1)
		user.visible_message(span_notice("<b>[user]</b> начинает срезать шерсть с <b>[src]</b>.") , span_notice("Начинаю срезать шерсть с <b>[src]</b>...") , span_hear("Слыш как нож режет плоть."))
		if(do_after(user, 50, target = src))
			to_chat(user, span_notice("Срезаю шерсть с <b>[src.singular_name]</b>."))
			new /obj/item/stack/sheet/hairlesshide(user.drop_location(), 1)
			use(1)
	else
		return ..()


//Step two - washing..... it's actually in washing machine code.

//Step three - drying
