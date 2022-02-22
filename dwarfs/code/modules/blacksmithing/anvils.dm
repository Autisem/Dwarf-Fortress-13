/obj/item/blacksmith/anvil_free
	name = "anvil"
	desc = "Its hard to forge on it."
	icon_state = "anvil_free"
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 20
	throw_range = 2

/obj/item/blacksmith/anvil_free/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=10, force_wielded=10)

/obj/item/blacksmith/srub
	name = "log"
	desc = "Sturdy enough to hold an anvil."
	icon_state = "srub"
	w_class = WEIGHT_CLASS_HUGE
	force = 7
	throwforce = 10
	throw_range = 3
	custom_materials = null

/obj/item/blacksmith/srub/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=7, force_wielded=7)

/obj/structure/anvil
	name = "anvil"
	desc = "Hit it really hard."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "anvil"
	density = TRUE
	var/acd = FALSE
	var/obj/item/blacksmith/ingot/current_ingot = null
	var/list/allowed_things = list()

/obj/structure/anvil/Topic(href, list/href_list)
	. = ..()
	if(.)
		return .
	if(!usr.is_holding_item_of_type(/obj/item/blacksmith/smithing_hammer)||!(usr in view(1, src)))
		usr<<browse(null, "window=Anvil")
		return
	if(href_list["hit"])
		hit(usr)
	if(href_list["miss"])
		miss(usr)

/obj/structure/anvil/proc/hit(mob/user)
	var/mob/living/carbon/human/H = user
	if(current_ingot.progress_current == current_ingot.progress_need)
		current_ingot.progress_current++
		playsound(src, 'dwarfs/sounds/anvil_hit.ogg', 70, TRUE)
		to_chat(user, span_notice("[current_ingot] is ready. Hit it again to keep smithing or cool it down."))
		user<<browse(null, "window=Anvil")
		return
	else
		playsound(src, 'dwarfs/sounds/anvil_hit.ogg', 70, TRUE)
		user.visible_message(span_notice("<b>[user]</b> hits \the anvil with \a hammer.") , \
						span_notice("You hit \the anvil with \a hammer."))
		current_ingot.progress_current++
		H.adjustStaminaLoss(rand(1, 5))
		H.mind.adjust_experience(/datum/skill/smithing, rand(0, 4) * current_ingot.mod_grade)
		return

/obj/structure/anvil/proc/miss(mob/user)
	// var/mob/living/carbon/human/H = user
	current_ingot.durability--
	if(current_ingot.durability == 0)
		to_chat(user, span_warning("the ingot crumbles into countless metal pieces..."))
		current_ingot = null
		LAZYCLEARLIST(contents)
		icon_state = "[initial(icon_state)]"
		user<<browse(null, "window=Anvil")
	playsound(src, 'dwarfs/sounds/anvil_hit.ogg', 70, TRUE)
	user.visible_message(span_warning("<b>[user]</b> hits \the anvil with \a hammer incorrectly.") , \
						span_warning("You hit \the anvil with \a hammer incorrectly."))
	return

/obj/structure/anvil/fullsteel
	name = "heavy anvil"
	desc = "Can't move."
	icon = 'white/kacherkin/icons/dwarfs/obj/objects.dmi'
	icon_state = "old_anvil_full"

/obj/structure/anvil/Initialize()
	. = ..()
	for(var/item in subtypesof(/datum/smithing_recipe))
		var/datum/smithing_recipe/SR = new item()
		allowed_things += SR

/obj/structure/anvil/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(acd)
		return

	if(!ishuman(user))
		to_chat(user, span_warning("My hands are too weak to do this!"))
		return

	var/mob/living/carbon/human/H = user

	acd = TRUE
	addtimer(VARSET_CALLBACK(src, acd, FALSE), H.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER) SECONDS)

	if(istype(I, /obj/item/blacksmith/smithing_hammer))
		var/obj/item/blacksmith/smithing_hammer/hammer = I
		if(current_ingot)
			if(current_ingot.heattemp <= 0)
				icon_state = "[initial(icon_state)]_cold"
				to_chat(user, span_warning("\the [current_ingot] is to cold too keep working."))
				return
			if(current_ingot.recipe)
				var/height = 30
				var/html = file2text("dwarfs/code/modules/blacksmithing/minigames/slider.txt")
				if(current_ingot.progress_current <= current_ingot.progress_need)
					var/datum/browser/popup = new(user, "Anvil", "Anvil", 500, height+120)
					popup.set_content(html)
					popup.open()
					return
				if(current_ingot.progress_current > current_ingot.progress_need)
					current_ingot.progress_current = 0
					current_ingot.mod_grade++
					current_ingot.progress_need = round(current_ingot.progress_need * 1.1)
					playsound(src, 'dwarfs/sounds/anvil_hit.ogg', 70, TRUE)
					to_chat(user, span_notice("You begin to upgrade \the [current_ingot]."))
					return
			else
				var/list/metal_allowed_list = list()
				for(var/datum/smithing_recipe/SR in allowed_things)
					if(SR.metal_type_need == current_ingot.type_metal)
						metal_allowed_list += SR
				var/datum/smithing_recipe/sel_recipe = input("Choose:", "What to forge?", null, null) as null|anything in metal_allowed_list
				if(!sel_recipe)
					to_chat(user, span_warning("You did not decide what to forge yet."))
					return
				if(current_ingot.recipe)
					to_chat(user, span_warning("Too late to change your mind."))
					return
				current_ingot.recipe = new sel_recipe.type()
				current_ingot.recipe.max_resulting = H.mind.get_skill_modifier(/datum/skill/smithing, SKILL_RANDS_MODIFIER)
				playsound(src, 'dwarfs/sounds/anvil_hit.ogg', 70, TRUE)
				to_chat(user, span_notice("You begin to forge..."))
				return
		else
			to_chat(user, span_warning("Nothing to forge here."))
			return

	if(istype(I, /obj/item/blacksmith/tongs))
		if(current_ingot)
			if(I.contents.len)
				to_chat(user, span_warning("You are already holding something!"))
				return
			else
				if(current_ingot.heattemp > 0)
					I.icon_state = "tongs_hot"
				else
					I.icon_state = "tongs_cold"
				current_ingot.forceMove(I)
				current_ingot = null
				icon_state = "[initial(icon_state)]"
				to_chat(user, span_notice("You grab the ingot with \the [I]."))
				return
		else
			if(I.contents.len)
				if(current_ingot)
					to_chat(user, span_warning("You are already holding \a [current_ingot]."))
					return
				var/obj/item/blacksmith/ingot/N = I.contents[I.contents.len]
				if(N.heattemp > 0)
					icon_state = "[initial(icon_state)]_hot"
				else
					icon_state = "[initial(icon_state)]_cold"
				N.forceMove(src)
				current_ingot = N
				I.icon_state = "tongs"
				to_chat(user, span_notice("You place \the [current_ingot] onto \the [src]."))
				return
			else
				to_chat(user, span_warning("Nothing to grab with [I]."))
				return
	return ..()
