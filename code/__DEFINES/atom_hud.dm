// for secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list
// note: if you add more HUDs, even for non-human atoms, make sure to use unique numbers for the defines!
// /datum/atom_hud expects these to be unique
// these need to be strings in order to make them associative lists
/// dead, alive, sick, health status
#define HEALTH_HUD		"1"
/// a simple line rounding the mob's number health
#define STATUS_HUD		"2"
//for antag huds. these are used at the /mob level
#define ANTAG_HUD		"3"

//by default everything in the hud_list of an atom is an image
//a value in hud_list with one of these will change that behavior
#define HUD_LIST_LIST 1

//data HUD (medhud, sechud) defines
//Don't forget to update human/New() if you change these!
#define DATA_HUD_MEDICAL_BASIC			1
#define DATA_HUD_MEDICAL_ADVANCED		2

// Notification action types
#define NOTIFY_JUMP "jump"
#define NOTIFY_ATTACK "attack"
#define NOTIFY_ORBIT "orbit"

/// cooldown for being shown the images for any particular data hud
#define ADD_HUD_TO_COOLDOWN 20
