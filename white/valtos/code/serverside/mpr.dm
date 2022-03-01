/// The defines for the appropriate config files
#define WHITE_MENTOR_CONFIG_FILE "[global.config.directory]/mentors.txt"
#define WHITE_EXRP_CONFIG_FILE "[global.config.directory]/whitelist_exrp.txt"

/// The list of the available special player ranks
#define WHITE_PLAYER_RANKS list("Mentor", "EXRP")

/client/proc/manage_player_ranks()
	set category = "Особенное"
	set name = "Manage Player Ranks"
	set desc = "Manage who has the special player ranks while the server is running."
	if(!check_rights(R_PERMISSIONS))
		return
	usr.client.holder.manage_player_ranks()

/// Proc for admins to change people's "player" ranks (donator, mentor, veteran, etc.)
/datum/admins/proc/manage_player_ranks()
	if(!check_rights(R_PERMISSIONS))
		return

	var/choice = tgui_alert(usr, "Which rank would you like to manage?", "Manage Player Ranks", WHITE_PLAYER_RANKS+"Cancel")
	if(!choice || !(choice in WHITE_PLAYER_RANKS))
		return

	manage_player_rank_in_group(choice)

/// Proc that helps a bit with repetition, basically an extension of `manage_player_ranks()`
/datum/admins/proc/manage_player_rank_in_group(group)
	if(!(group in WHITE_PLAYER_RANKS))
		CRASH("[key_name(usr)] attempted to add someone to an invalid \"[group]\" group.")

	var/group_title = lowertext(group)

	var/list/choices = list("Add", "Remove")
	switch(tgui_alert(usr, "What would you like to do?", "Manage [group]s", choices))
		if("Add")
			var/name = input(usr, "Please enter the CKEY (case-insensitive) of the person you would like to make a [group_title]:", "Add a [group_title]") as null|text
			if(!name)
				return

			var/player_to_be = ckey(name)
			if(!player_to_be)
				to_chat(usr, span_warning("\"[name]\" is not a valid CKEY."))
				return

			switch(group)
				if("Mentor")
					return
				if("EXRP")
					for(var/a_exrp as anything in GLOB.whitelist_exrp)
						if(player_to_be == a_exrp)
							to_chat(usr, span_warning("\"[player_to_be]\" is already a [group_title]!"))
							return
					// Now that we know that the ckey is valid and they're not already apart of that group, let's add them to it!
					GLOB.whitelist_exrp[player_to_be] = TRUE
					text2file(player_to_be, WHITE_EXRP_CONFIG_FILE)
				else
					return

			message_admins("[key_name(usr)] has granted [group_title] status to [player_to_be].")
			log_admin_private("[key_name(usr)] has granted [group_title] status to [player_to_be].")


		if("Remove")
			var/name = input(usr, "Please enter the CKEY (case-insensitive) of the person you would like to no longer be a [group_title]:", "Remove a [group_title]") as null|text
			if(!name)
				return

			var/player_that_was = ckey(name)
			if(!player_that_was)
				to_chat(usr, span_warning("\"[name]\" is not a valid CKEY."))
				return

			var/changes = FALSE
			switch(group)
				if("Mentor")
					return
				if("EXRP")
					for(var/a_exrp as anything in GLOB.whitelist_exrp)
						if(player_that_was == a_exrp)
							GLOB.whitelist_exrp -= player_that_was
							changes = TRUE
					if(!changes)
						to_chat(usr, span_warning("\"[player_that_was]\" was already not a [group_title]."))
						return
					save_exrp_players()
				else
					return
			message_admins("[key_name(usr)] has revoked [group_title] status from [player_that_was].")
			log_admin_private("[key_name(usr)] has revoked [group_title] status from [player_that_was].")

		else
			return

/proc/save_exrp_players()
	var/exrp_list = ""
	for(var/exrp in GLOB.whitelist_exrp)
		exrp_list += exrp + "\n"
	rustg_file_write(exrp_list, WHITE_EXRP_CONFIG_FILE)

#undef WHITE_MENTOR_CONFIG_FILE
#undef WHITE_EXRP_CONFIG_FILE
#undef WHITE_PLAYER_RANKS

