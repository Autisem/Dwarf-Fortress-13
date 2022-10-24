/obj/structure/blueprint
	name = "blueprint"
	desc = "Build it."
	max_integrity = 1
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "blueprint"
	//What are we building
	var/obj/structure/target_structure
	//What do we need to build it
	var/list/reqs = list()
	//The size of our blueprint = list(x,y)
	var/list/dimensions = list(0,0)
	var/cat = "misc"

/obj/structure/blueprint/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_BUILDER_HAMMER)
		var/list/contained = list()
		for(var/obj/O in contents)
			if(!(O.type in contained))
				contained[O.type] = 0
			contained[O.type] += 1
		for(var/i in reqs)
			if(!(i in contained) || reqs[i] != contained[i])
				to_chat(user, span_warning("[src] is is missing materials to be built!"))
				return
		if(I.use_tool(src, user, 20 SECONDS, volume=50))
			to_chat(user, span_notice("You build [initial(target_structure.name)]."))
			new target_structure(get_turf(src))
			qdel(src)
	else
		var/_type
		var/contained = 0
		//Check the hard way because of subtypes
		for(var/i in reqs)
			if(istype(I, i))
				_type = i
				//figure out how much we actually need
				for(var/obj/O in contents)
					if(istype(O, I.type))
						contained++
				break
		if(!_type)
			return ..()
		if(reqs[_type] == contained)
			to_chat(user, span_warning("There are already enough [I]!"))
			return
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			var/required = reqs[_type] - contained
			while(!S.use(required))
				required--
			for(var/i in 1 to required)
				new S.type(src)
		else
			I.forceMove(src)
		to_chat(user, span_notice("You add [I] to the blueprint."))

/obj/structure/blueprint/proc/structure_overlay()
	var/mutable_appearance/M = mutable_appearance(initial(target_structure.icon), initial(target_structure.icon_state), layer=ABOVE_MOB_LAYER)
	M.color = "#5e8bdf"
	M.alpha = 120
	return M

/obj/structure/blueprint/update_overlays()
	. = ..()
	var/mutable_appearance/M = structure_overlay()
	. += M

/obj/structure/blueprint/large //2x1 size
	name = "large blueprint"
	desc = "That's some real construction going on in here."
	icon = 'dwarfs/icons/structures/64x32.dmi'
	icon_state = "blueprint"
	dimensions = list(1,0)

/obj/structure/blueprint/large/brewery
	name = "brewery blueprint"
	target_structure = /obj/structure/brewery/spawner
	reqs = list(/obj/item/stack/sheet/planks=8, /obj/item/stack/sheet/stone=4 ,/obj/item/ingot=4)
	cat = "food processing"

/obj/structure/blueprint/large/workbench
	name = "workbench blueprint"
	target_structure = /obj/structure/workbench
	reqs = list(/obj/item/stack/sheet/planks=10, /obj/item/ingot=2)
	cat = "craftsmanship"

/obj/structure/blueprint/stove
	name = "stove blueprint"
	target_structure = /obj/structure/stove
	reqs = list(/obj/item/stack/sheet/stone=10, /obj/item/ingot=1)
	cat = "food processing"

/obj/structure/blueprint/oven
	name = "oven blueprint"
	target_structure = /obj/structure/oven
	reqs = list(/obj/item/stack/sheet/stone=15)
	cat = "food processing"

/obj/structure/blueprint/smelter
	name = "smelter blueprint"
	target_structure = /obj/structure/smelter
	reqs = list(/obj/item/stack/sheet/stone=15)
	cat = "craftsmanship"

/obj/structure/blueprint/forge
	name = "forge blueprint"
	target_structure = /obj/structure/forge
	reqs = list(/obj/item/stack/sheet/stone=20)
	cat = "craftsmanship"

/obj/structure/blueprint/quern
	name = "quern blueprint"
	target_structure = /obj/structure/quern
	reqs = list(/obj/item/stack/sheet/stone=8, /obj/item/stack/sheet/planks=2)
	cat = "food processing"

/obj/structure/blueprint/well
	name = "well blueprint"
	target_structure = /obj/structure/well
	reqs = list(/obj/item/stack/sheet/stone=15, /obj/item/stack/sheet/planks=4, /obj/item/ingot=1, /obj/item/stack/sheet/string=5)
	cat = "utils"

/obj/structure/blueprint/anvil
	name = "anvil blueprint"
	target_structure = /obj/structure/anvil
	reqs = list(/obj/item/ingot=5)
	cat = "craftsmanship"

/obj/structure/blueprint/gemcutter
	name = "gemstone grinder blueprint"
	target_structure = /obj/structure/gemcutter
	reqs = list(/obj/item/ingot=2, /obj/item/stack/sheet/planks=6, /obj/item/stack/glass=1)
	cat = "craftsmanship"

/obj/structure/blueprint/altar
	name = "altar blueprint"
	target_structure = /obj/structure/dwarf_altar
	reqs = list(/obj/item/stack/sheet/stone=25, /obj/item/flashlight/fueled/candle=6)
	cat = "utils"

/obj/structure/blueprint/loom
	name = "loom blueprint"
	target_structure = /obj/structure/loom
	reqs = list(/obj/item/stack/sheet/planks=8, /obj/item/ingot=2)
	cat = "craftsmanship"

// dirty water barrel from smithing (yes, this is a bad solution)
/obj/structure/blueprint/waterbarrel
	name = "water barrel"
	target_structure = /obj/structure/waterbarrel
	reqs = list(/obj/item/stack/sheet/planks=7, /obj/item/ingot=1)
	cat = "craftsmanship"
