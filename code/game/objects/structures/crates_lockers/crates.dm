/obj/structure/closet/crate
	name = "ящик"
	desc = "Прямоугольный ящик, как деревянный, только стальной."
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	can_weld_shut = FALSE
	horizontal = TRUE
	allow_objects = TRUE
	allow_dense = TRUE
	dense_when_open = TRUE
	delivery_icon = "deliverycrate"
	open_sound = 'sound/machines/crate_open.ogg'
	close_sound = 'sound/machines/crate_close.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	drag_slowdown = 0
	var/crate_climb_time = 20
	var/obj/item/paper/fluff/jobs/cargo/manifest/manifest

/obj/structure/closet/crate/Initialize()
	. = ..()
	if(icon_state == "[initial(icon_state)]open")
		opened = TRUE
		AddElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)
	else
		AddElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)
	update_icon()

/obj/structure/closet/crate/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return TRUE
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return TRUE

/obj/structure/closet/crate/update_icon_state()
	icon_state = "[initial(icon_state)][opened ? "open" : ""]"
	return ..()

/obj/structure/closet/crate/closet_update_overlays(list/new_overlays)
	. = new_overlays

/obj/structure/closet/crate/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

/obj/structure/closet/crate/after_open(mob/living/user, force)
	. = ..()
	RemoveElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)
	AddElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)

/obj/structure/closet/crate/after_close(mob/living/user, force)
	. = ..()
	RemoveElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)
	AddElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)

/obj/structure/closet/crate/coffin
	name = "гроб"
	desc = "Это погребальный сосуд для тел тех, кто сейчас в лучшем мире."
	icon_state = "coffin"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 5
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/freezer
	desc = "Фризер."
	name = "морозильник"
	icon_state = "freezer"

//Snowflake organ freezer code
//Order is important, since we check source, we need to do the check whenever we have all the organs in the crate

/obj/structure/closet/crate/freezer/open(mob/living/user, force = FALSE)
	recursive_organ_check(src)
	..()

/obj/structure/closet/crate/freezer/close()
	..()
	recursive_organ_check(src)

/obj/structure/closet/crate/freezer/Destroy()
	recursive_organ_check(src)
	return ..()

/obj/structure/closet/crate/freezer/Initialize()
	. = ..()
	recursive_organ_check(src)



/obj/structure/closet/crate/freezer/blood
	name = "морозильник для крови"
	desc = "Холодильник с пакетами крови."

/obj/structure/closet/crate/freezer/blood/PopulateContents()
	. = ..()
	new /obj/item/reagent_containers/blood(src)
	new /obj/item/reagent_containers/blood(src)
	new /obj/item/reagent_containers/blood/a_minus(src)
	new /obj/item/reagent_containers/blood/b_minus(src)
	new /obj/item/reagent_containers/blood/b_plus(src)
	new /obj/item/reagent_containers/blood/o_minus(src)
	new /obj/item/reagent_containers/blood/o_plus(src)
	new /obj/item/reagent_containers/blood/lizard(src)
	new /obj/item/reagent_containers/blood/ethereal(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/blood/random(src)

/obj/structure/closet/crate/freezer/surplus_limbs
	name = "бюджетные протезы конечностей"
	desc = "Ящик с набором бюджетных протезов."

/obj/structure/closet/crate/freezer/surplus_limbs/PopulateContents()
	. = ..()
	new /obj/item/bodypart/l_arm/robot/surplus(src)
	new /obj/item/bodypart/l_arm/robot/surplus(src)
	new /obj/item/bodypart/r_arm/robot/surplus(src)
	new /obj/item/bodypart/r_arm/robot/surplus(src)
	new /obj/item/bodypart/l_leg/robot/surplus(src)
	new /obj/item/bodypart/l_leg/robot/surplus(src)
	new /obj/item/bodypart/r_leg/robot/surplus(src)
	new /obj/item/bodypart/r_leg/robot/surplus(src)
