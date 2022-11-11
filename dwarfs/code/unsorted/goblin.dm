// To make dwarven only jumpsuits, add this species' path to the clothing's species_exception list. By default jumpsuits don't fit dwarven since they're big boned
/datum/species/goblin
	name = "Goblin"
	id = "goblin"
	species_traits = list(NO_UNDERWEAR)
	mutant_bodyparts = list("mcolor" = "FFF", "wings" = "None")
	use_skintones = 0
	sexes = FALSE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	mutantlungs = /obj/item/organ/lungs/goblin
	mutanttongue = /obj/item/organ/tongue/goblin
	mutantliver = /obj/item/organ/liver/goblin
	species_language_holder = /datum/language_holder/goblin
	exotic_bloodtype = "G"
	exotic_blood = /datum/reagent/goblin_blood
	bodypart_overides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/goblin,\
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/goblin,\
		BODY_ZONE_HEAD = /obj/item/bodypart/head/goblin,\
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/goblin,\
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/goblin,\
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/goblin)


/datum/species/goblin/check_roundstart_eligible()
	return TRUE

/datum/species/goblin/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	GLOB.goblin_list += C
	. = ..()

/datum/species/goblin/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	GLOB.goblin_list -= C
	. = ..()

/datum/species/goblin/random_name(gender,unique,lastname)
	var/first = GLOB.language_adjectives[pick(GLOB.language_adjectives)]["Goblin"]
	var/last = GLOB.language_nouns[pick(GLOB.language_nouns)]["Goblin"]
	return "[capitalize(first)] [capitalize(last)]"

// Dwarven tongue, they only know their language.
/obj/item/organ/tongue/goblin
	name = "Asnam"
	var/static/list/goblinLang = typecacheof(list(/datum/language/goblin))
	color = "#99e65f"

/obj/item/organ/tongue/goblin/Initialize(mapload)
	. = ..()
	languages_possible = goblinLang

/obj/item/organ/lungs/goblin
	name = "goblin lungs"
	desc = "A pair of quite small lungs. They look pretty greenish."
	color = "#99e65f"

/obj/item/organ/liver/goblin
	name = "goblin liver"
	desc = "Looks like something rotten"
	alcohol_tolerance = 50
	color = "#99e65f"

/obj/item/bodypart/l_arm/goblin

/obj/item/bodypart/r_arm/goblin

/obj/item/bodypart/head/goblin

/obj/item/bodypart/l_leg/goblin

/obj/item/bodypart/r_leg/goblin

/obj/item/bodypart/chest/goblin

/datum/language/goblin
	name = "Goblin"
	desc = "Quite archaic language used by greenlings."
	key = "g"
	syllables = list("xubok", "môklo", "lâsm", "agsmông", "loma", "musör", "smestre", "abo", "oslem",
	 "kangsu", "odsnun", "sasmok", "arur", "kök", "ngod", "umuz", "ulxe", "zestto", "osm", "olos", "bor",
	"uros", "ugas", "stasno", "egu", "uslôx", "osmze", "asu", "tông", "ostrug", "sner", "xedub", "ngul",
	"ragu", "snod", "uxzo", "snorbû", "stonu", "osum", "stungo", "ostad", "zemkom", "slos", "zöslu", "goslust",
	"dök", "ulxa", "aslan", "slongus", "asttu", "okom", "edzum", "nuslu", "asa", "ostox", "uku", "bûku", "uslot",
	"rukku", "stratâb", "astrum", "romnu", "gorno", "kusmke", "stato", "entust", "ast", "slospo", "mugub", "om", "uno",
	"star", "lel", "uze", "urog", "nonu", "spet", "ustthut", "uta", "smabek", "smal", "axngu", "ugo", "onga", "osnaz",
	"slonu", "ustgu", "dông", "komu", "smumub", "xama", "ub", "nub", "slësla", "eg", "dunosp", "strox", "kuda", "studu",
	"exuz", "ozad", "ustu", "dugut", "ug", "ostôk", "susnû", "nûng", "usno", "ûsp", "rötstong", "er", "snosstrosp", "gadu",
	"kasta", "ozma", "ngosm", "zon", "nur", "bosu", "zex", "dukxong", "otak", "stestrak", "smob", "äkon", "rom", "ustêx", "ugu",
	"ngure", "kengku", "oknus", "ngot", "raslost", "oslu", "kol", "dusmun", "odan", "olo", "sluda", "gudo", "ukas", "ubspu", "ezrû"
	)

	space_chance = 35
	icon_state = "goblin"

/datum/language_holder/goblin
	understood_languages = list(/datum/language/goblin = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/goblin = list(LANGUAGE_ATOM))

/datum/outfit/goblin
	name = "Goblin"
	uniform = /obj/item/clothing/under/loincloth
	r_hand = /obj/item/club
	back = /obj/item/pickaxe
