#define TRANSFORMATION_DURATION 22

/mob/living/carbon/proc/monkeyize()
	if (notransform || transformation_timer)
		return

	if(ismonkey(src))
		return

	//Make mob invisible and spawn animation
	notransform = TRUE
	Paralyze(TRANSFORMATION_DURATION, ignore_canstun = TRUE)
	icon = null
	cut_overlays()
	invisibility = INVISIBILITY_MAXIMUM

	new /obj/effect/temp_visual/monkeyify(loc)

	transformation_timer = addtimer(CALLBACK(src, .proc/finish_monkeyize), TRANSFORMATION_DURATION, TIMER_UNIQUE)

/mob/living/carbon/proc/finish_monkeyize()
	transformation_timer = null
	to_chat(src, "<B>Теперь я обезьяна.</B>")
	notransform = FALSE
	icon = initial(icon)
	invisibility = 0
	set_species(/datum/species/monkey)
	uncuff()
	return src

//////////////////////////           Humanize               //////////////////////////////
//Could probably be merged with monkeyize but other transformations got their own procs, too

/mob/living/carbon/proc/humanize(species = /datum/species/human)
	if (notransform || transformation_timer)
		return

	if(!ismonkey(src))
		return

	//Make mob invisible and spawn animation
	notransform = TRUE
	Paralyze(TRANSFORMATION_DURATION, ignore_canstun = TRUE)
	icon = null
	cut_overlays()
	invisibility = INVISIBILITY_MAXIMUM

	new /obj/effect/temp_visual/monkeyify/humanify(loc)
	transformation_timer = addtimer(CALLBACK(src, .proc/finish_humanize, species), TRANSFORMATION_DURATION, TIMER_UNIQUE)

/mob/living/carbon/proc/finish_humanize(species = /datum/species/human)
	transformation_timer = null
	to_chat(src, "<B>Теперь я человек.</B>")
	notransform = FALSE
	icon = initial(icon)
	invisibility = 0
	set_species(species)
	return src

/mob/living/carbon/human/proc/corgize()
	if (notransform)
		return
	notransform = TRUE
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	regenerate_icons()
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in bodyparts)	//this really should not be necessary
		qdel(t)

	var/mob/living/simple_animal/pet/dog/corgi/new_corgi = new /mob/living/simple_animal/pet/dog/corgi (loc)
	new_corgi.a_intent = INTENT_HARM
	new_corgi.key = key

	to_chat(new_corgi, "<B>Теперь я Корги! Ура-ура!</B>")
	. = new_corgi
	qdel(src)

/mob/living/carbon/proc/gorillize()
	if(notransform)
		return
	notransform = TRUE
	Paralyze(1, ignore_canstun = TRUE)

	SSblackbox.record_feedback("amount", "gorillas_created", 1)

	var/Itemlist = get_equipped_items(TRUE)
	Itemlist += held_items
	for(var/obj/item/W in Itemlist)
		dropItemToGround(W, TRUE)

	regenerate_icons()
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	var/mob/living/simple_animal/hostile/gorilla/new_gorilla = new (get_turf(src))
	new_gorilla.a_intent = INTENT_HARM
	if(mind)
		mind.transfer_to(new_gorilla)
	else
		new_gorilla.key = key
	to_chat(new_gorilla, "<B>Теперь я горилла! Ар-р!</B>")
	. = new_gorilla
	qdel(src)

/mob/living/carbon/human/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = tgui_input_list(usr, "Which type of mob should [src] turn into?", "Choose a type", sort_list(mobtypes, /proc/cmp_typepaths_asc))

	if(!safe_animal(mobpath))
		to_chat(usr, span_danger("Извините, но данный тип мода сейчас недоступен."))
		return

	if(notransform)
		return
	notransform = TRUE
	Paralyze(1, ignore_canstun = TRUE)

	for(var/obj/item/W in src)
		dropItemToGround(W)

	regenerate_icons()
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	for(var/t in bodyparts)
		qdel(t)

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = INTENT_HARM


	to_chat(new_mob, span_boldnotice("Внезапно чувствую себя более ... животным."))
	. = new_mob
	qdel(src)

/mob/proc/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = tgui_input_list(usr, "Which type of mob should [src] turn into?", "Choose a type", sort_list(mobtypes, /proc/cmp_typepaths_asc))

	if(!safe_animal(mobpath))
		to_chat(usr, span_danger(">Извините, но данный тип мода сейчас недоступен."))
		return

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = INTENT_HARM
	to_chat(new_mob, span_boldnotice("Чувствую себя более ... животным."))

	. = new_mob
	qdel(src)

/* Certain mob types have problems and should not be allowed to be controlled by players.
 *
 * This proc is here to force coders to manually place their mob in this list, hopefully tested.
 * This also gives a place to explain -why- players shouldn't be turn into certain mobs and hopefully someone can fix them.
 */
/mob/proc/safe_animal(MP)

//Bad mobs! - Remember to add a comment explaining what's wrong with the mob
	if(!MP)
		return FALSE	//Sanity, this should never happen.

//Good mobs!
	if(ispath(MP, /mob/living/simple_animal/pet/cat))
		return TRUE
	if(ispath(MP, /mob/living/simple_animal/pet/dog/corgi))
		return TRUE
	if(ispath(MP, /mob/living/simple_animal/crab))
		return TRUE
	if(ispath(MP, /mob/living/simple_animal/hostile/carp))
		return TRUE
	if(ispath(MP, /mob/living/simple_animal/hostile/mushroom))
		return TRUE
	if(ispath(MP, /mob/living/simple_animal/hostile/killertomato))
		return TRUE
	if(ispath(MP, /mob/living/simple_animal/mouse))
		return TRUE
	if(ispath(MP, /mob/living/simple_animal/hostile/bear))
		return TRUE
	if(ispath(MP, /mob/living/simple_animal/parrot))
		return TRUE //Parrots are no longer unfinished! -Nodrak

	//Not in here? Must be untested!
	return FALSE

#undef TRANSFORMATION_DURATION
