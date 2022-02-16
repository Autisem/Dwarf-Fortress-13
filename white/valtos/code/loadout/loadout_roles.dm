
/datum/gear/roles
	sort_category = "Роли"
	var/job_path = null

/datum/gear/roles/purchase(client/C)
	C?.prefs?.jobs_buyed += job_path
	C?.prefs?.save_preferences()
	return TRUE
