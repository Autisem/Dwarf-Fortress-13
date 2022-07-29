//Each lists stores ckeys for "Never for this round" option category


GLOBAL_LIST_INIT(poll_ignore_desc, list(
))
GLOBAL_LIST_INIT(poll_ignore, init_poll_ignore())


/proc/init_poll_ignore()
	. = list()
	for (var/k in GLOB.poll_ignore_desc)
		.[k] = list()
