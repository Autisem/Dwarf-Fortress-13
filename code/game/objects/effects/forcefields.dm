/obj/effect/forcefield
	desc = "A wizard's magic wall."
	name = "FORCEWALL"
	icon_state = "m_shield"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	var/timeleft = 300 //Set to 0 for permanent forcefields (ugh)

/obj/effect/forcefield/Initialize(mapload)
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft)
