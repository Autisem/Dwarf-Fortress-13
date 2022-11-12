/datum/skill/cooking
	name = "Cooking"
	title = "Chef"
	desc = "The art of cooking dishes."
	modifiers = list(
		SKILL_SPEED_MODIFIER=list(3,2.5,2,1.5,1.2,1,1,0.9,0.8,0.7,0.6),//How fast are we doing cooking related stuff
		SKILL_AMOUNT_MIN_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3),//+This to the base min amount
		SKILL_AMOUNT_MAX_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3)//+This to the base max amount
	)

/datum/skill/cooking/level_gained(datum/mind/mind, new_level, old_level)
	. = ..()
	for(var/t in GLOB.cooking_recipes)
		var/datum/cooking_recipe/recipe = GLOB.cooking_recipes[t]
		var/recipe_name = initial(recipe.result.name)
		if(recipe.req_lvl == new_level)
			var/text = span_green("<br>[recipe_name]:")
			for(var/item in recipe.req_items)
				var/obj/item/I = item
				text += "<br>\t[recipe.req_items[item]] [initial(I.name)]"
			for(var/reag in recipe.req_reagents)
				var/datum/reagent/R = reag
				text += "<br>\t[recipe.req_reagents[reag]] [initial(R.name)]"
			mind.store_memory(text)
	to_chat(mind.current, span_green("Through better understanding of [name] I realise how to cook new recipes!"))
