//Each lists stores ckeys for "Never for this round" option category

#define POLL_IGNORE_SENTIENCE_POTION "sentience_potion"
#define POLL_IGNORE_HOLOPARASITE "holoparasite"
#define POLL_IGNORE_IMAGINARYFRIEND "imaginary_friend"
#define POLL_IGNORE_SPLITPERSONALITY "split_personality"

GLOBAL_LIST_INIT(poll_ignore_desc, list(
	POLL_IGNORE_SENTIENCE_POTION = "Зелье разумности",
	POLL_IGNORE_HOLOPARASITE = "Голопаразит",
	POLL_IGNORE_SPECTRAL_BLADE = "Спектральный меч",
	POLL_IGNORE_IMAGINARYFRIEND = "Воображаемый друг",
	POLL_IGNORE_SPLITPERSONALITY = "Раздвоение личности",
))
GLOBAL_LIST_INIT(poll_ignore, init_poll_ignore())


/proc/init_poll_ignore()
	. = list()
	for (var/k in GLOB.poll_ignore_desc)
		.[k] = list()
