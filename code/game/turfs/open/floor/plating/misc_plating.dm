/turf/open/floor/plating/abductor
	name = "чужеродное покрытие"
	icon_state = "alienpod1"
	base_icon_state = "alienpod1"
	tiled_dirt = FALSE

/turf/open/floor/plating/abductor/setup_broken_states()
	return list("alienpod1")

/turf/open/floor/plating/abductor/Initialize()
	. = ..()
	icon_state = "alienpod[rand(1,9)]"


/turf/open/floor/plating/abductor2
	name = "чужеродное покрытие"
	icon_state = "alienplating"
	base_icon_state = "alienplating"
	tiled_dirt = FALSE

/turf/open/floor/plating/abductor2/break_tile()
	return //unbreakable

/turf/open/floor/plating/abductor2/burn_tile()
	return //unburnable

/turf/open/floor/plating/abductor2/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/ashplanet
	icon = 'icons/turf/mining.dmi'
	gender = PLURAL
	name = "пепел"
	icon_state = "ash"
	base_icon_state = "ash"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	desc = "Земля покрыта вулканическим пеплом."
	baseturfs = /turf/open/floor/plating/ashplanet/wateryrock //I assume this will be a chasm eventually, once this becomes an actual surface
	attachment_holes = FALSE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	var/smooth_icon = 'icons/turf/floors/ash.dmi'


/turf/open/floor/plating/ashplanet/Initialize()
	. = ..()
	if(smoothing_flags & SMOOTH_BITMASK)
		var/matrix/M = new
		M.Translate(-4, -4)
		transform = M
		icon = smooth_icon
		icon_state = "[icon_state]-[smoothing_junction]"


/turf/open/floor/plating/ashplanet/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/ashplanet/break_tile()
	return

/turf/open/floor/plating/ashplanet/burn_tile()
	return

/turf/open/floor/plating/ashplanet/ash
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_ASH)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_ASH, SMOOTH_GROUP_CLOSED_TURFS)
	layer = HIGH_TURF_LAYER
	slowdown = 1

/turf/open/floor/plating/ashplanet/rocky
	gender = PLURAL
	name = "каменистый грунт"
	icon_state = "rockyash"
	base_icon_state = "rocky_ash"
	smooth_icon = 'icons/turf/floors/rocky_ash.dmi'
	layer = MID_TURF_LAYER
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_ASH_ROCKY)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_ASH_ROCKY, SMOOTH_GROUP_CLOSED_TURFS)
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/ashplanet/wateryrock
	gender = PLURAL
	name = "мокренький каменистый грунт"
	smoothing_flags = NONE
	icon_state = "wateryrock"
	base_icon_state = "wateryrock"
	slowdown = 2
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/ashplanet/wateryrock/Initialize()
	icon_state = "[icon_state][rand(1, 9)]"
	. = ..()


/turf/open/floor/plating/beach
	name = "пляж"
	icon = 'icons/misc/beach.dmi'
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/beach/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/beach/ex_act(severity, target)
	contents_explosion(severity, target)

/turf/open/floor/plating/beach/sand
	gender = PLURAL
	name = "песок"
	desc = "Занимайся серфингом."
	icon_state = "sand"
	base_icon_state = "sand"
	baseturfs = /turf/open/floor/plating/beach/sand

/turf/open/floor/plating/beach/sand/setup_broken_states()
	return list("sand")

/turf/open/floor/plating/beach/coastline_t
	name = "побережье"
	desc = "Сегодня сильный прилив. Заряжай дубинки."
	icon_state = "sandwater_t"
	base_icon_state = "sandwater_t"
	baseturfs = /turf/open/floor/plating/beach/coastline_t

/turf/open/floor/plating/beach/sand/coastline_t/setup_broken_states()
	return list("sandwater_t")

/turf/open/floor/plating/beach/coastline_b //need to make this water subtype.
	name = "побережье"
	icon_state = "sandwater_b"
	base_icon_state = "sandwater_b"
	baseturfs = /turf/open/floor/plating/beach/coastline_b
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA

/turf/open/floor/plating/beach/sand/coastline_b/setup_broken_states()
	return list("sandwater_b")

/turf/open/floor/plating/beach/water
	gender = PLURAL
	name = "вода"
	desc = "У меня такое ощущение, что никто не заботится о том, чтобы эта вода наконец была настоящей водой..."
	icon_state = "water"
	base_icon_state = "water"
	baseturfs = /turf/open/floor/plating/beach/water
	footstep = FOOTSTEP_LAVA //placeholder, kinda.
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA

/turf/open/floor/plating/beach/water/setup_broken_states()
	return list("water")

/turf/open/floor/plating/beach/coastline_t/sandwater_inner
	icon_state = "sandwater_inner"
	baseturfs = /turf/open/floor/plating/beach/coastline_t/sandwater_inner

/turf/open/floor/plating/beach/coastline_t/sandwater_inner/setup_broken_states()
	return list("sandwater_inner")

/turf/open/floor/plating/ironsand
	gender = PLURAL
	name = "железный песок"
	desc = "Как песок, но только <i>металлический</i>."
	icon_state = "ironsand1"
	base_icon_state = "ironsand1"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/ironsand/setup_broken_states()
	return list("ironsand1")

/turf/open/floor/plating/ironsand/Initialize()
	. = ..()
	icon_state = "ironsand[rand(1,15)]"

/turf/open/floor/plating/ironsand/burn_tile()
	return

/turf/open/floor/plating/ironsand/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/ice
	name = "ледяной покров"
	desc = "Полоса сплошного льда. Выглядит скользко."
	icon = 'icons/turf/floors/ice_turf.dmi'
	icon_state = "ice_turf-0"
	base_icon_state = "ice_turf-0"
	baseturfs = /turf/open/floor/plating/ice
	slowdown = 1
	attachment_holes = FALSE
	bullet_sizzle = TRUE
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/ice/Initialize()
	. = ..()
	MakeSlippery(TURF_WET_PERMAFROST, INFINITY, 0, INFINITY, TRUE)

/turf/open/floor/plating/ice/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/ice/smooth
	icon_state = "ice_turf-255"
	base_icon_state = "ice_turf"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = list(SMOOTH_GROUP_FLOOR_ICE)
	canSmoothWith = list(SMOOTH_GROUP_TURF_OPEN)

/turf/open/floor/plating/ice/break_tile()
	return

/turf/open/floor/plating/ice/burn_tile()
	return

/turf/open/floor/plating/ice/icemoon
	slowdown = 0

/turf/open/floor/plating/snowed
	name = "заснеженное покрытие"
	desc = "Секция горячего покрытия помогает удержать снег от налипания."
	icon = 'icons/turf/snow.dmi'
	icon_state = "snowplating"
	base_icon_state = "snowplating"
	attachment_holes = FALSE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/snowed/smoothed
	icon = 'icons/turf/floors/snow_turf.dmi'
	icon_state = "snow_turf-0"
	base_icon_state = "snow_turf"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_SNOWED)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_SNOWED)

/turf/open/floor/plating/grass
	name = "трава"
	desc = "Обычная зелёная трава, ничего особенного."
	icon_state = "grass0"
	base_icon_state = "grass"
	baseturfs = /turf/open/floor/plating/sandy_dirt
	bullet_bounce_sound = null
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_GRASS)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_GRASS)
	layer = HIGH_TURF_LAYER
	var/smooth_icon = 'icons/turf/floors/grass.dmi'

/turf/open/floor/plating/grass/setup_broken_states()
	return list("damaged")

/turf/open/floor/plating/grass/Initialize()
	. = ..()
	if(smoothing_flags)
		var/matrix/translation = new
		translation.Translate(-9, -9)
		transform = translation
		icon = smooth_icon

/turf/open/floor/plating/grass/lavaland

/turf/open/floor/plating/sandy_dirt
	gender = PLURAL
	name = "dirt"
	desc = "Upon closer examination, it's still dirt."
	icon_state = "sand"
	base_icon_state = "sand"
	bullet_bounce_sound = null
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/plating/sandy_dirt/setup_broken_states()
	return list("sand_damaged")
