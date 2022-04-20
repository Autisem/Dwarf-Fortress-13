/turf/open/floor/goonplaque
	name = "памятная доска"
	icon_state = "plaque"
	desc = "\"Это мемориальная доска в честь наших товарищей на станциях G4407. Надеюсь, модель TG4407 будет соответствовать вашей славе и богатству.\" Под ним грубое изображение метеорита и космонавта. Космонавт смеется. Метеорит взрывается."
	floor_tile = /obj/item/stack/tile/plasteel
	tiled_dirt = FALSE

/turf/open/floor/vault
	icon_state = "rockvault"
	floor_tile = /obj/item/stack/tile/plasteel

/turf/open/floor/pod
	name = "капсульный пол"
	icon_state = "podfloor"
	floor_tile = /obj/item/stack/tile/pod

/turf/open/floor/pod/light
	icon_state = "podfloor_light"
	floor_tile = /obj/item/stack/tile/pod/light

/turf/open/floor/pod/dark
	icon_state = "podfloor_dark"
	floor_tile = /obj/item/stack/tile/pod/dark


/turf/open/floor/noslip
	name = "высокопрочный пол"
	icon_state = "noslip"
	floor_tile = /obj/item/stack/tile/noslip
	slowdown = -0.3

/turf/open/floor/noslip/setup_broken_states()
	return list("noslip-damaged1","noslip-damaged2","noslip-damaged3")

/turf/open/floor/noslip/setup_burnt_states()
	return list("noslip-scorched1","noslip-scorched2")

/turf/open/floor/noslip/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/floor/oldshuttle
	icon = 'icons/turf/shuttleold.dmi'
	icon_state = "floor"
	floor_tile = /obj/item/stack/tile/plasteel


/turf/open/floor/bronze
	name = "латунный пол"
	desc = "Тяжелая латунная плитка."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "clockwork_floor"
	floor_tile = /obj/item/stack/tile/bronze

/turf/open/floor/white
	name = "белый пол"
	desc = "Плитка чистого белого цвета."
	icon_state = "pure_white"

/turf/open/floor/black
	name = "чёрный пол"
	icon_state = "black"

/turf/open/floor/plastic
	name = "пластмассовый пол"
	desc = "Дешевый, легкий пол. Легко плавится."
	icon_state = "plastic"
	floor_tile = /obj/item/stack/tile/plastic

/turf/open/floor/plastic/setup_broken_states()
	return list("plastic-damaged1","plastic-damaged2")

/turf/open/floor/eighties
	name = "ретро-пол"
	desc = "Этот вернёт тебя назад."
	icon_state = "eighties"
	floor_tile = /obj/item/stack/tile/eighties

/turf/open/floor/eighties/setup_broken_states()
	return list("eighties_damaged")

/turf/open/floor/eighties/red
	name = "красный ретро-пол"
	desc = "Totally RED-ICAL!"
	icon_state = "eightiesred"
	floor_tile = /obj/item/stack/tile/eighties/red

/turf/open/floor/eighties/red/setup_broken_states()
	return list("eightiesred_damaged")

/turf/open/floor/plating/rust
	//SDMM supports colors, this is simply for easier mapping
	//and should be removed on initialize
	color = COLOR_BROWN

/turf/open/floor/plating/rust/Initialize(mapload)
	. = ..()
	color = null

/turf/open/floor/plating/rust/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/rust)

/turf/open/floor/plating/plasma

/turf/open/floor/plating/plasma/rust/Initialize(mapload)
	. = ..()
	// Because this is a fluff turf explicitly for KiloStation it doesn't make sense to ChangeTurf like usual
	// Especially since it looks like we don't even change the default icon/iconstate???
	AddElement(/datum/element/rust)


/turf/open/floor/plating/rust
	name = "ржавая обшивка"
	desc = "НЕ безопасна."
	icon_state = "plating_rust"

/turf/open/floor/stone
	name = "stone brick floor"
	desc = "Odd, really, how it looks exactly like the iron walls yet is stone instead of iron. Now, if that's really more of a complaint about\
		the ironness of walls or the stoneness of the floors, that's really up to you. But have you really ever seen iron that dull? I mean, it\
		makes sense for the station to have dull metal walls but we're talking how a rudimentary iron wall would be. Medieval ages didn't even\
		use iron walls, iron walls are actually not even something that exists because iron is an expensive and not-so-great thing to build walls\
		out of. It only makes sense in the context of space because you're trying to keep a freezing vacuum out. Is anyone following me on this? \
		The idea of a \"rudimentary\" iron wall makes no sense at all! Is anything i'm even saying here true? Someone's gotta fact check this!"
	icon_state = "stone_floor"
