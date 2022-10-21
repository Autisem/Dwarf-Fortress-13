#ifndef DFLIB

/var/__dflib

/proc/__detect_dflib()
	if (world.system_type == UNIX)
		if (fexists("./libdflib.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __dflib = "./libdflib.so"
		else if (fexists("./dflib"))
			// Old dumb filename.
			return __dflib = "./dflib"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/dflib"))
			// Old dumb filename in `~/.byond/bin`.
			return __dflib = "dflib"
		else
			// It's not in the current directory, so try others
			return __dflib = "libdflib.so"
	else
		return __dflib = "dflib"

#define DFLIB (__dflib || __detect_dflib())
#endif

/proc/fbm(x=100, y=100, seed=null, frequency=0.03, octaves=5, lacunarity=2, persistence=0.5)
	if(!seed) seed = rand(1, 2000)
	var/res = call(DFLIB,"fbm")("[x]", "[y]" ,"[seed]", "[frequency]", "[octaves]", "[lacunarity]", "[persistence]")
	var/list/lres = splittext(res, ",")
	return lres
