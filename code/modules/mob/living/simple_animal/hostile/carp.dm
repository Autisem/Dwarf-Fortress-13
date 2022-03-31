#define REGENERATION_DELAY 60  // After taking damage, how long it takes for automatic regeneration to begin for megacarps (ty robustin!)

/mob/living/simple_animal/hostile/carp
	name = "космокарп"
	desc = "Милашка - подумаешь ты перед первым в своей жизни укусом карпа."
	icon = 'icons/mob/carp.dmi'
	icon_state = "base"
	icon_living = "base"
	icon_dead = "base_dead"
	icon_gib = "carp_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	movement_type = FLOATING
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/food/fishmeat/carp = 2)
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "аккуратно отталкивает"
	response_disarm_simple = "аккуратно отталкивает"
	emote_taunt = list("скрежетает зубками")
	taunt_chance = 30
	speed = 0
	maxHealth = 25
	health = 25
	food_type = list(/obj/item/food/meat)
	tame_chance = 10
	bonus_tame_chance = 5
	search_objects = 1
	wanted_objects = list(/obj/item/storage/cans)
	harm_intent_damage = 8
	obj_damage = 100
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "кусает"
	attack_verb_simple = "кусает"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	speak_emote = list("скрежещет")
	//Space carp aren't affected by cold.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list("carp")
	gold_core_spawnable = HOSTILE_SPAWN
	/// If the carp uses random coloring
	var/random_color = TRUE
	/// The chance for a rare color variant
	var/rarechance = 1
	/// List of usual carp colors
	var/static/list/carp_colors = list(
		"lightpurple" = "#aba2ff",
		"lightpink" = "#da77a8",
		"green" = "#70ff25",
		"grape" = "#df0afb",
		"swamp" = "#e5e75a",
		"turquoise" = "#04e1ed",
		"brown" = "#ca805a",
		"teal" = "#20e28e",
		"lightblue" = "#4d88cc",
		"rusty" = "#dd5f34",
		"lightred" = "#fd6767",
		"yellow" = "#f3ca4a",
		"blue" = "#09bae1",
		"palegreen" = "#7ef099"
	)
	/// List of rare carp colors
	var/static/list/carp_colors_rare = list(
		"silver" = "#fdfbf3"
	)

/mob/living/simple_animal/hostile/carp/Initialize(mapload)
	AddElement(/datum/element/simple_flying)
	if(random_color)
		set_greyscale(new_config=/datum/greyscale_config/carp)
		carp_randomify(rarechance)
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	add_cell_sample()
	var/datum/action/small_sprite/action = new
	action.Grant(src)

/**
 * Randomly assigns a color to a carp from either a common or rare color variant lists
 *
 * Arguments:
 * * rare The chance of the carp receiving color from the rare color variant list
 */
/mob/living/simple_animal/hostile/carp/proc/carp_randomify(rarechance)
	var/our_color
	if(prob(rarechance))
		our_color = pick(carp_colors_rare)
		set_greyscale(colors=list(carp_colors_rare[our_color]))
	else
		our_color = pick(carp_colors)
		set_greyscale(colors=list(carp_colors[our_color]))

/mob/living/simple_animal/hostile/carp/revive(full_heal = FALSE, admin_revive = FALSE)
	. = ..()
	if(.)
		update_icon()

/mob/living/simple_animal/hostile/carp/proc/chomp_plastic()
	var/obj/item/storage/cans/tasty_plastic = locate(/obj/item/storage/cans) in view(1, src)
	if(tasty_plastic && Adjacent(tasty_plastic))
		visible_message(span_notice("[capitalize(src.name)] gets its head stuck in [tasty_plastic], and gets cut breaking free from it!") , span_notice("Пытаюсь avoid [tasty_plastic], but it looks so... delicious... Ow! It cuts the inside of your mouth!"))

		new /obj/effect/decal/cleanable/plastic(loc)

		adjustBruteLoss(5)
		qdel(tasty_plastic)

/mob/living/simple_animal/hostile/carp/Life(delta_time = SSMOBS_DT, times_fired)
	. = ..()
	if(stat == CONSCIOUS)
		chomp_plastic()

/mob/living/simple_animal/hostile/carp/tamed()
	. = ..()
	can_buckle = TRUE
	buckle_lying = 0
	AddElement(/datum/element/ridable, /datum/component/riding/creature/carp)

/mob/living/simple_animal/hostile/carp/holocarp
	icon_state = "holocarp"
	icon_living = "holocarp"
	maxbodytemp = INFINITY
	gold_core_spawnable = NO_SPAWN
	del_on_death = 1
	random_color = FALSE
	food_type = list()
	tame_chance = 0
	bonus_tame_chance = 0

/mob/living/simple_animal/hostile/carp/holocarp/add_cell_sample()
	return

/mob/living/simple_animal/hostile/carp/megacarp
	icon = 'icons/mob/broadMobs.dmi'
	name = "мега-космокарп"
	desc = "Милашка - подумаешь ты перед первым в своей жизни укусом карпа. Этот выглядит здоровее обычного."
	icon_state = "megacarp"
	icon_living = "megacarp"
	icon_dead = "megacarp_dead"
	icon_gib = "megacarp_gib"
	health_doll_icon = "megacarp"
	maxHealth = 100
	health = 100
	pixel_x = -16
	base_pixel_x = -16
	mob_size = MOB_SIZE_LARGE
	random_color = FALSE
	food_type = list()
	tame_chance = 0
	bonus_tame_chance = 0

	obj_damage = 120
	melee_damage_lower = 30
	melee_damage_upper = 30

	var/regen_cooldown = 0

/mob/living/simple_animal/hostile/carp/megacarp/Initialize()
	. = ..()
	name = "[pick(GLOB.megacarp_first_names)] [pick(GLOB.megacarp_last_names)]"
	melee_damage_lower += rand(2, 10)
	melee_damage_upper += rand(10,20)
	maxHealth += rand(30,60)
	move_to_delay = rand(3,7)

/mob/living/simple_animal/hostile/carp/megacarp/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(.)
		regen_cooldown = world.time + REGENERATION_DELAY

/mob/living/simple_animal/hostile/carp/megacarp/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	AddElement(/datum/element/ridable, /datum/component/riding/creature/megacarp)
	can_buckle = TRUE
	buckle_lying = 0

/mob/living/simple_animal/hostile/carp/megacarp/Life(delta_time = SSMOBS_DT, times_fired)
	. = ..()
	if(regen_cooldown < world.time)
		heal_overall_damage(2 * delta_time)

/mob/living/simple_animal/hostile/carp/bluespacecarp
	name = "Блюспэйскарп"
	desc = "Интересная зверушка, постоянно мерцает. Интересно, на какой частоте?"
	maxHealth = 90
	health = 90
	harm_intent_damage = 5
	attack_verb_continuous = "прожигает"
	attack_verb_simple = "прожигает"
	attack_sound = 'sound/weapons/blaster.ogg'
	rarechance = 10
	melee_damage_type = BURN
	butcher_results = list(/obj/item/food/fishmeat/carp = 2)
	var/safe_cooldown = 20
	var/safe

/mob/living/simple_animal/hostile/carp/bluespacecarp/Initialize()
	safe = world.time
	. = ..()

/mob/living/simple_animal/hostile/carp/bluespacecarp/attackby(obj/item/W, mob/user, params)
	if(safe+safe_cooldown <= world.time && stat != DEAD)
		do_sparks(1, FALSE, src)
		to_chat(user,("[src.name] дематериализуется и удар пролетает насквозь!"))
		safe = world.time
		return
	else
		return ..()
