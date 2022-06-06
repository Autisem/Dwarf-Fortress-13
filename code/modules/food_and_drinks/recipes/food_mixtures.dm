/datum/crafting_recipe/food
	var/real_parts
	category = CAT_FOOD

/datum/crafting_recipe/food/New()
	real_parts = parts.Copy()
	parts |= reqs

//////////////////////////////////////////FOOD MIXTURES////////////////////////////////////

/datum/chemical_reaction/food
	optimal_temp = 400
	temp_exponent_factor = 1
	thermic_constant = 0
	reaction_tags = REACTION_TAG_FOOD | REACTION_TAG_EASY
