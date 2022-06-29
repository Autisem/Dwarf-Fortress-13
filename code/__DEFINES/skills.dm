
// Skill levels
#define SKILL_LEVEL_NONE 1
#define SKILL_LEVEL_NOVICE 2
#define SKILL_LEVEL_ADEQUATE 3
#define SKILL_LEVEL_COMPETENT 4
#define SKILL_LEVEL_PROFICIENT 5
#define SKILL_LEVEL_ADEPT 6
#define SKILL_LEVEL_EXPERT 7
#define SKILL_LEVEL_ACCOMPLISHED 8
#define SKILL_LEVEL_MASTER 9
#define SKILL_LEVEL_GRANDMASTER 10
#define SKILL_LEVEL_LEGEND 11

// Level experience requirements
#define SKILL_EXP_NONE 0
#define SKILL_EXP_NOVICE 100
#define SKILL_EXP_ADEQUATE 250
#define SKILL_EXP_COMPETENT 500
#define SKILL_EXP_PROFICIENT 800
#define SKILL_EXP_ADEPT 1200
#define SKILL_EXP_EXPERT 1700
#define SKILL_EXP_ACCOMPLISHED 2300
#define SKILL_EXP_MASTER 3000
#define SKILL_EXP_GRANDMASTER 3800
#define SKILL_EXP_LEGEND 5000

//Allows us to get EXP from level, or level from EXP
#define SKILL_EXP_LIST list(SKILL_EXP_NONE, SKILL_EXP_NOVICE, SKILL_EXP_ADEQUATE, SKILL_EXP_COMPETENT, SKILL_EXP_PROFICIENT, SKILL_EXP_ADEPT, SKILL_EXP_EXPERT, SKILL_EXP_ACCOMPLISHED, SKILL_EXP_MASTER, SKILL_EXP_GRANDMASTER, SKILL_EXP_LEGEND)

//Skill modifier types
#define SKILL_SPEED_MODIFIER "skill_speed_modifier"//ideally added/subtracted in speed calculations to make you do stuff faster
#define SKILL_PROBS_MODIFIER "skill_probability_modifier"//ideally added/subtracted where beneficial in prob(x) calls
#define SKILL_RANDS_MODIFIER "skill_randomness_modifier"//ideally added/subtracted where beneficial in rand(x,y) calls
#define SKILL_SMITHING_MODIFIER "skill_smithing_modifier"//for smithing minigame
//Combat related modifiers
#define SKILL_PARRY_MODIFIER "skill_parry_modifier"//passive dodge/parry chance on weapon skills
#define SKILL_MISS_MODIFIER "skill_miss_modifier"//passive misses in combat; the higher the level the lesser the miss chance
#define SKILL_DAMAGE_MODIFIER "skill_damage_modifier"
#define SKILL_PENETRATION_MODIFIER "skill_penetration_modifier"

//number defines
#define CLEAN_SKILL_BEAUTY_ADJUSTMENT	-15//It's a denominator so no 0. Higher number = less cleaning xp per cleanable. Negative value means cleanables with negative beauty give xp.
#define CLEAN_SKILL_GENERIC_WASH_XP	1.5//Value. Higher number = more XP when cleaning non-cleanables (walls/floors/lips)
