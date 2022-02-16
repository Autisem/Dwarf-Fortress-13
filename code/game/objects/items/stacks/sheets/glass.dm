/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
GLOBAL_LIST_INIT(glass_recipes, list ( \
	new/datum/stack_recipe("направленное окно", /obj/structure/window/unanchored, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("полноценное окно", /obj/structure/window/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("осколок стекла", /obj/item/shard, time = 0, on_floor = TRUE), \
	new/datum/stack_recipe("стеклянная плитка", /obj/item/stack/tile/glass, 1, 4, 20)
))

/obj/item/stack/sheet/glass
	name = "стекло"
	desc = "HOLY SHEET! Это много стекла."
	singular_name = "лист стекла"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "sheet-glass"
	inhand_icon_state = "sheet-glass"
	mats_per_unit = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/glass
	grind_results = list(/datum/reagent/silicon = 20)
	material_type = /datum/material/glass
	point_value = 1
	tableVariant = /obj/structure/table/glass
	matter_amount = 4
	cost = 500

/obj/item/stack/sheet/glass/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] начинает разрезать шею [user.ru_ego ()] с помощью <b> [src.name] </b>! Похоже, [user.p_theyre ()] пытается совершить самоубийство!"))
	return BRUTELOSS

/obj/item/stack/sheet/glass/five
	amount = 5

/obj/item/stack/sheet/glass/fifty
	amount = 50

/obj/item/stack/sheet/glass/get_main_recipes()
	. = ..()
	. += GLOB.glass_recipes

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if (get_amount() < 1 || CC.get_amount() < 5)
			to_chat(user, "<span class='warning>Нужно пять длин катушки кабеля и один лист стекла, чтобы сделать проводное стекло!</span>")
			return
		CC.use(5)
		use(1)
		to_chat(user, span_notice("Присоединяю провод к стеклу."))
		var/obj/item/stack/light_w/new_tile = new(user.loc)
		new_tile.add_fingerprint(user)
		return
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/rglass/RG = new (get_turf(user))
			if(!QDELETED(RG))
				RG.add_fingerprint(user)
			var/replace = user.get_inactive_held_item()==src
			V.use(1)
			use(1)
			if(QDELETED(src) && replace && !QDELETED(RG))
				user.put_in_hands(RG)
		else
			to_chat(user, span_warning("Мне понадобится один стержень и один лист стекла для создания укреплённого стекла!"))
		return
	return ..()

GLOBAL_LIST_INIT(pglass_recipes, list ( \
	new/datum/stack_recipe("направленное окно", /obj/structure/window/plasma/unanchored, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("полноценное окно", /obj/structure/window/plasma/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("осколок плазмастекла", /obj/item/shard/plasma, time = 0, on_floor = TRUE) \
))

/obj/item/stack/sheet/plasmaglass
	name = "плазмастекло"
	desc = "Стеклянный лист из плазмосиликатного сплава. Это выглядит чрезвычайно жестким и достаточно огнестойким."
	singular_name = "лист плазмастекла"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "sheet-pglass"
	inhand_icon_state = "sheet-pglass"
	mats_per_unit = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plasmaglass
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 75, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plasmaglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/toxin/plasma = 10)
	material_flags = MATERIAL_NO_EFFECTS

/obj/item/stack/sheet/plasmaglass/fifty
	amount = 50

/obj/item/stack/sheet/plasmaglass/get_main_recipes()
	. = ..()
	. += GLOB.pglass_recipes

/obj/item/stack/sheet/plasmaglass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)

	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/plasmarglass/RG = new (get_turf(user))
			RG.add_fingerprint(user)
			var/replace = user.get_inactive_held_item()==src
			V.use(1)
			use(1)
			if(QDELETED(src) && replace)
				user.put_in_hands(RG)
		else
			to_chat(user, span_warning("Мне понадобится один стержень и один лист плазмастекла для создания укреплённого плазмастекла!"))
			return
	else
		return ..()

/*
 * Reinforced glass sheets
 */
GLOBAL_LIST_INIT(reinforced_glass_recipes, list ( \
	new/datum/stack_recipe("направленное армированное окно", /obj/structure/window/reinforced/unanchored, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("полноценное армированное окно", /obj/structure/window/reinforced/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("осколок стекла", /obj/item/shard, time = 0, on_floor = TRUE), \
	new/datum/stack_recipe("армированная стеклянная плитка", /obj/item/stack/tile/rglass, 1, 4, 20)
))


/obj/item/stack/sheet/rglass
	name = "армированное стекло"
	desc = "Стекло, в котором, кажется, есть стержни или что-то застряло."
	singular_name = "лист армированного стекла"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "sheet-rglass"
	inhand_icon_state = "sheet-rglass"
	mats_per_unit = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 70, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/rglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/iron = 10)
	point_value = 4
	matter_amount = 6

/obj/item/stack/sheet/rglass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	..()

/obj/item/stack/sheet/rglass/get_main_recipes()
	. = ..()
	. += GLOB.reinforced_glass_recipes

GLOBAL_LIST_INIT(prglass_recipes, list ( \
	new/datum/stack_recipe("направленное армированное окно", /obj/structure/window/plasma/reinforced/unanchored, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("полноценное армированное окно", /obj/structure/window/plasma/reinforced/fulltile/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("осколок плазмастекла", /obj/item/shard/plasma, time = 0, on_floor = TRUE) \
))

/obj/item/stack/sheet/plasmarglass
	name = "армированное плазмастекло"
	desc = "Стеклянный лист из плазмосиликатного сплава и стержневой матрицы. Это выглядит безнадежно жестким и почти пожаробезопасным!"
	singular_name = "лист армированного плазмастекла"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "sheet-prglass"
	inhand_icon_state = "sheet-prglass"
	mats_per_unit = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT, /datum/material/iron = MINERAL_MATERIAL_AMOUNT * 0.5)
	armor = list(MELEE = 20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 100)
	resistance_flags = ACID_PROOF
	material_flags = MATERIAL_NO_EFFECTS
	merge_type = /obj/item/stack/sheet/plasmarglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/toxin/plasma = 10, /datum/reagent/iron = 10)
	point_value = 23
	matter_amount = 8

/obj/item/stack/sheet/plasmarglass/get_main_recipes()
	. = ..()
	. += GLOB.prglass_recipes

GLOBAL_LIST_INIT(titaniumglass_recipes, list(
	new/datum/stack_recipe("окно шаттла", /obj/structure/window/shuttle/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("осколок стекла", /obj/item/shard, time = 0, on_floor = TRUE) \
	))

/obj/item/stack/sheet/titaniumglass
	name = "титановое стекло"
	desc = "Стеклянный лист из титаносиликатного сплава."
	singular_name = "лист титанового стекла"
	icon_state = "sheet-titaniumglass"
	inhand_icon_state = "sheet-titaniumglass"
	mats_per_unit = list(/datum/material/alloy/titaniumglass=MINERAL_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/titaniumglass
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/titaniumglass

/obj/item/stack/sheet/titaniumglass/get_main_recipes()
	. = ..()
	. += GLOB.titaniumglass_recipes

GLOBAL_LIST_INIT(plastitaniumglass_recipes, list(
	new/datum/stack_recipe("пластитановое окно", /obj/structure/window/plasma/reinforced/plastitanium/unanchored, 2, time = 0, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("осколок плазмастекла", /obj/item/shard/plasma, time = 0, on_floor = TRUE) \
	))

/obj/item/stack/sheet/plastitaniumglass
	name = "пластитановое стекло"
	desc = "Стеклянный лист из плазмотитано-силикатного сплава."
	singular_name = "лист пластитанового стекла"
	icon_state = "sheet-plastitaniumglass"
	inhand_icon_state = "sheet-plastitaniumglass"
	mats_per_unit = list(/datum/material/alloy/plastitaniumglass=MINERAL_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plastitaniumglass
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 100)
	material_flags = MATERIAL_NO_EFFECTS
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plastitaniumglass

/obj/item/stack/sheet/plastitaniumglass/get_main_recipes()
	. = ..()
	. += GLOB.plastitaniumglass_recipes

/obj/item/shard
	name = "осколок"
	desc = "Гадкий осколок стекла. Хочет заскочить к тебе под ногти."
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	w_class = WEIGHT_CLASS_TINY
	force = 5
	throwforce = 10
	inhand_icon_state = "shard-glass"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	custom_materials = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	attack_verb_continuous = list("режет", "нарезает", "рубит", "стеклит")
	attack_verb_simple = list("режет", "нарезает", "рубит", "стеклит")
	hitsound = 'sound/weapons/bladeslice.ogg'
	resistance_flags = ACID_PROOF
	armor = list(MELEE = 100, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 100)
	max_integrity = 40
	sharpness = SHARP_EDGED
	var/icon_prefix
	var/obj/item/stack/sheet/weld_material = /obj/item/stack/sheet/glass
	embedding = list("embed_chance" = 65)


/obj/item/shard/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] режет [user.ru_ego()] [pick("wrists", "throat")] осколком стекла! Похоже, [user.p_theyre()] пытается совершить самоубийство."))
	return (BRUTELOSS)


/obj/item/shard/Initialize()
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = force)
	AddComponent(/datum/component/butchering, 150, 65)
	icon_state = pick("large", "medium", "small")
	switch(icon_state)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)
	if (icon_prefix)
		icon_state = "[icon_prefix][icon_state]"

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/shard/Destroy()
	. = ..()

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)

/obj/item/shard/afterattack(atom/A as mob|obj, mob/user, proximity)
	. = ..()
	if(!proximity || !(src in user))
		return
	if(isturf(A))
		return
	if(istype(A, /obj/item/storage))
		return
	var/hit_hand = ((user.active_hand_index % 2 == 0) ? "r_" : "l_") + "arm"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.gloves && !HAS_TRAIT(H, TRAIT_PIERCEIMMUNE)) // golems, etc
			to_chat(H, span_warning("<b>[capitalize(src.name)]</b> впивается в мою руку!"))
			H.apply_damage(force*0.5, BRUTE, hit_hand)

/obj/item/shard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet/cloth))
		var/obj/item/stack/sheet/cloth/C = I
		to_chat(user, span_notice("Начинаю обматывать [src] используя [C]..."))
		if(do_after(user, 35, target = src))
			var/obj/item/kitchen/knife/shiv/S = new /obj/item/kitchen/knife/shiv
			C.use(1)
			to_chat(user, span_notice("Обматываю [src] используя [C], получая при этом самодельное оружие."))
			remove_item_from_storage(src)
			qdel(src)
			user.put_in_hands(S)

	else
		return ..()

/obj/item/shard/welder_act(mob/living/user, obj/item/I)
	..()
	if(I.use_tool(src, user, 0, volume=50))
		var/obj/item/stack/sheet/NG = new weld_material(user.loc)
		if(!QDELETED(NG))
			for(var/obj/item/stack/sheet/G in user.loc)
				if(G == NG)
					continue
				if(G.amount >= G.max_amount)
					continue
				G.attackby(NG, user)
		to_chat(user, span_notice("Добавляю свеженькое [NG.name] в кучу. Теперь она содержит [NG.amount] листов."))
		qdel(src)
	return TRUE

/obj/item/shard/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(isliving(AM))
		var/mob/living/L = AM
		if(!(L.movement_type & (FLYING|FLOATING)) || L.buckled)
			playsound(src, 'sound/effects/glass_step.ogg', HAS_TRAIT(L, TRAIT_LIGHT_STEP) ? 30 : 50, TRUE)

/obj/item/shard/plasma
	name = "фиолетовый осколок"
	desc = "Гадкий осколок плазмастекла."
	force = 6
	throwforce = 11
	icon_state = "plasmalarge"
	custom_materials = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "plasma"
	weld_material = /obj/item/stack/sheet/plasmaglass
