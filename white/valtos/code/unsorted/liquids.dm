/obj/effect/liquid
	name = "жидкость"
	icon_state = "water"
	anchored = TRUE
	layer = TURF_LAYER
	obj_flags = BLOCK_Z_OUT_DOWN

/obj/effect/liquid/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

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
		if(isliving(A))
			// some logic here
			return
	else
		qdel(src)
		return

/obj/effect/liquid/magma
	name = "магма"
	icon = 'icons/turf/floors/lava.dmi'
	icon_state = "lava-255"

/obj/effect/liquid/magma/Initialize(mapload)
	. = ..()
	set_light(2, 1, LIGHT_COLOR_LAVA)

/obj/effect/liquid/magma/enter_this(atom/A)
	if(A == src)
		return
	var/turf/T = SSmapping.get_turf_below(get_turf(src))
	if(T && isopenturf(T))
		if(isliving(A))
			var/mob/living/L = A
			L.emote("agony")
			L.dust(TRUE, FALSE)
			return
		else if(isobj(A))
			var/obj/O = A
			O.burn()
		return
	else
		qdel(src)
		return
