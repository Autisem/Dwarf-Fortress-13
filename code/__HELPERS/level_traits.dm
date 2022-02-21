// Helpers for checking whether a z-level conforms to a specific requirement

// Basic levels
#define is_marx_level(z) SSmapping.level_trait(z, ZTRAIT_MARX)

#define is_fortress_level(z) SSmapping.level_trait(z, ZTRAIT_FORTRESS)

#define is_reserved_level(z) SSmapping.level_trait(z, ZTRAIT_RESERVED)
