/turf/closed/wall/vault
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/closed/wall/ice
	icon = 'icons/turf/walls/icedmetal_wall.dmi'
	icon_state = "icedmetal_wall-0"
	base_icon_state = "icedmetal_wall"
	desc = "Стена покрытая льдом."
	smoothing_flags = SMOOTH_BITMASK
	canSmoothWith = list(SMOOTH_GROUP_WALLS)
	hardness = 35
	slicing_duration = 150 //welding through the ice+metal
	bullet_sizzle = TRUE

/turf/closed/wall/rust
	//SDMM supports colors, this is simply for easier mapping
	//and should be removed on initialize
	color = COLOR_ORANGE_BROWN

/turf/closed/wall/rust/Initialize(mapload)
	. = ..()
	color = null
	AddElement(/datum/element/rust)

/turf/closed/wall/r_wall/rust
	//SDMM supports colors, this is simply for easier mapping
	//and should be removed on initialize
	color = COLOR_ORANGE_BROWN

/turf/closed/wall/r_wall/rust/Initialize(mapload)
	. = ..()
	color = null
	AddElement(/datum/element/rust)


/turf/closed/wall/rust
	name = "ржавая стена"
	desc = "Старая ржавая стена."
	icon = 'icons/turf/walls/rusty_wall.dmi'
	icon_state = "rusty_wall-0"
	base_icon_state = "rusty_wall"
	smoothing_flags = SMOOTH_BITMASK
	hardness = 45

/turf/closed/wall/r_wall/rust
	name = "ржавая укреплённая стена"
	desc = "Старая укреплённая ржавая стена."
	icon = 'icons/turf/walls/rusty_reinforced_wall.dmi'
	icon_state = "rusty_reinforced_wall-0"
	base_icon_state = "rusty_reinforced_wall"
	smoothing_flags = SMOOTH_BITMASK
	hardness = 15

/turf/closed/wall/mineral/bronze
	name = "латунная стена"
	desc = "Крупная латунная стена. Её украшивают также и латунные шестерни."
	icon = 'icons/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall"
	base_icon_state = "clockwork_wall-0"
	smoothing_flags = SMOOTH_CORNERS
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SILVER_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SILVER_WALLS)
	sheet_type = /obj/item/stack/tile/bronze
	sheet_amount = 2
	girder_type = /obj/structure/girder/bronze
