#define MIN_PERCENTAGE 0.8
GLOBAL_LIST_EMPTY(cooking_recipes)

/proc/build_cooking_recipes()
	for(var/recipe in subtypesof(/datum/cooking_recipe))
		var/datum/cooking_recipe/C = new recipe
		GLOB.cooking_recipes[recipe] = C

/datum/cooking_recipe
	var/list/req_items = list()
	var/list/req_reagents = list()
	var/result
	var/custom_result

///******************OVEN RECIPES******************///
/datum/cooking_recipe/oven
/datum/cooking_recipe/oven/bowl
/datum/cooking_recipe/oven/flat_plate
/datum/cooking_recipe/oven/plate

/datum/cooking_recipe/oven/plate/plump_steak
	req_items = list(/obj/item/food/slice/plump_helmet=3, /obj/item/food/slice/meat=1)
	result = /obj/item/food/dish/plump_with_steak
	custom_result = /obj/item/food/dish/plump_with_steak/custom

/datum/cooking_recipe/oven/bowl/plump_pie
	req_items = list(/obj/item/food/dough=1, /obj/item/growable/plump_helmet=3, /obj/item/growable/sweet_pod=2)
	result = /obj/item/food/dish/plump_pie
	custom_result = /obj/item/food/dish/plump_pie/custom

/datum/cooking_recipe/oven/flat_plate/balanced_roll
	req_items = list(/obj/item/food/flat_dough=1, /obj/item/food/slice/meat=3, /obj/item/growable/carrot=2, /obj/item/food/slice/plump_helmet=2)
	result = /obj/item/food/dish/balanced_roll
	custom_result = /obj/item/food/dish/balanced_roll/custom

/datum/cooking_recipe/oven/flat_plate/trolls_delight
	req_items = list(/obj/item/food/slice/meat/troll=2, /obj/item/food/slice/plump_helmet=3, /obj/item/growable/carrot=1)
	req_reagents = list(/datum/reagent/consumable/juice/sweet_pod=10)
	result = /obj/item/food/dish/troll_delight
	custom_result = /obj/item/food/dish/troll_delight/custom

///******************POT RECIPES******************///
/datum/cooking_recipe/pot

/datum/cooking_recipe/pot/dwarven_stew
	req_items = list(/obj/item/food/slice/meat=3, /obj/item/food/slice/plump_helmet=3, /obj/item/growable/turnip=1)
	req_reagents = list(/datum/reagent/water=15)
	result = /obj/item/food/dish/dwarven_stew
	custom_result = /obj/item/food/dish/dwarven_stew/custom

///******************PLATE RECIPES******************///
/datum/cooking_recipe/plate

/datum/cooking_recipe/plate/dwarven_salad
	req_items = list(/obj/item/growable/carrot=1, /obj/item/growable/plump_helmet=1, /obj/item/growable/turnip=1)
	result = /obj/item/food/dish/salad
	custom_result = /obj/item/food/dish/salad/custom

///******************STICK RECIPES******************///
/datum/cooking_recipe/stick

/datum/cooking_recipe/stick/plump_skewer
	req_items = list(/obj/item/growable/plump_helmet=3)
	result = /obj/item/food/dish/plump_skewer
	custom_result = /obj/item/food/dish/plump_skewer/custom

///******************BOWL RECIPES******************///
/datum/cooking_recipe/bowl

///******************PAN RECIPES******************///
/datum/cooking_recipe/pan

/datum/cooking_recipe/pan/beer_wurst
	req_items = list(/obj/item/food/sausage=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer=10)
	result = /obj/item/food/dish/roasted_beer_wurst
	custom_result = /obj/item/food/dish/roasted_beer_wurst/custom

/datum/cooking_recipe/pan/allwurst
	req_items = list(/obj/item/food/sausage/luxurious=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer=10, /datum/reagent/consumable/juice/sweet_pod=10)
	result = /obj/item/food/dish/allwurst
	custom_result = /obj/item/food/dish/allwurst/custom

///******************SAUSAGE RECIPES******************///
/datum/cooking_recipe/sausage

/datum/cooking_recipe/sausage/regular
	req_items = list(/obj/item/food/slice/meat=3)
	result = /obj/item/food/sausage

/datum/cooking_recipe/sausage/luxurious
	req_items = list(/obj/item/food/slice/meat/troll=1, /obj/item/food/slice/meat=1, /obj/item/growable/carrot=1, /obj/item/growable/plump_helmet=1, /obj/item/growable/turnip=1)
	result = /obj/item/food/sausage/luxurious

///Returns either null if no plausable candidates found or a list of a recipe and a value whether it is an exact match or the closest one
/proc/find_recipe(list/_recipes=list(), list/_contents=list(), list/_reagents=list())
	var/list/recipes = list()
	for(var/R in _recipes)
		var/datum/cooking_recipe/C = GLOB.cooking_recipes[R]
		recipes.Add(C)

	if(!recipes.len || (!_contents.len && !_reagents)) // sanity check
		return

	//typelists with amount of specified type
	var/list/contents = list()
	var/list/reagents = list()

	// count amount of each item type
	for(var/obj/O in _contents)
		if(!contents[O.type])
			contents[O.type] = 1
		else
			contents[O.type]++
	// same with reagent types
	for(var/datum/reagent/R in _reagents)
		reagents[R.type] = R.volume

	var/list/recipe_matches_items = list()
	var/list/recipe_matches_reagents = list()

	for(var/datum/cooking_recipe/_recipe in recipes)
		recipe_matches_items[_recipe.type] = list()
		recipe_matches_reagents[_recipe.type] = list()

	// check for each recipe amount of matched reagents and remember the total amount
	for(var/datum/cooking_recipe/recipe in recipes)
		for(var/O in contents)
			var/amt = contents[O]
			if(O in recipe.req_items)
				recipe_matches_items[recipe.type][O] = amt

		for(var/R in reagents)
			var/vol = reagents[R]
			if(R in recipe.req_reagents)
				recipe_matches_reagents[recipe.type][R] = vol

	var/list/P = list()
	// compare whether each recipe passes minimum required matches to be considered an attempt at this recipe
	for(var/datum/cooking_recipe/recipe in recipes.Copy())
		var/i_p = 1
		var/r_p = 1
		if(recipe.req_items.len)
			var/matched = 0
			for(var/O in recipe.req_items)
				matched += recipe_matches_items[recipe.type][O]/recipe.req_items[O]
			i_p = matched/recipe.req_items.len
		if(recipe.req_reagents.len)
			var/matched = 0
			for(var/R in recipe.req_reagents)
				matched += recipe_matches_reagents[recipe.type][R]/recipe.req_reagents[R]
			r_p = matched/recipe.req_reagents.len

		if(i_p < MIN_PERCENTAGE || r_p < MIN_PERCENTAGE)
			recipes.Remove(recipe)
		else
			P.Add((i_p+r_p)/2)

	if(!P.len)
		return

	if(1 in P)
		var/datum/cooking_recipe/best_recipe = recipes[P.Find(1)]
		return list(best_recipe, 1)
	else
		//Find the closest number to 1: this is our closest recipe assuming all indexes are the same everywhere
		var/list/deltas = list()
		for(var/x in P)
			deltas.Add(abs(x-1))
		var/best_match = P[deltas.Find(min(deltas))]
		var/datum/cooking_recipe/best_recipe = recipes[P.Find(best_match)]
		return list(best_recipe, 0)

/obj/item/food/proc/transfer_nutrients_from(obj/item/I)
	var/datum/component/edible/E = GetComponent(/datum/component/edible)
	E.initial_reagents = list()

	if(I.reagents)
		for(var/datum/reagent/R in I.reagents.reagent_list)
			E.initial_reagents[R.type] = R.volume/2

	for(var/obj/item/food/food in I.contents)
		for(var/R in food.food_reagents)
			if(R in E.initial_reagents)
				E.initial_reagents[R] += food.food_reagents[R]
			else
				E.initial_reagents[R] = food.food_reagents[R]

	for(var/obj/item/growable/food in I.contents)
		for(var/R in food.food_reagents)
			if(R in E.initial_reagents)
				E.initial_reagents[R] += food.food_reagents[R]
			else
				E.initial_reagents[R] = food.food_reagents[R]

#undef MIN_PERCENTAGE
