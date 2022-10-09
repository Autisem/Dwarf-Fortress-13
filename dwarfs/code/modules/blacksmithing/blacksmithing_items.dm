#define TORCH_LIGHT_COLOR "#FFE0B3"

/obj/item/ingot
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
	var/metal_color = "#7e7e7e"

/obj/item/ingot/gold
	name = "golden ingot"
	icon_state = "gold"
	type_metal = "gold"
	metal_color = "#ffae34"

/obj/item/ingot/examine(mob/user)
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

/obj/item/ingot/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/ingot/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/ingot/process()
	if(!heattemp)
		return
	heattemp = max(heattemp-25, 0)
	update_appearance()
	if(isobj(loc))
		loc.update_appearance()

/obj/item/ingot/update_overlays()
	. = ..()
	var/mutable_appearance/heat = mutable_appearance('dwarfs/icons/items/ingots.dmi', initial(icon_state))
	heat.alpha =  255 * (heattemp / 350)
	. += heat


/obj/item/ingot/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/tongs))
		if(I.contents.len)
			to_chat(user, span_warning("You are already holding something with [I]!"))
			return
		else
			src.forceMove(I)
			update_appearance()
			I.update_appearance()
			to_chat(user, span_notice("You grab \the [src] with \the [I]."))
			return

/obj/item/torch_handle
	name = "torch handle"
	desc = "Can be attached to a wall."
	icon_state = "torch_handle"
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron = 10000)
	var/result_path = /obj/structure/sconce

/obj/item/torch_handle/proc/try_build(turf/on_wall, mob/user)
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

/obj/item/torch_handle/proc/attach(turf/on_wall, mob/user)
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

/obj/item/partial
	desc = "Looks like a part of something bigger."
	icon = 'dwarfs/icons/items/components.dmi'
	force = 1

/obj/item/partial/Initialize()
	. = ..()

/obj/item/partial/dagger
	name = "dagger blade"
	icon_state = "dagger_blade"

/obj/item/partial/pickaxe
	name = "pickaxe blade"
	icon_state = "pickaxe_head"

/obj/item/partial/shovel
	name = "shovel blade"
	icon_state = "shovel_head"

/obj/item/partial/axe
	name = "axe blade"
	icon_state = "axe_head"

/obj/item/partial/builder_hammer
	name = "builder's hammer head"
	icon_state = "hammer_head"

/obj/item/partial/smithing_hammer
	name = "smithing hammer head"
	icon_state = "smithing_hammer_head"

/obj/item/partial/zwei
	name = "zweihander blade"
	icon_state = "zweihander_blade"

/obj/item/partial/flail
	name = "ball on a chain"
	icon_state = "cep_mace"

/obj/item/partial/sword
	name = "sword blade"
	icon_state = "sword_blade"

/obj/item/partial/crown_empty
	name = "empty crown"
	icon_state = "crown_part"

/obj/item/partial/scepter_part
	name = "scepter part"
	icon_state = "scepter_part"

/obj/item/scepter_shaft
	name = "scepter shaft"
	icon_state = "scepter_shaft"
