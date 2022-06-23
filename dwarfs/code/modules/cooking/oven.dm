/obj/structure/oven
	name = "oven"
	desc = ""
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "oven_empty_lower"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	var/fuel = 0
	var/working = FALSE
	var/cooking_time = 10 SECONDS
	var/timerid

/obj/structure/oven/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	update_appearance()

/obj/structure/oven/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/oven/update_icon_state()
	. = ..()
	if(working)
		icon_state = "oven_on_lower"
	else if(fuel)
		icon_state = "oven_fueled_lower"
	else
		icon_state = "oven_empty_lower"

/obj/structure/oven/update_overlays()
	. = ..()
	var/mutable_appearance/M = mutable_appearance(initial(icon), layer=ABOVE_MOB_LAYER)
	if(working)
		M.icon_state = "oven_on_upper"
	else if(fuel)
		M.icon_state = "oven_fueled_upper"
	else
		M.icon_state = "oven_empty_upper"
	. += M

/obj/structure/oven/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/plate))
		if(contents.len)
			to_chat(user, span_warning("There is already something cooking inside."))
			return
		I.forceMove(src)
		to_chat(user, span_notice("You place \the [I] inside [src]."))
		if(working)
			timerid = addtimer(CALLBACK(src, .proc/try_cook, I), cooking_time, TIMER_STOPPABLE)
	else if(I.get_temperature())
		if(!fuel)
			to_chat(user, span_warning("[src] has no fuel."))
			return
		if(working)
			to_chat(user, span_warning("[src] is already lit."))
			return
		to_chat(user, span_notice("You light up [src]."))
		working = TRUE
		if(contents.len)
			timerid = addtimer(CALLBACK(src, .proc/try_cook, contents[1]), cooking_time, TIMER_STOPPABLE)
		update_appearance()
	else if(istype(I, /obj/item/stack/sheet/mineral/coal))
		var/obj/item/stack/sheet/mineral/coal/C = I
		fuel += C.amount*15
		qdel(C)
		to_chat(user, span_notice("You throw [C] into [src]."))
		update_appearance()

/obj/structure/oven/proc/try_cook(obj/item/I)
	var/list/possible_recipes = list()
	if(istype(I, /obj/item/reagent_containers/glass/plate/regular))
		possible_recipes = subtypesof(/datum/cooking_recipe/oven/plate)
	else if(istype(I, /obj/item/reagent_containers/glass/plate/flat))
		possible_recipes = subtypesof(/datum/cooking_recipe/oven/flat_plate)
	else if(istype(I, /obj/item/reagent_containers/glass/plate/bowl))
		possible_recipes = subtypesof(/datum/cooking_recipe/oven/bowl)
	var/datum/cooking_recipe/R = find_recipe(possible_recipes, I.contents, I.reagents.reagent_list)
	if(!R)
		qdel(I)
		new /obj/item/food/badrecipe(get_turf(src))
		return

	new R.result(get_turf(src))
	qdel(I)

/obj/structure/oven/process(delta_time)
	if(!working)
		return
	if(fuel<1)
		working = FALSE
		update_appearance()
	fuel = max(fuel-1, 0)
