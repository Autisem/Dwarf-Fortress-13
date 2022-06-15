
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override, antag_override = FALSE)
	if(randomise[RANDOM_SPECIES])
		random_species()
	else if(randomise[RANDOM_NAME])
		real_name = pref_species.random_name(gender,1)
	if(gender_override && !(randomise[RANDOM_GENDER] || randomise[RANDOM_GENDER_ANTAG] && antag_override))
		gender = gender_override
	else
		gender = pick(MALE,FEMALE,PLURAL)
	if(randomise[RANDOM_AGE] || randomise[RANDOM_AGE_ANTAG] && antag_override)
		age = rand(AGE_MIN,AGE_MAX)
	if(randomise[RANDOM_UNDERWEAR])
		underwear = random_underwear(gender)
	if(randomise[RANDOM_UNDERWEAR_COLOR])
		underwear_color = random_short_color()
	if(randomise[RANDOM_UNDERSHIRT])
		undershirt = random_undershirt(gender)
	if(randomise[RANDOM_SOCKS])
		socks = random_socks()
	if(randomise[RANDOM_BACKPACK])
		backpack = random_backpack()
	if(randomise[RANDOM_JUMPSUIT_STYLE])
		jumpsuit_style = pick(GLOB.jumpsuitlist)
	if(randomise[RANDOM_HAIRSTYLE])
		hairstyle = random_hairstyle(gender)
	if(randomise[RANDOM_FACIAL_HAIRSTYLE])
		facial_hairstyle = random_facial_hairstyle(gender)
	if(randomise[RANDOM_HAIR_COLOR])
		hair_color = random_short_color()
	if(randomise[RANDOM_FACIAL_HAIR_COLOR])
		facial_hair_color = random_short_color()
	if(randomise[RANDOM_SKIN_TONE])
		skin_tone = random_skin_tone()
	if(randomise[RANDOM_EYE_COLOR])
		eye_color = random_eye_color()
	if(!pref_species)
		var/rando_race = pick(GLOB.roundstart_races)
		pref_species = new rando_race()
	features = random_features()
	if(gender in list(MALE, FEMALE))
		body_type = gender
	else
		body_type = pick(MALE, FEMALE)

/datum/preferences/proc/random_species()
	var/random_species_type = GLOB.species_list[pick(GLOB.roundstart_races)]
	pref_species = new random_species_type
	if(randomise[RANDOM_NAME])
		real_name = pref_species.random_name(gender,1)

///Setup a hardcore random character and calculate their hardcore random score
/datum/preferences/proc/hardcore_random_setup(mob/living/carbon/human/character, antagonist, is_latejoiner)
	var/rand_gender = pick(list(MALE, FEMALE, PLURAL))
	random_character(rand_gender, antagonist)
	hardcore_survival_score = hardcore_survival_score ** 1.2 //30 points would be about 60 score
	if(is_latejoiner)//prevent them from cheatintg
		hardcore_survival_score = 0

/datum/preferences/proc/update_preview_icon()

	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	copy_to(mannequin, 1, TRUE, TRUE)

	mannequin.equipOutfit(/datum/outfit/dwarf)
	COMPILE_OVERLAYS(mannequin)
	parent.show_character_previews(new /mutable_appearance(mannequin))
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
