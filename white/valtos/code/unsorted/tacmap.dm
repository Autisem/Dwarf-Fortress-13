/proc/gen_tacmap(map_z = 2)
	var/icon/tacmap_icon = new('white/valtos/icons/tacmap.dmi', "tacmap_base")
	// берём все турфы с нужного з-уровня и рисуем шедевр
	for(var/xx in 1 to world.maxx)
		for(var/yy in 1 to world.maxy)
			var/turf/T = locate(xx, yy, map_z)
			if(isspaceturf(T) || isopenspace(T))
				if(locate(/obj/structure/lattice) in T)
					tacmap_icon.DrawBox(rgb(143, 103, 175), xx, yy, xx, yy)
				continue
			if(isopenturf(T))
				if(isplatingturf(T))
					if(locate(/obj/structure/window) in T)
						tacmap_icon.DrawBox(rgb(0, 60, 255), xx, yy, xx, yy)
					else
						tacmap_icon.DrawBox(rgb(109, 42, 128), xx, yy, xx, yy)
					continue
				tacmap_icon.DrawBox(rgb(220, 44, 255), xx, yy, xx, yy)
				continue
			if(isclosedturf(T))
				tacmap_icon.DrawBox(rgb(0, 195, 255), xx, yy, xx, yy)
	return tacmap_icon

/proc/gen_tacmap_full(map_z = 2)
	var/icon/mapofthemap   = gen_tacmap(map_z)
	return mapofthemap
