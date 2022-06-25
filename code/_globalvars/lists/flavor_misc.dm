//Preferences stuff
	//Hairstyles
GLOBAL_LIST_EMPTY(hairstyles_list)			//stores /datum/sprite_accessory/hair indexed by name
GLOBAL_LIST_EMPTY(hairstyles_male_list)		//stores only hair names
GLOBAL_LIST_EMPTY(hairstyles_female_list)	//stores only hair names
GLOBAL_LIST_EMPTY(facial_hairstyles_list)	//stores /datum/sprite_accessory/facial_hair indexed by name
GLOBAL_LIST_EMPTY(facial_hairstyles_male_list)	//stores only hair names
GLOBAL_LIST_EMPTY(facial_hairstyles_female_list)	//stores only hair names
GLOBAL_LIST_EMPTY(hair_gradients_list) //stores /datum/sprite_accessory/hair_gradient indexed by name
GLOBAL_LIST_EMPTY(facial_hair_gradients_list) //stores /datum/sprite_accessory/facial_hair_gradient indexed by name
	//Underwear
GLOBAL_LIST_EMPTY(underwear_list)		//stores /datum/sprite_accessory/underwear indexed by name
GLOBAL_LIST_EMPTY(underwear_m)	//stores only underwear name
GLOBAL_LIST_EMPTY(underwear_f)	//stores only underwear name
	//Undershirts
GLOBAL_LIST_EMPTY(undershirt_list) 	//stores /datum/sprite_accessory/undershirt indexed by name
GLOBAL_LIST_EMPTY(undershirt_m)	 //stores only undershirt name
GLOBAL_LIST_EMPTY(undershirt_f)	 //stores only undershirt name
	//Socks
GLOBAL_LIST_EMPTY(socks_list)		//stores /datum/sprite_accessory/socks indexed by name
	//Lizard Bits (all datum lists indexed by name)
GLOBAL_LIST_EMPTY(body_markings_list)
GLOBAL_LIST_EMPTY(tails_list_lizard)
GLOBAL_LIST_EMPTY(animated_tails_list_lizard)
GLOBAL_LIST_EMPTY(snouts_list)
GLOBAL_LIST_EMPTY(horns_list)
GLOBAL_LIST_EMPTY(frills_list)
GLOBAL_LIST_EMPTY(spines_list)
GLOBAL_LIST_EMPTY(legs_list)
GLOBAL_LIST_EMPTY(animated_spines_list)

	//Mutant Human bits
GLOBAL_LIST_EMPTY(tails_list_human)
GLOBAL_LIST_EMPTY(animated_tails_list_human)
GLOBAL_LIST_EMPTY(ears_list)
GLOBAL_LIST_EMPTY(wings_list)
GLOBAL_LIST_EMPTY(wings_open_list)
GLOBAL_LIST_EMPTY(r_wings_list)
GLOBAL_LIST_EMPTY(moth_wings_list)
GLOBAL_LIST_EMPTY(moth_antennae_list)
GLOBAL_LIST_EMPTY(moth_markings_list)
GLOBAL_LIST_EMPTY(caps_list)
GLOBAL_LIST_EMPTY(tails_list_monkey)

GLOBAL_LIST_INIT(color_list_ethereal, list(
	"Red" = "ff4d4d",
	"Faint Red" = "ffb3b3",
	"Dark Red" = "9c3030",
	"Orange" = "ffa64d",
	"Burnt Orange" = "cc4400",
	"Bright Yellow" = "ffff99",
	"Dull Yellow" = "fbdf56",
	"Faint Green" = "ddff99",
	"Green" = "97ee63",
	"Seafoam Green" = "00fa9a",
	"Dark Green" = "37835b",
	"Cyan Blue" = "00ffff",
	"Faint Blue" = "b3d9ff",
	"Blue" = "3399ff",
	"Dark Blue" = "6666ff",
	"Purple" = "ee82ee",
	"Dark Fuschia" = "cc0066",
	"Pink" = "ff99cc",
	"White" = "f2f2f2",))

GLOBAL_LIST_INIT(ghost_forms_with_directions_list, list(
	"ghost",
	"ghostian",
	"ghostian2",
	"ghostking",
	"ghost_red",
	"ghost_black",
	"ghost_blue",
	"ghost_yellow",
	"ghost_green",
	"ghost_pink",
	"ghost_cyan",
	"ghost_dblue",
	"ghost_dred",
	"ghost_dgreen",
	"ghost_dcyan",
	"ghost_grey",
	"ghost_dyellow",
	"ghost_dpink",
	"skeleghost",
	"ghost_purpleswirl",
	"ghost_rainbow",
	"ghost_fire",
	"ghost_funkypurp",
	"ghost_pinksherbert",
	"ghost_blazeit",
	"ghost_mellow",
	"ghost_camo",
	"catghost")) //stores the ghost forms that support directional sprites

GLOBAL_LIST_INIT(ghost_forms_with_accessories_list, list("ghost")) //stores the ghost forms that support hair and other such things

GLOBAL_LIST_INIT(security_depts_prefs, sort_list(list(SEC_DEPT_RANDOM, SEC_DEPT_NONE, SEC_DEPT_ENGINEERING, SEC_DEPT_MEDICAL, SEC_DEPT_SCIENCE, SEC_DEPT_SUPPLY)))

	//Backpacks
#define GBACKPACK "Grey Backpack"
#define GSATCHEL "Grey Satchel"
#define GDUFFELBAG "Grey Duffel Bag"
#define LSATCHEL "Leather Satchel"
#define DBACKPACK "Department Backpack"
#define DSATCHEL "Department Satchel"
#define DDUFFELBAG "Department Duffel Bag"
GLOBAL_LIST_INIT(backpacklist, list(DBACKPACK, DSATCHEL, DDUFFELBAG, GBACKPACK, GSATCHEL, GDUFFELBAG, LSATCHEL))

	//Suit/Skirt
#define PREF_SUIT "Jumpsuit"
#define PREF_SKIRT "Jumpskirt"
GLOBAL_LIST_INIT(jumpsuitlist, list(PREF_SUIT, PREF_SKIRT))

//Uplink spawn loc
#define UPLINK_PDA		"PDA"
#define UPLINK_RADIO	"Radio"
#define UPLINK_PEN		"Pen" //like a real spy!
#define UPLINK_IMPLANT  "Implant"
GLOBAL_LIST_INIT(uplink_spawn_loc_list, list(UPLINK_PDA, UPLINK_RADIO, UPLINK_PEN, UPLINK_IMPLANT))

	//Female Uniforms
GLOBAL_LIST_EMPTY(female_clothing_icons)

GLOBAL_LIST_INIT(scarySounds, list('sound/weapons/thudswoosh.ogg','sound/weapons/taser.ogg','sound/weapons/armbomb.ogg','sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg','sound/voice/hiss5.ogg','sound/voice/hiss6.ogg','sound/effects/glassbr1.ogg','sound/effects/glassbr2.ogg','sound/effects/glassbr3.ogg','sound/items/welder.ogg','sound/items/welder2.ogg','sound/machines/airlock.ogg','sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg'))


// Reference list for disposal sort junctions. Set the sortType variable on disposal sort junctions to
// the index of the sort department that you want. For example, sortType set to 2 will reroute all packages
// tagged for the Cargo Bay.

/* List of sortType codes for mapping reference
0 Waste
1 Disposals - All unwrapped items and untagged parcels get picked up by a junction with this sortType. Usually leads to the recycler.
2 Cargo Bay
3 QM Office
4 Engineering
5 CE Office
6 Atmospherics
7 Security
8 HoS Office
9 Medbay
10 CMO Office
11 Chemistry
12 Research
13 RD Office
14 Robotics
15 HoP Office
16 Library
17 Chapel
18 Theatre
19 Bar
20 Kitchen
21 Hydroponics
22 Janitor
23 Genetics
24 Experimentor Lab
25 Toxins
26 Dormitories
27 Virology
28 Xenobiology
29 Law Office
30 Detective's Office
*/
