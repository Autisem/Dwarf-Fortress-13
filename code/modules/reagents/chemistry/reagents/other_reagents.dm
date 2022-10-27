/datum/reagent/blood
	data = list("blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null)
	name = "Blood"
	color = "#C80000" // rgb: 200, 0, 0
	metabolization_rate = 12.5 * REAGENTS_METABOLISM //fast rate so it disappears fast.
	taste_description = "iron"
	taste_mult = 1.3
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	shot_glass_icon_state = "shotglassred"
	penetrates_skin = NONE
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/liquidgibs
	name = "Liquid Gibs"
	color = "#CC4633"
	description = "You don't even want to think about what's in here."
	taste_description = "gross iron"
	shot_glass_icon_state = "shotglassred"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/ash
	name = "Ash"
	description = "Supposedly phoenixes rise from these, but you've never seen it."
	reagent_state = LIQUID
	color = "#515151"
	taste_description = "ash"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/ants
	name = "Ants"
	description = "A genetic crossbreed between ants and termites, their bites land at a 3 on the Schmidt Pain Scale."
	reagent_state = SOLID
	color = "#993333"
	taste_mult = 1.3
	taste_description = "tiny legs scuttling down the back of your throat"
	metabolization_rate = 5 * REAGENTS_METABOLISM //1u per second
	glass_name = "glass of ants"
	glass_desc = "Bottoms up...?"
	/// How much damage the ants are going to be doing (rises with each tick the ants are in someone's body)
	var/ant_damage = 0
	/// Tells the debuff how many ants we are being covered with.
	var/amount_left = 0
	/// List of possible common statements to scream when eating ants
	var/static/list/ant_screams = list(
		"THEY'RE UNDER MY SKIN!!",
		"GET THEM OUT OF ME!!",
		"HOLY HELL THEY BURN!!",
		"MY GOD THEY'RE INSIDE ME!!",
		"GET THEM OUT!!"
		)

/datum/reagent/ants/on_mob_life(mob/living/carbon/victim, delta_time)
	victim.adjustBruteLoss(max(0.1, round((ant_damage * 0.025),0.1))) //Scales with time. Roughly 32 brute with 100u.
	ant_damage++
	if(ant_damage < 5) // Makes ant food a little more appetizing, since you won't be screaming as much.
		return ..()
	if(DT_PROB(5, delta_time))
		if(DT_PROB(5, delta_time)) //Super rare statement
			victim.say("AUGH NO NOT THE ANTS! NOT THE ANTS! AAAAUUGH THEY'RE IN MY EYES! MY EYES! AUUGH!!", forced = /datum/reagent/ants)
		else
			victim.say(pick(ant_screams), forced = /datum/reagent/ants)
	if(DT_PROB(15, delta_time))
		victim.emote("scream")
	if(DT_PROB(2, delta_time)) // Stuns, but purges ants.
		victim.vomit(rand(5,10), FALSE, TRUE, 1, TRUE, FALSE, purge_ratio = 1)
	return ..()

/datum/reagent/ants/on_mob_end_metabolize(mob/living/living_anthill)
	ant_damage = 0
	to_chat(living_anthill, "<span class='notice'>You feel like the last of the ants are out of your system.</span>")
	return ..()

/datum/reagent/ants/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob) || (methods & (INGEST|INJECT)))
		return
	if(methods & (PATCH|TOUCH|VAPOR))
		amount_left = round(reac_volume,0.1)
		exposed_mob.apply_status_effect(/datum/status_effect/ants, amount_left)

/datum/reagent/ants/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	var/turf/open/my_turf = exposed_obj.loc // No dumping ants on an object in a storage slot
	if(!istype(my_turf)) //Are we actually in an open turf?
		return
	var/static/list/accepted_types = typecacheof(list())
	if(!accepted_types[exposed_obj.type]) // Bypasses pipes, vents, and cables to let people create ant mounds on top easily.
		return
	expose_turf(my_turf, reac_volume)

/datum/reagent/ants/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf) || isopenspace(exposed_turf)) // Is the turf valid
		return
	if((reac_volume <= 10)) // Makes sure people don't duplicate ants.
		return

	var/obj/effect/decal/cleanable/ants/pests = locate() in exposed_turf.contents
	if(!pests)
		pests = new(exposed_turf)
	var/spilled_ants = (round(reac_volume,1) - 5) // To account for ant decals giving 3-5 ants on initialize.
	pests.reagents.add_reagent(/datum/reagent/ants, spilled_ants)
