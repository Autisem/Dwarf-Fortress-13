/obj/item/stack/spacecash  //Don't use base space cash stacks. Any other space cash stack can merge with them, and could cause potential money duping exploits.
	name = "космоденьги"
	singular_name = "bill"
	icon = 'icons/obj/economy.dmi'
	icon_state = null
	amount = 1
	max_amount = INFINITY
	throwforce = 0
	throw_speed = 2
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/value = 0
	grind_results = list(/datum/reagent/cellulose = 10)

/obj/item/stack/spacecash/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	update_desc()

/obj/item/stack/spacecash/update_desc()
	var/total_worth = get_item_credit_value()
	desc = "Этот в номинале [total_worth] кредит[get_num_string(total_worth)]."
	return ..()

/obj/item/stack/spacecash/proc/get_item_credit_value()
	return (amount*value)

/obj/item/stack/spacecash/merge(obj/item/stack/S)
	. = ..()
	update_desc()

/obj/item/stack/spacecash/use(used, transfer = FALSE, check = TRUE)
	. = ..()
	update_desc()

/obj/item/stack/spacecash/update_icon_state()
	. = ..()
	switch(amount)
		if(1)
			icon_state = initial(icon_state)
		if(2 to 9)
			icon_state = "[initial(icon_state)]_2"
		if(10 to 24)
			icon_state = "[initial(icon_state)]_3"
		if(25 to INFINITY)
			icon_state = "[initial(icon_state)]_4"

/obj/item/stack/spacecash/c1
	icon_state = "spacecash1"
	singular_name = "один кредит"
	value = 1
	merge_type = /obj/item/stack/spacecash/c1

/obj/item/stack/spacecash/c10
	icon_state = "spacecash10"
	singular_name = "десять кредитов"
	value = 10
	merge_type = /obj/item/stack/spacecash/c10

/obj/item/stack/spacecash/c20
	icon_state = "spacecash20"
	singular_name = "двадцать кредитов"
	value = 20
	merge_type = /obj/item/stack/spacecash/c20

/obj/item/stack/spacecash/c50
	icon_state = "spacecash50"
	singular_name = "пятьдесят кредитов"
	value = 50
	merge_type = /obj/item/stack/spacecash/c50

/obj/item/stack/spacecash/c100
	icon_state = "spacecash100"
	singular_name = "сто кредитов"
	value = 100
	merge_type = /obj/item/stack/spacecash/c100

/obj/item/stack/spacecash/c200
	icon_state = "spacecash200"
	singular_name = "две сотни кредитов"
	value = 200
	merge_type = /obj/item/stack/spacecash/c200

/obj/item/stack/spacecash/c500
	icon_state = "spacecash500"
	singular_name = "пять сотен кредитов"
	value = 500
	merge_type = /obj/item/stack/spacecash/c500

/obj/item/stack/spacecash/c1000
	icon_state = "spacecash1000"
	singular_name = "тысяча кредитов"
	value = 1000
	merge_type = /obj/item/stack/spacecash/c1000

/obj/item/stack/spacecash/c10000
	icon_state = "spacecash10000"
	singular_name = "десять тысяч кредитов"
	value = 10000
	merge_type = /obj/item/stack/spacecash/c10000
