/obj/structure/plant/tree
	name = "tree"
	desc = "Big green?"
	icon = 'dwarfs/icons/farming/growing_tree_96x96.dmi'
	density = TRUE
	lifespan = INFINITY
	layer = ABOVE_MOB_LAYER
	var/small_log_type = /obj/item/log
	var/large_log_type = /obj/item/log
	var/list/small_log_amount = list(0,1,1,2,0,2,0) //a list of small logs with amount corresponding to the growthstage
	var/list/large_log_amount = list(0,0,0,0,1,1,2) //a list of large logs with amount corresponding to the growthstage
	var/cutting_time = 40 SECONDS

/obj/structure/plant/tree/Initialize()
	. = ..()
	pixel_x = -32

/obj/structure/plant/tree/proc/try_chop(obj/item/tool, mob/living/user)
	to_chat(user, span_notice("You start chopping down [src]..."))
	var/time_mod = user?.mind.get_skill_modifier(/datum/skill/logging, SKILL_SPEED_MODIFIER)
	time_mod = time_mod ? time_mod : 1
	var/channel = playsound(src.loc, 'dwarfs/sounds/tools/axe/axe_chop_long.ogg', 50, TRUE)
	if(tool.use_tool(src, user, cutting_time*time_mod))
		stop_sound_channel_nearby(src, channel)
		to_chat(user, span_notice("You chop down [src]."))
		user?.mind.adjust_experience(/datum/skill/logging, 36)
		chop_tree(get_turf(src))
		qdel(src)
	else
		stop_sound_channel_nearby(src, channel)

/obj/structure/plant/tree/proc/chop_tree(turf/my_turf)
	if(small_log_type)
		for(var/i in 1 to small_log_amount[growthstage])
			new small_log_type(my_turf)
	if(large_log_type)
		for(var/i in 1 to large_log_amount[growthstage])
			new large_log_type(my_turf)

/obj/structure/plant/tree/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_AXE)
		try_chop(I, user)
	else
		. = ..()

/obj/structure/plant/tree/towercap
	name = "towercap"
	desc = "A mushroom-like subterranean tree. Bears tower cap logs once chopped down."
	species = "towercap"
	produced = list(/obj/item/growable/seeds/tree/towercap=2)
	large_log_type = /obj/item/log/large/towercap
	small_log_type = /obj/item/log/towercap
	health = 100
	icon_ripe = "towercap-7"
	growthstages = 7
	growthdelta = 80 SECONDS
	produce_delta = 120 SECONDS

/*
/obj/structure/plant/tree/apple
	name = "apple tree"
	desc = ""
	species = "apple"
	produced = list(/obj/item/growable/apple=4)
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/alder
	name = "alder tree"
	desc = ""
	species = "alder"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/almond
	name = "almond tree"
	desc = ""
	species = "almond"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/apricot
	name = "apricot tree"
	desc = ""
	species = "apricot"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/ash
	name = "ash tree"
	desc = ""
	species = "ash"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/bayberry
	name = "bayberry tree"
	desc = ""
	species = "bayberry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/birch
	name = "birch tree"
	desc = ""
	species = "birch"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/cedar
	name = "cedar tree"
	desc = ""
	species = "cedar"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/cherry
	name = "cherry tree"
	desc = ""
	species = "cherry"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/chestnut
	name = "chestnut tree"
	desc = ""
	species = "chestnut"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/ginkgo
	name = "ginkgo tree"
	desc = ""
	species = "ginkgo"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/hazel
	name = "hazel tree"
	desc = ""
	species = "hazel"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/larch
	name = "larch tree"
	desc = ""
	species = "larch"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/maple
	name = "maple tree"
	desc = ""
	species = "maple"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/oak
	name = "oak tree"
	desc = ""
	species = "oak"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/peach
	name = "peach tree"
	desc = ""
	species = "peach"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/pear
	name = "pear tree"
	desc = ""
	species = "pear"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/pecan
	name = "pecan tree"
	desc = ""
	species = "pecan"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/persimmon
	name = "persimmon tree"
	desc = ""
	species = "persimmon"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/plum
	name = "plum tree"
	desc = ""
	species = "plum"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/sand_pear
	name = "sand pear tree"
	desc = ""
	species = "sand_pear"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/walnut
	name = "walnut tree"
	desc = ""
	species = "walnut"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =

/obj/structure/plant/tree/willow
	name = "willow tree"
	desc = ""
	species = "willow"
	produced = list()
	// growthdelta = 1 MINUTES
	// produce_delta = 1 MINUTES
	// max_harvestables =
*/
