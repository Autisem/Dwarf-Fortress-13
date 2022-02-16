/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "pizzabox"
	base_icon_state = "pizzabox"
	inhand_icon_state = "pizzabox"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	custom_materials = list(/datum/material/cardboard = 2000)

	var/open = FALSE
	var/can_open_on_fall = TRUE //if FALSE, this pizza box will never open if it falls from a stack
	var/boxtag = ""
	///Used to make sure artisinal box tags aren't overwritten.
	var/boxtag_set = FALSE
	var/list/boxes = list()

	var/obj/item/food/pizza/pizza

/obj/item/pizzabox/Initialize(mapload)
	. = ..()
	if(pizza)
		pizza = new pizza
	update_appearance()


/obj/item/pizzabox/Destroy()
	unprocess()
	return ..()

/obj/item/pizzabox/update_desc()
	desc = initial(desc)
	. = ..()
	if(pizza && pizza.boxtag && !boxtag_set)
		boxtag = pizza.boxtag
		boxtag_set = TRUE
	if(open)
		if(pizza)
			desc = "[desc] It appears to have \a [pizza] inside. Use your other hand to take it out."
	else
		var/obj/item/pizzabox/box = boxes.len ? boxes[boxes.len] : src
		if(boxes.len)
			desc = "A pile of boxes suited for pizzas. There appear to be [boxes.len + 1] boxes in the pile."
		if(box.boxtag != "")
			desc = "[desc] The [boxes.len ? "top box" : "box"]'s tag reads: [box.boxtag]"

/obj/item/pizzabox/update_icon_state()
	if(!open)
		icon_state = "[base_icon_state]"
		return ..()

	icon_state = pizza ? "[base_icon_state]_messy" : "[base_icon_state]_open"
	return ..()

/obj/item/pizzabox/update_overlays()
	. = ..()
	if(open)
		if(pizza)
			var/mutable_appearance/pizza_overlay = mutable_appearance(pizza.icon, pizza.icon_state)
			pizza_overlay.pixel_y = -2
			. += pizza_overlay
		return

	var/box_offset = 0
	for(var/stacked_box in boxes)
		box_offset += 3
		var/obj/item/pizzabox/box = stacked_box
		var/mutable_appearance/box_overlay = mutable_appearance(box.icon, box.icon_state)
		box_overlay.pixel_y = box_offset
		. += box_overlay

	var/obj/item/pizzabox/box = LAZYLEN(boxes.len) ? boxes[boxes.len] : src
	if(box.boxtag != "")
		var/mutable_appearance/tag_overlay = mutable_appearance(icon, "pizzabox_tag")
		tag_overlay.pixel_y = box_offset
		. += tag_overlay

/obj/item/pizzabox/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	var/current_offset = 2
	if(!isinhands)
		return

	for(var/V in boxes) //add EXTRA BOX per box
		var/mutable_appearance/M = mutable_appearance(icon_file, inhand_icon_state)
		M.pixel_y = current_offset
		current_offset += 2
		. += M

/obj/item/pizzabox/attack_self(mob/user)
	if(boxes.len > 0)
		return
	open = !open
	if(!open && !pizza)
		var/obj/item/stack/sheet/cardboard/cardboard = new /obj/item/stack/sheet/cardboard(user.drop_location())
		to_chat(user, span_notice("You fold [src] into [cardboard]."))
		user.put_in_active_hand(cardboard)
		qdel(src)
		return
	update_appearance()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/pizzabox/attack_hand(mob/user, list/modifiers)
	if(user.get_inactive_held_item() != src)
		return ..()
	if(open)
		if(pizza)
			user.put_in_hands(pizza)
			to_chat(user, span_notice("You take [pizza] out of [src]."))
			pizza = null
			update_appearance()
	else if(boxes.len)
		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		boxes -= topbox
		user.put_in_hands(topbox)
		to_chat(user, span_notice("You remove the topmost [name] from the stack."))
		topbox.update_appearance()
		update_appearance()
		user.regenerate_icons()

/obj/item/pizzabox/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pizzabox))
		var/obj/item/pizzabox/newbox = I
		if(!open && !newbox.open)
			var/list/add = list()
			add += newbox
			add += newbox.boxes
			if(!user.transferItemToLoc(newbox, src))
				return
			boxes += add
			newbox.boxes.Cut()
			to_chat(user, span_notice("You put [newbox] on top of [src]!"))
			newbox.update_appearance()
			update_appearance()
			user.regenerate_icons()
			if(boxes.len >= 5)
				if(prob(10 * boxes.len))
					to_chat(user, span_danger("You can't keep holding the stack!"))
					disperse_pizzas()
				else
					to_chat(user, span_warning("The stack is getting a little high..."))
			return
		else
			to_chat(user, span_notice("Close [open ? src : newbox] first!"))
	else if(istype(I, /obj/item/food/pizza))
		if(open)
			if(pizza)
				to_chat(user, span_warning("[src] already has \a [pizza.name]!"))
				return
			if(!user.transferItemToLoc(I, src))
				return
			pizza = I
			to_chat(user, span_notice("You put [I] in [src]."))
			update_appearance()
			return
	else if(istype(I, /obj/item/pen))
		if(!open)
			if(!user.is_literate())
				to_chat(user, span_notice("You scribble illegibly on [src]!"))
				return
			var/obj/item/pizzabox/box = boxes.len ? boxes[boxes.len] : src
			box.boxtag += stripped_input(user, "Write on [box] tag:", box, "", 30)
			if(!user.canUseTopic(src, BE_CLOSE))
				return
			to_chat(user, span_notice("You write with [I] on [src]."))
			update_appearance()
			return
	else if(istype(I, /obj/item/reagent_containers/food))
		to_chat(user, span_warning("That's not a pizza!"))
	..()

/obj/item/pizzabox/attack(mob/living/target, mob/living/user, def_zone)
	. = ..()
	if(boxes.len >= 3 && prob(25 * boxes.len))
		disperse_pizzas()

/obj/item/pizzabox/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(boxes.len >= 2 && prob(20 * boxes.len))
		disperse_pizzas()

/obj/item/pizzabox/examine(mob/user)
	. = ..()
	if(isobserver(user))
		if(pizza && istype(pizza, /obj/item/food/pizza/margherita/robo))
			. += span_deadsay("The pizza in this pizza box contains nanomachines.")

/obj/item/pizzabox/proc/disperse_pizzas()
	visible_message(span_warning("The pizzas fall everywhere!"))
	for(var/V in boxes)
		var/obj/item/pizzabox/P = V
		var/fall_dir = pick(GLOB.alldirs)
		step(P, fall_dir)
		if(P.pizza && P.can_open_on_fall && prob(50)) //rip pizza
			P.open = TRUE
			P.pizza.forceMove(get_turf(P))
			fall_dir = pick(GLOB.alldirs)
			step(P.pizza, fall_dir)
			P.pizza = null
			P.update_appearance()
		boxes -= P
	update_appearance()
	if(isliving(loc))
		var/mob/living/L = loc
		L.regenerate_icons()

/obj/item/pizzabox/proc/unprocess()
	STOP_PROCESSING(SSobj, src)
	qdel(wires)
	wires = null
	update_appearance()

/obj/item/pizzabox/margherita
	pizza = /obj/item/food/pizza/margherita

/obj/item/pizzabox/margherita/robo
	pizza = /obj/item/food/pizza/margherita/robo

/obj/item/pizzabox/vegetable
	pizza = /obj/item/food/pizza/vegetable

/obj/item/pizzabox/mushroom
	pizza = /obj/item/food/pizza/mushroom

/obj/item/pizzabox/meat
	pizza = /obj/item/food/pizza/meat

/obj/item/pizzabox/pineapple
	pizza = /obj/item/food/pizza/pineapple
