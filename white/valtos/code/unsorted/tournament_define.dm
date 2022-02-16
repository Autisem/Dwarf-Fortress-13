
// Для турниров

/client/proc/toggle_tournament_rules()
	set name = "ПЕРЕКЛЮЧИТЬ РЕЖИМ ТУРНИРА"
	set category = "Особенное"

	GLOB.is_tournament_rules = !GLOB.is_tournament_rules

	if(GLOB.is_tournament_rules)
		for(var/mob/M in GLOB.player_list)
			M.hud_used.update_parallax_pref(M, 1)
			SEND_SOUND(M, sound('white/valtos/sounds/impact.ogg'))

		if(SSticker.current_state == GAME_STATE_PREGAME)
			for(var/mob/dead/new_player/player in GLOB.player_list)
				to_chat(player, "<span class=greenannounce>Ты призрак. Скоро предоставят возможность вступить в схватку.</span>")
				player.ready = FALSE
				player.make_me_an_observer(TRUE)
			SSticker.start_immediately = TRUE

	to_chat(world, "\n\n<span class='revenbignotice'><center>Турнирный режим теперь <b>[GLOB.is_tournament_rules ? "ВКЛЮЧЕН" : "ОТКЛЮЧЕН"]</b>.</center></span>\n\n")
	message_admins("[ADMIN_LOOKUPFLW(usr)] переключает режимммм турнира в положение [GLOB.is_tournament_rules ? "ВКЛ" : "ВЫКЛ"].")
	log_admin("[key_name(usr)] переключает режимммм турнира в положение [GLOB.is_tournament_rules ? "ВКЛ" : "ВЫКЛ"].")

// Турнирные предметы

/obj/item/storage/toolbox/tournament
	name = "турбокс"
	desc = "Урон от удара и броска 15."
	force = 15
	throwforce = 15

/obj/item/extinguisher/tournament
	name = "огнетуршитель"
	desc = "Урон от удара и броска 10."
	throwforce = 10
	force = 10
	can_explode = FALSE

/obj/item/extinguisher/tournament/babah
	name = "огнетуршитель-БАБАХ"
	desc = "Урон от удара и броска 10. Может бабахнуть."
	can_explode = TRUE

/obj/item/stack/tile/plasteel/tournament
	name = "турплитка"
	desc = "Урон от удара 6. От броска 10."
	force = 6
	throwforce = 10
	amount = 50

/turf/open/floor/plasteel/tournament
	var/time_to_die = 3 // 3 секунды

/turf/open/floor/plasteel/tournament/Initialize(mapload)
	. = ..()
	spawn(time_to_die SECONDS)
		ChangeTurf(/turf/open/lava/smooth)

// Аутфиты

/datum/outfit/whiterobust/ass
	name = "Ассистуха"

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black
