
/proc/mineral_scan_pulse(turf/T, range = world.view)
	var/list/parsedrange = getviewsize(range)
	var/xrange = (parsedrange[1] - 1) / 2
	var/yrange = (parsedrange[2] - 1) / 2
	var/cx = T.x
	var/cy = T.y
	for(var/r in 1 to max(xrange, yrange))
		var/xr = min(xrange, r)
		var/yr = min(yrange, r)
		var/turf/TL = locate(cx - xr, cy + yr, T.z)
		var/turf/BL = locate(cx - xr, cy - yr, T.z)
		var/turf/TR = locate(cx + xr, cy + yr, T.z)
		var/turf/BR = locate(cx + xr, cy - yr, T.z)
		var/list/turfs = list()
		turfs += block(TL, TR)
		turfs += block(TL, BL)
		turfs |= block(BL, BR)
		turfs |= block(BR, TR)
		for(var/turf/closed/mineral/M in turfs)
			new /obj/effect/temp_visual/mining_scanner(M)
			if(M.scan_state)
				var/obj/effect/temp_visual/mining_overlay/oldC = locate(/obj/effect/temp_visual/mining_overlay) in M
				if(oldC)
					qdel(oldC)
				var/obj/effect/temp_visual/mining_overlay/C = new /obj/effect/temp_visual/mining_overlay(M)
				C.icon_state = M.scan_state
		sleep(1)

/proc/pulse_effect(turf/T, range = world.view)
	var/list/parsedrange = getviewsize(range)
	var/xrange = (parsedrange[1] - 1) / 2
	var/yrange = (parsedrange[2] - 1) / 2
	var/cx = T.x
	var/cy = T.y
	for(var/r in 1 to max(xrange, yrange))
		var/xr = min(xrange, r)
		var/yr = min(yrange, r)
		var/turf/TL = locate(cx - xr, cy + yr, T.z)
		var/turf/BL = locate(cx - xr, cy - yr, T.z)
		var/turf/TR = locate(cx + xr, cy + yr, T.z)
		var/turf/BR = locate(cx + xr, cy - yr, T.z)
		var/list/turfs = list()
		turfs += block(TL, TR)
		turfs += block(TL, BL)
		turfs |= block(BL, BR)
		turfs |= block(BR, TR)
		for(var/turf/M in turfs)
			new /obj/effect/temp_visual/mining_scanner(M)
		sleep(1)

/obj/effect/temp_visual/mining_overlay
	plane = FULLSCREEN_PLANE
	layer = FLASH_LAYER
	icon = 'icons/effects/ore_visuals.dmi'
	appearance_flags = 0 //to avoid having TILE_BOUND in the flags, so that the 480x480 icon states let you see it no matter where you are
	duration = 35
	pixel_x = -224
	pixel_y = -224

/obj/effect/temp_visual/mining_overlay/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration, easing = EASE_IN)

/obj/effect/temp_visual/mining_scanner
	plane = FULLSCREEN_PLANE
	layer = FLASH_LAYER
	icon = 'icons/effects/mining_scanner.dmi'
	appearance_flags = 0
	pixel_x = -224
	pixel_y = -224
	duration = 3
	alpha = 100
	icon_state = "mining_scan"

/obj/effect/temp_visual/mining_scanner/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration, easing = EASE_IN)
