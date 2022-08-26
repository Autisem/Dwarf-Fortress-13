/obj/structure/sapling_pot
	name = "sapling pot"
	var/has_dirt = FALSE
	var/waterlevel = 0
	var/watermax = 100
	var/list/allowed_species
	///The currently planted plant
	var/obj/structure/plant/myplant = null

/obj/structure/sapling_pot/Destroy()
	if(myplant)
		QDEL_NULL(myplant)
	. = ..()

/obj/structure/sapling_pot/proc/on_damage(obj/structure/plant/source)
	SIGNAL_HANDLER
	if(!waterlevel)
		source.health -= rand(1, 3)
	if(source.age >= 2)
		source.health -= rand(1, 3)

/obj/structure/sapling_pot/proc/on_grow(obj/structure/plant/source)
	SIGNAL_HANDLER
	if(source.growthstage ==2)
		source.age++
		return COMPONENT_CANCEL_PLANT_GROW

/obj/structure/sapling_pot/examine(mob/user)
	. = ..()
	.+="<hr>"
	if(myplant)
		.+="There is \a [myplant] growing here."
	else
		.+="It's empty."
	var/water_text = "<br>"
	switch(waterlevel)
		if(60 to 100)
			water_text+="Looks very moist."
		if(30 to 59)
			water_text+="Looks normal."
		if(1 to 29)
			water_text+="Looks a bit dry."
		else
			water_text+="Looks extremely dry."
	.+=water_text

/obj/structure/sapling_pot/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/growable/seeds))
		if(!myplant)
			var/obj/item/growable/seeds/S = O
			to_chat(user, span_notice("You plant [S]."))
			var/obj/structure/plant/P = new S.plant(loc)
			qdel(S)
			myplant = P
			P.plot = src
			myplant.update_appearance()
			RegisterSignal(P, COSMIG_PLANT_DAMAGE_TICK, .proc/on_damage)
			RegisterSignal(P, COSMIG_PLANT_ON_GROW, .proc/on_grow)
			return
		else
			to_chat(user, span_warning("[capitalize(src.name)] already has seeds in it!"))
			return
	else if(istype(O, /obj/item/shovel))
		user.visible_message(span_notice("[user] starts digging out [src]'s plants...") ,
			span_notice("You start digging out [src]'s plants..."))
		if(O.use_tool(src, user, 50, volume=50) || !myplant)
			user.visible_message(span_notice("[user] digs out the plants in [src]!") , span_notice("You dig out all of [src]'s plants!"))
			if(myplant) //Could be that they're just using it as a de-weeder
				QDEL_NULL(myplant)
				name = initial(name)
				desc = initial(desc)
			update_appearance()
			return
	else if(istype(O, /obj/item/stack/dirt))
		if(has_dirt)
			to_chat(user, span_warning("[src] already has dirt inside!"))
			return
		var/obj/item/stack/D = O
		if(D.use(5))
			to_chat(user, span_notice("You fill [src] with dirt."))
			has_dirt = TRUE
			update_appearance()
		else
			to_chat(user, span_notice("You need at least 5 dirt to fill [src]!"))
	else if(O.is_refillable())
		var/datum/reagent/W = O.reagents.has_reagent(/datum/reagent/water)
		if(!W)
			to_chat(user, span_warning("[O] doesn't have any water."))
			return
		if(!has_dirt)
			to_chat(user, span_warning("[src] doesn't have any dirt."))
			return
		var/needed = watermax-waterlevel
		var/to_trans = W.volume <= needed ? W.volume : needed
		O.reagents.remove_reagent(/datum/reagent/water, to_trans)
		waterlevel += to_trans
		to_chat(user, span_notice("You water [src]."))
		user.mind.adjust_experience(/datum/skill/farming, rand(1,5))
	else
		return ..()

/obj/structure/sapling_pot/attack_hand(mob/user)
	if(myplant && myplant.growthstage == 2)
		to_chat(user, span_notice("You start removing the sapling from [src]..."))
		if(do_after(user, 10 SECONDS, src))
			var/mob/living/carbon/human/H = user
			var/obj/item/sapling/S = new()
			S.health = myplant.health
			S.name = "[myplant.species] sapling"
			S.plant_type = myplant.type
			S.growthstage = myplant.growthstage
			START_PROCESSING(SSprocessing, S)
			QDEL_NULL(myplant)
			H.put_in_active_hand(S)
			to_chat(user, span_notice("You remove [S] from [src]."))
			has_dirt = FALSE
			waterlevel = 0
			user.mind.adjust_experience(/datum/skill/farming, rand(1,5))
			update_appearance()

/obj/structure/sapling_pot/update_icon_state()
	. = ..()
	if(has_dirt)
		icon_state = "sapling_pot_dirt"
	else
		icon_state = initial(icon_state)
