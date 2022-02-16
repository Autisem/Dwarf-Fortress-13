/** Materials made from other materials.
 */
/datum/material/alloy
	name = "сплав"
	skloname = "сплава"
	desc = "Материал, состоящий из двух или более других материалов."
	init_flags = NONE
	/// The materials this alloy is made from weighted by their ratios.
	var/list/composition = null
	/// Breakdown flags required to reduce this alloy to its component materials.
	var/req_breakdown_flags = BREAKDOWN_ALLOYS

/datum/material/alloy/return_composition(amount=1, breakdown_flags)
	if(req_breakdown_flags & !(breakdown_flags & req_breakdown_flags))
		return ..()

	. = list()
	var/list/cached_comp = composition
	for(var/comp_mat in cached_comp)
		var/datum/material/component_material = GET_MATERIAL_REF(comp_mat)
		var/list/component_composition = component_material.return_composition(cached_comp[comp_mat], breakdown_flags)
		for(var/comp_comp_mat in component_composition)
			.[comp_comp_mat] += component_composition[comp_comp_mat] * amount


/** Plasteel
 *
 * An alloy of iron and plasma.
 * Applies a significant slowdown effect to any and all items that contain it.
 */
/datum/material/alloy/plasteel
	name = "пласталь"
	skloname = "пластали"
	desc = "Сверхмощный результат пропитки железа плазмой."
	color = "#706374"
	init_flags = MATERIAL_INIT_MAPLOAD
	value_per_unit = 0.135
	strength_modifier = 1.25
	integrity_modifier = 1.5 // Heavy duty.
	armor_modifiers = list(MELEE = 1.4, BULLET = 1.4, LASER = 1.1, ENERGY = 1.1, BOMB = 1.5, BIO = 1, RAD = 1.5, FIRE = 1.1, ACID = 1)
	sheet_type = /obj/item/stack/sheet/plasteel
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/iron=1, /datum/material/plasma=1)

/datum/material/alloy/plasteel/on_applied_obj(obj/item/target_item, amount, material_flags)
	. = ..()
	if(!istype(target_item))
		return

	target_item.slowdown += MATERIAL_SLOWDOWN_PLASTEEL * amount / MINERAL_MATERIAL_AMOUNT

/datum/material/alloy/plasteel/on_removed_obj(obj/item/target_item, amount, material_flags)
	. = ..()

	if(!istype(target_item))
		return

	target_item.slowdown -= MATERIAL_SLOWDOWN_PLASTEEL * amount / MINERAL_MATERIAL_AMOUNT

/** Plastitanium
 *
 * An alloy of titanium and plasma.
 */
/datum/material/alloy/plastitanium
	name = "пластитан"
	skloname = "пластитана"
	desc = "Чрезвычайно термостойкий результат наплавки титана плазмой."
	color = "#3a313a"
	init_flags = MATERIAL_INIT_MAPLOAD
	value_per_unit = 0.225
	strength_modifier = 0.9	// It's a lightweight alloy.
	integrity_modifier = 1.3
	armor_modifiers = list(MELEE = 1.1, BULLET = 1.1, LASER = 1.4, ENERGY = 1.4, BOMB = 1.1, BIO = 1.2, RAD = 1.1, FIRE = 1.5, ACID = 1)
	sheet_type = /obj/item/stack/sheet/mineral/plastitanium
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/titanium=1, /datum/material/plasma=1)

/** Plasmaglass
 *
 * An alloy of silicate and plasma.
 */
/datum/material/alloy/plasmaglass
	name = "плазмастекло"
	skloname = "плазмастекла"
	desc = "Силикат, наполненный плазмой. Он намного более прочный и термостойкий, чем любой из входящих в него материалов."
	color = "#ff80f4"
	alpha = 150
	init_flags = MATERIAL_INIT_MAPLOAD
	integrity_modifier = 0.5
	armor_modifiers = list(MELEE = 0.8, BULLET = 0.8, LASER = 1.2, ENERGY = 1.2, BOMB = 0.3, BIO = 1.2, RAD = 1, FIRE = 2, ACID = 2)
	sheet_type = /obj/item/stack/sheet/plasmaglass
	shard_type = /obj/item/shard/plasma
	value_per_unit = 0.075
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/glass=1, /datum/material/plasma=0.5)

/** Titaniumglass
 *
 * An alloy of glass and titanium.
 */
/datum/material/alloy/titaniumglass
	name = "титановое стекло"
	skloname = "титанового стекла"
	desc = "Специализированный силикатно-титановый сплав, который обычно используется в окнах челнока."
	color = "#cfbee0"
	alpha = 150
	init_flags = MATERIAL_INIT_MAPLOAD
	armor_modifiers = list(MELEE = 1.2, BULLET = 1.2, LASER = 0.8, ENERGY = 0.8, BOMB = 0.5, BIO = 1.2, RAD = 1, FIRE = 0.8, ACID = 2)
	sheet_type = /obj/item/stack/sheet/titaniumglass
	shard_type = /obj/item/shard
	value_per_unit = 0.04
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/glass=1, /datum/material/titanium=0.5)

/** Plastitanium Glass
 *
 * An alloy of plastitanium and glass.
 */
/datum/material/alloy/plastitaniumglass
	name = "пластитановое стекло"
	skloname = "пластитанового стекла"
	desc = "Специализированный силикатно-пластитановый сплав."
	color = "#5d3369"
	alpha = 150
	init_flags = MATERIAL_INIT_MAPLOAD
	integrity_modifier = 1.1
	armor_modifiers = list(MELEE = 1.2, BULLET = 1.2, LASER = 1.2, ENERGY = 1.2, BOMB = 0.5, BIO = 1.2, RAD = 1, FIRE = 2, ACID = 2)
	sheet_type = /obj/item/stack/sheet/plastitaniumglass
	shard_type = /obj/item/shard/plasma
	value_per_unit = 0.125
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/glass=1, /datum/material/alloy/plastitanium=0.5)

/** Alien Alloy
 *
 * Densified plasteel.
 * Applies a significant slowdown effect to anything that contains it.
 * Anything constructed from it can slowly regenerate.
 */
/datum/material/alloy/alien
	name = "чужеродный сплав"
	skloname = "чужеродного сплава"
	desc = "Чрезвычайно плотный сплав, по составу похожий на пласталь. Для его создания требуются экзотические металлургические процессы."
	color = "#6041aa"
	init_flags = MATERIAL_INIT_MAPLOAD
	strength_modifier = 1.5 // It's twice the density of plasteel and just as durable. Getting hit with it is going to HURT.
	integrity_modifier = 1.5
	armor_modifiers = list(MELEE = 1.4, BULLET = 1.4, LASER = 1.2, ENERGY = 1.2, BOMB = 1.5, BIO = 1.2, RAD = 1.5, FIRE = 1.2, ACID = 1.2)
	sheet_type = /obj/item/stack/sheet/mineral/abductor
	value_per_unit = 0.4
	categories = list(MAT_CATEGORY_RIGID=TRUE, MAT_CATEGORY_BASE_RECIPES=TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	composition = list(/datum/material/iron=2, /datum/material/plasma=2)

/datum/material/alloy/alien/on_applied_obj(obj/item/target_item, amount, material_flags)
	. = ..()

	target_item.AddElement(/datum/element/obj_regen, _rate=0.02) // 2% regen per tick.
	if(!istype(target_item))
		return

	target_item.slowdown += MATERIAL_SLOWDOWN_ALIEN_ALLOY * amount / MINERAL_MATERIAL_AMOUNT

/datum/material/alloy/alien/on_removed_obj(obj/item/target_item, amount, material_flags)
	. = ..()

	target_item.RemoveElement(/datum/element/obj_regen, _rate=0.02)
	if(!istype(target_item))
		return

	target_item.slowdown -= MATERIAL_SLOWDOWN_ALIEN_ALLOY * amount / MINERAL_MATERIAL_AMOUNT
