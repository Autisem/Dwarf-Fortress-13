
/obj/machinery/hydroponics
	name = "Лоток гидропоники"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray"
	density = TRUE
	pixel_z = 8
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	idle_power_usage = 5000
	use_power = NO_POWER_USE
	///The amount of water in the tray (max 100)
	var/waterlevel = 100
	///The maximum amount of water in the tray
	var/maxwater = 100
	///How many units of nutrients will be drained in the tray.
	var/nutridrain = 1
	///The maximum nutrient of water in the tray
	var/maxnutri = 10
	///The amount of pests in the tray (max 10)
	var/pestlevel = 0
	///The amount of weeds in the tray (max 10)
	var/weedlevel = 0
	///Nutriment's effect on yield
	var/yieldmod = 1
	///Nutriment's effect on mutations
	var/mutmod = 1
	///Toxicity in the tray?
	var/toxic = 0
	///Current age
	var/age = 0
	///Is it dead?
	var/dead = FALSE
	///Its health
	var/plant_health
	///Last time it was harvested
	var/lastproduce = 0
	///Used for timing of cycles.
	var/lastcycle = 0
	///About 10 seconds / cycle
	var/cycledelay = 200
	///Ready to harvest?
	var/harvest = FALSE
	///The currently planted seed
	var/obj/item/seeds/myseed = null
	///Obtained from the quality of the parts used in the tray, determines nutrient drain rate.
	var/rating = 1
	///Can it be unwrenched to move?
	var/unwrenchable = TRUE
	///Have we been visited by a bee recently, so bees dont overpollinate one plant
	var/recent_bee_visit = FALSE
	///The last user to add a reagent to the tray, mostly for logging purposes.
	var/mob/lastuser
	///If the tray generates nutrients and water on its own
	var/self_sustaining = FALSE
	///The icon state for the overlay used to represent that this tray is self-sustaining.
	var/self_sustaining_overlay_icon_state = "gaia_blessing"

/obj/machinery/hydroponics/Initialize()
	//ALRIGHT YOU DEGENERATES. YOU HAD REAGENT HOLDERS FOR AT LEAST 4 YEARS AND NONE OF YOU MADE HYDROPONICS TRAYS HOLD NUTRIENT CHEMS INSTEAD OF USING "Points".
	//SO HERE LIES THE "nutrilevel" VAR. IT'S DEAD AND I PUT IT OUT OF IT'S MISERY. USE "reagents" INSTEAD. ~ArcaneMusic, accept no substitutes.
	create_reagents(20)
	reagents.add_reagent(/datum/reagent/plantnutriment/eznutriment, 10) //Half filled nutrient trays for dirt trays to have more to grow with in prison/lavaland.
	. = ..()


/obj/machinery/hydroponics/constructable
	name = "Лоток гидропоники"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray3"

/obj/machinery/hydroponics/constructable/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, .proc/can_be_rotated))
	AddComponent(/datum/component/plumbing/simple_demand)

/obj/machinery/hydroponics/constructable/proc/can_be_rotated(mob/user, rotation_type)
	return !anchored

/obj/machinery/hydroponics/constructable/RefreshParts()
	var/tmp_capacity = 0
	for (var/obj/item/stock_parts/matter_bin/M in component_parts)
		tmp_capacity += M.rating
	for (var/obj/item/stock_parts/manipulator/M in component_parts)
		rating = M.rating
	maxwater = tmp_capacity * 50 // Up to 300
	maxnutri = (tmp_capacity * 5) + STATIC_NUTRIENT_CAPACITY // Up to 50 Maximum
	reagents.maximum_volume = maxnutri
	nutridrain = 1/rating

/obj/machinery/hydroponics/constructable/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Используйте <b>Ctrl-Click</b>, чтобы активировать авторост. \n<b>ПКМ</b> опустошит удобрения внутри лотка.</span>"
	if(in_range(user, src) || isobserver(user))
		. += "<hr><span class='notice'>Дисплей: Tray efficiency at <b>[rating*100]%</b>.</span>"


/obj/machinery/hydroponics/Destroy()
	if(myseed)
		qdel(myseed)
		myseed = null
	return ..()

/obj/machinery/hydroponics/constructable/attackby(obj/item/I, mob/user, params)
	if (user.a_intent != INTENT_HARM)
		// handle opening the panel
		if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
			return
		if(default_deconstruction_crowbar(I))
			return

	return ..()

/obj/machinery/hydroponics/bullet_act(obj/projectile/Proj) //Works with the Somatoray to modify plant variables.
	if(!myseed)
		return ..()
	if(istype(Proj , /obj/projectile/energy/floramut))
		mutate()
	else if(istype(Proj , /obj/projectile/energy/florayield))
		return myseed.bullet_act(Proj)
	else if(istype(Proj , /obj/projectile/energy/florarevolution))
		if(myseed)
			if(myseed.mutatelist.len > 0)
				myseed.set_instability(myseed.instability/2)
		mutatespecie()
	else
		return ..()

/obj/machinery/hydroponics/power_change()
	. = ..()
	if(machine_stat & NOPOWER && self_sustaining)
		self_sustaining = FALSE

/obj/machinery/hydroponics/process(delta_time)
	var/needs_update = 0 // Checks if the icon needs updating so we don't redraw empty trays every time

	if(myseed && (myseed.loc != src))
		myseed.forceMove(src)

	if(!powered() && self_sustaining)
		visible_message(span_warning("[name] авторост отключается!"))
		update_use_power(NO_POWER_USE)
		self_sustaining = FALSE
		update_appearance()

	else if(self_sustaining)
		adjustWater(rand(1,2) * delta_time * 0.5)
		adjustWeeds(-0.5 * delta_time)
		adjustPests(-0.5 * delta_time)

	if(world.time > (lastcycle + cycledelay))
		lastcycle = world.time
		if(myseed && !dead)
			// Advance age
			age++
			if(age < myseed.maturation)
				lastproduce = age

			needs_update = 1


//Nutrients//////////////////////////////////////////////////////////////
			// Nutrients deplete at a constant rate, since new nutrients can boost stats far easier.
			apply_chemicals(lastuser)
			if(self_sustaining)
				reagents.remove_any(min(0.5, nutridrain))
			else
				reagents.remove_any(nutridrain)

			// Lack of nutrients hurts non-weeds
			if(reagents.total_volume <= 0 && !myseed.get_gene(/datum/plant_gene/trait/plant_type/weed_hardy))
				adjustHealth(-rand(1,3))

//Photosynthesis/////////////////////////////////////////////////////////
			// Lack of light hurts non-mushrooms
			if(isturf(loc))
				var/turf/currentTurf = loc
				var/lightAmt = currentTurf.get_lumcount()
				if(myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
					if(lightAmt < 0.2)
						adjustHealth(-1 / rating)
				else // Non-mushroom
					if(lightAmt < 0.4)
						adjustHealth(-2 / rating)

//Water//////////////////////////////////////////////////////////////////
			// Drink random amount of water
			adjustWater(-rand(1,6) / rating)

			// If the plant is dry, it loses health pretty fast, unless mushroom
			if(waterlevel <= 10 && !myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
				adjustHealth(-rand(0,1) / rating)
				if(waterlevel <= 0)
					adjustHealth(-rand(0,2) / rating)

			// Sufficient water level and nutrient level = plant healthy but also spawns weeds
			else if(waterlevel > 10 && reagents.total_volume > 0)
				adjustHealth(rand(1,2) / rating)
				if(myseed && prob(myseed.weed_chance))
					adjustWeeds(myseed.weed_rate)
				else if(prob(5))  //5 percent chance the weed population will increase
					adjustWeeds(1 / rating)

//Toxins/////////////////////////////////////////////////////////////////

			// Too much toxins cause harm, but when the plant drinks the contaiminated water, the toxins disappear slowly
			if(toxic >= 40 && toxic < 80)
				adjustHealth(-1 / rating)
				adjustToxic(-rating * 2)
			else if(toxic >= 80) // I don't think it ever gets here tbh unless above is commented out
				adjustHealth(-3)
				adjustToxic(-rating *3)

//Pests & Weeds//////////////////////////////////////////////////////////

			if(pestlevel >= 8)
				if(!myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
					if(myseed.potency >=30)
						myseed.adjust_potency(-rand(2,6)) //Pests eat leaves and nibble on fruit, lowering potency.
						myseed.set_potency(min((myseed.potency), CARNIVORY_POTENCY_MIN, MAX_PLANT_POTENCY))
				else
					adjustHealth(2 / rating)
					adjustPests(-1 / rating)

			else if(pestlevel >= 4)
				if(!myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
					if(myseed.potency >=30)
						myseed.adjust_potency(-rand(1,4))
						myseed.set_potency(min((myseed.potency), CARNIVORY_POTENCY_MIN, MAX_PLANT_POTENCY))

				else
					adjustHealth(1 / rating)
					if(prob(50))
						adjustPests(-1 / rating)

			else if(pestlevel < 4 && myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
				if(prob(5))
					adjustPests(-1 / rating)

			// If it's a weed, it doesn't stunt the growth
			if(weedlevel >= 5 && !myseed.get_gene(/datum/plant_gene/trait/plant_type/weed_hardy))
				if(myseed.yield >=3)
					myseed.adjust_yield(-rand(1,2)) //Weeds choke out the plant's ability to bear more fruit.
					myseed.set_yield(min((myseed.yield), WEED_HARDY_YIELD_MIN, MAX_PLANT_YIELD))

//This is the part with pollination
			pollinate()

//This is where stability mutations exist now.
			if(myseed.instability >= 80)
				var/mutation_chance = myseed.instability - 75
				mutate(0, 0, 0, 0, 0, 0, 0, mutation_chance, 0) //Scaling odds of a random trait or chemical
			if(myseed.instability >= 60)
				if(prob((myseed.instability)/2) && !self_sustaining && length(myseed.mutatelist)) //Minimum 30%, Maximum 50% chance of mutating every age tick when not on autogrow.
					mutatespecie()
					myseed.set_instability(myseed.instability/2)
			if(myseed.instability >= 40)
				if(prob(myseed.instability))
					hardmutate()
			if(myseed.instability >= 20 )
				if(prob(myseed.instability))
					mutate()

//Health & Age///////////////////////////////////////////////////////////

			// Plant dies if plant_health <= 0
			if(plant_health <= 0)
				plantdies()
				adjustWeeds(1 / rating) // Weeds flourish

			// If the plant is too old, lose health fast
			if(age > myseed.lifespan)
				adjustHealth(-rand(1,5) / rating)

			// Harvest code
			if(age > myseed.production && (age - lastproduce) > myseed.production && (!harvest && !dead))
				if(myseed && myseed.yield != -1) // Unharvestable shouldn't be harvested
					harvest = TRUE
				else
					lastproduce = age
			if(prob(5))  // On each tick, there's a 5 percent chance the pest population will increase
				adjustPests(1 / rating)
		else
			if(waterlevel > 10 && reagents.total_volume > 0 && prob(10))  // If there's no plant, the percentage chance is 10%
				adjustWeeds(1 / rating)

		// Weeeeeeeeeeeeeeedddssss
		if(weedlevel >= 10 && prob(50) && !self_sustaining) // At this point the plant is kind of fucked. Weeds can overtake the plant spot.
			if(myseed && myseed.yield >= 3)
				myseed.adjust_yield(-rand(1,2)) //Loses even more yield per tick, quickly dropping to 3 minimum.
				myseed.set_yield(min((myseed.yield), WEED_HARDY_YIELD_MIN, MAX_PLANT_YIELD))
			if(!myseed)
				weedinvasion()
			needs_update = 1
		if (needs_update)
			update_appearance()

		if(myseed && prob(5 * (11-myseed.production)))
			for(var/g in myseed.genes)
				if(istype(g, /datum/plant_gene/trait))
					var/datum/plant_gene/trait/selectedtrait = g
					selectedtrait.on_grow(src)
	return

/obj/machinery/hydroponics/update_appearance(updates)
	. = ..()
	if(self_sustaining)
		set_light(3)
		return
	if(myseed?.get_gene(/datum/plant_gene/trait/glow)) // Hydroponics needs a refactor, badly.
		var/datum/plant_gene/trait/glow/G = myseed.get_gene(/datum/plant_gene/trait/glow)
		set_light(G.glow_range(myseed), G.glow_power(myseed), G.glow_color)
		return
	set_light(0)

/obj/machinery/hydroponics/update_overlays()
	. = ..()
	if(myseed)
		. += update_plant_overlay()
		. += update_status_light_overlays()

	if(self_sustaining && self_sustaining_overlay_icon_state)
		. += mutable_appearance(icon, self_sustaining_overlay_icon_state)

/obj/machinery/hydroponics/proc/update_plant_overlay()
	var/mutable_appearance/plant_overlay = mutable_appearance(myseed.growing_icon, layer = OBJ_LAYER + 0.01)
	if(dead)
		plant_overlay.icon_state = myseed.icon_dead
	else if(harvest)
		if(!myseed.icon_harvest)
			plant_overlay.icon_state = "[myseed.icon_grow][myseed.growthstages]"
		else
			plant_overlay.icon_state = myseed.icon_harvest
	else
		var/t_growthstate = clamp(round((age / myseed.maturation) * myseed.growthstages), 1, myseed.growthstages)
		plant_overlay.icon_state = "[myseed.icon_grow][t_growthstate]"
	return plant_overlay

/obj/machinery/hydroponics/proc/update_status_light_overlays()
	. = list()
	if(waterlevel <= 10)
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lowwater3")
	if(reagents.total_volume <= 2)
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lownutri3")
	if(plant_health <= (myseed.endurance / 2))
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lowhealth3")
	if(weedlevel >= 5 || pestlevel >= 5 || toxic >= 40)
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_alert3")
	if(harvest)
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_harvest3")


/obj/machinery/hydroponics/examine(user)
	. = ..()
	. += "<hr>"
	if(myseed)
		. += span_info("Здесь <span class='name'>[myseed.plantname]</span> посажен.")
		if (dead)
			. += "\n<span class='warning'>Оно мертво!</span>"
		else if (harvest)
			. += "\n<span class='info'>Оно готово к сбору.</span>"
		else if (plant_health <= (myseed.endurance / 2))
			. += "\n<span class='warning'>Оно выглядит нездорово.</span>"
	else
		. += span_info("Тут пусто.")

	. += "\n<span class='info'>Вода: [waterlevel]/[maxwater].</span>"
	. += "\n<span class='info'>Питание: [reagents.total_volume]/[maxnutri].</span>"
	if(self_sustaining)
		. += "\n<span class='info'>Авторост лотка активен, теперь лоток защищает растение от мутаций, сорняков и паразитов.</span>"

	if(weedlevel >= 5)
		. += span_warning("Оно всё в сорняках!")
	if(pestlevel >= 5)
		. += span_warning("Оно заполнено маленькими червями!")

/**
 * What happens when a tray's weeds grow too large.
 * Plants a new weed in an empty tray, then resets the tray.
 */
/obj/machinery/hydroponics/proc/weedinvasion()
	dead = FALSE
	var/oldPlantName
	if(myseed) // In case there's nothing in the tray beforehand
		oldPlantName = myseed.plantname
		qdel(myseed)
		myseed = null
	else
		oldPlantName = "empty tray"
	switch(rand(1,18))		// randomly pick predominative weed
		if(16 to 18)
			myseed = new /obj/item/seeds/reishi(src)
		if(14 to 15)
			myseed = new /obj/item/seeds/nettle(src)
		if(12 to 13)
			myseed = new /obj/item/seeds/harebell(src)
		if(10 to 11)
			myseed = new /obj/item/seeds/amanita(src)
		if(8 to 9)
			myseed = new /obj/item/seeds/chanter(src)
		if(6 to 7)
			myseed = new /obj/item/seeds/tower(src)
		if(4 to 5)
			myseed = new /obj/item/seeds/plump(src)
		else
			myseed = new /obj/item/seeds/starthistle(src)
	age = 0
	plant_health = myseed.endurance
	lastcycle = world.time
	harvest = FALSE
	weedlevel = 0 // Reset
	pestlevel = 0 // Reset
	update_appearance()
	visible_message(span_warning("[oldPlantName] настигает какое-то [myseed.plantname]!"))
	TRAY_NAME_UPDATE

/obj/machinery/hydroponics/proc/mutate(lifemut = 2, endmut = 5, productmut = 1, yieldmut = 2, potmut = 25, wrmut = 2, wcmut = 5, traitmut = 0, stabmut = 3) // Mutates the current seed
	if(!myseed)
		return
	myseed.mutate(lifemut, endmut, productmut, yieldmut, potmut, wrmut, wcmut, traitmut, stabmut)

/obj/machinery/hydroponics/proc/hardmutate()
	mutate(4, 10, 2, 4, 50, 4, 10, 0, 4)


/obj/machinery/hydroponics/proc/mutatespecie() // Mutagent produced a new plant!
	if(!myseed || dead)
		return

	var/oldPlantName = myseed.plantname
	if(myseed.mutatelist.len > 0)
		var/mutantseed = pick(myseed.mutatelist)
		qdel(myseed)
		myseed = null
		myseed = new mutantseed
	else
		return

	hardmutate()
	age = 0
	plant_health = myseed.endurance
	lastcycle = world.time
	harvest = FALSE
	weedlevel = 0 // Reset

	sleep(5) // Wait a while
	update_appearance()
	visible_message(span_warning("[oldPlantName] мутирует в [myseed.plantname]!"))
	TRAY_NAME_UPDATE

/obj/machinery/hydroponics/proc/mutateweed() // If the weeds gets the mutagent instead. Mind you, this pretty much destroys the old plant
	if( weedlevel > 5 )
		if(myseed)
			qdel(myseed)
			myseed = null
		var/newWeed = pick(/obj/item/seeds/liberty, /obj/item/seeds/angel, /obj/item/seeds/nettle/death, /obj/item/seeds/kudzu)
		myseed = new newWeed
		dead = FALSE
		hardmutate()
		age = 0
		plant_health = myseed.endurance
		lastcycle = world.time
		harvest = FALSE
		weedlevel = 0 // Reset

		sleep(5) // Wait a while
		update_appearance()
		visible_message(span_warning("Мутировавшие сорняки в [src] порождают [myseed.plantname]!"))
		TRAY_NAME_UPDATE
	else
		to_chat(usr, span_warning("Несколько сорняков в [src], кажется, реагируют, но только на мгновение..."))

/**
 * Plant Death Proc.
 * Cleans up various stats for the plant upon death, including pests, harvestability, and plant health.
 */
/obj/machinery/hydroponics/proc/plantdies()
	plant_health = 0
	harvest = FALSE
	pestlevel = 0 // Pests die
	lastproduce = 0
	if(!dead)
		update_appearance()
		dead = TRUE

/**
 * Plant Cross-Pollination.
 * Checks all plants in the tray's oview range, then averages out the seed's potency, instability, and yield values.
 * If the seed's instability is >= 20, the seed donates one of it's reagents to that nearby plant.
 * * Range - The Oview range of trays to which to look for plants to donate reagents.
 */
/obj/machinery/hydroponics/proc/pollinate(range = 1)
	for(var/obj/machinery/hydroponics/T in oview(src, range))
		//Here is where we check for window blocking.
		if(!Adjacent(T) && range <= 1)
			continue
		if(T.myseed && !T.dead)
			T.myseed.set_potency(round((T.myseed.potency+(1/10)*(myseed.potency-T.myseed.potency))))
			T.myseed.set_instability(round((T.myseed.instability+(1/10)*(myseed.instability-T.myseed.instability))))
			T.myseed.set_yield(round((T.myseed.yield+(1/2)*(myseed.yield-T.myseed.yield))))
			if(myseed.instability >= 20 && prob(70) && length(T.myseed.reagents_add))
				var/list/datum/plant_gene/reagent/possible_reagents = list()
				for(var/datum/plant_gene/reagent/reag in T.myseed.genes)
					possible_reagents += reag
				var/datum/plant_gene/reagent/reagent_gene = pick(possible_reagents) //Let this serve as a lession to delete your WIP comments before merge.
				if(reagent_gene.can_add(myseed))
					if(!reagent_gene.try_upgrade_gene(myseed))
						myseed.genes += reagent_gene.Copy()
					myseed.reagents_from_genes()
					continue

/**
 * Pest Mutation Proc.
 * When a tray is mutated with high pest values, it will spawn spiders.
 * * User - Person who last added chemicals to the tray for logging purposes.
 */
/obj/machinery/hydroponics/proc/mutatepest(mob/user)
	if(pestlevel > 5)
		message_admins("[ADMIN_LOOKUPFLW(user)] last altered a hydro tray's contents which spawned spiderlings")
		log_game("[key_name(user)] last altered a hydro tray, which spiderlings spawned from.")
		visible_message(span_warning("Паразиты ведут себя странно..."))
	else if(myseed)
		visible_message(span_warning("Паразиты ведут себя странно в лотке с [myseed.name], но быстро успокаиваются..."))

/obj/machinery/hydroponics/attackby(obj/item/O, mob/user, params)
	//Called when mob user "attacks" it with object O
	if(IS_EDIBLE(O) || istype(O, /obj/item/reagent_containers))  // Syringe stuff (and other reagent containers now too)
		var/obj/item/reagent_containers/reagent_source = O

		if(istype(reagent_source, /obj/item/reagent_containers/syringe))
			var/obj/item/reagent_containers/syringe/syr = reagent_source
			if(syr.mode != 1)
				to_chat(user, span_warning("Не могу получить что-либо из этого растения.") 		)
				return

		if(!reagent_source.reagents.total_volume)
			to_chat(user, span_warning("[reagent_source] пустой!"))
			return 1

		if(reagents.total_volume >= reagents.maximum_volume && !reagent_source.reagents.has_reagent(/datum/reagent/water, 1))
			to_chat(user, span_notice("[capitalize(src.name)] полный."))
			return

		var/list/trays = list(src)//makes the list just this in cases of syringes and compost etc
		var/target = myseed ? myseed.plantname : src
		var/visi_msg = ""
		var/transfer_amount

		if(IS_EDIBLE(reagent_source) || istype(reagent_source, /obj/item/reagent_containers/pill))
			visi_msg="[user] composts [reagent_source], spreading it through [target]"
			transfer_amount = reagent_source.reagents.total_volume
			SEND_SIGNAL(reagent_source, COMSIG_ITEM_ON_COMPOSTED, user)
		else
			transfer_amount = reagent_source.amount_per_transfer_from_this
			if(istype(reagent_source, /obj/item/reagent_containers/syringe/))
				var/obj/item/reagent_containers/syringe/syr = reagent_source
				visi_msg="[user] injects [target] with [syr]"
				if(syr.reagents.total_volume <= syr.amount_per_transfer_from_this)
					syr.mode = 0
			// Beakers, bottles, buckets, etc.
			if(reagent_source.is_drainable())
				playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)

		if(visi_msg)
			visible_message(span_notice("[visi_msg]."))

		for(var/obj/machinery/hydroponics/H in trays)
		//cause I don't want to feel like im juggling 15 tamagotchis and I can get to my real work of ripping flooring apart in hopes of validating my life choices of becoming a space-gardener
			//This was originally in apply_chemicals, but due to apply_chemicals only holding nutrients, we handle it here now.
			if(reagent_source.reagents.has_reagent(/datum/reagent/water, 1))
				var/water_amt = reagent_source.reagents.get_reagent_amount(/datum/reagent/water) * transfer_amount / reagent_source.reagents.total_volume
				H.adjustWater(round(water_amt))
				reagent_source.reagents.remove_reagent(/datum/reagent/water, water_amt)
			reagent_source.reagents.trans_to(H.reagents, transfer_amount, transfered_by = user)
			if(IS_EDIBLE(reagent_source) || istype(reagent_source, /obj/item/reagent_containers/pill))
				qdel(reagent_source)
				lastuser = user
				H.update_appearance()
				return 1
			H.update_appearance()
		if(reagent_source) // If the source wasn't composted and destroyed
			reagent_source.update_appearance()
		return 1

	else if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/sample))
		if(!myseed)
			if(istype(O, /obj/item/seeds/kudzu))
				investigate_log("had Kudzu planted in it by [key_name(user)] at [AREACOORD(src)]","kudzu")
			if(!user.transferItemToLoc(O, src))
				return
			to_chat(user, span_notice("Сажаю [O]."))
			dead = FALSE
			myseed = O
			TRAY_NAME_UPDATE
			age = 1
			plant_health = myseed.endurance
			lastcycle = world.time
			update_appearance()
			return
		else
			to_chat(user, span_warning("[capitalize(src.name)] уже имеет семена внутри!"))
			return

	else if(istype(O, /obj/item/plant_analyzer))
		var/obj/item/plant_analyzer/plant_analyzer = O
		to_chat(user, plant_analyzer.scan_tray(src))
		return

	else if(istype(O, /obj/item/cultivator))
		if(weedlevel > 0)
			user.visible_message(span_notice("[user] выдирает сорняки.") , span_notice("Выдираю сорняки из [src]."))
			weedlevel = 0
			update_appearance()
			return
		else
			to_chat(user, span_warning("Этот участок полностью лишён сорняков! Тут нечего выдирать."))
			return

	else if(istype(O, /obj/item/secateurs))
		if(!myseed)
			to_chat(user, span_notice("Этот участок пустой."))
			return
		else if(!harvest)
			to_chat(user, span_notice("Это растение должно быть выросшим, чтобы его привить."))
			return
		else if(myseed.grafted)
			to_chat(user, span_notice("Это растение уже привито."))
			return
		else
			user.visible_message(span_notice("[user] трансплантирует конечность из [src].") , span_notice("Осторожно трансплантирую часть [src]."))
			var/obj/item/graft/snip = myseed.create_graft()
			if(!snip)
				return // The plant did not return a graft.

			snip.forceMove(drop_location())
			myseed.grafted = TRUE
			adjustHealth(-5)
			return

	else if(istype(O, /obj/item/geneshears))
		if(!myseed)
			to_chat(user, span_notice("Лоток пустой."))
			return
		if(plant_health <= GENE_SHEAR_MIN_HEALTH)
			to_chat(user, span_notice("Это растение выглядит слишком нездоровым, чтобы его обстригать прямо сейчас."))
			return

		var/list/current_traits = list()
		for(var/datum/plant_gene/gene in myseed.genes)
			if(istype(gene, /datum/plant_gene/core) || (istype(gene,/datum/plant_gene/trait/plant_type)) || islist(gene))
				continue
			if(!(gene.mutability_flags & PLANT_GENE_REMOVABLE) || !(gene.mutability_flags & PLANT_GENE_EXTRACTABLE))
				continue //No bypassing unextractable or essential genes.
			current_traits[gene.name] = gene
		var/removed_trait = (input(user, "Select a trait to remove from the [myseed.plantname].", "Plant Trait Removal") as null|anything in sort_list(current_traits))
		if(removed_trait == null)
			return
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(!myseed)
			return
		if(plant_health <= GENE_SHEAR_MIN_HEALTH) //Check health again to make sure they're not keeping inputs open to get free shears.
			return
		for(var/datum/plant_gene/gene in myseed.genes)
			if(gene.name == removed_trait)
				if(myseed.genes.Remove(gene))
					qdel(gene)
					break
		myseed.reagents_from_genes()
		adjustHealth(-15)
		to_chat(user, span_notice("Аккуратно отрезаю гены с [myseed.plantname], оставляя растения выглядеть слабее."))
		update_appearance()
		return

	else if(istype(O, /obj/item/graft))
		var/obj/item/graft/snip = O
		if(!myseed)
			to_chat(user, span_notice("Лоток пустой."))
			return
		if(!myseed.apply_graft(snip))
			to_chat(user, span_warning("[myseed.plantname] отвергает [snip]!"))
			return
		qdel(snip)
		to_chat(user, span_notice("Тщательно интегрирую привитую ветвь [myseed.plantname]."))
		return

	else if(istype(O, /obj/item/storage/bag/plants))
		attack_hand(user)
		for(var/obj/item/food/grown/G in locate(user.x,user.y,user.z))
			SEND_SIGNAL(O, COMSIG_TRY_STORAGE_INSERT, G, user, TRUE)
		return

	else if(default_unfasten_wrench(user, O))
		return

	else if(istype(O, /obj/item/shovel/spade))
		if(!myseed && !weedlevel)
			to_chat(user, span_warning("[capitalize(src.name)] нет никаких растения или сорняков!"))
			return
		user.visible_message(span_notice("[user] выкапывает [src]...") ,
			span_notice("Выкапываю [src]..."))
		if(O.use_tool(src, user, 50, volume=50) || (!myseed && !weedlevel))
			user.visible_message(span_notice("[user] выкапывает [src]!") , span_notice("Выкопал [src]!"))
			if(myseed) //Could be that they're just using it as a de-weeder
				age = 0
				plant_health = 0
				lastproduce = 0
				if(harvest)
					harvest = FALSE //To make sure they can't just put in another seed and insta-harvest it
				qdel(myseed)
				myseed = null
				name = initial(name)
				desc = initial(desc)
			weedlevel = 0 //Has a side effect of cleaning up those nasty weeds
			update_appearance()
			return
	else
		return ..()

/obj/machinery/hydroponics/can_be_unfasten_wrench(mob/user, silent)
	if (!unwrenchable)  // case also covered by NODECONSTRUCT checks in default_unfasten_wrench
		return CANT_UNFASTEN

	return ..()

/obj/machinery/hydroponics/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(harvest)
		return myseed.harvest(user)

	else if(dead)
		dead = FALSE
		to_chat(user, span_notice("Убираю мёртвое растение из [src]."))
		qdel(myseed)
		myseed = null
		update_appearance()
		TRAY_NAME_UPDATE
	else
		if(user)
			user.examinate(src)

/obj/machinery/hydroponics/CtrlClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(!powered())
		to_chat(user, span_warning("[name] без питания."))
		update_use_power(NO_POWER_USE)
		return
	if(!anchored)
		return
	self_sustaining = !self_sustaining
	update_use_power(self_sustaining ? IDLE_POWER_USE : NO_POWER_USE)
	to_chat(user, "<span class='notice'>[self_sustaining ? "activate" : "deactivated"] [src] функцию автороста[self_sustaining ? ", maintaining the tray's health while using high amounts of power" : ""].")

	update_appearance()

/obj/machinery/hydroponics/AltClick(mob/user)
	. = ..()
	if(!anchored)
		update_appearance()
		return FALSE
	var/warning = tgui_alert(user, "Are you sure you wish to empty the tray's nutrient beaker?","Empty Tray Nutrients?", list("Yes", "No"))
	if(warning == "Yes" && user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		reagents.clear_reagents()
		to_chat(user, span_warning("Опустошаю питательные вещества [src]."))

/**
 * Update Tray Proc
 * Handles plant harvesting on the tray side, by clearing the sead, names, description, and dead stat.
 * Shuts off autogrow if enabled.
 * Sends messages to the cleaer about plants harvested, or if nothing was harvested at all.
 * * User - The mob who clears the tray.
 */
/obj/machinery/hydroponics/proc/update_tray(mob/user)
	harvest = FALSE
	lastproduce = age
	if(istype(myseed, /obj/item/seeds/replicapod))
		to_chat(user, span_notice("Собираю плоды с [myseed.plantname]."))
	else if(myseed.getYield() <= 0)
		to_chat(user, span_warning("Не смог собрать ничего полезного!"))
	else
		to_chat(user, span_notice("Собираю [myseed.getYield()] плодов с [myseed.plantname]."))
	if(!myseed.get_gene(/datum/plant_gene/trait/repeated_harvest))
		qdel(myseed)
		myseed = null
		dead = FALSE
		name = initial(name)
		desc = initial(desc)
		TRAY_NAME_UPDATE
		if(self_sustaining) //No reason to pay for an empty tray.
			update_use_power(NO_POWER_USE)
			self_sustaining = FALSE
	update_appearance()

/// Tray Setters - The following procs adjust the tray or plants variables, and make sure that the stat doesn't go out of bounds.
/**
 * Adjust water.
 * Raises or lowers tray water values by a set value. Adding water will dillute toxicity from the tray.
 * * adjustamt - determines how much water the tray will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustWater(adjustamt)
	waterlevel = clamp(waterlevel + adjustamt, 0, maxwater)

	if(adjustamt>0)
		adjustToxic(-round(adjustamt/4))//Toxicity dilutation code. The more water you put in, the lesser the toxin concentration.

/**
 * Adjust Health.
 * Raises the tray's plant_health stat by a given amount, with total health determined by the seed's endurance.
 * * adjustamt - Determines how much the plant_health will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustHealth(adjustamt)
	if(myseed && !dead)
		plant_health = clamp(plant_health + adjustamt, 0, myseed.endurance)

/**
 * Adjust Health.
 * Raises the plant's plant_health stat by a given amount, with total health determined by the seed's endurance.
 * * adjustamt - Determines how much the plant_health will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustToxic(adjustamt)
	toxic = clamp(toxic + adjustamt, 0, MAX_TRAY_TOXINS)

/**
 * Adjust Pests.
 * Raises the tray's pest level stat by a given amount.
 * * adjustamt - Determines how much the pest level will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustPests(adjustamt)
	pestlevel = clamp(pestlevel + adjustamt, 0, MAX_TRAY_PESTS)

/**
 * Adjust Weeds.
 * Raises the plant's weed level stat by a given amount.
 * * adjustamt - Determines how much the weed level will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustWeeds(adjustamt)
	weedlevel = clamp(weedlevel + adjustamt, 0, MAX_TRAY_PESTS)

/**
 * Spawn Plant.
 * Upon using strange reagent on a tray, it will spawn a killer tomato or killer tree at random.
 */
/obj/machinery/hydroponics/proc/spawnplant() // why would you put strange reagent in a hydro tray you monster I bet you also feed them blood
	var/list/livingplants = list(/mob/living/simple_animal/hostile/tree, /mob/living/simple_animal/hostile/killertomato)
	var/chosen = pick(livingplants)
	var/mob/living/simple_animal/hostile/C = new chosen
	C.faction = list("plants")

///////////////////////////////////////////////////////////////////////////////
/obj/machinery/hydroponics/soil //Not actually hydroponics at all! Honk!
	name = "Почва"
	desc = "Пятно грязи."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "soil"
	gender = PLURAL
	density = FALSE
	use_power = NO_POWER_USE
	flags_1 = NODECONSTRUCT_1
	unwrenchable = FALSE

/obj/machinery/hydroponics/soil/update_icon(updates=ALL)
	. = ..()
	if(self_sustaining)
		add_atom_colour(rgb(255, 175, 0), FIXED_COLOUR_PRIORITY)

/obj/machinery/hydroponics/soil/update_status_light_overlays()
	return // Has no lights

/obj/machinery/hydroponics/soil/attackby(obj/item/O, mob/user, params)
	if(O.tool_behaviour == TOOL_SHOVEL && !istype(O, /obj/item/shovel/spade)) //Doesn't include spades because of uprooting plants
		to_chat(user, span_notice("Очищаю [src]!"))
		qdel(src)
	else
		return ..()

/obj/machinery/hydroponics/soil/CtrlClick(mob/user)
	return //Soil has no electricity.
