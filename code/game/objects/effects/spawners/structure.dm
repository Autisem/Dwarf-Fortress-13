/*
Because mapping is already tedious enough this spawner let you spawn generic
"sets" of objects rather than having to make the same object stack again and
again.
*/

/obj/effect/spawner/structure
	name = "map structure spawner"
	var/list/spawn_list

/obj/effect/spawner/structure/Initialize()
	. = ..()
	if(spawn_list?.len)
		for(var/I in spawn_list)
			new I(get_turf(src))
		// новый год 2022
		//if(prob(10))
		//	new /obj/structure/snowflakes(get_turf(src))
	return INITIALIZE_HINT_QDEL


//normal windows

/obj/effect/spawner/structure/window
	icon = 'icons/obj/structures_spawners.dmi'
	icon_state = "window_spawner"
	name = "window spawner"
	spawn_list = list(/obj/structure/window/fulltile)
	dir = SOUTH

/obj/effect/spawner/structure/window/hollow
	name = "hollow window spawner"
	icon_state = "hwindow_spawner_full"
	spawn_list = list(/obj/structure/window, /obj/structure/window/spawner/north, /obj/structure/window/spawner/east, /obj/structure/window/spawner/west)

/obj/effect/spawner/structure/window/hollow/end
	icon_state = "hwindow_spawner_end"

/obj/effect/spawner/structure/window/hollow/end/Initialize()
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/window/spawner/north, /obj/structure/window/spawner/east, /obj/structure/window/spawner/west)
		if(EAST)
			spawn_list = list(/obj/structure/window, /obj/structure/window/spawner/north, /obj/structure/window/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/window, /obj/structure/window/spawner/east, /obj/structure/window/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/window, /obj/structure/window/spawner/north, /obj/structure/window/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/middle
	icon_state = "hwindow_spawner_middle"

/obj/effect/spawner/structure/window/hollow/middle/Initialize()
	switch(dir)
		if(NORTH,SOUTH)
			spawn_list = list(/obj/structure/window, /obj/structure/window/spawner/north)
		if(EAST,WEST)
			spawn_list = list(/obj/structure/window/spawner/east, /obj/structure/window/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/directional
	icon_state = "hwindow_spawner_directional"

/obj/effect/spawner/structure/window/hollow/directional/Initialize()
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/window/spawner/north)
		if(NORTHEAST)
			spawn_list = list(/obj/structure/window/spawner/north, /obj/structure/window/spawner/east)
		if(EAST)
			spawn_list = list(/obj/structure/window/spawner/east)
		if(SOUTHEAST)
			spawn_list = list(/obj/structure/window, /obj/structure/window/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/window)
		if(SOUTHWEST)
			spawn_list = list(/obj/structure/window, /obj/structure/window/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/window/spawner/west)
		if(NORTHWEST)
			spawn_list = list(/obj/structure/window/spawner/north, /obj/structure/window/spawner/west)
	. = ..()
