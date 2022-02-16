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

	//Vents
	if(ventcrawler)
		to_chat(src, span_notice("Есть возможность ползать по трубам! Используй alt+клик на вентиляции/вытяжке и попадёшь во внутрь."))

	med_hud_set_status()

	update_fov_client()

/mob/living/carbon/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	if(HAS_TRAIT(src, TRAIT_CLIENT_LEAVED))
		REMOVE_TRAIT(src, TRAIT_CLIENT_LEAVED, "ice_cream")

		var/list/spawners = GLOB.mob_spawners[real_name]
		LAZYREMOVE(spawners, src)
		if(!LAZYLEN(spawners))
			GLOB.mob_spawners -= real_name
	else
		ice_cream_mob_time = client?.prefs?.ice_cream_time
		ice_cream_mob = client?.prefs?.ice_cream
