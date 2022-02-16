/datum/space_level
	var/name = "NAME MISSING"
	var/list/neigbours = list()
	var/list/traits
	var/z_value = 1 //actual z placement
	var/linkage = SELFLOOPING
	var/xi
	var/yi   //imaginary placements on the grid
	//Z-levels orbital body
	var/datum/orbital_object/z_linked/orbital_body
	//Is something generating on this level?
	var/generating = FALSE

/datum/space_level/New(new_z, new_name, list/new_traits = list())
	z_value = new_z
	name = new_name
	traits = new_traits
	set_linkage(new_traits[ZTRAIT_LINKAGE])
