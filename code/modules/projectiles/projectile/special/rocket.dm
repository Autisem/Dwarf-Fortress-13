/obj/projectile/bullet/gyro
	name ="взрывной заряд"
	icon_state= "bolter"
	damage = 50
	embedding = null
	shrapnel_type = null

/obj/projectile/bullet/gyro/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 0, 2)
	return BULLET_ACT_HIT

/// PM9 HEDP rocket
/obj/projectile/bullet/a84mm
	name ="\improper HEDP ракета"
	desc = "USE A WEEL GUN"
	icon_state= "84mm-hedp"
	damage = 80
	var/anti_armour_damage = 200
	armour_penetration = 100
	dismemberment = 100
	embedding = null
	shrapnel_type = null

/obj/projectile/bullet/a84mm/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 1, 3, 1, 0, flame_range = 4)
	return BULLET_ACT_HIT

/// PM9 standard rocket
/obj/projectile/bullet/a84mm_he
	name ="\improper HE ракета"
	desc = "Бабах."
	icon_state = "missile"
	damage = 50
	ricochets_max = 0 //it's a MISSILE
	embedding = null
	shrapnel_type = null

/obj/projectile/bullet/a84mm_he/on_hit(atom/target, blocked=0)
	..()
	if(!isliving(target)) //if the target isn't alive, so is a wall or something
		explosion(target, 0, 1, 2, 4, flame_range = 3)
	else
		explosion(target, 0, 0, 2, 4, flame_range = 3)
	return BULLET_ACT_HIT

/// PM9 weak rocket
/obj/projectile/bullet/a84mm_weak
	name ="low-yield HE missile"
	desc = "Бабах, но поменьше."
	icon_state = "missile"
	damage = 30
	ricochets_max = 0 //it's a MISSILE
	embedding = null
	shrapnel_type = null

/obj/projectile/bullet/a84mm_weak/on_hit(atom/target, blocked=0)
	..()
	if(!isliving(target)) //if the target isn't alive, so is a wall or something
		explosion(target, 0, 1, 2, 4, flame_range = 3)
	else
		explosion(target, 0, 0, 2, 4, flame_range = 3)
	return BULLET_ACT_HIT

/// Mech BRM-6 missile
/obj/projectile/bullet/a84mm_br
	name ="\improper HE ракета"
	desc = "Бабах."
	icon_state = "missile"
	damage = 30
	ricochets_max = 0 //it's a MISSILE
	embedding = null
	shrapnel_type = null
	var/sturdy = list(
	/turf/closed,
	)

/obj/item/broken_missile
	name = "\improper сломанная ракета"
	desc = "Не сдетонировавшая ракета. Хвост сломался и использовать её повторно не получится."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "missile_broken"
	w_class = WEIGHT_CLASS_TINY


/obj/projectile/bullet/a84mm_br/on_hit(atom/target, blocked=0)
	..()
	for(var/i in sturdy)
		if(istype(target, i))
			explosion(target, 0, 1, 1, 2)
			return BULLET_ACT_HIT
	new /obj/item/broken_missile(get_turf(src), 1)
