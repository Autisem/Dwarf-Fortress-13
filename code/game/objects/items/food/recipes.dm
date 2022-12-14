GLOBAL_LIST_EMPTY(cooking_recipes)

/proc/build_cooking_recipes()
	for(var/recipe in subtypesof(/datum/cooking_recipe))
		var/datum/cooking_recipe/C = new recipe
		GLOB.cooking_recipes[recipe] = C

/datum/cooking_recipe
	var/list/req_items = list()
	var/list/req_reagents = list()
	var/obj/result
	var/req_lvl = 12 // what cooking level is required to add this recipe to dwarf's notes

///******************OVEN RECIPES******************///
/datum/cooking_recipe/oven
/datum/cooking_recipe/oven/bowl
/datum/cooking_recipe/oven/flat_plate
/datum/cooking_recipe/oven/plate

/datum/cooking_recipe/oven/plate/plump_steak
	req_items = list(/obj/item/food/slice/plump_helmet=3, /obj/item/food/meat/slab=1)
	result = /obj/item/food/dish/plump_with_steak
	req_lvl = 2

/datum/cooking_recipe/oven/bowl/plump_pie
	req_items = list(/obj/item/food/dough=1, /obj/item/growable/plump_helmet=3, /obj/item/growable/sweet_pod=2)
	result = /obj/item/food/dish/plump_pie
	req_lvl = 4

/datum/cooking_recipe/oven/flat_plate/balanced_roll
	req_items = list(/obj/item/food/flat_dough=1, /obj/item/food/slice/meat=3, /obj/item/growable/carrot=2, /obj/item/food/slice/plump_helmet=2)
	result = /obj/item/food/dish/balanced_roll
	req_lvl = 6

/datum/cooking_recipe/oven/flat_plate/trolls_delight
	req_items = list(/obj/item/food/meat/slab/troll=2, /obj/item/food/slice/plump_helmet=3, /obj/item/growable/carrot=1)
	req_reagents = list(/datum/reagent/consumable/juice/sweet_pod=10)
	result = /obj/item/food/dish/troll_delight
	req_lvl = 7

///******************POT RECIPES******************///
/datum/cooking_recipe/pot

/datum/cooking_recipe/pot/dwarven_stew
	req_items = list(/obj/item/food/slice/meat=3, /obj/item/food/slice/plump_helmet=3, /obj/item/growable/turnip=1)
	req_reagents = list(/datum/reagent/water=15)
	result = /obj/item/transfer_food/stew
	req_lvl = 3

///******************PLATE RECIPES******************///
/datum/cooking_recipe/plate

///******************STICK RECIPES******************///
/datum/cooking_recipe/stick

/datum/cooking_recipe/stick/plump_skewer
	req_items = list(/obj/item/growable/plump_helmet=3)
	result = /obj/item/food/dish/plump_skewer
	req_lvl = 1

///******************BOWL RECIPES******************///
/datum/cooking_recipe/bowl

/datum/cooking_recipe/bowl/dwarven_salad
	req_items = list(/obj/item/growable/carrot=1, /obj/item/growable/plump_helmet=1, /obj/item/growable/turnip=1)
	result = /obj/item/food/dish/salad
	req_lvl = 2

///******************PAN RECIPES******************///
/datum/cooking_recipe/pan

/datum/cooking_recipe/pan/beer_wurst
	req_items = list(/obj/item/food/sausage=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer/cave_wheat=10)
	result = /obj/item/transfer_food/beer_wurst
	req_lvl = 5

/datum/cooking_recipe/pan/allwurst
	req_items = list(/obj/item/food/sausage/luxurious=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer/cave_wheat=10, /datum/reagent/consumable/juice/sweet_pod=10)
	result = /obj/item/transfer_food/allwurst
	req_lvl = 7

/datum/cooking_recipe/pan/beer_wurst_alternative
	req_items = list(/obj/item/food/sausage=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer/barley=10)
	result = /obj/item/transfer_food/beer_wurst
	req_lvl = 5

/datum/cooking_recipe/pan/allwurst_alternative
	req_items = list(/obj/item/food/sausage/luxurious=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer/barley=10, /datum/reagent/consumable/juice/sweet_pod=10)
	result = /obj/item/transfer_food/allwurst
	req_lvl = 7

///******************SAUSAGE RECIPES******************///
/datum/cooking_recipe/sausage

/datum/cooking_recipe/sausage/regular
	req_items = list(/obj/item/food/slice/meat=3)
	result = /obj/item/food/sausage
	req_lvl = 5

/datum/cooking_recipe/sausage/luxurious
	req_items = list(/obj/item/food/slice/meat/troll=1, /obj/item/food/slice/meat=1, /obj/item/growable/carrot=1, /obj/item/growable/plump_helmet=1, /obj/item/growable/turnip=1)
	result = /obj/item/food/sausage/luxurious
	req_lvl = 7

///Returns either null if no plausable candidates found or a recipe /datum/cooking_recipe/...
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

	// search for perfect match
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

		if(i_p == 1 && r_p == 1)
			return recipe
