#ifndef DFGEN

/var/__dfgen

/proc/__detect_dfgen()
	if (world.system_type == UNIX)
		if (fexists("./dfgen.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __dfgen = "./dfgen.so"
		else if (fexists("./dfgen"))
			// Old dumb filename.
			return __dfgen = "./dfgen"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/dfgen"))
			// Old dumb filename in `~/.byond/bin`.
			return __dfgen = "dfgen"
		else
			// It's not in the current directory, so try others
			return __dfgen = "dfgen.so"
	else
		return __dfgen = "dfgen"

#define DFGEN (__dfgen || __detect_dfgen())
#endif

/proc/simplex2(x=100, y=100, seed=null, frequency=0.03, octaves=5, lacunarity=2, gain=0.5)
	if(!seed) seed = rand(1, 2000)
	var/res = call(DFGEN,"noise")("[x]", "[y]" ,"[seed]", "[frequency]", "[octaves]", "[lacunarity]", "[gain]")
	var/list/lres = splittext(res, ",")
	call(DFGEN,"del_memory")(lres[lres.len])
	lres.Remove(lres[lres.len])
	return lres
