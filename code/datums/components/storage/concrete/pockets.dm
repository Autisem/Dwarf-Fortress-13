/datum/component/storage/concrete/pockets
	max_items = 2
	max_w_class = WEIGHT_CLASS_SMALL
	max_combined_w_class = 50
	rustle_sound = FALSE

/datum/component/storage/concrete/pockets/handle_item_insertion(obj/item/I, prevent_warning, mob/user)
	. = ..()
	if(. && silent && !prevent_warning)
		if(quickdraw)
			to_chat(user, span_notice("You discreetly slip [I] into [parent]. Right-click [parent] to remove it."))
		else
			to_chat(user, span_notice("You discreetly slip [I] into [parent]."))

/datum/component/storage/concrete/pockets/small
	max_items = 1
	max_w_class = WEIGHT_CLASS_SMALL
	attack_hand_interact = FALSE

/datum/component/storage/concrete/pockets/tiny
	max_items = 1
	max_w_class = WEIGHT_CLASS_TINY
	attack_hand_interact = FALSE

/datum/component/storage/concrete/pockets/small/fedora/Initialize()
	. = ..()
	var/static/list/exception_cache = typecacheof(list(
		/obj/item/gun/ballistic/automatic/tommygun
		))
	exception_hold = exception_cache

/datum/component/storage/concrete/pockets/small/fedora/detective
	attack_hand_interact = TRUE // so the detectives would discover pockets in their hats

/datum/component/storage/concrete/pockets/shoes
	attack_hand_interact = FALSE
	quickdraw = TRUE
	silent = TRUE

/datum/component/storage/concrete/pockets/shoes/Initialize()
	. = ..()
	set_holdable(list(
		/obj/item/kitchen/knife, /obj/item/pen,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/hypospray/medipen, /obj/item/reagent_containers/dropper,
		/obj/item/screwdriver, /obj/item/weldingtool/mini,
		/obj/item/firing_pin
		),
		list()
		)

/datum/component/storage/concrete/pockets/shoes/clown/Initialize()
	. = ..()
	set_holdable(list(
		/obj/item/kitchen/knife, /obj/item/pen,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/hypospray/medipen, /obj/item/reagent_containers/dropper,
		/obj/item/screwdriver, /obj/item/weldingtool/mini,
		/obj/item/firing_pin, /obj/item/bikehorn),
		list()
		)

/datum/component/storage/concrete/pockets/pocketprotector
	max_items = 3
	max_w_class = WEIGHT_CLASS_TINY
	var/atom/original_parent

/datum/component/storage/concrete/pockets/pocketprotector/Initialize()
	original_parent = parent
	. = ..()
	set_holdable(list( //Same items as a PDA
		/obj/item/pen,
		/obj/item/toy/crayon,
		/obj/item/lipstick,
		/obj/item/clothing/mask/cigarette)
		)

/datum/component/storage/concrete/pockets/pocketprotector/real_location()
	// if the component is reparented to a jumpsuit, the items still go in the protector
	return original_parent

/datum/component/storage/concrete/pockets/helmet
	quickdraw = TRUE
	max_combined_w_class = 6

/datum/component/storage/concrete/pockets/helmet/Initialize()
	. = ..()
	set_holdable(list(/obj/item/reagent_containers/food/drinks/bottle/vodka,
					  /obj/item/reagent_containers/food/drinks/bottle/molotov,
					  /obj/item/reagent_containers/food/drinks/drinkingglass,
					  /obj/item/ammo_box/a762))

/datum/component/storage/concrete/pockets/big
	max_items = 3
	max_w_class = WEIGHT_CLASS_NORMAL
	rustle_sound = TRUE
