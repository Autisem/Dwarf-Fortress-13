//Acid rain is part of the natural weather cycle in the humid forests of Planetstation, and cause acid damage to anyone unprotected.
/datum/weather/acid_rain
	name = "acid rain"
	desc = "Грозы планеты по своей природе кислые и сожгут любого, кто стоит под ними без защиты."

	telegraph_duration = 400
	telegraph_message = span_boldwarning("Грохот гремит намного громче. Слышу, как капли стучат о купол. Нужно найти убежище.")
	telegraph_sound = 'sound/ambience/acidrain_start.ogg'

	weather_message = span_userdanger("<i>Кислотный дождь льет вокруг меня! В УКРЫТИЕ!</i>")
	weather_overlay = "acid_rain"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_sound = 'sound/ambience/acidrain_mid.ogg'

	end_duration = 100
	end_message = span_boldannounce("Ливень постепенно замедляется до легкого душа. На улице сейчас должно быть безопасно.")
	end_sound = 'sound/ambience/acidrain_end.ogg'

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_ACIDRAIN

	immunity_type = WEATHER_ACID // temp

	barometer_predictable = TRUE


/datum/weather/acid_rain/weather_act(mob/living/L)
	var/resist = L.getarmor(null, ACID)
	if(prob(max(0,100-resist)))
		L.acid_act(20,20)
