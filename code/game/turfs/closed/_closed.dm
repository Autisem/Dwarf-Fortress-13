/turf/closed
	layer = CLOSED_TURF_LAYER
	opacity = TRUE
	density = TRUE
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	pass_flags_self = PASSCLOSEDTURF
	gender = FEMALE

/turf/closed/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE

/turf/closed/indestructible
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	explosion_block = 50

/turf/closed/indestructible/black
	name = "emptiness"
	desc = "It look back at you."
	icon_state = "black"
	layer = FLY_LAYER
	bullet_bounce_sound = null
	baseturfs = /turf/closed/indestructible/black

/turf/closed/indestructible/black/New()
	return

/turf/closed/indestructible/TerraformTurf(path, new_baseturf, flags, defer_change = FALSE, ignore_air = FALSE)
	return

/turf/closed/indestructible/acid_act(acidpwr, acid_volume, acid_id)
	return FALSE

/turf/closed/indestructible/Melt()
	return src

/turf/closed/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/turf/turf_one = SSmapping.get_turf_above(get_turf(user))
	var/turf/turf_two = SSmapping.get_turf_above(src)
	playsound(src, 'sound/weapons/genhit.ogg', 25, TRUE)
	add_fingerprint(user)
	if(isopenspace(turf_one))
		if(do_after(user, 3 SECONDS, target = src))
			if(isopenturf(turf_two))
				user.forceMove(turf_two)
				if(!HAS_TRAIT(user, TRAIT_FREERUNNING))
					if(ishuman(user))
						var/mob/living/carbon/human/H = user
						H.adjustStaminaLoss(60)
						H.set_resting(TRUE)
					to_chat(user, span_notice("You climb up the wall..."))
					return
			user.movement_type |= FLYING
			user.forceMove(turf_one)
			to_chat(user, span_notice("You carefully climb up the wall..."))
			var/time_to_fall = 1 SECONDS
			if(!HAS_TRAIT(user, TRAIT_FREERUNNING))
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					H.adjustStaminaLoss(60)
			else
				time_to_fall = 2 SECONDS
			spawn(time_to_fall)
				user.movement_type &= ~FLYING
				var/turf/feetson = get_turf(user)
				if(isgroundlessturf(feetson))
					feetson.zFall(user)
	else
		to_chat(user, span_notice("You push the wall but nothing happens!"))

/turf/closed/indestructible/splashscreen
	name = "Dwarf Fortress"
	icon = 'icons/runtime/default_title.dmi'
	icon_state = "station_intact"
	plane = SPLASHSCREEN_PLANE
	bullet_bounce_sound = null
	maptext_height = 480
	maptext_width = 608
	maptext_x = 4
	maptext_y = 8

/turf/closed/indestructible/splashscreen/Initialize(mapload)
	. = ..()
	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/title_screens = list()
	var/file_path
	for(var/S in provisional_title_screens)
		var/list/L = splittext(S,"+")
		if((L.len == 1 && (L[1] != "exclude" && L[1] != "blank.png")))
			title_screens += S

	if(length(title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(title_screens)]"

	if(!file_path)
		file_path = "icons/runtime/default_title.dmi"

	ASSERT(fexists(file_path))

	var/icon/I = new(fcopy_rsc(file_path))
	icon = I

