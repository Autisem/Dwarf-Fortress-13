#define ARMORID "armor-[sharp]-[pierce]-[blunt]-[fire]-[acid]-[magic]-[wound]"

/proc/getArmor(sharp = 0, pierce = 0, blunt = 0, fire = 0, acid = 0, magic = 0, wound = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(sharp, pierce, blunt, fire, acid, magic, wound)

/datum/armor
	datum_flags = DF_USE_TAG
	var/sharp
	var/pierce
	var/blunt
	var/fire
	var/acid
	var/magic
	var/wound

/datum/armor/New(sharp = 0, pierce = 0, blunt = 0, fire = 0, acid = 0, magic = 0, wound = 0)
	src.sharp = sharp
	src.pierce = pierce
	src.blunt = blunt
	src.fire = fire
	src.acid = acid
	src.magic = magic
	src.wound = wound
	tag = ARMORID

/datum/armor/proc/modifyRating(sharp = 0, pierce = 0, blunt = 0, fire = 0, acid = 0, magic = 0, wound = 0)
	return getArmor(src.sharp+sharp, src.pierce+pierce, src.blunt+blunt, src.fire+fire, src.acid+acid, src.magic+magic, src.wound+wound)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(sharp+modifier, pierce+modifier, blunt+modifier, fire+modifier, acid+modifier, magic+modifier, wound+modifier)

/datum/armor/proc/setRating(sharp, pierce, blunt, fire, acid, magic, wound)
	return getArmor((isnull(sharp) ? src.sharp : sharp),\
					(isnull(pierce) ? src.pierce : pierce),\
					(isnull(blunt) ? src.blunt : blunt),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(acid) ? src.acid : acid),\
					(isnull(magic) ? src.magic : magic),\
					(isnull(wound) ? src.wound : wound))

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list(SHARP = sharp, PIERCE = pierce, BLUNT = blunt, FIRE = fire, ACID = acid, MAGIC = magic, WOUND = wound)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(sharp+AA.sharp, pierce+AA.pierce, blunt+AA.blunt, fire+AA.fire, acid+AA.acid, magic+AA.magic, wound+AA.wound)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(sharp-AA.sharp, pierce-AA.pierce, blunt-AA.blunt, fire-AA.fire, acid-AA.acid, magic-AA.magic, wound-AA.wound)

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = ARMORID // update tag in case armor values were edited

#undef ARMORID
