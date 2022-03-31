
/////////////////////////// DNA DATUM
/datum/dna
	var/unique_enzymes
	var/uni_identity
	var/blood_type
	var/datum/species/species = new /datum/species/human //The type of mutant race the player is if applicable (i.e. potato-man)
	var/list/features = list("FFF") //first value is mutant color
	var/real_name //Stores the real name of the person who originally got this dna datum. Used primarely for changelings,
	var/list/mutations = list()   //All mutations are from now on here
	var/list/temporary_mutations = list() //Temporary changes to the UE
	var/list/previous = list() //For temporary name/ui/ue/blood_type modifications
	var/mob/living/holder
	var/mutation_index[DNA_MUTATION_BLOCKS] //List of which mutations this carbon has and its assigned block
	var/default_mutation_genes[DNA_MUTATION_BLOCKS] //List of the default genes from this mutation to allow DNA Scanner highlighting
	var/stability = 100
	var/scrambled = FALSE //Did we take something like mutagen? In that case we cant get our genes scanned to instantly cheese all the powers.

/datum/dna/New(mob/living/new_holder)
	if(istype(new_holder))
		holder = new_holder

/datum/dna/Destroy()
	if(iscarbon(holder))
		var/mob/living/carbon/cholder = holder
		if(cholder.dna == src)
			cholder.dna = null
	holder = null

	QDEL_NULL(species)

	mutations.Cut()					//This only references mutations, just dereference.
	temporary_mutations.Cut()		//^
	previous.Cut()					//^

	return ..()

/datum/dna/proc/transfer_identity(mob/living/carbon/destination, transfer_SE = 0)
	if(!istype(destination))
		return
	destination.dna.unique_enzymes = unique_enzymes
	destination.dna.uni_identity = uni_identity
	destination.dna.blood_type = blood_type
	destination.set_species(species.type, icon_update=0)
	destination.dna.features = features.Copy()
	destination.dna.real_name = real_name
	destination.dna.temporary_mutations = temporary_mutations.Copy()
	if(transfer_SE)
		destination.dna.mutation_index = mutation_index
		destination.dna.default_mutation_genes = default_mutation_genes

/datum/dna/proc/copy_dna(datum/dna/new_dna)
	new_dna.unique_enzymes = unique_enzymes
	new_dna.mutation_index = mutation_index
	new_dna.default_mutation_genes = default_mutation_genes
	new_dna.uni_identity = uni_identity
	new_dna.blood_type = blood_type
	new_dna.features = features.Copy()
	new_dna.species = new species.type
	new_dna.real_name = real_name
	new_dna.mutations = mutations.Copy()

/datum/dna/proc/generate_uni_identity()
	. = ""
	var/list/L = new /list(DNA_UNI_IDENTITY_BLOCKS)

	switch(holder.gender)
		if(MALE)
			L[DNA_GENDER_BLOCK] = construct_block(G_MALE, 3)
		if(FEMALE)
			L[DNA_GENDER_BLOCK] = construct_block(G_FEMALE, 3)
		else
			L[DNA_GENDER_BLOCK] = construct_block(G_PLURAL, 3)
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		if(!GLOB.hairstyles_list.len)
			init_sprite_accessory_subtypes(/datum/sprite_accessory/hair,GLOB.hairstyles_list, GLOB.hairstyles_male_list, GLOB.hairstyles_female_list)
		L[DNA_HAIRSTYLE_BLOCK] = construct_block(GLOB.hairstyles_list.Find(H.hairstyle), GLOB.hairstyles_list.len)
		L[DNA_HAIR_COLOR_BLOCK] = sanitize_hexcolor(H.hair_color)
		if(!GLOB.facial_hairstyles_list.len)
			init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_hair, GLOB.facial_hairstyles_list, GLOB.facial_hairstyles_male_list, GLOB.facial_hairstyles_female_list)
		L[DNA_FACIAL_HAIRSTYLE_BLOCK] = construct_block(GLOB.facial_hairstyles_list.Find(H.facial_hairstyle), GLOB.facial_hairstyles_list.len)
		L[DNA_FACIAL_HAIR_COLOR_BLOCK] = sanitize_hexcolor(H.facial_hair_color)
		L[DNA_SKIN_TONE_BLOCK] = construct_block(GLOB.skin_tones.Find(H.skin_tone), GLOB.skin_tones.len)
		L[DNA_EYE_COLOR_BLOCK] = sanitize_hexcolor(H.eye_color)

	for(var/i=1, i<=DNA_UNI_IDENTITY_BLOCKS, i++)
		if(L[i])
			. += L[i]
		else
			. += random_string(DNA_BLOCK_SIZE,GLOB.hex_characters)
	return .

/datum/dna/proc/generate_dna_blocks()
	var/list/mutations_temp = GLOB.good_mutations + GLOB.bad_mutations + GLOB.not_good_mutations
	if(!LAZYLEN(mutations_temp))
		return
	mutation_index.Cut()
	default_mutation_genes.Cut()
	shuffle_inplace(mutations_temp)
	shuffle_inplace(mutation_index)

//Used to generate original gene sequences for every mutation
/proc/generate_gene_sequence(length=4)
	var/static/list/active_sequences = list("AT","TA","GC","CG")
	var/sequence
	for(var/i in 1 to length*DNA_SEQUENCE_LENGTH)
		sequence += pick(active_sequences)
	return sequence

//Used to create a chipped gene sequence
/proc/create_sequence(mutation, active, difficulty)
	difficulty += rand(-2,4)
	var/sequence = GET_SEQUENCE(mutation)
	if(active)
		return sequence
	while(difficulty)
		var/randnum = rand(1, length_char(sequence))
		sequence = copytext_char(sequence, 1, randnum) + "X" + copytext_char(sequence, randnum + 1)
		difficulty--
	return sequence

/datum/dna/proc/generate_unique_enzymes()
	. = ""
	if(istype(holder))
		real_name = holder.real_name
		. += md5(holder.real_name)
	else
		. += random_string(DNA_UNIQUE_ENZYMES_LEN, GLOB.hex_characters)
	return .

/datum/dna/proc/update_ui_block(blocknumber)
	if(!blocknumber || !ishuman(holder))
		return
	var/mob/living/carbon/human/H = holder
	switch(blocknumber)
		if(DNA_HAIR_COLOR_BLOCK)
			setblock(uni_identity, blocknumber, sanitize_hexcolor(H.hair_color))
		if(DNA_FACIAL_HAIR_COLOR_BLOCK)
			setblock(uni_identity, blocknumber, sanitize_hexcolor(H.facial_hair_color))
		if(DNA_SKIN_TONE_BLOCK)
			setblock(uni_identity, blocknumber, construct_block(GLOB.skin_tones.Find(H.skin_tone), GLOB.skin_tones.len))
		if(DNA_EYE_COLOR_BLOCK)
			setblock(uni_identity, blocknumber, sanitize_hexcolor(H.eye_color))
		if(DNA_GENDER_BLOCK)
			switch(H.gender)
				if(MALE)
					setblock(uni_identity, blocknumber, construct_block(G_MALE, 3))
				if(FEMALE)
					setblock(uni_identity, blocknumber, construct_block(G_FEMALE, 3))
				else
					setblock(uni_identity, blocknumber, construct_block(G_PLURAL, 3))
		if(DNA_FACIAL_HAIRSTYLE_BLOCK)
			setblock(uni_identity, blocknumber, construct_block(GLOB.facial_hairstyles_list.Find(H.facial_hairstyle), GLOB.facial_hairstyles_list.len))
		if(DNA_HAIRSTYLE_BLOCK)
			setblock(uni_identity, blocknumber, construct_block(GLOB.hairstyles_list.Find(H.hairstyle), GLOB.hairstyles_list.len))

/**
 * Checks if two DNAs are practically the same by comparing their most defining features
 *
 * Arguments:
 * * target_dna The DNA that we are comparing to
 */
/datum/dna/proc/is_same_as(datum/dna/target_dna)
	if(uni_identity == target_dna.uni_identity && mutation_index == target_dna.mutation_index && real_name == target_dna.real_name)
		if(species.type == target_dna.species.type && compare_list(features, target_dna.features) && blood_type == target_dna.blood_type)
			return TRUE
	return FALSE

/datum/dna/proc/update_instability(alert=TRUE)
	stability = 100
	if(holder)
		var/message
		if(alert)
			switch(stability)
				if(70 to 90)
					message = span_warning("Дрожу.")
				if(60 to 69)
					message = span_warning("Мне холодно.")
				if(40 to 59)
					message = span_warning("Мне плохо.")
				if(20 to 39)
					message = span_warning("Моя кожа движется?")
				if(1 to 19)
					message = span_warning("Чувствую как каждая моя клеточка горит.")
				if(-INFINITY to 0)
					message = span_boldwarning("Похоже моя ДНК сейчас взорвётся! Надо бы что-то предпринять поскорее.")
		if(stability <= 0)
			holder.apply_status_effect(STATUS_EFFECT_DNA_MELT)
		if(message)
			to_chat(holder, message)

//used to update dna UI, UE, and dna.real_name.
/datum/dna/proc/update_dna_identity()
	uni_identity = generate_uni_identity()
	unique_enzymes = generate_unique_enzymes()

/datum/dna/proc/initialize_dna(newblood_type, skip_index = FALSE)
	if(newblood_type)
		blood_type = newblood_type
	unique_enzymes = generate_unique_enzymes()
	uni_identity = generate_uni_identity()
	if(!skip_index) //I hate this
		generate_dna_blocks()
	features = random_features()

/////////////////////////// DNA MOB-PROCS //////////////////////

/mob/proc/set_species(datum/species/mrace, icon_update = 1)
	return

/mob/living/carbon/set_species(datum/species/mrace, icon_update = TRUE, pref_load = FALSE)
	if(mrace && has_dna())
		var/datum/species/new_race
		if(ispath(mrace))
			new_race = new mrace
		else if(istype(mrace))
			new_race = mrace
		else
			return
		deathsound = new_race.deathsound
		dna.species.on_species_loss(src, new_race, pref_load)
		var/datum/species/old_species = dna.species
		dna.species = new_race
		dna.species.on_species_gain(src, old_species, pref_load)
		if(ishuman(src))
			qdel(language_holder)
			var/species_holder = initial(mrace.species_language_holder)
			language_holder = new species_holder(src)
		update_atom_languages()

/mob/living/carbon/human/set_species(datum/species/mrace, icon_update = TRUE, pref_load = FALSE)
	..()
	if(icon_update)
		update_body()
		update_hair()
		update_body_parts()
	update_teeth()


/mob/proc/has_dna()
	return

/mob/living/carbon/has_dna()
	return dna


/mob/living/carbon/human/proc/hardset_dna(ui, list/mutation_index, list/default_mutation_genes, newreal_name, newblood_type, datum/species/mrace, newfeatures, list/mutations, force_transfer_mutations)
//Do not use force_transfer_mutations for stuff like cloners without some precautions, otherwise some conditional mutations could break (timers, drill hat etc)
	if(newfeatures)
		dna.features = newfeatures

	if(mrace)
		var/datum/species/newrace = new mrace.type
		newrace.copy_properties_from(mrace)
		set_species(newrace, icon_update=0)

	if(newreal_name)
		dna.real_name = newreal_name
		dna.generate_unique_enzymes()

	if(newblood_type)
		dna.blood_type = newblood_type

	if(ui)
		dna.uni_identity = ui
		updateappearance(icon_update=0)

	if(LAZYLEN(mutation_index))
		dna.mutation_index = mutation_index.Copy()
		if(LAZYLEN(default_mutation_genes))
			dna.default_mutation_genes = default_mutation_genes.Copy()
		else
			dna.default_mutation_genes = mutation_index.Copy()

	if(mrace || newfeatures || ui)
		update_body()
		update_hair()
		update_body_parts()

/mob/living/carbon/proc/create_dna()
	dna = new /datum/dna(src)
	if(!dna.species)
		var/rando_race = pick(GLOB.roundstart_races)
		dna.species = new rando_race()

//proc used to update the mob's appearance after its dna UI has been changed
/mob/living/carbon/proc/updateappearance(icon_update=1, mutcolor_update=0, mutations_overlay_update=0)
	if(!has_dna())
		return

	switch(deconstruct_block(getblock(dna.uni_identity, DNA_GENDER_BLOCK), 3))
		if(G_MALE)
			gender = MALE
		if(G_FEMALE)
			gender = FEMALE
		else
			gender = PLURAL

/mob/living/carbon/human/updateappearance(icon_update=1, mutcolor_update=0, mutations_overlay_update=0)
	..()
	var/structure = dna.uni_identity
	hair_color = sanitize_hexcolor(getblock(structure, DNA_HAIR_COLOR_BLOCK))
	facial_hair_color = sanitize_hexcolor(getblock(structure, DNA_FACIAL_HAIR_COLOR_BLOCK))
	skin_tone = GLOB.skin_tones[deconstruct_block(getblock(structure, DNA_SKIN_TONE_BLOCK), GLOB.skin_tones.len)]
	eye_color = sanitize_hexcolor(getblock(structure, DNA_EYE_COLOR_BLOCK))
	facial_hairstyle = GLOB.facial_hairstyles_list[deconstruct_block(getblock(structure, DNA_FACIAL_HAIRSTYLE_BLOCK), GLOB.facial_hairstyles_list.len)]
	hairstyle = GLOB.hairstyles_list[deconstruct_block(getblock(structure, DNA_HAIRSTYLE_BLOCK), GLOB.hairstyles_list.len)]
	if(icon_update)
		update_body()
		update_hair()
		if(mutcolor_update)
			update_body_parts()

/datum/dna/proc/check_block_string(mutation)
	if((LAZYLEN(mutation_index) > DNA_MUTATION_BLOCKS) || !(mutation in mutation_index))
		return FALSE
	return is_gene_active(mutation)

/datum/dna/proc/is_gene_active(mutation)
	return (mutation_index[mutation] == GET_SEQUENCE(mutation))

/////////////////////////// DNA HELPER-PROCS //////////////////////////////

/proc/getleftblocks(input,blocknumber,blocksize)
	if(blocknumber > 1)
		return copytext_char(input,1,((blocksize*blocknumber)-(blocksize-1)))

/proc/getrightblocks(input,blocknumber,blocksize)
	if(blocknumber < (length(input)/blocksize))
		return copytext_char(input,blocksize*blocknumber+1,length(input)+1)

/proc/getblock(input, blocknumber, blocksize=DNA_BLOCK_SIZE)
	return copytext_char(input, blocksize*(blocknumber-1)+1, (blocksize*blocknumber)+1)

/proc/setblock(istring, blocknumber, replacement, blocksize=DNA_BLOCK_SIZE)
	if(!istring || !blocknumber || !replacement || !blocksize)
		return 0
	return getleftblocks(istring, blocknumber, blocksize) + replacement + getrightblocks(istring, blocknumber, blocksize)

/datum/dna/proc/mutation_in_sequence(mutation)
	if(!mutation)
		return
	else if(mutation in mutation_index)
		return TRUE

/mob/living/carbon/proc/randmuti()
	if(!has_dna())
		return
	var/num = rand(1, DNA_UNI_IDENTITY_BLOCKS)
	var/newdna = setblock(dna.uni_identity, num, random_string(DNA_BLOCK_SIZE, GLOB.hex_characters))
	dna.uni_identity = newdna
	updateappearance(mutations_overlay_update=1)

/mob/living/carbon/proc/clean_dna()
	if(!has_dna())
		return

/proc/scramble_dna(mob/living/carbon/M, ui=FALSE, se=FALSE, probability)
	if(!M.has_dna())
		return FALSE
	if(se)
		for(var/i=1, i<=DNA_MUTATION_BLOCKS, i++)
			if(prob(probability))
				M.dna.generate_dna_blocks()
	if(ui)
		for(var/i=1, i<=DNA_UNI_IDENTITY_BLOCKS, i++)
			if(prob(probability))
				M.dna.uni_identity = setblock(M.dna.uni_identity, i, random_string(DNA_BLOCK_SIZE, GLOB.hex_characters))
		M.updateappearance(mutations_overlay_update=1)
	return TRUE

//value in range 1 to values. values must be greater than 0
//all arguments assumed to be positive integers
/proc/construct_block(value, values, blocksize=DNA_BLOCK_SIZE)
	var/width = round((16**blocksize)/values)
	if(value < 1)
		value = 1
	value = (value * width) - rand(1,width)
	return num2hex(value, blocksize)

//value is hex
/proc/deconstruct_block(value, values, blocksize=DNA_BLOCK_SIZE)
	var/width = round((16**blocksize)/values)
	value = round(hex2num(value) / width) + 1
	if(value > values)
		value = values
	return value

/////////////////////////// DNA HELPER-PROCS

/mob/living/carbon/human/proc/something_horrible(ignore_stability)
	if(!has_dna()) //shouldn't ever happen anyway so it's just in really weird cases
		return
	if(!ignore_stability && (dna.stability > 0))
		return
	var/instability = -dna.stability
	dna.stability = 100
	if(prob(max(70-instability,0)))
		switch(rand(0,10)) //not complete and utter death
			if(0)
				monkeyize()
			if(1)
				gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic)
				to_chat(src, span_warning("Моя плоть превратилась в инвалидную коляску, и я не чувствую своих ног."))
			if(2)
				corgize()
			if(3)
				to_chat(src, span_notice("А мне неплохо!"))
			if(4)
				to_chat(src, span_notice("Неплохо!")) //you thought
				physiology.damage_resistance = -20000
			if(5)
				to_chat(src, span_notice("Отлично!"))
				reagents.add_reagent(/datum/reagent/aslimetoxin, 10)
			if(6)
				apply_status_effect(STATUS_EFFECT_GO_AWAY)
			if(7)
				to_chat(src, span_notice("Зашибись!"))
				ForceContractDisease(new/datum/disease/decloning()) //slow acting, non-viral clone damage based GBS
			if(8)
				var/list/elligible_organs = list()
				for(var/obj/item/organ/O in internal_organs) //make sure we dont get an implant or cavity item
					elligible_organs += O
				vomit(20, TRUE)
				if(elligible_organs.len)
					var/obj/item/organ/O = pick(elligible_organs)
					O.Remove(src)
					visible_message(span_danger("[capitalize(src.name)] выблёвывает [O.name]!") , span_danger("Выблёвываю [O.name]")) //no "vomit up your the heart"
					O.forceMove(drop_location())
			if(9 to 10)
				ForceContractDisease(new/datum/disease/gastrolosis())
				to_chat(src, span_notice("О, да!"))
	else
		switch(rand(0,5))
			if(0)
				gib()
			if(1)
				dust()

			if(2)
				death()
			if(3)
				if(prob(95))
					var/obj/item/bodypart/BP = get_bodypart(pick(BODY_ZONE_CHEST,BODY_ZONE_HEAD))
					if(BP)
						BP.dismember()
					else
						gib()
				else
					set_species(/datum/species/dullahan)
			if(4)
				visible_message(span_warning("С [src] слезает кожа!") , span_boldwarning("Моя кожа слезает с меня!"))
				spawn_gibs()
				set_species(/datum/species/skeleton)
				if(prob(90))
					addtimer(CALLBACK(src, .proc/death), 30)
					if(mind)
						mind.hasSoul = FALSE
			if(5)
				to_chat(src, span_phobia("ПОСМОТРИ НАВЕРХ!"))
				addtimer(CALLBACK(src, .proc/something_horrible_mindmelt), 30)


/mob/living/carbon/human/proc/something_horrible_mindmelt()
	if(!is_blind())
		var/obj/item/organ/eyes/eyes = locate(/obj/item/organ/eyes) in internal_organs
		if(!eyes)
			return
		eyes.Remove(src)
		qdel(eyes)
		visible_message(span_notice("У [src] тают глаза!") , "<span class>='userdanger'>Кажется я теперь понимаю что-то.</span>")
		addtimer(CALLBACK(src, .proc/adjustOrganLoss, ORGAN_SLOT_BRAIN, 200), 20)
