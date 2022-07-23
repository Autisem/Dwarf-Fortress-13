
#define ORESTACK_OVERLAYS_MAX 10

/**********************Mineral ores**************************/

/obj/item/stack/ore
	name = "rock"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "ore"
	inhand_icon_state = "ore"
	full_w_class = WEIGHT_CLASS_BULKY
	singular_name = "ore chunk"
	var/refined_type = null //What this ore defaults to being refined into
	var/mine_experience = 5 //How much experience do you get for mining this ore?
	novariants = TRUE // Ore stacks handle their icon updates themselves to keep the illusion that there's more going
	var/list/stack_overlays
	var/spreadChance = 0 //Also used by mineral turfs for spreading veins
	var/ore_icon  //icons for ore overlays
	var/ore_basename //sus?

/obj/item/stack/ore/update_overlays()
	. = ..()
	var/difference = min(ORESTACK_OVERLAYS_MAX, amount) - (LAZYLEN(stack_overlays)+1)
	if(difference == 0)
		return
	else if(difference < 0 && LAZYLEN(stack_overlays))			//amount < stack_overlays, remove excess.
		if (LAZYLEN(stack_overlays)-difference <= 0)
			stack_overlays = null
		else
			stack_overlays.len += difference
	else if(difference > 0)			//amount > stack_overlays, add some.
		for(var/i in 1 to difference)
			var/mutable_appearance/newore = mutable_appearance(icon, icon_state)
			newore.pixel_x = rand(-8,8)
			newore.pixel_y = rand(-8,8)
			LAZYADD(stack_overlays, newore)
	if (stack_overlays)
		. += stack_overlays

/obj/item/stack/ore/welder_act(mob/living/user, obj/item/I)
	..()
	if(!refined_type)
		return TRUE

	if(I.use_tool(src, user, 0, volume=50, amount=15))
		new refined_type(drop_location())
		use(1)

	return TRUE

/obj/item/stack/ore/fire_act(exposed_temperature, exposed_volume)
	. = ..()
	if(isnull(refined_type))
		return
	else
		var/probability = (rand(0,100))/100
		var/burn_value = probability*amount
		var/amountrefined = round(burn_value, 1)
		if(amountrefined < 1)
			qdel(src)
		else
			new refined_type(drop_location(),amountrefined)
			qdel(src)

/obj/item/stack/ore/iron
	name = "iron ore"
	icon_state = "iron"
	inhand_icon_state = "Iron ore"
	singular_name = "iron ore chunk"
	mine_experience = 1
	spreadChance = 60
	merge_type = /obj/item/stack/ore/iron
	ore_icon = 'dwarfs/icons/turf/ores/iron.dmi'
	ore_basename = "iron"

/obj/item/stack/ore/coal
	name = "coal"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "coal"
	inhand_icon_state = "Iron ore"
	singular_name = "coal chunk"
	refined_type = /obj/item/stack/sheet/mineral/coal
	mine_experience = 1
	spreadChance = 80
	merge_type = /obj/item/stack/ore/coal
	ore_icon = 'dwarfs/icons/turf/ores/coal.dmi'
	ore_basename = "coal"

/obj/item/stack/ore/coal/get_fuel()
	return 15 * amount

/obj/item/stack/ore/gold
	name = "gold ore"
	icon_state = "gold"
	inhand_icon_state = "Gold ore"
	singular_name = "gold ore chunk"
	mine_experience = 5
	refined_type = /obj/item/stack/sheet/mineral/gold
	spreadChance = 30
	merge_type = /obj/item/stack/ore/gold
	ore_icon = 'dwarfs/icons/turf/ores/gold.dmi'
	ore_basename = "gold"

/obj/item/stack/ore/gem
	max_amount = 1
	spreadChance = 10

/obj/item/stack/ore/gem/diamond
	name = "diamond ore"
	icon_state = "diamond_uncut"
	// inhand_icon_state = "Diamond ore"
	singular_name = "uncut diamond"
	refined_type = /obj/item/stack/sheet/mineral/gem/diamond
	mine_experience = 10
	merge_type = /obj/item/stack/ore/gem/diamond
	ore_icon = 'dwarfs/icons/turf/ores/diamond.dmi'
	ore_basename = "diamond"

/obj/item/stack/ore/gem/sapphire
	name = "sapphire ore"
	icon_state = "sapphire_uncut"
	// inhand_icon_state = "Diamond ore"
	singular_name = "uncut sapphire"
	refined_type = /obj/item/stack/sheet/mineral/gem/sapphire
	mine_experience = 10
	merge_type = /obj/item/stack/ore/gem/sapphire
	ore_icon = 'dwarfs/icons/turf/ores/sapphire.dmi'
	ore_basename = "sapphire"

/obj/item/stack/ore/gem/ruby
	name = "ruby ore"
	icon_state = "ruby_uncut"
	// inhand_icon_state = "Diamond ore"
	singular_name = "uncut ruby"
	refined_type = /obj/item/stack/sheet/mineral/gem/ruby
	mine_experience = 10
	merge_type = /obj/item/stack/ore/gem/ruby
	ore_icon = 'dwarfs/icons/turf/ores/ruby.dmi'
	ore_basename = "ruby"

/obj/item/stack/ore/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/stack/ore/ex_act(severity, target)
	if (!severity || severity >= 2)
		return
	qdel(src)


#undef ORESTACK_OVERLAYS_MAX
