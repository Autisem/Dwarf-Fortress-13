/obj/structure/workbench
	name = "workbench"
	desc = "Almost that cube game."
	icon = 'dwarfs/icons/structures/64x32.dmi'
	icon_state = "workshop"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	var/datum/workbench_recipe/recipe
	var/ready = FALSE
	var/busy = FALSE

/obj/structure/workbench/Initialize()
	. = ..()
	var/turf/T = locate(x+1,y,z)
	T.density = TRUE

/obj/structure/workbench/Destroy()
	var/turf/T = locate(x+1,y,z)
	if(istype(T, /turf/open))
		T.density = FALSE
	..()

/obj/structure/workbench/attack_hand(mob/user)
	. = ..()
	if(busy)
		to_chat(user, span_notice("Currently busy."))
		return
	if(recipe && contents.len && !ready)
		var/answer = tgui_alert(user, "Cancel current assembly?", "Workbench", list("Yes", "No"))
		if(answer != "Yes" || !answer)
			return
		for(var/I in contents)
			var/atom/movable/M = I
			M.forceMove(drop_location())
		qdel(recipe)
		recipe = null
		to_chat(user, span_notice("You cancel the assembly of [recipe]."))
		return
	if(ready)
		busy = TRUE
		to_chat(user, span_notice("You start assembling [recipe]..."))
		if(!do_after(user, 10 SECONDS, target = src))
			busy = FALSE
			return
		busy = FALSE
		playsound(src, 'dwarfs/sounds/anvil_hit.ogg', 70, TRUE)
		var/obj/O = new recipe.result(loc)
		if(istype(get_primary(), /obj/item/blacksmith/partial))
			var/obj/item/blacksmith/partial/P = get_primary()
			O.name = "[P.grade][O.name][P.grade]"
			O.calculate_smithing_stats(P.level)
			if(istype(O, /obj/item/blacksmith))
				var/obj/item/blacksmith/B = O
				B.level = P.level
		to_chat(user, span_notice("You assemble [O]."))
		qdel(recipe)
		recipe = null
		ready = FALSE
		return
	var/list/recipes = list()
	var/list/recipe_names = list()
	for(var/t in subtypesof(/datum/workbench_recipe))
		var/datum/workbench_recipe/r = new t
		recipes[r.name] = r
		recipe_names+=r.name
	var/answer = tgui_input_list(user, "What to assemble?", "Workbench", recipe_names)
	if(!answer)
		return
	recipe = recipes[answer]
	to_chat(user, span_notice("You select [recipe.name] for assembly."))

/obj/structure/workbench/examine(mob/user)
	. = ..()
	if(recipe)
		.+="<br>Currenly [recipe.name] is assembled."
		if(!ready)
			var/text = "<br>Required:"
			for(var/type in recipe.reqs)
				var/obj/O = type
				var/amount = recipe.reqs[O]
				if(amount - src.amount(O))
					text += "<br>[amount - src.amount(O)] [initial(O.name)]"
			.+=text
		else
			.+="<hr>[recipe.name] is ready to be assembled."
	else
		.+="<br>[src] is empty!"

/obj/structure/workbench/proc/is_required(obj/item/I)
	. = FALSE
	for(var/O in recipe.reqs)
		if(istype(I, O))
			return TRUE

/obj/structure/workbench/proc/get_primary()
	. = null
	for(var/obj/I in contents)
		if(istype(I, recipe.primary))
			. = I

/obj/structure/workbench/proc/check_ready()
	var/r = TRUE
	for(var/type in recipe.reqs)
		if((recipe.reqs[type] - amount(type)) > 0)
			r = FALSE
			break
	ready = r
	return r

/obj/structure/workbench/proc/amount(type)
	. = 0
	for(var/obj/item/I in contents)
		if(istype(I, type))
			if(istype(I, /obj/item/stack))
				var/obj/item/stack/S = I
				.+=S.amount
			else
				.++

/obj/structure/workbench/attackby(obj/item/I, mob/user, params)
	if(!recipe)
		return ..()
	else if(is_required(I))
		if((recipe.reqs[I.type]-amount(I.type))>0)
			if(istype(I, /obj/item/stack))
				var/obj/item/stack/S = I
				I = new S.type()
				S.use(1)
			I.forceMove(src)
			visible_message(span_notice("[user] places [I] on \the [src].") ,span_notice("You place [I] on \the [src]."))
			check_ready()
		else
			to_chat(user, span_warning("There is enough [I]."))
	else
		return ..()
