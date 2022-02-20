/obj/item/damaz
	name = "Damaz"
	desc = "A book?"
	icon = 'white/rashcat/icons/dwarfs/objects/tools.dmi'
	icon_state = "damaz"

/obj/item/damaz/proc/can_use(mob/user)
	var/allowed = isdwarf(user)
	if(!allowed)
		to_chat(user, span_warning("Thy are not worthy!"))
	return allowed
