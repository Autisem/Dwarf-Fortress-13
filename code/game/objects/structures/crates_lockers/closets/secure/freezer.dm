/obj/structure/closet/secure_closet/freezer
	icon_state = "freezer"
	var/jones = FALSE

/obj/structure/closet/secure_closet/freezer/Destroy()
	recursive_organ_check(src)
	..()

/obj/structure/closet/secure_closet/freezer/Initialize()
	. = ..()
	recursive_organ_check(src)

/obj/structure/closet/secure_closet/freezer/open(mob/living/user, force = FALSE)
	if(opened || !can_open(user, force))	//dupe check just so we don't let the organs decay when someone fails to open the locker
		return FALSE
	recursive_organ_check(src)
	return ..()

/obj/structure/closet/secure_closet/freezer/close(mob/living/user)
	if(..())	//if we actually closed the locker
		recursive_organ_check(src)

/obj/structure/closet/secure_closet/freezer/ex_act()
	if(!jones)
		jones = TRUE
	else
		..()
