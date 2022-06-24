////////////////////
/////BODYPARTS//////
////////////////////


/obj/item/bodypart/var/should_draw_hippie = FALSE

/mob/living/carbon/proc/draw_hippie_parts(undo = FALSE)
	if(!undo)
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_hippie = TRUE
	else
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_hippie = FALSE

/datum/species/proc/hippie_handle_hiding_bodyparts(list/bodyparts_adding, obj/item/bodypart/head/head, mob/living/carbon/human/human)
	if("ipc_screen" in mutant_bodyparts)
		if((human.wear_mask && (human.wear_mask.flags_inv & HIDEFACE)) || (human.head && (human.head.flags_inv & HIDEFACE)) || !head || head.status == BODYPART_ROBOTIC)
			bodyparts_adding -= "ipc_screen"

// To make dwarven only jumpsuits, add this species' path to the clothing's species_exception list. By default jumpsuits don't fit dwarven since they're big boned
/datum/species/dwarf
	name = "Dwarf"
	id = "dwarf"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, NO_UNDERWEAR, TRAIT_ALCOHOL_TOLERANCE)
	mutant_bodyparts = list("mcolor" = "FFF", "wings" = "None")
	use_skintones = 1
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	mutantlungs = /obj/item/organ/lungs/dwarven
	mutanttongue = /obj/item/organ/tongue/dwarven
	mutantliver = /obj/item/organ/liver/dwarven
	species_language_holder = /datum/language_holder/dwarf

/datum/species/dwarf/check_roundstart_eligible()
	return TRUE

/datum/species/dwarf/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	if((slot == ITEM_SLOT_ICLOTHING) && !is_type_in_list(src, I.species_exception))
		return FALSE
	return ..()

/datum/species/dwarf/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	// var/dwarf_beard = pick("Beard (Full)", "Beard (Dwarf)", "Beard (Very Long)")
	C.hairstyle = "Bald"
	// C.facial_hairstyle = dwarf_beard
	C.draw_hippie_parts()
	C.update_body()
	C.update_hair()
	C.update_body_parts()
	GLOB.dwarf_list += C
	. = ..()
	spawn(5 SECONDS)
		if(!istype(C, /mob/living/carbon/human/dummy))
			C.mind.set_experience(/datum/skill/smithing, SKILL_EXP_APPRENTICE, FALSE)
			C.mind.set_experience(/datum/skill/mining,   SKILL_EXP_APPRENTICE, FALSE)

/datum/species/dwarf/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	GLOB.dwarf_list -= C
	. = ..()

/datum/species/dwarf/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(!..())
		if(istype(chem, /datum/reagent/consumable/ethanol))
			H.heal_bodypart_damage(0.5,0.5,0.5)
			return FALSE

/datum/species/dwarf/random_name(gender,unique,lastname, en_lang = FALSE)
	return dwarf_name()

// Dwarven tongue, they only know their language.
/obj/item/organ/tongue/dwarven
	name = "nol"
	var/static/list/dwarvenLang = typecacheof(list(/datum/language/dwarven))

/obj/item/organ/tongue/dwarven/Initialize(mapload)
	. = ..()
	languages_possible = dwarvenLang

/obj/item/organ/lungs/dwarven
	name = "dwarven lungs"
	desc = "A pair of quite small lungs. They look different than normal human's ones."

/obj/item/organ/liver/dwarven
	name = "dwarven liver"
	desc = "It looks different than normal human's ones."
	alcohol_tolerance = 0

/datum/language/dwarven
	name = "Dwarfen"
	desc = "An ancient language which is still used by some individuals."
	key = "w"
	syllables = list(
		"etag", "gekur", "tol", "gudos", "geth", "udiz", "zalud", "showeh", "ver", "zilir",
		"eshobak", "samurak", "asdobak", "fosak", "shoveth", "tangak", "dogak", "ashokak", "gethak", "slisak", "mulonak",
		"wadag", "vasag", "udosag", "longudosag", "wanag", "hivag", "wilkag",
		"asdob", "nir", "nob", "mes", "vor", "fim", "gat", "zyn", "att", "nog", "zez", "eshob", "asdob",
		"og", "get", "zal", "yd", "lok", "ad", "nat", "gat", "mit", "des", "shyg", "kul", "gat", "gad", "zis",
		"deb", "koshmot", "legon", "raz", "lanzil", "gim", "gamil", "datlad", "tat", "gelut", "gakit", "tomus", "tizot", "rirnol",
		"med", "kulet", "ngalak", "kuthdeng", "cenath", "ustos", "oshnel", "nural", "nazush"
	)
	space_chance = 35
	icon = 'dwarfs/icons/mob/language.dmi'
	icon_state = "dwarf"

/datum/language_holder/dwarf
	understood_languages = list(/datum/language/dwarven = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/dwarven = list(LANGUAGE_ATOM))

/datum/outfit/dwarf
	name = "Dwarf"
	uniform = /obj/item/clothing/under/dwarf
	shoes = /obj/item/clothing/shoes/dwarf

/datum/outfit/dwarf/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	H.set_species(/datum/species/dwarf)
	H.gender = MALE
	var/new_name = H.dna.species.random_name(H.gender, TRUE)
	H.fully_replace_character_name(H.real_name, new_name)
	H.regenerate_icons()
