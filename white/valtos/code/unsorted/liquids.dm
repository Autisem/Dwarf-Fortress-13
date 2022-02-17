/obj/effect/liquid
	icon_state = "water"

/obj/effect/liquid/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, src, loc_connections)

/obj/effect/liquid/proc/on_entered(datum/source, atom/movable/movable_atom)
	SIGNAL_HANDLER
	enter_this(movable_atom)

/obj/effect/liquid/Bump(atom/bumped_atom)
	enter_this(bumped_atom)

/obj/effect/liquid/Bumped(atom/movable/movable_atom)
	enter_this(movable_atom)

/obj/effect/liquid/proc/enter_this(atom/A)
	if(A == src)
		return
	var/turf/T = SSmapping.get_turf_below(get_turf(src))
	if(T && isopenturf(T))
		if(ismob(A))
			A.AddElement(/datum/element/swimming)
			return
	else
		qdel(src)
		return

/obj/effect/liquid/magma
	icon_state = "magma"

/obj/effect/liquid/magma/Initialize(mapload)
	. = ..()
	set_light(2, 1, LIGHT_COLOR_LAVA)

/obj/effect/liquid/magma/enter_this(atom/A)
	if(A == src)
		return
	var/turf/T = SSmapping.get_turf_below(get_turf(src))
	if(T && isopenturf(T))
		if(ishuman(A))
			var/mob/living/L = A
			L.dust(TRUE, FALSE)
			return
	else
		qdel(src)
		return
