/*	Pens!
 *	Contains:
 *		Pens
 *		Sleepy Pens
 *		Parapens
 *		Edaggers
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_EARS
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=10)
	grind_results = list(/datum/reagent/iron = 2, /datum/reagent/iodine = 1)
	var/colour = "black"	//what colour the ink is!
	var/degrees = 0
	var/font = PEN_FONT
	embedding = list()
	atck_type = PIERCE

/obj/item/pen/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is scribbling numbers all over [user.ru_na()]self with [src]! It looks like [user.p_theyre()] trying to commit sudoku..."))
	return(BRUTELOSS)

/obj/item/pen/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"
	throw_speed = 4 // red ones go faster (in this case, fast enough to embed!)

/obj/item/pen/invisible
	desc = "It's an invisible pen marker."
	icon_state = "pen"
	colour = "white"

/obj/item/pen/fourcolor
	desc = "It's a fancy four-color ink pen, set to black."
	name = "four-color pen"
	colour = "black"

/obj/item/pen/fourcolor/attack_self(mob/living/carbon/user)
	switch(colour)
		if("black")
			colour = "red"
			throw_speed++
		if("red")
			colour = "green"
			throw_speed = initial(throw_speed)
		if("green")
			colour = "blue"
		else
			colour = "black"
	to_chat(user, span_notice("<b>[src.name]</b> will now write in [colour]."))
	desc = "It's a fancy four-color ink pen, set to [colour]."

/obj/item/pen/fountain
	name = "fountain pen"
	desc = "It's a common fountain pen, with a faux wood body."
	icon_state = "pen-fountain"
	font = FOUNTAIN_PEN_FONT

/obj/item/pen/charcoal
	name = "charcoal stylus"
	desc = "It's just a wooden stick with some compressed ash on the end. At least it can write."
	icon_state = "pen-charcoal"
	colour = "dimgray"
	font = CHARCOAL_FONT
	custom_materials = null
	grind_results = list(/datum/reagent/ash = 5, /datum/reagent/cellulose = 10)

/datum/crafting_recipe/charcoal_stylus
	name = "Charcoal Stylus"
	result = /obj/item/pen/charcoal
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1, /datum/reagent/ash = 30)
	time = 30
	category = CAT_PRIMAL

/obj/item/pen/fountain/captain
	name = "captain's fountain pen"
	desc = "It's an expensive Oak fountain pen. The nib is quite sharp."
	icon_state = "pen-fountain-o"
	force = 5
	throwforce = 5
	throw_speed = 4
	colour = "crimson"
	custom_materials = list(/datum/material/gold = 750)
	atck_type = PIERCE
	resistance_flags = FIRE_PROOF
	unique_reskin = list("Oak" = "pen-fountain-o",
						"Gold" = "pen-fountain-g",
						"Rosewood" = "pen-fountain-r",
						"Black and Silver" = "pen-fountain-b",
						"Command Blue" = "pen-fountain-cb"
						)
	embedding = list("embed_chance" = 75)

/obj/item/pen/fountain/captain/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 200, 115) //the pen is mightier than the sword

/obj/item/pen/fountain/captain/reskin_obj(mob/M)
	..()
	if(current_skin)
		desc = "It's an expensive [current_skin] fountain pen. The nib is quite sharp."

/obj/item/pen/attack_self(mob/living/carbon/user)
	. = ..()
	if(.)
		return

	var/deg = input(user, "What angle would you like to rotate the pen head to? (1-360)", "Rotate Pen Head") as null|num
	if(deg && (deg > 0 && deg <= 360))
		degrees = deg
		to_chat(user, span_notice("You rotate the top of the pen to [degrees] degrees."))
		SEND_SIGNAL(src, COMSIG_PEN_ROTATED, deg, user)

/obj/item/pen/attack(mob/living/M, mob/user,stealth)
	if(!istype(M))
		return

	if(!force)
		if(M.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
			to_chat(user, span_warning("You stab [M] with the pen."))
			if(!stealth)
				to_chat(M, span_danger("Что-то укололо меня!"))
			. = 1

		log_combat(user, M, "втыкает", src)

	else
		. = ..()

/obj/item/pen/afterattack(obj/O, mob/living/user, proximity)
	. = ..()
	//Changing name/description of items. Only works if they have the UNIQUE_RENAME object flag set
	if(isobj(O) && proximity && (O.obj_flags & UNIQUE_RENAME))
		var/penchoice = input(user, "What would you like to edit?", "Rename, change description or reset both?") as null|anything in list("Rename","Change description","Reset")
		if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
			return
		if(penchoice == "Rename")
			var/input = stripped_input(user,"What do you want to name [O]?", ,"[O.name]", MAX_NAME_LEN)
			var/oldname = O.name
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(oldname == input || input == "")
				to_chat(user, span_notice("You changed [O] to... well... [O]."))
			else
				O.name = input
				var/datum/component/label/label = O.GetComponent(/datum/component/label)
				if(label)
					label.remove_label()
					label.apply_label()
				to_chat(user, span_notice("You have successfully renamed [oldname] to [O]."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Change description")
			var/input = stripped_input(user,"Describe [O] here:", ,"[O.desc]", 140)
			var/olddesc = O.desc
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(olddesc == input || input == "")
				to_chat(user, span_notice("You decide against changing [O] description."))
			else
				O.desc = input
				to_chat(user, span_notice("You have successfully changed [O] description."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Reset")
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			O.desc = initial(O.desc)
			O.name = initial(O.name)
			var/datum/component/label/label = O.GetComponent(/datum/component/label)
			if(label)
				label.remove_label()
				label.apply_label()
			to_chat(user, span_notice("You have successfully reset [O] name and description."))
			O.renamedByPlayer = FALSE

/*
 * Sleepypens
 */

/obj/item/pen/sleepy/attack(mob/living/M, mob/user)
	if(!istype(M))
		return

	if(..())
		if(reagents.total_volume)
			if(M.reagents)

				reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = INJECT)


/obj/item/pen/sleepy/Initialize()
	. = ..()
	create_reagents(45, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/toxin/chloralhydrate, 20)
	reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 15)
	reagents.add_reagent(/datum/reagent/toxin/staminatoxin, 10)

/obj/item/pen/survival
	name = "survival pen"
	desc = "The latest in portable survival technology, this pen was designed as a miniature diamond pickaxe. Watchers find them very desirable for their diamond exterior."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "digging_pen"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	force = 3
	w_class = WEIGHT_CLASS_TINY
	grind_results = list(/datum/reagent/iron = 2, /datum/reagent/iodine = 1)
	tool_behaviour = TOOL_MINING //For the classic "digging out of prison with a spoon but you're in space so this analogy doesn't work" situation.
	toolspeed = 10 //You will never willingly choose to use one of these over a shovel.
