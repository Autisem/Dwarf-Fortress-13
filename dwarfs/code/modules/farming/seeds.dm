// ********************************************************
// Here's all the seeds (plants) that can be used in hydro
// ********************************************************

/obj/item/seeds
	icon = 'dwarfs/icons/farming/seeds.dmi'
	icon_state = "seed"				// Unknown plant seed - these shouldn't exist in-game.
	worn_icon_state = "seed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	/// Name of plant when planted.
	var/plantname = "Plants"
	/// A type path. The thing that is created when the plant is harvested.
	var/obj/item/product
	var/list/harvestables
	/// Used to update icons. Should match the name in the sprites unless all icon_* are overridden.
	var/growing_icon = 'dwarfs/icons/farming/growing.dmi'
	/// Used to override grow icon (default is `"[species]-grow"`). You can use one grow icon for multiple closely related plants with it.
	var/icon_grow
	/// Used to override dead icon (default is `"[species]-dead"`). You can use one dead icon for multiple closely related plants with it.
	var/icon_dead
	var/species
	/// How long before the plant begins to take damage from age.
	var/lifespan = 25
	var/age = 1
	/// Amount of health the plant has.
	var/health = 15
	/// Used to determine which sprite to switch to when growing.
	var/growth_delta = 1 MINUTES
	/// Amount of growns created per harvest. If is -1, the plant/shroom/weed is never meant to be harvested.
	var/yield = 3
	var/growthstage = 1
	/// Amount of growth sprites the plant has.
	var/growthstages = 5
	/// Plant genes are stored here, see plant_genes.dm for more info.
	var/list/genes = list()
	/// to prevent spamming
	var/dead = FALSE

/obj/item/seeds/Initialize(mapload, nogenes = 0)
	. = ..()
	pixel_x = base_pixel_x + rand(-8, 8)
	pixel_y = base_pixel_y + rand(-8, 8)

	// if(!icon_grow)
	// 	icon_grow = "[species]-grow"

	if(!icon_dead)
		icon_dead = "[species]-dead"

/obj/item/seeds/proc/get_gene(typepath)
	return (locate(typepath) in genes)

// Harvest procs
/obj/item/seeds/proc/getYield(mob/living/user)
	var/return_yield = yield

	return return_yield


/obj/item/seeds/proc/harvest(mob/user)
	return
/// Setters procs ///

/**
 * Adjusts seed lifespan up or down according to adjustamt. (Max 100)
 */
/obj/item/seeds/proc/adjust_lifespan(adjustamt)
	lifespan = clamp(lifespan + adjustamt, 10, MAX_PLANT_LIFESPAN)

/**
 * Adjusts seed health up or down according to adjustamt. (Max 100)
 */
/obj/item/seeds/proc/adjust_health(adjustamt)
	health = clamp(health + adjustamt, MIN_PLANT_ENDURANCE, MAX_PLANT_ENDURANCE)

//Directly setting stats

/**
 * Sets the plant's yield stat to the value of adjustamt. (Max 10, or 5 with some traits)
 */
/obj/item/seeds/proc/set_yield(adjustamt)
	if(yield != -1) // Unharvestable shouldn't suddenly turn harvestable
		/// Our plant's max yield
		var/max_yield = MAX_PLANT_YIELD

		yield = clamp(adjustamt, 0, max_yield)

/**
 * Sets the plant's lifespan stat to the value of adjustamt. (Max 100)
 */
/obj/item/seeds/proc/set_lifespan(adjustamt)
	lifespan = clamp(adjustamt, 10, MAX_PLANT_LIFESPAN)

/**
 * Sets the plant's health stat to the value of adjustamt. (Max 100)
 */
/obj/item/seeds/proc/set_health(adjustamt)
	health = clamp(adjustamt, MIN_PLANT_ENDURANCE, MAX_PLANT_ENDURANCE)

/*
 * Both `/item/food/grown` and `/item/grown` implement a seed variable which tracks
 * plant statistics, genes, traits, etc. This proc gets the seed for either grown food or
 * grown inedibles and returns it, or returns null if it's not a plant.
 *
 * Returns an `/obj/item/seeds` ref for grown foods or grown inedibles.
 *  - returned seed CAN be null in weird cases but in all applications it SHOULD NOT be.
 * Returns null if it is not a plant.
 */

// /obj/item/food/grown/get_plant_seed()
// 	return seed

// /obj/item/grown/get_plant_seed()
// 	return seed
