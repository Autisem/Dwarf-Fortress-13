#define TORCH_LIGHT_COLOR "#FFE0B3"

/obj/item/blacksmith
	name = "item"
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "iron_ingot"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	custom_materials = list(/datum/material/iron = 10000)
	var/real_force = 0
	var/grade = ""
	var/level = 1

/obj/item/blacksmith/smithing_hammer
	name = "smithing hammer"
	desc = "Used for forging."
	icon_state = "smithing_hammer"
	w_class = WEIGHT_CLASS_HUGE
	force = 20
	throwforce = 25
	throw_range = 4

/obj/item/blacksmith/smithing_hammer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()

	if(iswallturf(target) && proximity_flag)
		var/turf/closed/wall/W = target
		var/chance = (W.hardness * 0.5)
		if(chance < 10)
			return FALSE

		if(prob(chance))
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			W.dismantle_wall(TRUE)

		else
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			W.add_dent(WALL_DENT_HIT)
			visible_message(span_danger("<b>[user]</b> hits the <b>[W]</b> with [src]!") , null, COMBAT_MESSAGE_RANGE)
	return TRUE

/obj/item/blacksmith/chisel
	name = "chisel"
	desc = "Used for carving on stone."
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "chisel"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	atck_type = SHARP
	w_class = WEIGHT_CLASS_SMALL
	force = 10
	throwforce = 12
	throw_range = 7

/obj/item/blacksmith/tongs
	name = "tongs"
	desc = "Essential tool for smithing."
	icon = 'dwarfs/icons/items/tools.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	inhand_icon_state = "tongs"
	icon_state = "tongs_open"
	w_class = WEIGHT_CLASS_SMALL
	force = 4
	throwforce = 6
	throw_range = 7

/obj/item/blacksmith/tongs/update_icon_state()
	. = ..()
	if(contents.len)
		icon_state = "tongs_closed"
	else
		icon_state = "tongs_open"

/obj/item/blacksmith/tongs/update_overlays()
	. = ..()
	if(contents.len)
		var/obj/item/blacksmith/ingot/I = contents[1]
		var/mutable_appearance/Ingot = mutable_appearance('dwarfs/icons/items/tools.dmi', "tongs_ingot")
		Ingot.color = I.metal_color
		. += Ingot
		var/mutable_appearance/Ingot_heat = mutable_appearance('dwarfs/icons/items/tools.dmi', "tongs_ingot")
		Ingot_heat.color = "#ffb35c"
		Ingot_heat.alpha =  255 * (I.heattemp / 350)
		. += Ingot_heat

/obj/item/blacksmith/tongs/worn_overlays(isinhands, icon_file)
	. = ..()
	if(contents.len)
		var/obj/item/blacksmith/ingot/I = contents[1]
		var/mutable_appearance/Ingot = mutable_appearance(icon_file, "tongs_ingot")
		Ingot.color = I.metal_color
		. += Ingot
		var/mutable_appearance/Ingot_heat = mutable_appearance(icon_file, "tongs_ingot")
		Ingot_heat.color = "#ffb35c"
		Ingot_heat.alpha =  255 * (I.heattemp / 350)
		. += Ingot_heat

/obj/item/blacksmith/tongs/update_appearance(updates)
	. = ..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/blacksmith/tongs/attack_self(mob/user)
	. = ..()
	if(contents.len)
		var/obj/O = contents[contents.len]
		O.forceMove(drop_location())
		update_appearance()

/obj/item/blacksmith/ingot
	name = "iron ingot"
	desc = "Can be forged into something."
	icon = 'dwarfs/icons/items/ingots.dmi'
	icon_state = "iron"
	w_class = WEIGHT_CLASS_NORMAL
	force = 2
	throwforce = 5
	throw_range = 7
	var/datum/smithing_recipe/recipe = null
	var/durability = 6
	var/progress_current = 0
	var/progress_need = 10
	var/heattemp = 0
	var/type_metal = "iron"
	var/mod_grade = 1
	var/metal_color = "#7e7e7e"

/obj/item/blacksmith/ingot/gold
	name = "golden ingot"
	icon_state = "gold"
	type_metal = "gold"
	metal_color = "#ffae34"

/obj/item/blacksmith/ingot/examine(mob/user)
	. = ..()
	var/ct = ""
	switch(heattemp)
		if(200 to INFINITY)
			ct = "red-hot"
		if(100 to 199)
			ct = "very hot"
		if(1 to 99)
			ct = "hot enough"
		else
			ct = "cold"

	. += "<hr>The [src] is [ct]."

/obj/item/blacksmith/ingot/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/blacksmith/ingot/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/blacksmith/ingot/process()
	if(!heattemp)
		return
	heattemp = max(heattemp-25, 0)
	update_appearance()
	if(isobj(loc))
		loc.update_appearance()

/obj/item/blacksmith/ingot/update_overlays()
	. = ..()
	var/mutable_appearance/heat = mutable_appearance('dwarfs/icons/items/ingots.dmi', initial(icon_state))
	heat.alpha =  255 * (heattemp / 350)
	. += heat


/obj/item/blacksmith/ingot/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/blacksmith/tongs))
		if(I.contents.len)
			to_chat(user, span_warning("You are already holding something with [I]!"))
			return
		else
			src.forceMove(I)
			update_appearance()
			I.update_appearance()
			to_chat(user, span_notice("You grab \the [src] with \the [I]."))
			return

/obj/item/storage/belt/dagger_sneath
	name = "dagger sneath"
	desc = "Perfect habitat for your little friend."
	icon_state = "dagger_sneath"
	inhand_icon_state = "dagger_sneath"
	worn_icon_state = "dagger_sneath"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/dagger_sneath/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.rustle_sound = FALSE
	STR.quickdraw = TRUE
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/blacksmith/dagger
		))

/obj/item/storage/belt/dagger_sneath/update_icon_state()
	icon_state = "dagger_sneath"
	worn_icon_state = "dagger_sneath"
	if(contents.len)
		icon_state += "-sword"
		worn_icon_state += "-sword"
	return ..()

/obj/item/blacksmith/torch_handle
	name = "torch handle"
	desc = "Can be attached to a wall."
	icon_state = "torch_handle"
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron = 10000)
	var/result_path = /obj/structure/sconce

/obj/item/blacksmith/torch_handle/proc/try_build(turf/on_wall, mob/user)
	if(get_dist(on_wall, user)>1)
		return
	var/ndir = get_dir(on_wall, user)
	if(!(ndir in GLOB.cardinals))
		return
	var/turf/T = get_turf(user)
	if(!isfloorturf(T))
		to_chat(user, span_warning("You can't place [src] on the floor!"))
		return
	if(locate(/obj/structure/sconce) in view(1))
		to_chat(user, span_warning("There is something already attached to it!"))
		return

	return TRUE

/obj/item/blacksmith/torch_handle/proc/attach(turf/on_wall, mob/user)
	if(result_path)
		playsound(src.loc, 'sound/machines/click.ogg', 75, TRUE)
		user.visible_message(span_notice("[user.name] attaches [src] to the wall.") ,
			span_notice("You attach the handle to the wall.") ,
			span_hear("You hear a metal click."))
		var/ndir = get_dir(on_wall, user)

		new result_path(get_turf(user), ndir)
	qdel(src)

/obj/structure/sconce
	name = "sconce"
	desc = "A small fixture that can hold torches."
	icon = 'dwarfs/icons/structures/wall_mount.dmi'
	icon_state = "sconce_empty"
	layer = BELOW_MOB_LAYER
	max_integrity = 100
	var/obj/item/flashlight/fueled/torch/torch

/obj/structure/sconce/Initialize(mapload, ndir=null)
	. = ..()
	if(ndir)
		dir = turn(dir, 180)
	switch(dir)
		if(WEST)	pixel_x = 32
		if(EAST)	pixel_x = -32
		if(SOUTH)	pixel_y = 32

/obj/structure/sconce/lit
	icon_state = "sconce_on"

/obj/structure/sconce/lit/Initialize(mapload, ndir)
	. = ..()
	torch = new /obj/item/flashlight/fueled/torch/lit(src)
	update_appearance()

/obj/structure/sconce/update_icon_state()
	. = ..()
	if(!torch)
		icon_state = "sconce_empty"
	else if(torch.on)
		icon_state = "sconce_on"
	else
		if(torch.fuel)
			icon_state = "sconce_off"
		else
			icon_state = "sconce_burned"

/obj/structure/sconce/update_appearance(updates)
	. = ..()
	_update_light()

/obj/structure/sconce/proc/_update_light()
	if(!torch)
		set_light(0, 0, 0)
	else
		if(torch.on)
			set_light(9, 1, TORCH_LIGHT_COLOR)
		else
			set_light(0, 0, 0)


/obj/structure/sconce/attackby(obj/item/W, mob/living/user, params)

	if(istype(W, /obj/item/flashlight/fueled/torch))
		if(torch)
			to_chat(user, span_warning("There is a torch already!"))
			return
		src.add_fingerprint(user)
		var/obj/item/flashlight/fueled/torch/L = W
		if(!user.temporarilyRemoveItemFromInventory(L))
			return
		src.add_fingerprint(user)
		to_chat(user, span_notice("You place [L] inside."))
		torch = L
		L.forceMove(src)
		update_appearance()
	else
		return ..()

/obj/structure/sconce/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)

	if(!torch)
		to_chat(user, span_warning("There is no torch!"))
		return
	torch.add_fingerprint(user)
	user.put_in_active_hand(torch)
	torch = null
	update_appearance()

#define SHPATEL_BUILD_FLOOR 1
#define SHPATEL_BUILD_WALL 2
#define SHPATEL_BUILD_DOOR 3
#define SHPATEL_BUILD_TABLE 4
#define SHPATEL_BUILD_CHAIR 5

/obj/item/blacksmith/shpatel
	name = "trowel"
	desc = "Used for building purposes."
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "trowel"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	force = 8
	throwforce = 12
	throw_range = 3
	var/mode = SHPATEL_BUILD_FLOOR

/obj/item/blacksmith/shpatel/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	do_job(A, user)

/obj/item/blacksmith/shpatel/proc/check_resources()
	var/mat_to = 0
	var/mat_need = 0
	for(var/obj/item/stack/sheet/stone/B in view(1))
		mat_to += B.amount
	switch(mode)
		if(SHPATEL_BUILD_WALL) mat_need = 4
		if(SHPATEL_BUILD_FLOOR) mat_need = 1
	if(mat_to >= mat_need)
		return TRUE
	else
		return FALSE

/obj/item/blacksmith/shpatel/proc/use_resources(var/turf/open/floor/T, mob/user)
	switch(mode)
		if(SHPATEL_BUILD_WALL)
			var/blocks_need = 5
			for(var/obj/item/stack/sheet/stone/B in view(1))
				blocks_need -= B.amount
				B.amount = -blocks_need
				B.update_icon()
				if(B.amount <= 0)
					qdel(B)
				if(blocks_need <= 0)
					break
			T.ChangeTurf(/turf/closed/wall/stonewall, flags = CHANGETURF_IGNORE_AIR)
			user.visible_message(span_notice("<b>[user]</b> constructs a stone wall.") , \
								span_notice("You construct a stone wall."))
		if(SHPATEL_BUILD_FLOOR)
			var/blocks_need = 1
			for(var/obj/item/stack/sheet/stone/B in view(1))
				blocks_need -= B.amount
				B.amount = -blocks_need
				B.update_icon()
				if(B.amount <= 0)
					qdel(B)
				if(blocks_need <= 0)
					break
			T.ChangeTurf(/turf/open/floor/stone, flags = CHANGETURF_INHERIT_AIR)
			user.visible_message(span_notice("<b>[user]</b> constructs stone floor.") , \
								span_notice("You construct stone floor."))

/obj/item/blacksmith/shpatel/proc/do_job(atom/A, mob/user)
	if(!istype(A, /turf/open/floor))
		return
	if(mode != SHPATEL_BUILD_FLOOR && !istype(A, /turf/open/floor/stone))
		to_chat(user, span_warning("Can't build here!"))
		return
	var/turf/T = get_turf(A)
	if(check_resources())
		if(do_after(user, 5 SECONDS, target = A))
			if(check_resources())
				use_resources(T, user)
				playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
				return TRUE
	else
		to_chat(user, span_warning("Not enough materials!"))

/obj/item/blacksmith/shpatel/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/blacksmith/shpatel/attack_self(mob/user)
	..()
	var/list/choices = list(
		"Floor" = image(icon = 'dwarfs/icons/turf/floors_dwarven.dmi', icon_state = "stone_floor"),
		"Wall" = image(icon = 'dwarfs/icons/turf/walls_dwarven.dmi', icon_state = "rich_wall-0")
	)
	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Floor")
			mode = SHPATEL_BUILD_FLOOR
		if("Wall")
			mode = SHPATEL_BUILD_WALL

#undef SHPATEL_BUILD_FLOOR
#undef SHPATEL_BUILD_WALL
#undef SHPATEL_BUILD_DOOR
#undef SHPATEL_BUILD_TABLE
#undef SHPATEL_BUILD_CHAIR

/obj/item/blacksmith/partial
	desc = "Looks like a part of something bigger."
	icon = 'dwarfs/icons/items/parts.dmi'
	var/item_grade = "*"

/obj/item/blacksmith/partial/Initialize()
	. = ..()
	force = 1

/obj/item/blacksmith/partial/zwei
	name = "zweihander blade"
	real_force = 40
	icon_state = "zwei_part"

/obj/item/blacksmith/partial/katanus
	name = "katanus blade"
	real_force = 16
	icon_state = "katanus_part"

/obj/item/blacksmith/partial/flail
	name = "ball on a chain"
	real_force = 20
	icon_state = "cep_part"

/obj/item/blacksmith/partial/dwarfsord
	name = "sword blade"
	real_force = 16
	icon_state = "dwarfsord_part"

/obj/item/blacksmith/partial/crown_empty
	name = "empty crown"
	icon_state = "crown_part"

/obj/item/blacksmith/partial/scepter_part
	name = "scepter part"
	icon_state = "scepter_part"

/obj/item/scepter_shaft
	name = "scepter shaft"
	icon_state = "scepter_shaft"
