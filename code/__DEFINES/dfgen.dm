#ifndef DFLIB

/var/__dflib

/proc/__detect_dflib()
	if (world.system_type == UNIX)
		if (fexists("./dflib.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __dflib = "./dflib.so"
		else if (fexists("./dflib"))
			// Old dumb filename.
			return __dflib = "./dflib"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/dflib"))
			// Old dumb filename in `~/.byond/bin`.
			return __dflib = "dflib"
		else
			// It's not in the current directory, so try others
			return __dflib = "dflib.so"
	else
		return __dflib = "dflib"

#define DFLIB (__dflib || __detect_dflib())
#endif

/proc/noise(x=100, y=100, seed=null, frequency=0.03, octaves=5, lacunarity=2)
	if(!seed) seed = rand(1, 2000)
	var/res = call(DFLIB,"simplex")("[x]", "[y]" ,"[seed]", "[frequency]", "[octaves]", "[lacunarity]")
	var/list/lres = splittext(res, ",")
	return lres
