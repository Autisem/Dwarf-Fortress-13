/obj/structure/chair
	name = "стул"
	desc = "На нём можно сидеть."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair"
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 0 //you sit in a chair, not lay
	resistance_flags = NONE
	max_integrity = 250
	integrity_failure = 0.1

	custom_materials = list(/datum/material/iron = 2000)
	var/buildstacktype = /obj/item/stack/sheet/stone
	var/buildstackamount = 1
	var/item_chair = /obj/item/chair // if null it can't be picked up
	layer = OBJ_LAYER

/obj/structure/chair/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_notice("Удерживается вместе парочкой <b>болтов</b>.")
	if(!has_buckled_mobs() && can_buckle)
		. += "</br><span class='notice'>Перетащите себя, чтобы сидеть на нём.</span>"

/obj/structure/chair/Initialize()
	. = ..()
	if(prob(0.2))
		name = "tactical [name]"

/obj/structure/chair/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, .proc/can_user_rotate),CALLBACK(src, .proc/can_be_rotated),null)

/obj/structure/chair/proc/can_be_rotated(mob/user)
	return TRUE

/obj/structure/chair/proc/can_user_rotate(mob/user)
	var/mob/living/L = user

	if(istype(L))
		if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE))
			return FALSE
		else
			return TRUE
	else if(isobserver(user) && CONFIG_GET(flag/ghost_interaction))
		return TRUE
	return FALSE

/obj/structure/chair/deconstruct()
	// If we have materials, and don't have the NOCONSTRUCT flag
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
		else
			for(var/i in custom_materials)
				var/datum/material/M = i
				new M.sheet_type(loc, FLOOR(custom_materials[M] / MINERAL_MATERIAL_AMOUNT, 1))
	..()

/obj/structure/chair/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/chair/attackby(obj/item/W, mob/user, params)
	if((flags_1 & NODECONSTRUCT_1))
		return . = ..()
	if(W.tool_behaviour == TOOL_WRENCH)
		return
	. = ..()

/obj/structure/chair/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	I.play_tool_sound(src)
	deconstruct()

/obj/structure/chair/proc/handle_rotation(direction)
	handle_layer()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/structure/chair/proc/handle_layer()
	if(has_buckled_mobs() && dir == NORTH)
		layer = ABOVE_MOB_LAYER
		plane = ABOVE_GAME_PLANE
	else
		layer = OBJ_LAYER
		plane = GAME_PLANE

/obj/structure/chair/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()

/obj/structure/chair/post_unbuckle_mob()
	. = ..()
	handle_layer()

/obj/structure/chair/setDir(newdir)
	..()
	handle_rotation(newdir)

// Chair types

///Material chair
/obj/structure/chair/greyscale
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	item_chair = /obj/item/chair/greyscale
	buildstacktype = null //Custom mats handle this


/obj/structure/chair/wood
	name = "деревянный стул"
	desc = "Старое никогда не бывает слишком старым, чтобы не быть в моде."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "wooden_chair"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstackamount = 3
	item_chair = /obj/item/chair/wood

/obj/structure/chair/wood/wings
	icon_state = "wooden_chair_wings"
	item_chair = /obj/item/chair/wood/wings

/obj/structure/chair/comfy
	name = "удобный стул"
	desc = "Это выглядит удобно."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "comfychair"
	color = rgb(255,255,255)
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstackamount = 2
	item_chair = null
	var/mutable_appearance/armrest

/obj/structure/chair/comfy/Initialize()
	armrest = GetArmrest()
	armrest.layer = ABOVE_MOB_LAYER
	armrest.plane = ABOVE_GAME_PLANE
	return ..()

/obj/structure/chair/comfy/proc/GetArmrest()
	return mutable_appearance('icons/obj/chairs.dmi', "comfychair_armrest", plane = ABOVE_GAME_PLANE)

/obj/structure/chair/comfy/Destroy()
	QDEL_NULL(armrest)
	return ..()

/obj/structure/chair/comfy/post_buckle_mob(mob/living/M)
	. = ..()
	update_armrest()

/obj/structure/chair/comfy/proc/update_armrest()
	if(has_buckled_mobs())
		add_overlay(armrest)
	else
		cut_overlay(armrest)

/obj/structure/chair/comfy/post_unbuckle_mob()
	. = ..()
	update_armrest()

/obj/structure/chair/comfy/brown
	color = rgb(255,113,0)

/obj/structure/chair/comfy/beige
	color = rgb(255,253,195)

/obj/structure/chair/comfy/teal
	color = rgb(0,255,255)

/obj/structure/chair/comfy/black
	color = rgb(167,164,153)

/obj/structure/chair/comfy/lime
	color = rgb(255,251,0)

/obj/structure/chair/comfy/shuttle
	name = "пассажирское сиденье"
	desc = "Удобное, безопасное сиденье. У него есть более крепко выглядящая система ремней, для более гладких полетов."
	icon_state = "shuttle_chair"

/obj/structure/chair/comfy/shuttle/GetArmrest()
	return mutable_appearance('icons/obj/chairs.dmi', "shuttle_chair_armrest", plane = ABOVE_GAME_PLANE)

/obj/structure/chair/office
	icon = 'icons/obj/chairs.dmi'
	anchored = FALSE
	buildstackamount = 5
	item_chair = null
	icon_state = "officechair_dark"


/obj/structure/chair/office/Moved()
	. = ..()
	playsound(src, 'sound/effects/roll.ogg', 100, TRUE)

/obj/structure/chair/office/light
	icon_state = "officechair_white"

//Stool

/obj/structure/chair/stool
	name = "табуретка"
	desc = "Для жопы."
	icon_state = "stool"
	can_buckle = FALSE
	buildstackamount = 1
	item_chair = /obj/item/chair/stool

/obj/structure/chair/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(!item_chair || has_buckled_mobs() || src.flags_1 & NODECONSTRUCT_1)
			return
		if(!usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
			return
		usr.visible_message(span_notice("[usr] хватает [src].") , span_notice("Хватаю [src]."))
		var/obj/item/C = new item_chair(loc)
		C.set_custom_materials(custom_materials)
		TransferComponents(C)
		usr.put_in_hands(C)
		qdel(src)

/obj/structure/chair/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return ..()

/obj/item/chair
	name = "стул"
	desc = "Особенность потасовок в баре."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair_toppled"
	inhand_icon_state = "chair"
	lefthand_file = 'icons/mob/inhands/misc/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/chairs_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 8
	throwforce = 10
	throw_range = 3
	hitsound = 'sound/items/trayhit1.ogg'
	hit_reaction_chance = 50
	custom_materials = list(/datum/material/iron = 2000)
	var/break_chance = 5 //Likely hood of smashing the chair.
	var/obj/structure/chair/origin_type = /obj/structure/chair

/obj/item/chair/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins hitting [user.p_them()]self with <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(src,hitsound,50,TRUE)
	return BRUTELOSS

/obj/item/chair/attack_self(mob/user)
	plant(user)

/obj/item/chair/proc/plant(mob/user)
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, span_warning("Надо бы пол!"))
		return
	for(var/obj/A in T)
		if(istype(A, /obj/structure/chair))
			to_chat(user, span_warning("Здесь уже есть стул!"))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, span_warning("Здесь уже что-то есть!"))
			return

	user.visible_message(span_notice("[user] ставит [src.name] на пол.") , span_notice("Ставлю [src.name] на пол."))
	var/obj/structure/chair/C = new origin_type(get_turf(loc))
	C.set_custom_materials(custom_materials)
	TransferComponents(C)
	C.setDir(dir)
	qdel(src)

/obj/item/chair/proc/smash(mob/living/user)
	var/stack_type = initial(origin_type.buildstacktype)
	if(!stack_type)
		return
	var/remaining_mats = initial(origin_type.buildstackamount)
	remaining_mats-- //Part of the chair was rendered completely unusable. It magically dissapears. Maybe make some dirt?
	if(remaining_mats)
		for(var/M=1 to remaining_mats)
			new stack_type(get_turf(loc))
	qdel(src)




/obj/item/chair/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == UNARMED_ATTACK && prob(hit_reaction_chance))
		owner.visible_message(span_danger("[owner] отражает [attack_text] [src]!"))
		return TRUE
	return FALSE

/obj/item/chair/afterattack(atom/target, mob/living/carbon/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(prob(break_chance))
		user.visible_message(span_danger("[user] разбивает [src] на куски об [target]"))
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			if(C.health < C.maxHealth*0.5)
				C.Paralyze(20)
		smash(user)

/obj/item/chair/greyscale
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	origin_type = /obj/structure/chair/greyscale

/obj/item/chair/stool
	name = "табуретка"
	icon_state = "stool_toppled"
	inhand_icon_state = "stool"
	origin_type = /obj/structure/chair/stool
	break_chance = 0 //It's too sturdy.

/obj/item/chair/wood
	name = "деревянный стул"
	icon = 'icons/obj/chairs.dmi'
	icon_state = "wooden_chair_toppled"
	inhand_icon_state = "woodenchair"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	hitsound = 'sound/weapons/genhit1.ogg'
	origin_type = /obj/structure/chair/wood
	custom_materials = null
	break_chance = 50

/obj/item/chair/wood/wings
	icon_state = "wooden_chair_wings_toppled"
	origin_type = /obj/structure/chair/wood/wings

/obj/structure/chair/old
	name = "странный стул"
	desc = "На нём можно сидеть. Выглядит ОЧЕНЬ комфортным."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chairold"
	item_chair = null

/obj/structure/chair/mime
	name = "невидимый стул"
	desc = "Мда."
	anchored = FALSE
	icon_state = null
	buildstacktype = null
	item_chair = null
	flags_1 = NODECONSTRUCT_1
	alpha = 0

/obj/structure/chair/mime/post_buckle_mob(mob/living/M)
	M.pixel_y += 5

/obj/structure/chair/mime/post_unbuckle_mob(mob/living/M)
	M.pixel_y -= 5


/obj/structure/chair/plastic
	name = "складной пластиковый стул"
	desc = "Независимо от того, сколько вы корчитесь, это все равно будет неудобно."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "plastic_chair"
	resistance_flags = FLAMMABLE
	max_integrity = 50
	buildstackamount = 2
	item_chair = /obj/item/chair/plastic

/obj/structure/chair/plastic/post_buckle_mob(mob/living/Mob)
	Mob.pixel_y += 2
	.=..()
	if(iscarbon(Mob))
		INVOKE_ASYNC(src, .proc/snap_check, Mob)

/obj/structure/chair/plastic/post_unbuckle_mob(mob/living/Mob)
	Mob.pixel_y -= 2

/obj/structure/chair/plastic/proc/snap_check(mob/living/carbon/Mob)
	if (Mob.nutrition >= NUTRITION_LEVEL_FAT)
		to_chat(Mob, span_warning("Стул начинает трещать и трескаться, я слишком тяжелый!"))
		if(do_after(Mob, 6 SECONDS, progress = FALSE))
			Mob.visible_message(span_notice("Пластиковый стул защелкивается под весом [Mob]!"))
			new /obj/effect/decal/cleanable/plastic(loc)
			qdel(src)

/obj/item/chair/plastic
	name = "складной пластиковый стул"
	desc = "Так или иначе, вы всегда можете найти его под борцовским рингом."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "folded_chair"
	inhand_icon_state = "folded_chair"
	lefthand_file = 'icons/mob/inhands/misc/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/chairs_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 7
	throw_range = 5 //Lighter Weight --> Flies Farther.
	break_chance = 25
	origin_type = /obj/structure/chair/plastic
