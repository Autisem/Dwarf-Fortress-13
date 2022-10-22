/turf/closed/mineral/random/dwarf_lustress
	icon = 'dwarfs/icons/turf/walls_cavern.dmi'
	smooth_icon = 'dwarfs/icons/turf/walls_cavern.dmi'
	icon_state = "rockwall-0"
	base_icon_state = "rockwall"
	environment_type = "stone_raw"
	turf_type = /turf/open/floor/rock
	baseturfs = /turf/open/floor/rock
	mineralSpawnChanceList = list(/obj/item/stack/ore/smeltable/gold = 20, /obj/item/stack/ore/smeltable/iron = 40, /obj/item/stack/ore/gem/diamond=10,/obj/item/stack/ore/gem/ruby=10,/obj/item/stack/ore/gem/sapphire=10,/obj/item/stack/ore/coal=20)
	mineralChance = 0.1

/turf/closed/mineral/random/dwarf_lustress/gets_drilled(user, give_exp = FALSE)
	. = ..()

	if(prob(33))
		new /obj/item/stack/ore/stone(src)

	if(prob(0.3))
		to_chat(user, span_userdanger("THIS ROCK APPEARS TO BE ESPECIALLY SOFT!"))
		new /mob/living/simple_animal/hostile/troll(src)

/turf/closed/wall/stone
	name = "stone wall"
	desc = "Just a regular stone wall."
	icon = 'dwarfs/icons/turf/walls_dwarven.dmi'
	icon_state = "rich_wall-0"
	base_icon_state = "rich_wall"
	sheet_type = /obj/item/stack/sheet/stone
	baseturfs = /turf/open/floor/stone
	sheet_amount = 4

/turf/closed/mineral/random/sand
	name = "sand"
	smoothing_flags = SMOOTH_BITMASK
	mineralSpawnChanceList = list(/obj/item/stack/ore/smeltable/gold = 20, /obj/item/stack/ore/smeltable/iron = 40, /obj/item/stack/ore/gem/diamond=10,/obj/item/stack/ore/gem/ruby=10,/obj/item/stack/ore/gem/sapphire=10,/obj/item/stack/ore/coal=20)
	mineralChance = 0.1
	baseturfs = /turf/open/floor/sand
	smooth_icon = 'dwarfs/icons/turf/walls_sandstone.dmi'
	base_icon_state = "rockwall"
	icon = 'dwarfs/icons/turf/walls_sandstone.dmi'
	icon_state = "rockwall-0"

/turf/closed/mineral/random/sand/gets_drilled(user, give_exp)
	. = ..()
	if(prob(33))
		new /obj/item/stack/ore/smeltable/sand(src)
