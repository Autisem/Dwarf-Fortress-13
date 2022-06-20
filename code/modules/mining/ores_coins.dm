
#define GIBTONITE_QUALITY_HIGH 3
#define GIBTONITE_QUALITY_MEDIUM 2
#define GIBTONITE_QUALITY_LOW 1

#define ORESTACK_OVERLAYS_MAX 10

/**********************Mineral ores**************************/

/obj/item/stack/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
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
	icon_state = "iron_ore"
	inhand_icon_state = "Iron ore"
	singular_name = "iron ore chunk"
	mine_experience = 1
	spreadChance = 20
	merge_type = /obj/item/stack/ore/iron
	ore_icon = 'dwarfs/icons/turf/ores/iron.dmi'
	ore_basename = "iron"

/obj/item/stack/ore/coal
	name = "coal ore"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "coal"
	inhand_icon_state = "Iron ore"
	singular_name = "coal ore chunk"
	refined_type = /obj/item/stack/sheet/mineral/coal
	mine_experience = 1
	spreadChance = 20
	merge_type = /obj/item/stack/ore/coal
	ore_icon = 'dwarfs/icons/turf/ores/coal.dmi'
	ore_basename = "coal"

/obj/item/stack/ore/coal/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	var/obj/item/stack/S = new refined_type (get_turf(src))
	S.amount = new_amount
	qdel(src)

/obj/item/stack/ore/gold
	name = "gold ore"
	icon_state = "gold_ore"
	inhand_icon_state = "Gold ore"
	singular_name = "gold ore chunk"
	mine_experience = 5
	refined_type = /obj/item/stack/sheet/mineral/gold
	spreadChance = 5
	merge_type = /obj/item/stack/ore/gold
	ore_icon = 'dwarfs/icons/turf/ores/gold.dmi'
	ore_basename = "gold"

/obj/item/stack/ore/gem
	max_amount = 1
/obj/item/stack/ore/gem/diamond
	name = "diamond ore"
	icon_state = "diamond_ore"
	// inhand_icon_state = "Diamond ore"
	singular_name = "uncut diamond"
	refined_type = /obj/item/stack/sheet/mineral/gem/diamond
	mine_experience = 10
	merge_type = /obj/item/stack/ore/gem/diamond
	ore_icon = 'dwarfs/icons/turf/ores/diamond.dmi'
	ore_basename = "diamond"

/obj/item/stack/ore/gem/sapphire
	name = "sapphire ore"
	icon_state = "sapphire_ore"
	// inhand_icon_state = "Diamond ore"
	singular_name = "uncut sapphire"
	refined_type = /obj/item/stack/sheet/mineral/gem/sapphire
	mine_experience = 10
	merge_type = /obj/item/stack/ore/gem/sapphire
	ore_icon = 'dwarfs/icons/turf/ores/sapphire.dmi'
	ore_basename = "sapphire"

/obj/item/stack/ore/gem/ruby
	name = "ruby ore"
	icon_state = "ruby_ore"
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


/*****************************Coin********************************/

// The coin's value is a value of it's materials.
// Yes, the gold standard makes a come-back!
// This is the only way to make coins that are possible to produce on station actually worth anything.
/obj/item/coin
	icon = 'icons/obj/economy.dmi'
	name = "coin"
	icon_state = "coin"
	flags_1 = CONDUCT_1
	force = 1
	throwforce = 2
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = 400)
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	var/string_attached
	var/list/sideslist = list("heads","tails")
	var/cooldown = 0
	var/value
	var/coinflip
	item_flags = NO_MAT_REDEMPTION //You know, it's kind of a problem that money is worth more extrinsicly than intrinsically in this universe.

/obj/item/coin/Initialize()
	. = ..()
	coinflip = pick(sideslist)
	icon_state = "coin_[coinflip]"
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/coin/set_custom_materials(list/materials, multiplier = 1)
	. = ..()
	value = 0
	for(var/i in custom_materials)
		var/datum/material/M = i
		value += M.value_per_unit * custom_materials[M]

/obj/item/coin/proc/get_item_credit_value()
	return value

/obj/item/coin/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] contemplates suicide with <b>[src.name]</b>!"))
	if (!attack_self(user))
		user.visible_message(span_suicide("[user] couldn't flip <b>[src.name]</b>!"))
		return SHAME
	addtimer(CALLBACK(src, .proc/manual_suicide, user), 10)//10 = time takes for flip animation
	return MANUAL_SUICIDE_NONLETHAL

/obj/item/coin/proc/manual_suicide(mob/living/user)
	var/index = sideslist.Find(coinflip)
	if (index==2)//tails
		user.visible_message(span_suicide("<b>[src.name]</b> lands on [coinflip]! [user] promptly falls over, dead!"))
		user.adjustOxyLoss(200)
		user.death(0)
		user.set_suicide(TRUE)
		user.suicide_log()
	else
		user.visible_message(span_suicide("<b>[src.name]</b> lands on [coinflip]! [user] keeps on living!"))

/obj/item/coin/examine(mob/user)
	. = ..()
	. += "<hr><span class='info'>It's worth [value] credit\s.</span>"

/obj/item/coin/attack_self(mob/user)
	if(cooldown < world.time)
		if(string_attached) //does the coin have a wire attached
			to_chat(user, span_warning("The coin won't flip very well with something attached!")  )
			return FALSE//do not flip the coin
		cooldown = world.time + 15
		flick("coin_[coinflip]_flip", src)
		coinflip = pick(sideslist)
		icon_state = "coin_[coinflip]"
		playsound(user.loc, 'sound/items/coinflip.ogg', 50, TRUE)
		var/oldloc = loc
		sleep(15)
		if(loc == oldloc && user && !user.incapacitated())
			user.visible_message(span_notice("[user] flips [src]. It lands on [coinflip].") , \
				span_notice("You flip [src]. It lands on [coinflip].") , \
				span_hear("You hear the clattering of loose change."))
	return TRUE//did the coin flip? useful for suicide_act

/obj/item/coin/twoheaded
	desc = "Hey, this coin's the same on both sides!"
	sideslist = list("heads")

/obj/item/coin/antagtoken
	name = "antag token"
	desc = "A novelty coin that helps the heart know what hard evidence cannot prove."
	icon_state = "coin_valid"
	sideslist = list("valid", "salad")
	material_flags = NONE

/obj/item/coin/iron

#undef ORESTACK_OVERLAYS_MAX
