/mob/living/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	//Mind updates
	sync_mind()
	mind.show_memory(src, 0)

	update_damage_hud()
	update_health_hud()

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

	med_hud_set_status()

	update_fov_client()

/mob/living/carbon/Login()
	. = ..()
	if(!. || !client)
		return FALSE
