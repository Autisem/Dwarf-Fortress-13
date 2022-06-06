/// Any humanoid (non-Xeno) mob, such as humans, plasmamen, lizards.
/mob/living/carbon/human
	name = "Неизвестный"
	real_name = "Неизвестный"
	icon = 'icons/mob/human.dmi'
	icon_state = "human_basic"
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE|LONG_GLIDE
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ANTAG_HUD)
	hud_type = /datum/hud/human
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	can_buckle = TRUE
	buckle_lying = 0
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	can_be_shoved_into = TRUE

	//Hair colour and style
	var/hair_color = "000"
	var/hairstyle = "Bald"

	///Colours used for hair and facial hair gradients.
	var/list/grad_color
	///Styles used for hair and facial hair gradients.
	var/list/grad_style

	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hairstyle = "Shaved"

	//Eye colour
	var/eye_color = "000"

	var/skin_tone = "caucasian1"	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	var/age = 30		//Player's age

	var/underwear = "Nude"	//Which underwear the player wants
	var/underwear_color = "000"
	var/undershirt = "Nude" //Which undershirt the player wants
	var/socks = "Nude" //Which socks the player wants
	var/backpack = DBACKPACK		//Which backpack type the player has chosen.
	var/jumpsuit_style = PREF_SUIT		//suit/skirt

	//Equipment slots
	var/obj/item/clothing/wear_suit = null
	var/obj/item/clothing/w_uniform = null
	var/obj/item/belt = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/name_override //For temporary visible name changes

	var/list/datum/bioware = list()

	var/pooed = FALSE
	/// What types of mobs are allowed to ride/buckle to this mob
	var/static/list/can_ride_typecache = typecacheof(list(/mob/living/carbon/human))
	var/lastpuke = 0
	var/last_fire_update
	var/account_id

	var/hardcore_survival_score = 0
	/// For agendered spessmen, which body type to use
	var/body_type = MALE

	///Shoving vars
	var/shoved = FALSE
	var/mob/living/carbon/human/shover = null
	/// How many "units of blood" we have on our hands
	var/blood_in_hands = 0

	/// The core temperature of the human compaired to the skin temp of the body
	var/coretemperature = 310.15

	///Exposure to damaging heat levels increases stacks, stacks clean over time when temperatures are lower. Stack is consumed to add a wound.
	var/heat_exposure_stacks = 0

	///human specific screwyhuds from hallucinations (define key (bodypart) to int value (severity)) - see /datum/hallucination/fake_health_doll
	var/hal_screwydoll
