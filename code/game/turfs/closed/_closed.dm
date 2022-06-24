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
				var/obstacles = FALSE
				for(var/obj/O in turf_two)
					if(O.density && (istype(O, /obj/structure/window)))
						obstacles = TRUE
				if(!obstacles)
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

/turf/closed/indestructible/oldshuttle
	name = "странная челночная стена"
	icon = 'icons/turf/shuttleold.dmi'
	icon_state = "block"

/turf/closed/indestructible/sandstone
	name = "песчаниковая стена"
	desc = "A wall with sandstone plating. Rough."
	icon = 'icons/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone_wall-0"
	base_icon_state = "sandstone_wall"
	baseturfs = /turf/closed/indestructible/sandstone
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/oldshuttle/corner
	icon_state = "corner"

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

/turf/closed/indestructible/reinforced
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to separate rooms. Effectively impervious to conventional methods of destruction."
	icon = 'icons/turf/walls/rbaywall.dmi'
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS)

/turf/closed/indestructible/riveted
	icon = 'icons/turf/walls/riveted.dmi'
	icon_state = "riveted-0"
	base_icon_state = "riveted"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)

/turf/closed/indestructible/syndicate
	name = "пластитановая стена"
	desc = "Зловещая стена со пластитановым покрытием."
	icon = 'icons/turf/walls/plastitanium_wall.dmi'
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SYNDICATE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SYNDICATE_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS)

/turf/closed/indestructible/riveted/uranium
	icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium_wall-0"
	base_icon_state = "uranium_wall"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/riveted/plastinum
	name = "plastinum wall"
	desc = "A luxurious wall made out of a plasma-platinum alloy. Effectively impervious to conventional methods of destruction."
	icon = 'icons/turf/walls/plastinum_wall.dmi'
	icon_state = "plastinum_wall-0"
	base_icon_state = "plastinum_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS

/turf/closed/indestructible/wood
	icon = 'icons/turf/walls/wood_wall.dmi'
	icon_state = "wood_wall-0"
	base_icon_state = "wood_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WOOD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WOOD_WALLS)


/turf/closed/indestructible/alien
	name = "alien wall"
	desc = "A wall with alien alloy plating."
	icon = 'icons/turf/walls/abductor_wall.dmi'
	icon_state = "abductor_wall-0"
	base_icon_state = "abductor_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ABDUCTOR_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ABDUCTOR_WALLS)


/turf/closed/indestructible/cult
	name = "runed metal wall"
	desc = "A cold metal wall engraved with indecipherable symbols. Studying them causes your head to pound. Effectively impervious to conventional methods of destruction."
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult_wall-0"
	base_icon_state = "cult_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS)


/turf/closed/indestructible/abductor
	icon_state = "alien1"

/turf/closed/indestructible/opshuttle
	icon_state = "wall3"


/turf/closed/indestructible/fakeglass
	name = "окно"
	icon = 'icons/obj/smooth_structures/reinforced_window.dmi'
	icon_state = "fake_window"
	base_icon_state = "reinforced_window"
	opacity = FALSE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE)

/turf/closed/indestructible/fakeglass/Initialize()
	. = ..()
	underlays += mutable_appearance('icons/obj/structures.dmi', "grille") //add a grille underlay
	underlays += mutable_appearance('icons/turf/floors.dmi', "plating") //add the plating underlay, below the grille

/turf/closed/indestructible/opsglass
	name = "окно"
	icon = 'icons/obj/smooth_structures/plastitanium_window.dmi'
	icon_state = "plastitanium_window-0"
	base_icon_state = "plastitanium_window"
	opacity = FALSE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)

/turf/closed/indestructible/opsglass/Initialize()
	. = ..()
	icon_state = null
	underlays += mutable_appearance('icons/obj/structures.dmi', "grille")
	underlays += mutable_appearance('icons/turf/floors.dmi', "plating")

/turf/closed/indestructible/fakedoor
	name = "CentCom Access"
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	icon_state = "fake_door"

/turf/closed/indestructible/rock
	name = "плотная скала"
	desc = "Чрезвычайно плотная порода, большинство горнодобывающих орудий и взрывчатых веществ никогда не пройдет сквозь нее."
	icon = 'icons/turf/mining.dmi'
	icon_state = "rock"

/turf/closed/indestructible/rock/snow
	name = "склон горы"
	desc = "Чрезвычайно плотная скала, покрытая льдом и снегом на протяжении столетий."
	icon = 'icons/turf/walls.dmi'
	icon_state = "snowrock"
	bullet_sizzle = TRUE
	bullet_bounce_sound = null

/turf/closed/indestructible/rock/snow/ice
	name = "ледяной камень"
	desc = "Чрезвычайно плотно заполненные ледяные и скальные покровы, выкованные за годы сильного холода."
	icon = 'icons/turf/walls.dmi'
	icon_state = "icerock"

/turf/closed/indestructible/rock/snow/ice/ore
	icon = 'icons/turf/walls/icerock_wall.dmi'
	icon_state = "icerock_wall-0"
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)
	pixel_x = -4
	pixel_y = -4


/turf/closed/indestructible/paper
	name = "толстая бумажная стена"
	desc = "Стена, покрытая непроницаемыми листами бумаги."
	icon = 'icons/turf/walls.dmi'
	icon_state = "paperwall"

/turf/closed/indestructible/necropolis
	name = "стена некрополя"
	desc = "Казалось бы, непробиваемая стена."
	icon = 'icons/turf/walls.dmi'
	icon_state = "necro"
	explosion_block = 50
	baseturfs = /turf/closed/indestructible/necropolis

/turf/closed/indestructible/necropolis/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "necro1"
	return TRUE

/turf/closed/indestructible/iron
	name = "impervious iron wall"
	desc = "A wall with tough iron plating."
	icon = 'icons/turf/walls/iron_wall.dmi'
	icon_state = "iron_wall-0"
	base_icon_state = "iron_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_IRON_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_IRON_WALLS)
	opacity = FALSE

/turf/closed/indestructible/riveted/boss
	name = "стена некрополя"
	desc = "Толстая, казалось бы, неразрушимая каменная стена."
	icon = 'icons/turf/walls/boss_wall.dmi'
	icon_state = "boss_wall-0"
	base_icon_state = "boss_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_BOSS_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BOSS_WALLS)
	explosion_block = 50
	baseturfs = /turf/closed/indestructible/riveted/boss

/turf/closed/indestructible/riveted/boss/see_through
	opacity = FALSE

/turf/closed/indestructible/riveted/boss/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/closed/indestructible/riveted/hierophant
	name = "стена"
	desc = "Стена, сделанная из странного металла. Квадраты на нем пульсируют предсказуемым образом."
	icon = 'icons/turf/walls/hierophant_wall.dmi'
	icon_state = "wall"
	smoothing_flags = SMOOTH_CORNERS
	smoothing_groups = list(SMOOTH_GROUP_HIERO_WALL)
	canSmoothWith = list(SMOOTH_GROUP_HIERO_WALL)
