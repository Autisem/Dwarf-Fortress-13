/datum/reagent/blood
	data = list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null)
	name = "Кровь"
	enname = "Blood"
	color = "#C80000" // rgb: 200, 0, 0
	metabolization_rate = 5 //fast rate so it disappears fast.
	taste_description = "железо"
	taste_mult = 1.3
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	shot_glass_icon_state = "shotglassred"
	penetrates_skin = NONE
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/blood/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(iscarbon(exposed_mob))
		var/mob/living/carbon/exposed_carbon = exposed_mob
		if(exposed_carbon.get_blood_id() == /datum/reagent/blood && ((methods & INJECT) || ((methods & INGEST) && exposed_carbon.dna && exposed_carbon.dna.species && (DRINKSBLOOD in exposed_carbon.dna.species.species_traits))))
			if(!data || !(data["blood_type"] in get_safe_blood(exposed_carbon.dna.blood_type)))
				exposed_carbon.reagents.add_reagent(/datum/reagent/toxin, reac_volume * 0.5)
			else
				exposed_carbon.blood_volume = min(exposed_carbon.blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM)

/datum/reagent/blood/on_merge(list/mix_data)
	if(data && mix_data)
		if(data["blood_DNA"] != mix_data["blood_DNA"])
			data["cloneable"] = 0 //On mix, consider the genetic sampling unviable for pod cloning if the DNA sample doesn't match.
	return 1

/datum/reagent/blood/expose_turf(turf/exposed_turf, reac_volume)//splash the blood all over the place
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume < 3)
		return

	var/obj/effect/decal/cleanable/blood/bloodsplatter = locate() in exposed_turf //find some blood here
	if(!bloodsplatter)
		bloodsplatter = new(exposed_turf)
	if(data["blood_DNA"])
		bloodsplatter.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

/datum/reagent/liquidgibs
	name = "Жидкие Внутренности"
	enname = "Liquid gibs"
	color = "#CC4633"
	description = "You don't even want to think about what's in here."
	taste_description = "жирное железо"
	shot_glass_icon_state = "shotglassred"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/bone_dust
	name = "bone dust"
	enname = "bone dust"
	color = "#dbcdcb"
	description = "Ground up bones, gross!"
	taste_description = "the most disgusting grain in existence"
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/water
	name = "Вода"
	enname = "Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen."
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "вода"
	var/cooling_temperature = 2
	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = "The father of all refreshments."
	shot_glass_icon_state = "shotglassclear"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/*
 *	Water reaction to turf
 */

/datum/reagent/water/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return

	if(reac_volume >= 5)
		exposed_turf.MakeSlippery(TURF_WET_WATER, 10 SECONDS, min(reac_volume*1.5 SECONDS, 60 SECONDS))


/*
 *	Water reaction to an object
 */

/datum/reagent/water/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	exposed_obj.extinguish()
	exposed_obj.wash(CLEAN_TYPE_ACID)

	if(istype(exposed_obj, /obj/item/stack/sheet/hairlesshide))
		var/obj/item/stack/sheet/hairlesshide/HH = exposed_obj
		new /obj/item/stack/sheet/wethide(get_turf(HH), HH.amount)
		qdel(HH)

/*
 *	Water reaction to a mob
 */

/datum/reagent/water/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with water can help put them out!
	. = ..()
	if(methods & TOUCH)
		exposed_mob.extinguish_mob() // extinguish removes all fire stacks

/datum/reagent/water/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = ..()
	if(M.blood_volume)
		M.blood_volume += 0.1 * REM * delta_time // water is good for you!

/datum/reagent/water/holywater
	name = "Святая Вода"
	enname = "Holy Water"
	description = "Water blessed by some deity."
	color = "#E0E8EF" // rgb: 224, 232, 239
	glass_icon_state  = "glass_clear"
	glass_name = "glass of holy water"
	glass_desc = "A glass of holy water."
	self_consuming = TRUE //divine intervention won't be limited by the lack of a liver
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/water/holywater/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_HOLY, type)

/datum/reagent/water/holywater/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_HOLY, type)
	if(HAS_TRAIT_FROM(L, TRAIT_DEPRESSION, HOLYWATER_TRAIT))
		REMOVE_TRAIT(L, TRAIT_DEPRESSION, HOLYWATER_TRAIT)
		to_chat(L, span_notice("You cheer up, knowing that everything is going to be ok."))
	..()

/datum/reagent/water/holywater/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.blood_volume)
		M.blood_volume += 0.1 * REM * delta_time // water is good for you!
	if(!data)
		data = list("misc" = 0)

	data["misc"] += delta_time SECONDS * REM
	M.jitteriness = min(M.jitteriness + (2 * delta_time), 10)
	if(data["misc"] >= 25)		// 10 units, 45 seconds @ metabolism 0.4 units & tick rate 1.8 sec
		if(!M.stuttering)
			M.stuttering = 1
		M.stuttering = min(M.stuttering + (2 * delta_time), 10)
		M.Dizzy(5)
	if(data["misc"] >= 60)	// 30 units, 135 seconds
		M.jitteriness = 0
		M.stuttering = 0
		holder.remove_reagent(type, volume)	// maybe this is a little too perfect and a max() cap on the statuses would be better??
		return
	holder.remove_reagent(type, 1 * REAGENTS_METABOLISM * delta_time)	//fixed consumption to prevent balancing going out of whack

/datum/reagent/water/holywater/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	exposed_turf.Bless()

/datum/reagent/water/hollowwater
	name = "Полая Вода"
	enname = "Hollow Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen, but it looks kinda hollow."
	color = "#88878777"
	taste_description = "пустота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/hydrogen_peroxide
	name = "Перекись Водорода"
	enname = "Hydrogen peroxide"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen and oxygen." //intended intended
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "горящая вода"
	var/cooling_temperature = 2
	glass_icon_state = "glass_clear"
	glass_name = "glass of oxygenated water"
	glass_desc = "The father of all refreshments. Surely it tastes great, right?"
	shot_glass_icon_state = "shotglassclear"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/*
 *	Water reaction to turf
 */

/datum/reagent/hydrogen_peroxide/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume >= 5)
		exposed_turf.MakeSlippery(TURF_WET_WATER, 10 SECONDS, min(reac_volume*1.5 SECONDS, 60 SECONDS))
/*
 *	Water reaction to a mob
 */

/datum/reagent/hydrogen_peroxide/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with h2o2 can burn them !
	. = ..()
	if(methods & TOUCH)
		exposed_mob.adjustFireLoss(2, 0) // burns

/datum/reagent/fuel/unholywater		//if you somehow managed to extract this from someone, dont splash it on yourself and have a smoke
	name = "Нечистивая Вода"
	enname = "Unholy Water"
	description = "Something that shouldn't exist on this plane of existence."
	taste_description = "страдания"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM  //1u/tick
	penetrates_skin = TOUCH|VAPOR
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_MEDIUM

/datum/reagent/fuel/unholywater/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * REM * delta_time, 150)
	M.adjustToxLoss(1 * REM * delta_time, 0)
	M.adjustFireLoss(1 * REM * delta_time, 0)
	M.adjustOxyLoss(1 * REM * delta_time, 0)
	M.adjustBruteLoss(1 * REM * delta_time, 0)
	..()

/datum/reagent/hellwater			//if someone has this in their system they've really pissed off an eldrich god
	name = "Адская Вода"
	enname = "Hell Water"
	description = "YOUR FLESH! IT BURNS!"
	taste_description = "сжигание"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_LOW

/datum/reagent/hellwater/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.set_fire_stacks(min(M.fire_stacks + (1.5 * delta_time), 5))
	M.IgniteMob()			//Only problem with igniting people is currently the commonly available fire suits make you immune to being on fire
	M.adjustToxLoss(1, 0)
	M.adjustFireLoss(1, 0)		//Hence the other damages... ain't I a bastard?
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2.5 * delta_time, 150)
	holder.remove_reagent(type, 0.5 * delta_time)

/datum/reagent/medicine/omnizine/godblood
	name = "Кровь Бога"
	enname = "Godblood"
	description = "Slowly heals all damage types. Has a rather high overdose threshold. Glows with mysterious power."
	overdose_threshold = 150
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

///Used for clownery
/datum/reagent/lube
	name = "Космическая Смазка"
	enname = "Space Lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	color = "#009CA8" // rgb: 0, 156, 168
	taste_description = "вишня" // by popular demand
	var/lube_kind = TURF_WET_LUBE ///What kind of slipperiness gets added to turfs.
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/lube/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume >= 1)
		exposed_turf.MakeSlippery(lube_kind, 15 SECONDS, min(reac_volume * 2 SECONDS, 120))

///Stronger kind of lube. Applies TURF_WET_SUPERLUBE.
/datum/reagent/lube/superlube
	name = "Супер-Дупер Смазка"
	enname = "Super Duper Lube"
	description = "This \[REDACTED\] has been outlawed after the incident on \[DATA EXPUNGED\]."
	lube_kind = TURF_WET_SUPERLUBE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/spraytan
	name = "Спрей для Загара"
	enname = "Spray Tan"
	description = "A substance applied to the skin to darken the skin."
	color = "#FFC080" // rgb: 255, 196, 128  Bright orange
	metabolization_rate = 10 * REAGENTS_METABOLISM // very fast, so it can be applied rapidly.  But this changes on an overdose
	overdose_threshold = 11 //Slightly more than one un-nozzled spraybottle.
	taste_description = "кислые апельсины"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/spraytan/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE)
	. = ..()
	if(ishuman(exposed_mob))
		if(methods & (PATCH|VAPOR))
			var/mob/living/carbon/human/exposed_human = exposed_mob
			if(exposed_human.dna.species.id == "human")
				switch(exposed_human.skin_tone)
					if("african1")
						exposed_human.skin_tone = "african2"
					if("indian")
						exposed_human.skin_tone = "african1"
					if("arab")
						exposed_human.skin_tone = "indian"
					if("asian2")
						exposed_human.skin_tone = "arab"
					if("asian1")
						exposed_human.skin_tone = "asian2"
					if("mediterranean")
						exposed_human.skin_tone = "african1"
					if("latino")
						exposed_human.skin_tone = "mediterranean"
					if("caucasian3")
						exposed_human.skin_tone = "mediterranean"
					if("caucasian2")
						exposed_human.skin_tone = pick("caucasian3", "latino")
					if("caucasian1")
						exposed_human.skin_tone = "caucasian2"
					if ("albino")
						exposed_human.skin_tone = "caucasian1"

			if(MUTCOLORS in exposed_human.dna.species.species_traits) //take current alien color and darken it slightly
				var/newcolor = ""
				var/string = exposed_human.dna.features["mcolor"]
				var/len = length(string)
				var/char = ""
				var/ascii = 0
				for(var/i=1, i<=len, i += length(char))
					char = string[i]
					ascii = text2ascii(char)
					switch(ascii)
						if(48)
							newcolor += "0"
						if(49 to 57)
							newcolor += ascii2text(ascii-1)	//numbers 1 to 9
						if(97)
							newcolor += "9"
						if(98 to 102)
							newcolor += ascii2text(ascii-1)	//letters b to f lowercase
						if(65)
							newcolor += "9"
						if(66 to 70)
							newcolor += ascii2text(ascii+31)	//letters B to F - translates to lowercase
						else
							break
				if(ReadHSV(newcolor)[3] >= ReadHSV("#7F7F7F")[3])
					exposed_human.dna.features["mcolor"] = newcolor
			exposed_human.regenerate_icons()

		if((methods & INGEST) && show_message)
			to_chat(exposed_mob, span_notice("Вкус говнище."))


/datum/reagent/spraytan/overdose_process(mob/living/M, delta_time, times_fired)
	metabolization_rate = 1 * REAGENTS_METABOLISM

	if(ishuman(M))
		var/mob/living/carbon/human/N = M
		if(!HAS_TRAIT(N, TRAIT_BALD))
			N.hairstyle = "Spiky"
		N.facial_hairstyle = "Shaved"
		N.facial_hair_color = "000"
		N.hair_color = "000"
		if(!(HAIR in N.dna.species.species_traits)) //No hair? No problem!
			N.dna.species.species_traits += HAIR
		if(N.dna.species.use_skintones)
			N.skin_tone = "orange"
		else if(MUTCOLORS in N.dna.species.species_traits) //Aliens with custom colors simply get turned orange
			N.dna.features["mcolor"] = "f80"
		N.regenerate_icons()
		if(DT_PROB(3.5, delta_time))
			if(N.w_uniform)
				M.visible_message(pick("<b>[M]</b>'s collar pops up without warning.</span>", "<b>[M]</b> flexes [M.p_their()] arms."))
			else
				M.visible_message("<b>[M]</b> сгибает [M.p_their()] руки.")
	if(DT_PROB(5, delta_time))
		M.say(pick("Shit was SO cash.", "You are everything bad in the world.", "What sports do you play, other than 'jack off to naked drawn Japanese people?'", "Don???t be a stranger. Just hit me with your best shot.", "My name is John and I hate every single one of you."), forced = /datum/reagent/spraytan)
	..()
	return

/datum/reagent/mulligan
	name = "Токсин Муллигана"
	enname = "Mulligan Toxin"
	description = "This toxin will rapidly change the DNA of human beings. Commonly used by Syndicate spies and assassins in need of an emergency ID change."
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = INFINITY
	taste_description = "слайм"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/mulligan/on_mob_life(mob/living/carbon/human/H, delta_time, times_fired)
	..()
	if (!istype(H))
		return
	to_chat(H, span_warning("<b>Стискиваю зубы от боли, появившейся во время быстрой мутации моего тела!</b>"))
	H.visible_message("<b>[H]</b> внезапно трансформировался!")
	randomize_human(H)

/datum/reagent/aslimetoxin
	name = "Токсин Расширенной Мутации"
	enname = "Advanced Mutation Toxin"
	description = "An advanced corruptive toxin produced by slimes."
	color = "#13BC5E" // rgb: 19, 188, 94
	taste_description = "слайм"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/gluttonytoxin
	name = "Благословение Обжорства"
	enname = "Gluttony's Blessing"
	description = "An advanced corruptive toxin produced by something terrible."
	color = "#5EFF3B" //RGB: 94, 255, 59
	taste_description = "распад"
	penetrates_skin = NONE
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/apostletoxin
	name = "Вознесение"
	enname = "Apostle Mutation Toxin"
	description = "Как такие вещи попадают на космические станции?"
	color = "#fcf807"
	taste_description = "смех"
	penetrates_skin = NONE
	hydration_factor = DRINK_HYDRATION_FACTOR_HIGH

/datum/reagent/serotrotium
	name = "Серотроций"
	enname = "Serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	color = "#202040" // rgb: 20, 20, 40
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/serotrotium/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(ishuman(M))
		if(DT_PROB(3.5, delta_time))
			M.emote(pick("twitch","drool","moan","gasp"))
	..()

/datum/reagent/oxygen
	name = "Кислород"
	enname = "Oxygen"
	description = "A colorless, odorless gas. Grows on trees but is still pretty valuable."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0 // oderless and tasteless
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/nitrogen
	name = "Азот"
	enname = "Nitrogen"
	description = "A colorless, odorless, tasteless gas. A simple asphyxiant that can silently displace vital oxygen."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/hydrogen
	name = "Водород"
	enname = "Hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/potassium
	name = "Калий"
	enname = "Potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	taste_description = "сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mercury
	name = "Ртуть"
	enname = "Mercury"
	description = "A curious metal that's a liquid at room temperature. Neurodegenerative and very bad for the mind."
	color = "#484848" // rgb: 72, 72, 72A
	taste_mult = 0 // apparently tasteless.
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mercury/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(!HAS_TRAIT(src, TRAIT_IMMOBILIZED) && !isspaceturf(M.loc))
		step(M, pick(GLOB.cardinals))
	if(DT_PROB(3.5, delta_time))
		M.emote(pick("twitch","drool","moan"))
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5*delta_time)
	..()

/datum/reagent/sulfur
	name = "Сера"
	enname = "Sulfur"
	description = "A sickly yellow solid mostly known for its nasty smell. It's actually much more helpful than it looks in biochemisty."
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	taste_description = "гнилые яйца"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carbon
	name = "Углерод"
	enname = "Carbon"
	description = "A crumbly black solid that, while unexciting on a physical level, forms the base of all known life. Kind of a big deal."
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0
	taste_description = "кислый мел"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carbon/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/dirt/dirt_decal = (locate() in exposed_turf.contents)
	if(!dirt_decal)
		dirt_decal = new(exposed_turf)

/datum/reagent/chlorine
	name = "Хлор"
	enname = "Chlorine"
	description = "A pale yellow gas that's well known as an oxidizer. While it forms many harmless molecules in its elemental form it is far from harmless."
	reagent_state = GAS
	color = "#FFFB89" //pale yellow? let's make it light gray
	taste_description = "хлорка"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/chlorine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.take_bodypart_damage(0.5*REM*delta_time, 0, 0, 0)
	. = TRUE
	..()

/datum/reagent/fluorine
	name = "Фтор"
	enname = "Fluorine"
	description = "A comically-reactive chemical element. The universe does not want this stuff to exist in this form in the slightest."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "кислота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/fluorine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustToxLoss(0.5*REM*delta_time, 0)
	. = TRUE
	..()

/datum/reagent/sodium
	name = "Натрий"
	enname = "Sodium"
	description = "A soft silver metal that can easily be cut with a knife. It's not salt just yet, so refrain from putting it on your chips."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "солёный металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/phosphorus
	name = "Фосфор"
	enname = "Phosphorus"
	description = "A ruddy red powder that burns readily. Though it comes in many colors, the general theme is always the same."
	reagent_state = SOLID
	color = "#832828" // rgb: 131, 40, 40
	taste_description = "уксус"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/lithium
	name = "Литий"
	enname = "Lithium"
	description = "A silver metal, its claim to fame is its remarkably low density. Using it is a bit too effective in calming oneself down."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/lithium/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED) && !isspaceturf(M.loc))
		step(M, pick(GLOB.cardinals))
	if(DT_PROB(2.5, delta_time))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/glycerol
	name = "Глицерин"
	enname = "Glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	color = "#D3B913"
	taste_description = "сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/space_cleaner/sterilizine
	name = "Антисептик"
	enname = "Sterilizine"
	description = "Sterilizes wounds in preparation for surgery."
	color = "#D0EFEE" // space cleaner but lighter
	taste_description = "горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/space_cleaner/sterilizine/expose_mob(mob/living/carbon/exposed_carbon, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & (TOUCH|VAPOR|PATCH)))
		return

	for(var/s in exposed_carbon.surgeries)
		var/datum/surgery/surgery = s
		surgery.speed_modifier = max(0.2, surgery.speed_modifier)

/datum/reagent/iron
	name = "Железо"
	enname = "Iron"
	description = "Pure iron is a metal."
	reagent_state = SOLID
	taste_description = "железо"
	material = /datum/material/iron
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	color = "#606060" //pure iron? let's make it violet of course

/datum/reagent/iron/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.blood_volume += 0.25 * delta_time
	..()

/datum/reagent/iron/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!holder || (holder.chem_temp >= 100)) // COLD iron.
		return

	exposed_mob.reagents.add_reagent(/datum/reagent/toxin, reac_volume)

/datum/reagent/gold
	name = "Золото"
	enname = "Gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	taste_description = "дорогой металл"
	material = /datum/material/gold
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED



/datum/reagent/silver
	name = "Серебро"
	enname = "Silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	taste_description = "дорогой, но разумный металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium
	name ="Uranium"
	enname ="Uranium"
	description = "A jade-green metallic chemical element in the actinide series, weakly radioactive."
	reagent_state = SOLID
	color = "#5E9964" //this used to be silver, but liquid uranium can still be green and it's more easily noticeable as uranium like this so why bother?
	taste_description = "внутренности реактора"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if((reac_volume < 3) || isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/greenglow/glow = locate() in exposed_turf.contents
	if(!glow)
		glow = new(exposed_turf)
	if(!QDELETED(glow))
		glow.reagents.add_reagent(type, reac_volume)

/datum/reagent/uranium/radium
	name = "Радий"
	enname = "Radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = SOLID
	color = "#00CC00" // ditto
	taste_description = "синий цвет и сожаление"
	material = null
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/bluespace
	name = "Bluespace Пыль"
	enname = "Bluespace Dust"
	description = "A dust composed of microscopic bluespace crystals, with minor space-warping properties."
	reagent_state = SOLID
	color = "#0000CC"
	taste_description = "шипучий синий"
	material = /datum/material/bluespace
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/bluespace/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		do_teleport(exposed_mob, get_turf(exposed_mob), (reac_volume / 5), asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE) //4 tiles per crystal

/datum/reagent/bluespace/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle > 10 && DT_PROB(7.5, delta_time))
		to_chat(M, span_warning("Чувствую себя нестабильно..."))
		M.Jitter(2)
		current_cycle = 1
		addtimer(CALLBACK(M, /mob/living/proc/bluespace_shuffle), 30)
	..()

/mob/living/proc/bluespace_shuffle()
	do_teleport(src, get_turf(src), 5, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)

/datum/reagent/aluminium
	name = "Алюминий"
	enname = "Aluminium"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_description = "металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/silicon
	name = "Кремний"
	enname = "Silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_mult = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/fuel
	name = "Сварочное топливо"
	enname = "Welding fuel"
	description = "Required for welders. Flammable."
	color = "#660000" // rgb: 102, 0, 0
	taste_description = "валовой металл"
	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of welder fuel"
	glass_desc = "Unless you're an industrial tool, this is probably not safe for consumption."
	penetrates_skin = NONE
	burning_temperature = 1725 //more refined than oil
	burning_volume = 0.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/alcohol = 4)
	hydration_factor = DRINK_HYDRATION_FACTOR_SALTY

/datum/reagent/fuel/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with welding fuel to make them easy to ignite!
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_fire_stacks(reac_volume / 10)

/datum/reagent/fuel/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustToxLoss(0.5*delta_time, 0)
	..()
	return TRUE

/datum/reagent/space_cleaner
	name = "Космочист"
	enname = "Space cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	color = "#A5F0EE" // rgb: 165, 240, 238
	taste_description = "кислотность"
	reagent_weight = 0.6 //so it sprays further
	penetrates_skin = NONE
	var/clean_types = CLEAN_WASH
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/space_cleaner/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	exposed_obj?.wash(clean_types)

/datum/reagent/space_cleaner/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(reac_volume < 1)
		return

	exposed_turf.wash(clean_types)
	for(var/am in exposed_turf)
		var/atom/movable/movable_content = am
		if(ismopable(movable_content)) // Mopables will be cleaned anyways by the turf wash
			continue
		movable_content.wash(clean_types)

/datum/reagent/space_cleaner/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.wash(clean_types)

/datum/reagent/space_cleaner/ez_clean
	name = "Очиститель «EZ»"
	enname = "EZ Clean"
	description = "A powerful, acidic cleaner sold by Waffle Co. Affects organic matter while leaving other objects unaffected."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "кислота"
	penetrates_skin = VAPOR
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/space_cleaner/ez_clean/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustBruteLoss(1.665*delta_time)
	M.adjustFireLoss(1.665*delta_time)
	M.adjustToxLoss(1.665*delta_time)
	..()

/datum/reagent/space_cleaner/ez_clean/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if((methods & (TOUCH|VAPOR)))
		exposed_mob.adjustBruteLoss(1.5)
		exposed_mob.adjustFireLoss(1.5)

/datum/reagent/cryptobiolin
	name = "Криптобиолин"
	enname = "Cryptobiolin"
	description = "Cryptobiolin causes confusion and dizziness."
	color = "#ADB5DB" //i hate default violets and 'crypto' keeps making me think of cryo so it's light blue now
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "кислотность"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/cryptobiolin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.Dizzy(1)
	M.set_confusion(clamp(M.get_confusion(), 1, 20))
	..()

/datum/reagent/impedrezene
	name = "Импедрезин"
	enname = "Impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	color = "#E07DDD" // pink = happy = dumb
	taste_description = "онемение"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/opiods = 10)

/datum/reagent/impedrezene/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.jitteriness = max(M.jitteriness - (2.5*delta_time),0)
	if(DT_PROB(55, delta_time))
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2)
	if(DT_PROB(30, delta_time))
		M.drowsyness = max(M.drowsyness, 3)
	if(DT_PROB(5, delta_time))
		M.emote("drool")
	..()

/datum/reagent/nanomachines
	name = "Наномашины"
	enname = "Nanomachines"
	description = "Microscopic construction robots."
	color = "#535E66" // rgb: 83, 94, 102
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	taste_description = "отстой"
	penetrates_skin = NONE

/datum/reagent/xenomicrobes
	name = "Ксеномикробы"
	enname = "Xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	color = "#535E66" // rgb: 83, 94, 102
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	taste_description = "отстой"
	penetrates_skin = NONE

/datum/reagent/fluorosurfactant//foam precursor
	name = "Фторовая Пена"
	enname = "Fluorosurfactant"
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	color = "#9E6B38" // rgb: 158, 107, 56
	taste_description = "металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/foaming_agent// Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Пенный реагент"
	enname = "Foaming agent"
	description = "An agent that yields metallic foam when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_description = "металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/smart_foaming_agent //Smart foaming agent. Functions similarly to metal foam, but conforms to walls.
	name = "Реагент умной пены"
	enname = "Smart foaming agent"
	description = "An agent that yields metallic foam which conforms to area boundaries when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_description = "металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/ammonia
	name = "Аммиак"
	enname = "Ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	taste_description = "протрава"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/diethylamine
	name = "Диэтиламин"
	enname = "Diethylamine"
	description = "A secondary amine, mildly corrosive."
	color = "#604030" // rgb: 96, 64, 48
	taste_description = "железо"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carbondioxide
	name = "Диоксид Углерода"
	enname = "Carbon Dioxide"
	reagent_state = GAS
	description = "A gas commonly produced by burning carbon fuels. You're constantly producing this in your lungs."
	color = "#B0B0B0" // rgb : 192, 192, 192
	taste_description = "что-то непостижимое"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/nitrous_oxide
	name = "Оксид Азота"
	enname = "Nitrous Oxide"
	description = "A potent oxidizer used as fuel in rockets and as an anaesthetic during surgery."
	reagent_state = LIQUID
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	color = "#808080"
	taste_description = "сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/nitrous_oxide/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(methods & VAPOR)
		exposed_mob.drowsyness += max(round(reac_volume, 1), 2)

/datum/reagent/nitrous_oxide/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.drowsyness += 2 * REM * delta_time
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.blood_volume = max(H.blood_volume - (10 * REM * delta_time), 0)
	if(DT_PROB(10, delta_time))
		M.losebreath += 2
		M.set_confusion(min(M.get_confusion() + 2, 5))
	..()

/datum/reagent/stimulum
	name = "Stimulum"
	enname = "Stimulum"
	description = "An unstable experimental gas that greatly increases the energy of those that inhale it, while dealing increasing toxin damage over time."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because stimulum/nitryl/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "E1A116"
	taste_description = "кислотность"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/stimulants = 14)

/datum/reagent/stimulum/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_STUNIMMUNE, type)
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, type)

/datum/reagent/stimulum/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_STUNIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	..()

/datum/reagent/stimulum/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustStaminaLoss(-2 * REM * delta_time, 0)
	M.adjustToxLoss(0.1 * current_cycle * REM * delta_time, 0) // 1 toxin damage per cycle at cycle 10
	..()

/datum/reagent/nitryl
	name = "Нитрил"
	enname = "Nitryl"
	description = "A highly reactive gas that makes you feel faster."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because stimulum/nitryl/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "сжигание"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/nitryl/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/nitryl)

/datum/reagent/nitryl/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/nitryl)
	..()

/datum/reagent/freon
	name = "Фреон"
	enname = "Freon"
	description = "A powerful heat absorbent."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because stimulum/nitryl/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "горение"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/freon/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/freon)

/datum/reagent/freon/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/freon)
	return ..()

/datum/reagent/hypernoblium
	name = "Гипер-Ноблиум"
	enname = "Hyper-Noblium"
	description = "A suppressive gas that stops gas reactions on those who inhale it."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because stimulum/nitryl/freon/hyper-nob are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "searingly cold"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/healium
	name = "Хилиум"
	enname = "Healium"
	description = "A powerful sleeping agent with healing properties"
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5
	color = "90560B"
	taste_description = "rubbery"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/healium/on_mob_metabolize(mob/living/L)
	. = ..()
	L.PermaSleeping()

/datum/reagent/healium/on_mob_end_metabolize(mob/living/L)
	L.SetSleeping(10)
	return ..()

/datum/reagent/healium/on_mob_life(mob/living/L, delta_time, times_fired)
	. = ..()
	L.adjustFireLoss(-2 * REM * delta_time, FALSE)
	L.adjustToxLoss(-5 * REM * delta_time, FALSE)
	L.adjustBruteLoss(-2 * REM * delta_time, FALSE)

/datum/reagent/halon
	name = "Халон"
	enname = "Halon"
	description = "A fire suppression gas that removes oxygen and cools down the area"
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5
	color = "90560B"
	taste_description = "minty"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/halon/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/halon)
	ADD_TRAIT(L, TRAIT_RESISTHEAT, type)

/datum/reagent/halon/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/halon)
	REMOVE_TRAIT(L, TRAIT_RESISTHEAT, type)
	return ..()

/////////////////////////Colorful Powder////////////////////////////
//For colouring in /proc/mix_color_from_reagents

/datum/reagent/colorful_reagent/powder
	name = "Ничем не примечательный порошок" //the name's a bit similar to the name of colorful reagent, but hey, they're practically the same chem anyway
	enname = "Mundane Powder"
	var/colorname = "none"
	description = "A powder that is used for coloring things."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 207, 54, 0
	taste_description = "задняя часть класса"

/datum/reagent/colorful_reagent/powder/New()
	if(colorname == "none")
		description = "A rather mundane-looking powder. It doesn't look like it'd color much of anything..."
	else if(colorname == "invisible")
		description = "An invisible powder. Unfortunately, since it's invisible, it doesn't look like it'd color much of anything..."
	else
		description = "\An [colorname] powder, used for coloring things [colorname]."
	return ..()

/datum/reagent/colorful_reagent/powder/red
	name = "Красный Порошок"
	enname = "Red Powder"
	colorname = "red"
	color = "#DA0000" // red
	random_color_list = list("#FC7474")
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/orange
	name = "Оранжевый Порошок"
	enname = "Orange Powder"
	colorname = "orange"
	color = "#FF9300" // orange
	random_color_list = list("#FF9300")

/datum/reagent/colorful_reagent/powder/yellow
	name = "Желтый Порошок"
	enname = "Yellow Powder"
	colorname = "yellow"
	color = "#FFF200" // yellow
	random_color_list = list("#FFF200")
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/green
	name = "Зеленый Порошок"
	enname = "Green Powder"
	colorname = "green"
	color = "#A8E61D" // green
	random_color_list = list("#A8E61D")
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/blue
	name = "Синий Порошок"
	enname = "Blue Powder"
	colorname = "blue"
	color = "#00B7EF" // blue
	random_color_list = list("#71CAE5")
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/purple
	name = "Фиолетовый Порошок"
	enname = "Purple Powder"
	colorname = "purple"
	color = "#DA00FF" // purple
	random_color_list = list("#BD8FC4")
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/invisible
	name = "Невидимый Порошок"
	enname = "Invisible Powder"
	colorname = "invisible"
	color = "#FFFFFF00" // white + no alpha
	random_color_list = list(null)	//because using the powder color turns things invisible
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/black
	name = "Черный Порошок"
	enname = "Black Powder"
	colorname = "black"
	color = "#1C1C1C" // not quite black
	random_color_list = list("#8D8D8D")	//more grey than black, not enough to hide your true colors
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/white
	name = "Белый Порошок"
	enname = "White Powder"
	colorname = "white"
	color = "#FFFFFF" // white
	random_color_list = list("#FFFFFF") //doesn't actually change appearance at all
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/* used by crayons, can't color living things but still used for stuff like food recipes */

/datum/reagent/colorful_reagent/powder/red/crayon
	name = "Красный Порошковый Мел"
	enname = "Red Crayon Powder"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/orange/crayon
	name = "Оранжевый Порошковый Мел"
	enname = "Orange Crayon Powder"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/yellow/crayon
	name = "Желтый Порошковый Мел"
	enname = "Yellow Crayon Powder"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/green/crayon
	name = "Зеленый Порошковый Мел"
	enname = "Green Crayon Powder"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/blue/crayon
	name = "Синий Порошковый Мел"
	enname = "Blue Crayon Powder"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/purple/crayon
	name = "Фиолетовый Порошковый Мел"
	enname = "Purple Crayon Powder"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//datum/reagent/colorful_reagent/powder/invisible/crayon

/datum/reagent/colorful_reagent/powder/black/crayon
	name = "Черный Порошковый Мел"
	enname = "Black Crayon Powder"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/white/crayon
	name = "Белый Порошковый Мел"
	enname = "White Crayon Powder"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//////////////////////////////////Hydroponics stuff///////////////////////////////

/datum/reagent/plantnutriment
	name = "Generic nutriment"
	enname = "Generic nutriment"
	description = "Some kind of nutriment. You can't really tell what it is. You should probably report it, along with how you obtained it."
	color = "#000000" // RBG: 0, 0, 0
	var/tox_prob = 0
	taste_description = "удобрение"

/datum/reagent/plantnutriment/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(tox_prob, delta_time))
		M.adjustToxLoss(1, 0)
		. = TRUE
	..()

/datum/reagent/plantnutriment/eznutriment
	name = "E-Z-Nutrient"
	enname = "E-Z-Nutrient"
	description = "Contains electrolytes. It's what plants crave."
	color = "#376400" // RBG: 50, 100, 0
	tox_prob = 5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/left4zednutriment
	name = "Left 4 Zed"
	enname = "Robust Harvest"
	description = "Unstable nutriment that makes plants mutate more often than usual."
	color = "#1A1E4D" // RBG: 26, 30, 77
	tox_prob = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/robustharvestnutriment
	name = "Надежный Урожай"
	enname = "Robust Harvest"
	description = "Very potent nutriment that slows plants from mutating."
	color = "#9D9D00" // RBG: 157, 157, 0
	tox_prob = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/endurogrow
	name = "Эндуро-рост" //я трахать столб дом твой
	enname = "Enduro Grow"
	description = "A specialized nutriment, which decreases product quantity and potency, but strengthens the plants endurance."
	color = "#a06fa7" // RBG: 160, 111, 167
	tox_prob = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/liquidearthquake
	name = "Жидкая Встряска"
	enname = "Liquid Earthquake"
	description = "A specialized nutriment, which increases the plant's production speed, as well as it's susceptibility to weeds."
	color = "#912e00" // RBG: 145, 46, 0
	tox_prob = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// GOON OTHERS



/datum/reagent/fuel/oil
	name = "Масло"
	enname = "Oil"
	description = "Burns in a small smoky fire, can be used to get Ash."
	reagent_state = LIQUID
	color = "#2D2D2D"
	taste_description = "масло"
	burning_temperature = 1200//Oil is crude
	burning_volume = 0.05 //but has a lot of hydrocarbons
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = null

/datum/reagent/stable_plasma
	name = "Стабильная Плазма"
	enname = "Stable Plasma"
	description = "Non-flammable plasma locked into a liquid form that cannot ignite or become gaseous/solid."
	reagent_state = LIQUID
	color = "#2D2D2D"
	taste_description = "горечь"
	taste_mult = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/iodine
	name = "Йод"
	enname = "Iodine"
	description = "Commonly added to table salt as a nutrient. On its own it tastes far less pleasing."
	reagent_state = LIQUID
	color = "#BC8A00"
	taste_description = "металл"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/royal/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = ..()
	var/obj/item/organ/liver/liver = M.getorganslot(ORGAN_SLOT_LIVER)
	if(liver)
		// Heads of staff and the captain have a "royal metabolism"
		if(HAS_TRAIT(liver, TRAIT_ROYAL_METABOLISM))
			if(DT_PROB(5, delta_time))
				to_chat(M, "Ощущаю себя знатью.")
			if(DT_PROB(2.5, delta_time))
				M.say(pick("Peasants..","This carpet is worth more than your contracts!","I could fire you at any time..."), forced = "royal carpet")

		// The quartermaster, as a semi-head, has a "pretender royal" metabolism
		else if(HAS_TRAIT(liver, TRAIT_PRETENDER_ROYAL_METABOLISM))
			if(DT_PROB(8, delta_time))
				to_chat(M, "Ощущаю себя самозванцем...")

/datum/reagent/bromine
	name = "Бром"
	enname = "Bromine"
	description = "A brownish liquid that's highly reactive. Useful for stopping free radicals, but not intended for human consumption."
	reagent_state = LIQUID
	color = "#D35415"
	taste_description = "химикаты"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/pentaerythritol
	name = "Пентаэритхритол"
	enname = "Pentaerythritol"
	description = "Slow down, it ain't no spelling bee!"
	reagent_state = SOLID
	color = "#E66FFF"
	taste_description = "кислота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/acetaldehyde
	name = "Ацетальдегид"
	enname = "Acetaldehyde"
	description = "Similar to plastic. Tastes like dead people."
	reagent_state = SOLID
	color = "#EEEEEF"
	taste_description = "мертвецы" //made from formaldehyde, ya get da joke ?
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/acetone_oxide
	name = "Оксид Ацетона"
	enname = "Acetone oxide"
	description = "Enslaved oxygen"
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "кислота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/acetone_oxide/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people kills people!
	. = ..()
	if(methods & TOUCH)
		exposed_mob.adjustFireLoss(2, FALSE) // burns,
		exposed_mob.adjust_fire_stacks((reac_volume / 10))



/datum/reagent/phenol
	name = "Фенол"
	enname = "Phenol"
	description = "An aromatic ring of carbon with a hydroxyl group. A useful precursor to some medicines, but has no healing properties on its own."
	reagent_state = LIQUID
	color = "#E7EA91"
	taste_description = "кислота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/ash
	name = "Пепел"
	enname = "Ash"
	description = "Supposedly phoenixes rise from these, but you've never seen it."
	reagent_state = LIQUID
	color = "#515151"
	taste_description = "пепел"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/acetone
	name = "Ацетон"
	enname = "Acetone"
	description = "A slick, slightly carcinogenic liquid. Has a multitude of mundane uses in everyday life."
	reagent_state = LIQUID
	color = "#AF14B7"
	taste_description = "кислота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent
	name = "Цветной Реагент"
	enname = "Colorful Reagent"
	description = "Thoroughly sample the rainbow."
	reagent_state = LIQUID
	var/list/random_color_list = list("#00aedb","#a200ff","#f47835","#d41243","#d11141","#00b159","#00aedb","#f37735","#ffc425","#008744","#0057e7","#d62d20","#ffa700")
	color = "#C8A5DC"
	taste_description = "радуга"
	var/can_colour_mobs = TRUE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/datum/callback/color_callback

/datum/reagent/colorful_reagent/New()
	color_callback = CALLBACK(src, .proc/UpdateColor)
	SSticker.OnRoundstart(color_callback)
	return ..()

/datum/reagent/colorful_reagent/Destroy()
	LAZYREMOVE(SSticker.round_end_events, color_callback) //Prevents harddels during roundstart
	color_callback = null //Fly free little callback
	return ..()

/datum/reagent/colorful_reagent/proc/UpdateColor()
	color_callback = null
	color = pick(random_color_list)

/datum/reagent/colorful_reagent/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(can_colour_mobs)
		M.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
	return ..()

/// Colors anything it touches a random color.
/datum/reagent/colorful_reagent/expose_atom(atom/exposed_atom, reac_volume)
	. = ..()
	if(!isliving(exposed_atom) || can_colour_mobs)
		exposed_atom.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)

/datum/reagent/hair_dye
	name = "Квантовая Краска для Волос"
	enname = "Quantum Hair Dye"
	description = "Has a high chance of making you look like a mad scientist."
	reagent_state = LIQUID
	var/list/potential_colors = list("0ad","a0f","f73","d14","d14","0b5","0ad","f73","fc2","084","05e","d22","fa0") // fucking hair code
	color = "#C8A5DC"
	taste_description = "кислотность"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/hair_dye/New()
	SSticker.OnRoundstart(CALLBACK(src,.proc/UpdateColor))
	return ..()

/datum/reagent/hair_dye/proc/UpdateColor()
	color = pick(potential_colors)

/datum/reagent/hair_dye/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	exposed_human.hair_color = pick(potential_colors)
	exposed_human.facial_hair_color = pick(potential_colors)
	exposed_human.update_hair()

/datum/reagent/barbers_aid
	name = "Парикмахерская Аптечка"
	enname = "Barber's Aid"
	description = "A solution to hair loss across the world."
	reagent_state = LIQUID
	color = "#A86B45" //hair is brown
	taste_description = "кислотность"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/barbers_aid/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob) || HAS_TRAIT(exposed_mob, TRAIT_BALD))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	var/datum/sprite_accessory/hair/picked_hair = pick(GLOB.hairstyles_list)
	var/datum/sprite_accessory/facial_hair/picked_beard = pick(GLOB.facial_hairstyles_list)
	to_chat(exposed_human, span_notice("На моем скальпе начали расти волосы."))
	exposed_human.hairstyle = picked_hair
	exposed_human.facial_hairstyle = picked_beard
	exposed_human.update_hair()

/datum/reagent/concentrated_barbers_aid
	name = "Концентрированная Парикмахерская Аптечка"
	enname = "Concentrated Barber's Aid"
	description = "A concentrated solution to hair loss across the world."
	reagent_state = LIQUID
	color = "#7A4E33" //hair is dark browmn
	taste_description = "кислотность"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/concentrated_barbers_aid/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob) || HAS_TRAIT(exposed_mob, TRAIT_BALD))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	to_chat(exposed_human, span_notice("Мои волосы начали очень быстро расти!"))
	exposed_human.hairstyle = "Very Long Hair"
	exposed_human.facial_hairstyle = "Beard (Very Long)"
	exposed_human.update_hair()

/datum/reagent/baldium
	name = "Балдий"
	enname = "Baldium"
	description = "A major cause of hair loss across the world."
	reagent_state = LIQUID
	color = "#ecb2cf"
	taste_description = "горечь"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/baldium/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	to_chat(exposed_human, span_danger("Мои волосы начали выпадать целыми клочьями!"))
	exposed_human.hairstyle = "Bald"
	exposed_human.facial_hairstyle = "Shaved"
	exposed_human.update_hair()

/datum/reagent/saltpetre
	name = "Селитра"
	enname = "Saltpetre"
	description = "Volatile. Controversial. Third Thing."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	taste_description = "крутая соль"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/lye
	name = "Щелочь"
	enname = "Lye"
	description = "Also known as sodium hydroxide. As a profession making this is somewhat underwhelming."
	reagent_state = LIQUID
	color = "#FFFFD6" // very very light yellow
	taste_description = "кислота"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Virology virus food chems.

/datum/reagent/toxin/mutagen/mutagenvirusfood
	name = "мутагенный агар"
	enname = "mutagenic agar"
	color = "#A3C00F" // rgb: 163,192,15
	taste_description = "кислотность"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar
	name = "сахарозный агар"
	enname = "sucrose agar"
	color = "#41B0C0" // rgb: 65,176,192
	taste_description = "сладость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/synaptizine/synaptizinevirusfood
	name = "вирусный рацион"
	enname = "virus rations"
	color = "#D18AA5" // rgb: 209,138,165
	taste_description = "горечь"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/plasma/plasmavirusfood
	name = "вирусная плазма"
	enname = "virus plasma"
	color = "#A270A8" // rgb: 166,157,169
	taste_description = "горечь"
	taste_mult = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/plasma/plasmavirusfood/weak
	name = "ослабленная вирусная плазма"
	enname = "weakened virus plasma"
	color = "#A28CA5" // rgb: 206,195,198
	taste_description = "горечь"
	taste_mult = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium/uraniumvirusfood
	name = "распадающийся урановый гель"
	enname = "decaying uranium gel"
	color = "#67ADBA" // rgb: 103,173,186
	taste_description = "внутренности реактора"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium/uraniumvirusfood/unstable
	name = "нестабильный урановый гель"
	enname = "unstable uranium gel"
	color = "#2FF2CB" // rgb: 47,242,203
	taste_description = "внутренности реактора"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium/uraniumvirusfood/stable
	name = "стабильный урановый гель"
	enname = "stable uranium gel"
	color = "#04506C" // rgb: 4,80,108
	taste_description = "внутренности реактора"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Bee chemicals

/datum/reagent/royal_bee_jelly
	name = "Королевское пчелиное желе"
	enname = "royal bee jelly"
	description = "Royal Bee Jelly, if injected into a Queen Space Bee said bee will split into two bees."
	color = "#00ff80"
	taste_description = "странный мёд"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/royal_bee_jelly/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(1, delta_time))
		M.say(pick("Bzzz...","BZZ BZZ","Bzzzzzzzzzzz..."), forced = "royal bee jelly")
	..()

//Misc reagents

/datum/reagent/growthserum
	name = "Сыворотка Роста"
	enname = "Growth Serum"
	description = "A commercial chemical designed to help older men in the bedroom."//not really it just makes you a giant
	color = "#ff0000"//strong red. rgb 255, 0, 0
	var/current_size = RESIZE_DEFAULT_SIZE
	taste_description = "горечь" // apparently what viagra tastes like
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/growthserum/on_mob_life(mob/living/carbon/H, delta_time, times_fired)
	var/newsize = current_size
	switch(volume)
		if(0 to 19)
			newsize = 1.25*RESIZE_DEFAULT_SIZE
		if(20 to 49)
			newsize = 1.5*RESIZE_DEFAULT_SIZE
		if(50 to 99)
			newsize = 2*RESIZE_DEFAULT_SIZE
		if(100 to 199)
			newsize = 2.5*RESIZE_DEFAULT_SIZE
		if(200 to INFINITY)
			newsize = 3.5*RESIZE_DEFAULT_SIZE

	H.resize = newsize/current_size
	current_size = newsize
	H.update_transform()
	..()

/datum/reagent/growthserum/on_mob_end_metabolize(mob/living/M)
	M.resize = RESIZE_DEFAULT_SIZE/current_size
	current_size = RESIZE_DEFAULT_SIZE
	M.update_transform()
	..()

/datum/reagent/plastic_polymers
	name = "пластиковые полимеры"
	enname = "plastic polymers"
	description = "the petroleum based components of plastic."
	color = "#f7eded"
	taste_description = "пластик"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter
	name = "блятьстки"
	enname = "generic glitter"
	description = "if you can see this description, contact a coder."
	color = "#FFFFFF" //pure white
	taste_description = "пластик"
	reagent_state = SOLID
	var/glitter_type = /obj/effect/decal/cleanable/glitter
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	new glitter_type(exposed_turf)

/datum/reagent/glitter/pink
	name = "розовые блёстки"
	enname = "pink glitter"
	description = "pink sparkles that get everywhere"
	color = "#ff8080" //A light pink color
	glitter_type = /obj/effect/decal/cleanable/glitter/pink
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter/white
	name = "белые блёстки"
	enname = "white glitter"
	description = "white sparkles that get everywhere"
	glitter_type = /obj/effect/decal/cleanable/glitter/white
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter/blue
	name = "синие блёстки"
	enname = "blue glitter"
	description = "blue sparkles that get everywhere"
	color = "#4040FF" //A blueish color
	glitter_type = /obj/effect/decal/cleanable/glitter/blue
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/pax
	name = "Пакс"
	enname = "Pax"
	description = "A colorless liquid that suppresses violence in its subjects."
	color = "#AAAAAA55"
	taste_description = "вода"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/pax/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_PACIFISM, type)

/datum/reagent/pax/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_PACIFISM, type)
	..()

/datum/reagent/bz_metabolites
	name = "Метаболиты BZ"
	enname = "BZ metabolites"
	description = "A harmless metabolite of BZ gas."
	color = "#FAFF00"
	taste_description = "едкая корица"
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/bz_metabolites/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, CHANGELING_HIVEMIND_MUTE, type)

/datum/reagent/bz_metabolites/on_mob_end_metabolize(mob/living/L)
	..()
	REMOVE_TRAIT(L, CHANGELING_HIVEMIND_MUTE, type)

/datum/reagent/pax/peaceborg
	name = "синтепакс"
	enname = "synthpax"
	description = "A colorless liquid that suppresses violence in its subjects. Cheaper to synthesize than normal Pax, but wears off faster."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/peaceborg/confuse
	name = "Оглушающий Раствор"
	enname = "Dizzying Solution"
	description = "Makes the target off balance and dizzy"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "головокружение"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/peaceborg/confuse/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(M.get_confusion() < 6)
		M.set_confusion(clamp(M.get_confusion() + (3 * REM * delta_time), 0, 5))
	if(M.dizziness < 6)
		M.dizziness = clamp(M.dizziness + (3 * REM * delta_time), 0, 5)
	if(DT_PROB(10, delta_time))
		to_chat(M, "Я сбит с толку и дезориентирован.")
	..()

/datum/reagent/peaceborg/tire
	name = "Изматывающий Раствор"
	enname = "Tiring Solution"
	description = "An extremely weak stamina-toxin that tires out the target. Completely harmless."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "усталость"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/peaceborg/tire/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/healthcomp = (100 - M.health)	//DOES NOT ACCOUNT FOR ADMINBUS THINGS THAT MAKE YOU HAVE MORE THAN 200/210 HEALTH, OR SOMETHING OTHER THAN A HUMAN PROCESSING THIS.
	if(M.getStaminaLoss() < (45 - healthcomp))	//At 50 health you would have 200 - 150 health meaning 50 compensation. 60 - 50 = 10, so would only do 10-19 stamina.)
		M.adjustStaminaLoss(10 * REM * delta_time)
	if(DT_PROB(16, delta_time))
		to_chat(M, "Нужно присесть и отдохнуть...")
	..()

/datum/reagent/tranquility
	name = "Спокойствие"
	enname = "Tranquility"
	description = "A highly mutative liquid of unknown origin."
	color = "#9A6750" //RGB: 154, 103, 80
	taste_description = "внутреннее спокойствие"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	penetrates_skin = NONE

/datum/reagent/spider_extract
	name = "Экстракт Паука"
	enname = "Spider Extract"
	description = "A highly specialized extract coming from the Australicus sector, used to create broodmother spiders."
	color = "#ED2939"
	taste_description = "вверх ногами"

/// Improvised reagent that induces vomiting. Created by dipping a dead mouse in welder fluid.
/datum/reagent/yuck
	name = "Органическая Жижа"
	enname = "Organic Slurry"
	description = "A mixture of various colors of fluid. Induces vomiting."
	glass_name = "glass of ...yuck!"
	glass_desc = "It smells like a carcass, and doesn't look much better."
	color = "#545000"
	taste_description = "внутренности"
	taste_mult = 4
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	var/yuck_cycle = 0 //! The `current_cycle` when puking starts.

/datum/reagent/yuck/on_mob_add(mob/living/L)
	. = ..()
	if(HAS_TRAIT(L, TRAIT_NOHUNGER)) //they can't puke
		holder.del_reagent(type)

#define YUCK_PUKE_CYCLES 3 		// every X cycle is a puke
#define YUCK_PUKES_TO_STUN 3 	// hit this amount of pukes in a row to start stunning
/datum/reagent/yuck/on_mob_life(mob/living/carbon/C, delta_time, times_fired)
	if(!yuck_cycle)
		if(DT_PROB(4, delta_time))
			var/dread = pick("Something is moving in your stomach...", \
				"A wet growl echoes from your stomach...", \
				"For a moment you feel like your surroundings are moving, but it's your stomach...")
			to_chat(C, span_userdanger("[dread]"))
			yuck_cycle = current_cycle
	else
		var/yuck_cycles = current_cycle - yuck_cycle
		if(yuck_cycles % YUCK_PUKE_CYCLES == 0)
			if(yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
				holder.remove_reagent(type, 5)
			C.vomit(rand(14, 26), stun = yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
	if(holder)
		return ..()
#undef YUCK_PUKE_CYCLES
#undef YUCK_PUKES_TO_STUN

/datum/reagent/yuck/on_mob_end_metabolize(mob/living/L)
	yuck_cycle = 0 // reset vomiting
	return ..()

/datum/reagent/yuck/on_transfer(atom/A, methods=TOUCH, trans_volume)
	if((methods & INGEST) || !iscarbon(A))
		return ..()

	A.reagents.remove_reagent(type, trans_volume)
	A.reagents.add_reagent(/datum/reagent/fuel, trans_volume * 0.75)
	A.reagents.add_reagent(/datum/reagent/water, trans_volume * 0.25)

	return ..()

//monkey powder heehoo
/datum/reagent/monkey_powder
	name = "Мартышечный порошок"
	enname = "Monkey Powder"
	description = "Just add water!"
	color = "#9C5A19"
	taste_description = "бананы"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plasma_oxide
	name = "Гипер-Плазменная Окись"
	enname = "Hyper-Plasmium Oxide"
	description = "Compound created deep in the cores of demon-class planets. Commonly found through deep geysers."
	color = "#470750" // rgb: 255, 255, 255
	taste_description = "hell"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/exotic_stabilizer
	name = "Экзотический Стабилизатор"
	enname = "Exotic Stabilizer"
	description = "Advanced compound created by mixing stabilizing agent and hyper-plasmium oxide."
	color = "#180000" // rgb: 255, 255, 255
	taste_description = "blood"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/wittel
	name = "Виттель"
	enname = "Wittel"
	description = "An extremely rare metallic-white substance only found on demon-class planets."
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 0 // oderless and tasteless
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/metalgen
	name = "Металген"
	enname = "Metalgen"
	data = list("material"=null)
	description = "A purple metal morphic liquid, said to impose it's metallic properties on whatever it touches."
	color = "#b000aa"
	taste_mult = 0 // oderless and tasteless
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	/// The material flags used to apply the transmuted materials
	var/applied_material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR
	/// The amount of materials to apply to the transmuted objects if they don't contain materials
	var/default_material_amount = 100

/datum/reagent/metalgen/expose_obj(obj/exposed_obj, volume)
	. = ..()
	metal_morph(exposed_obj)

/datum/reagent/metalgen/expose_turf(turf/exposed_turf, volume)
	. = ..()
	metal_morph(exposed_turf)

///turn an object into a special material
/datum/reagent/metalgen/proc/metal_morph(atom/A)
	var/metal_ref = data["material"]
	if(!metal_ref)
		return

	var/metal_amount = 0
	var/list/materials_to_transmute = A.get_material_composition(BREAKDOWN_INCLUDE_ALCHEMY)
	for(var/metal_key in materials_to_transmute) //list with what they're made of
		metal_amount += materials_to_transmute[metal_key]

	if(!metal_amount)
		metal_amount = default_material_amount //some stuff doesn't have materials at all. To still give them properties, we give them a material. Basically doesn't exist

	var/list/metal_dat = list((metal_ref) = metal_amount)
	A.material_flags = applied_material_flags
	A.set_custom_materials(metal_dat)
	ADD_TRAIT(A, TRAIT_MAT_TRANSMUTED, type)

/datum/reagent/gravitum
	name = "Гравитум"
	enname = "Gravitum"
	description = "A rare kind of null fluid, capable of temporalily removing all weight of whatever it touches." //i dont even
	color = "#050096" // rgb: 5, 0, 150
	taste_mult = 0 // oderless and tasteless
	metabolization_rate = 0.1 * REAGENTS_METABOLISM //20 times as long, so it's actually viable to use
	var/time_multiplier = 1 MINUTES //1 minute per unit of gravitum on objects. Seems overpowered, but the whole thing is very niche
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/gravitum/expose_obj(obj/exposed_obj, volume)
	. = ..()
	exposed_obj.AddElement(/datum/element/forced_gravity, 0)
	addtimer(CALLBACK(exposed_obj, .proc/_RemoveElement, list(/datum/element/forced_gravity, 0)), volume * time_multiplier)

/datum/reagent/gravitum/on_mob_add(mob/living/L)
	L.AddElement(/datum/element/forced_gravity, 0) //0 is the gravity, and in this case weightless
	return ..()

/datum/reagent/gravitum/on_mob_end_metabolize(mob/living/L)
	L.RemoveElement(/datum/element/forced_gravity, 0)

/datum/reagent/cellulose
	name = "Волокна Целлюлозы"
	enname = "Cellulose Fibers"
	description = "A crystaline polydextrose polymer, plants swear by this stuff."
	reagent_state = SOLID
	color = "#E6E6DA"
	taste_mult = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// "Second wind" reagent generated when someone suffers a wound. Epinephrine, adrenaline, and stimulants are all already taken so here we are
/datum/reagent/determination
	name = "Решимость"
	enname = "Determination"
	description = "For when you need to push on a little more. Do NOT allow near plants."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM // 5u (WOUND_DETERMINATION_CRITICAL) will last for ~34 seconds
	self_consuming = TRUE
	/// Whether we've had at least WOUND_DETERMINATION_SEVERE (2.5u) of determination at any given time. No damage slowdown immunity or indication we're having a second wind if it's just a single moderate wound
	var/significant = FALSE

/datum/reagent/eldritch //unholy water, but for eldritch cultists. why couldn't they have both just used the same reagent? who knows. maybe nar'sie is considered to be too "mainstream" of a god to worship in the cultist community.
	name = "Жуткая Эссенция"
	enname = "Eldritch Essence"
	description = "A strange liquid that defies the laws of physics. It re-energizes and heals those who can see beyond this fragile reality, but is incredibly harmful to the closed-minded. It metabolizes very quickly."
	taste_description = "Ag'hsj'saje'sh"
	color = "#1f8016"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM  //0.5u/second
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/eldritch/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * REM * delta_time, 150)
	M.adjustToxLoss(2 * REM * delta_time, FALSE)
	M.adjustFireLoss(2 * REM * delta_time, FALSE)
	M.adjustOxyLoss(2 * REM * delta_time, FALSE)
	M.adjustBruteLoss(2 * REM * delta_time, FALSE)
	..()

/datum/reagent/ants
	name = "Муравьи"
	enname = "Ants"
	description = "A sample of a lost breed of Space Ants (formicidae bastardium tyrannus), they are well-known for ravaging the living shit out of pretty much anything."
	reagent_state = SOLID
	color = "#993333"
	taste_mult = 1.3
	taste_description = "tiny legs scuttling down the back of your throat."
	metabolization_rate = 5 * REAGENTS_METABOLISM //1u per second
	glass_name = "glass of ants"
	glass_desc = "Bottoms up...?"
	/// How much damage the ants are going to be doing (rises with each tick the ants are in someone's body)
	var/ant_damage = 0
	/// Tells the debuff how many ants we are being covered with.
	var/amount_left = 0

/datum/reagent/ants/on_mob_life(mob/living/carbon/victim, delta_time)
	victim.adjustBruteLoss(max(0.1, round((ant_damage * 0.005),0.1))) //Scales with time. Around 12.5 brute for 50 seconds.
	if(DT_PROB(5, delta_time))
		if(DT_PROB(5, delta_time)) //Super rare statement
			victim.say("AUGH NO NOT THE ANTS! NOT THE ANTS! AAAAUUGH THEY'RE IN MY EYES! MY EYES! AUUGH!!", forced = /datum/reagent/ants)
		else
			victim.say(pick("THEY'RE UNDER MY SKIN!!", "GET THEM OUT OF ME!!", "HOLY HELL THEY BURN!!", "MY GOD THEY'RE INSIDE ME!!", "GET THEM OUT!!"), forced = /datum/reagent/ants)
	if(DT_PROB(15, delta_time))
		victim.emote("agony")
	if(DT_PROB(2, delta_time))
		victim.vomit(rand(1, 2), stun = FALSE)
	ant_damage += 1
	return ..()

/datum/reagent/ants/on_mob_end_metabolize(mob/living/living_anthill)
	ant_damage = 0
	to_chat(living_anthill, span_notice("You feel like the last of the ants are out of your system."))
	return ..()

/datum/reagent/ants/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob) || (methods & (INGEST|INJECT)))
		return
	if(methods & (PATCH|TOUCH|VAPOR))
		amount_left = round(reac_volume,0.1)
		exposed_mob.apply_status_effect(STATUS_EFFECT_ANTS, amount_left)

//This is intended to a be a scarce reagent to gate certain drugs and toxins with. Do not put in a synthesizer. Renewable sources of this reagent should be inefficient.
/datum/reagent/lead
	name = "lead"
	description = "A dull metalltic element with a low melting point."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#80919d"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM

/datum/reagent/lead/on_mob_life(mob/living/carbon/victim)
	. = ..()
	victim.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5)

//The main feedstock for kronkaine production, also a shitty stamina healer.
/datum/reagent/kronkus_extract
	name = "kronkus extract"
	description = "A frothy extract made from fermented kronkus vine pulp.\nHighly bitter due to the presence of a variety of kronkamines."
	taste_description = "bitterness"
	color = "#228f63"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/stimulants = 5)

/datum/reagent/kronkus_extract/on_mob_life(mob/living/carbon/kronkus_enjoyer)
	. = ..()
	kronkus_enjoyer.adjustOrganLoss(ORGAN_SLOT_HEART, 0.1)
	kronkus_enjoyer.adjustStaminaLoss(-2, FALSE)
