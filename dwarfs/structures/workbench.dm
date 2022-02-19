/obj/structure/workbench
	name = "верстак"
	desc = "Почти майнкрафт"
	icon = 'white/kacherkin/icons/dwarfs/obj/workbench.dmi'
	icon_state = "workbench"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	var/list/inventory = list()
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
		to_chat(user, span_notice("Сейчас занято."))
		return
	if(recipe && inventory.len && !ready)
		var/answer = tgui_alert(user, "Отменить нынешнюю сборку?", "Верстак", list("Да", "Нет"))
		if(answer != "Да" || !answer)
			return
		for(var/I in inventory)
			var/atom/movable/M = I
			M.forceMove(drop_location())
		qdel(recipe)
		recipe = null
		inventory.Cut()
		to_chat(user, span_notice("Отменяю сборку [recipe]."))
		return
	if(ready)
		busy = TRUE
		if(!do_after(user, 10 SECONDS, target = src))
			busy = FALSE
			return
		busy = FALSE
		playsound(src, 'white/valtos/sounds/anvil_hit.ogg', 70, TRUE)
		var/obj/O = new recipe.result(loc)
		if(istype(get_primary(), /obj/item/blacksmith/partial))
			var/obj/item/blacksmith/partial/P = get_primary()
			O.name = "[P.grade][O.name][P.grade]"
			O.calculate_smithing_stats(P.level)
			if(istype(O, /obj/item/blacksmith))
				var/obj/item/blacksmith/B = O
				B.level = P.level
		to_chat(user, span_notice("Собираю [O]."))
		qdel(recipe)
		inventory.Cut()
		recipe = null
		ready = FALSE
		return
	var/list/recipes = list()
	var/list/recipe_names = list()
	for(var/t in typesof(/datum/workbench_recipe))
		var/datum/workbench_recipe/r = new t
		if(isstrictlytype(r, /datum/workbench_recipe))
			continue
		recipes[r.name] = r
		recipe_names+=r.name
	var/answer = tgui_input_list(user, "Что собираем?", "Верстак", recipe_names)
	if(!answer)
		return
	recipe = recipes[answer]
	to_chat(user, span_notice("Выбираю [recipe.name] для сборки."))

/obj/structure/workbench/examine(mob/user)
	. = ..()
	if(recipe)
		.+="<hr>Собирается [recipe.name]."
		var/text = "Требуется"
		for(var/S in recipe.reqs)
			var/obj/item/stack/I = new S()
			var/r = recipe.reqs[I.type] - amount(I)
			var/govno = r ? "[r]":""
			if(r)
				text+="<br>[I.name]: [govno]"
			qdel(I)
		if(text!="Требуется")
			.+="<hr>[text]"
		else
			.+="<hr>[recipe.name] готов к сборке."
	else
		.+="<hr>Верстак пустой!"

/obj/structure/workbench/proc/amount(obj/item/I)
	. = 0
	for(var/obj/O in inventory)
		if(istype(O, I.type))
			.+=1

/obj/structure/workbench/proc/is_required(obj/item/I)
	. = FALSE
	for(var/O in recipe.reqs)
		var/obj/item/R = new O()
		if(istype(I, R.type))
			. = TRUE
		qdel(R)

/obj/structure/workbench/proc/get_primary()
	. = null
	for(var/obj/I in inventory)
		if(istype(I, recipe.primary))
			. = I

/obj/structure/workbench/proc/check_ready()
	var/r = TRUE
	for(var/S in recipe.reqs)
		var/obj/item/It = new S
		if((recipe.reqs[It.type] - amount(It)) > 0)
			r = FALSE
			break
	ready = r
	return r

/obj/structure/workbench/attacked_by(obj/item/I, mob/living/user)
	if(!recipe)
		..()
		return
	if(is_required(I))
		if((recipe.reqs[I.type]-amount(I))>0)
			if(istype(I, /obj/item/stack))
				var/obj/item/stack/S = I
				I = new S.type()
				S.amount-=1
				if(S.amount<1)
					qdel(S)
			user.transferItemToLoc(I, src)
			inventory+=I
			visible_message(span_notice("[user] кладет [I] на [src].") ,span_notice("Кладу [I] на [src]."))
			check_ready()
		else
			to_chat(user, span_notice("В [src] больше не влазит."))
	else
		..()
