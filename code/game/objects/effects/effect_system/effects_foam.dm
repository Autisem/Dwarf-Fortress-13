// Foam
// Similar to smoke, but slower and mobs absorb its reagent through their exposed skin.
#define ALUMINUM_FOAM 1
#define IRON_FOAM 2
#define RESIN_FOAM 3


/obj/effect/particle_effect/foam
	name = "foam"
	icon_state = "foam"
	base_icon_state = "foam_smooth"
	opacity = FALSE
	anchored = TRUE
	density = FALSE
	layer = EDGED_TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/amount = 3
	animate_movement = NO_STEPS
	var/metal = 0
	var/lifetime = 40
	var/reagent_divisor = 7
	var/static/list/blacklisted_turfs = typecacheof(list(
	/turf/open/space/transit,
	/turf/open/chasm,
	/turf/open/lava))
	var/slippery_foam = TRUE
	var/can_bypass_density = FALSE
	var/smooth_icon = 'white/valtos/icons/foam_smooth.dmi'

/obj/effect/particle_effect/foam/smart
	can_bypass_density = TRUE

/obj/effect/particle_effect/foam/metal
	name = "aluminium foam"
	metal = ALUMINUM_FOAM
	icon_state = "mfoam"
	slippery_foam = FALSE

/obj/effect/particle_effect/foam/metal/smart
	name = "smart foam"

/obj/effect/particle_effect/foam/metal/iron
	name = "iron foam"
	metal = IRON_FOAM

/obj/effect/particle_effect/foam/metal/resin
	name = "resin foam"
	metal = RESIN_FOAM

/obj/effect/particle_effect/foam/long_life
	lifetime = 150

/obj/effect/particle_effect/foam/Initialize()
	. = ..()
	create_reagents(1000, REAGENT_HOLDER_INSTANT_REACT) //limited by the size of the reagent holder anyway. Works without instant possibly edit in future
	START_PROCESSING(SSfastprocess, src)
	playsound(src, 'sound/effects/bubbles2.ogg', 80, TRUE, -3)

	var/matrix/M = new
	M.Translate(-7, -7)
	transform = M
	icon = smooth_icon
	icon_state = "[base_icon_state]-0"

/obj/effect/particle_effect/foam/ComponentInitialize()
	. = ..()
	if(slippery_foam)
		AddComponent(/datum/component/slippery, 100)

/obj/effect/particle_effect/foam/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()


/obj/effect/particle_effect/foam/proc/kill_foam()
	STOP_PROCESSING(SSfastprocess, src)
	switch(metal)
		if(ALUMINUM_FOAM)
			if (!locate(/obj/structure/foamedmetal) in (get_turf(src)))
				new /obj/structure/foamedmetal(get_turf(src))
		if(IRON_FOAM)
			if (!locate(/obj/structure/foamedmetal) in (get_turf(src)))
				new /obj/structure/foamedmetal/iron(get_turf(src))
	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 5)

/obj/effect/particle_effect/foam/smart/kill_foam() //Smart foam adheres to area borders for walls
	STOP_PROCESSING(SSfastprocess, src)
	if(metal)
		var/turf/T = get_turf(src)
		if(isspaceturf(T) || isopenspace(T)) //Block up any exposed space
			T.PlaceOnTop(/turf/open/floor/plating/foam, flags = CHANGETURF_INHERIT_AIR)
		for(var/direction in GLOB.cardinals)
			var/turf/cardinal_turf = get_step(T, direction)
			if(get_area(cardinal_turf) != get_area(T)) //We're at an area boundary, so let's block off this turf!
				if (!locate(/obj/structure/foamedmetal) in (get_turf(src)))
					new/obj/structure/foamedmetal(T)
				break
	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 5)

/obj/effect/particle_effect/foam/process()
	lifetime--
	if(lifetime < 1)
		kill_foam()
		return

	var/fraction = 1/initial(reagent_divisor)
	for(var/obj/O in range(0,src))
		if(O.type == src.type)
			continue
		if(isturf(O.loc))
			var/turf/T = O.loc
			if(T.intact && HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
				continue
		if(lifetime % reagent_divisor)
			reagents.expose(O, VAPOR, fraction)
	var/hit = 0
	for(var/mob/living/L in range(0,src))
		hit += foam_mob(L)
	if(hit)
		lifetime++ //this is so the decrease from mobs hit and the natural decrease don't cumulate.
	var/T = get_turf(src)
	if(lifetime % reagent_divisor)
		reagents.expose(T, VAPOR, fraction)

	if(--amount < 0)
		return
	spread_foam()

/obj/effect/particle_effect/foam/proc/foam_mob(mob/living/L)
	if(lifetime<1)
		return FALSE
	if(!istype(L))
		return FALSE
	var/fraction = 1/initial(reagent_divisor)
	if(lifetime % reagent_divisor)
		reagents.expose(L, VAPOR, fraction)
	lifetime--
	return TRUE

/obj/effect/particle_effect/foam/proc/spread_foam()
	var/turf/t_loc = get_turf(src)
	for(var/turf/T in t_loc.reachableAdjacentTurfs(bypass_density = can_bypass_density))
		var/obj/effect/particle_effect/foam/foundfoam = locate() in T //Don't spread foam where there's already foam!
		if(foundfoam)
			continue

		if(is_type_in_typecache(T, blacklisted_turfs))
			continue

		for(var/mob/living/L in T)
			foam_mob(L)
		var/obj/effect/particle_effect/foam/F = new src.type(T)
		F.amount = amount
		reagents.copy_to(F, (reagents.total_volume))
		F.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		F.metal = metal

///////////////////////////////////////////////
//FOAM EFFECT DATUM
/datum/effect_system/foam_spread
	var/amount = 10		// the size of the foam spread.
	var/obj/chemholder
	effect_type = /obj/effect/particle_effect/foam
	var/metal = 0


/datum/effect_system/foam_spread/metal
	effect_type = /obj/effect/particle_effect/foam/metal


/datum/effect_system/foam_spread/metal/smart
	effect_type = /obj/effect/particle_effect/foam/smart


/datum/effect_system/foam_spread/long
	effect_type = /obj/effect/particle_effect/foam/long_life

/datum/effect_system/foam_spread/New()
	..()
	chemholder = new /obj()
	var/datum/reagents/R = new/datum/reagents(1000, REAGENT_HOLDER_INSTANT_REACT) //same as above
	chemholder.reagents = R
	R.my_atom = chemholder

/datum/effect_system/foam_spread/Destroy()
	qdel(chemholder)
	chemholder = null
	return ..()

/datum/effect_system/foam_spread/set_up(amt=5, loca, datum/reagents/carry = null, metaltype = 0)
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)

	amount = round(sqrt(amt / 2), 1)
	carry.copy_to(chemholder, carry.total_volume)
	if(metaltype)
		metal = metaltype

/datum/effect_system/foam_spread/start()
	var/obj/effect/particle_effect/foam/F = new effect_type(location)
	var/foamcolor = mix_color_from_reagents(chemholder.reagents.reagent_list)
	// To prevent insane reagent multiplication with 1u foam
	// I am capping amount of reagent foam recieves by limiting how low it can go
	// Any radius of foam less than 3 makes foam recieve same amount of reagents as foam of radius 3
	// Maximum multiplication of reagents is about 166% (3 times as low as before, it was about 500% with 1u foam)
	//
	// amount is radius of the foam
	// 10u foam has radius of 3
	// 5u foam has radius of 2
	// 1u foam has radius of 1
	var/effective_amount = chemholder.reagents.total_volume / max(amount, 3)
	chemholder.reagents.copy_to(F, effective_amount)
	F.add_atom_colour(foamcolor, FIXED_COLOUR_PRIORITY)
	F.amount = amount
	F.metal = metal


//////////////////////////////////////////////////////////
// FOAM STRUCTURE. Formed by metal foams. Dense and opaque, but easy to break
/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	base_icon_state = "foam_smooth"
	density = TRUE
	opacity = TRUE 	// changed in New()
	anchored = TRUE
	layer = EDGED_TURF_LAYER
	resistance_flags = FIRE_PROOF | ACID_PROOF
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	name = "металлопена"
	desc = "Лёгкая металлическая пенная стена."
	gender = PLURAL
	max_integrity = 20
	smoothing_groups = list(SMOOTH_GROUP_METALFOAM)
	canSmoothWith = list(SMOOTH_GROUP_METALFOAM)
	var/smooth_icon = 'white/valtos/icons/foam_smooth.dmi'

/obj/structure/foamedmetal/Initialize()
	. = ..()
	if(smoothing_flags & SMOOTH_BITMASK)
		var/matrix/M = new
		M.Translate(-7, -7)
		transform = M
		icon = smooth_icon
		icon_state = "[base_icon_state]-[smoothing_junction]"

/obj/structure/foamedmetal/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/foamedmetal/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	playsound(src.loc, 'sound/weapons/tap.ogg', 100, TRUE)

/obj/structure/foamedmetal/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
	to_chat(user, span_warning("You hit [src] but bounce off it!"))
	playsound(src.loc, 'sound/weapons/tap.ogg', 100, TRUE)

/obj/structure/foamedmetal/iron
	max_integrity = 50
	icon_state = "ironfoam"

#undef ALUMINUM_FOAM
#undef IRON_FOAM
#undef RESIN_FOAM
