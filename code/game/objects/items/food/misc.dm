
////////////////////////////////////////////OTHER////////////////////////////////////////////

/obj/item/food/cheesewheel
	name = "cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 5) //Hard cheeses contain about 25% protein
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("сыр" = 1)
	foodtypes = DAIRY

/obj/item/food/cheesewheel/Initialize()
	. = ..()
	AddComponent(/datum/component/food_storage)

/obj/item/food/cheesewheel/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cheesewedge, 5, 30)

/obj/item/food/cheesewheel/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/baked_cheese, rand(20 SECONDS, 25 SECONDS), TRUE, TRUE)
/obj/item/food/royalcheese
	name = "royal cheese"
	desc = "Ascend the throne. Consume the wheel. Feel the POWER."
	icon_state = "royalcheese"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/gold = 20, /datum/reagent/toxin/mutagen = 5)
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("cheese" = 4, "royalty" = 1)
	foodtypes = DAIRY

/obj/item/food/cheesewedge
	name = "cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("сыр" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/watermelonslice
	name = "watermelon slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	tastes = list("арбуз" = 1)
	food_reagents = list(/datum/reagent/water = 1, /datum/reagent/consumable/nutriment/vitamin = 0.2, /datum/reagent/consumable/nutriment = 1)
	foodtypes = FRUIT
	food_flags = FOOD_FINGER_FOOD
	juice_results = list(/datum/reagent/consumable/watermelonjuice = 5)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Can be stored in a detective's hat."
	icon_state = "candy_corn"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sugar = 2)
	tastes = list("сладкий попкорн" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/candy_corn/prison
	name = "desiccated candy corn"
	desc = "If this candy corn were any harder Security would confiscate it for being a potential shiv."
	force = 1 // the description isn't lying
	throwforce = 1 // if someone manages to bust out of jail with candy corn god bless them
	tastes = list("горький воск" = 1)
	foodtypes = GROSS

/obj/item/food/chocolatebar
	name = "chocolate bar"
	desc = "Such, sweet, fattening food."
	icon_state = "chocolatebar"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2)
	tastes = list("шоколад" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("грибы" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash_type = /obj/item/trash/popcorn
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	bite_consumption = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	tastes = list("попкорн" = 3, "масло" = 1)
	foodtypes = JUNKFOOD
	eatverbs = list("кусает","надкусывает","чапает","пожирает","ест")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("картоха" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fries
	name = "space fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("картофель фри" = 3, "соль" = 1)
	foodtypes = VEGETABLES | GRAIN | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/fries/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/tatortot
	name = "tator tot"
	desc = "A large fried potato nugget that may or may not try to valid you."
	icon_state = "tatortot"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("картоха" = 3, "valids" = 1)
	foodtypes = FRIED | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tatortot/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/soydope
	name = "soy dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("соя" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("картофель фри" = 3, "сыр" = 1)
	foodtypes = VEGETABLES | GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cheesyfries/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from cook for this."
	icon_state = "badrecipe"
	food_reagents = list(/datum/reagent/toxin/bad_food = 30)
	foodtypes = GROSS
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE //Can't decompose any more than this

/obj/item/food/badrecipe/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_GRILLED, .proc/OnGrill)

/obj/item/food/badrecipe/moldy
	name = "гниль"
	desc = "Фу."
	food_reagents = list(/datum/reagent/consumable/mold = 30)
	color = "#781948"

///Prevents grilling burnt shit from well, burning.
/obj/item/food/badrecipe/proc/OnGrill()
	return COMPONENT_HANDLED_GRILLING

/obj/item/food/carrotfries
	name = "carrot fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/medicine/oculine = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("морковка" = 3, "соль" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/carrotfries/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/candiedapple
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/caramel = 5)
	tastes = list("яблоко" = 2, "карамель" = 3)
	foodtypes = JUNKFOOD | FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mint
	name = "mint"
	desc = "It is only wafer thin."
	icon_state = "mint"
	bite_consumption = 1
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/toxin/minttoxin = 2)
	foodtypes = TOXIC | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/eggwrap
	name = "egg wrap"
	desc = "The precursor to Pigs in a Blanket."
	icon_state = "eggwrap"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("яйцо" = 1)
	foodtypes = MEAT | GRAIN
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/spidereggs
	name = "spider eggs"
	desc = "A cluster of juicy spider eggs. A great side dish for when you care not for your health."
	icon_state = "spidereggs"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/toxin = 2)
	tastes = list("паутина" = 1)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/spiderling
	name = "spiderling"
	desc = "It's slightly twitching in your hand. Ew..."
	icon_state = "spiderling"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/toxin = 4)
	tastes = list("паутина" = 1, "кишочки" = 2)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/chewable/spiderlollipop
	name = "spider lollipop"
	desc = "Still gross, but at least it has a mountain of sugar on it."
	icon_state = "spiderlollipop"
	worn_icon_state = "lollipop_stick"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/toxin = 1, /datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/omnizine = 2) //lollipop, but vitamins = toxins
	tastes = list("паутина" = 1, "сахар" = 2)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK

/obj/item/food/chococoin
	name = "chocolate coin"
	desc = "A completely edible but nonflippable festive coin."
	icon_state = "chococoin"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/coco = 1, /datum/reagent/consumable/sugar = 1)
	tastes = list("шоколад" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fudgedice
	name = "fudge dice"
	desc = "A little cube of chocolate that tends to have a less intense taste if you eat too many at once."
	icon_state = "chocodice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/coco = 1, /datum/reagent/consumable/sugar = 1)
	trash_type = /obj/item/dice/fudge
	tastes = list("помадка" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/chocoorange
	name = "chocolate orange"
	desc = "A festive chocolate orange."
	icon_state = "chocoorange"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 1)
	tastes = list("шоколад" = 3, "апельсины" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("баклажан" = 3, "сыр" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tortilla
	name = "tortilla"
	desc = "The base for all your burritos."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "tortilla"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("плоская маисовая лепешка" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/burrito
	name = "burrito"
	desc = "Tortilla wrapped goodness."
	icon_state = "burrito"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2,/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("плоская маисовая лепешка" = 2, "мясо" = 3)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/cheesyburrito
	name = "cheesy burrito"
	desc = "It's a burrito filled with cheese."
	icon_state = "cheesyburrito"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("плоская маисовая лепешка" = 2, "мясо" = 3, "сыр" = 1)
	foodtypes = GRAIN | MEAT | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/carneburrito
	name = "carne asada burrito"
	desc = "The best burrito for meat lovers."
	icon_state = "carneburrito"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("плоская маисовая лепешка" = 2, "мясо" = 4)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/fuegoburrito
	name = "fuego plasma burrito"
	desc = "A super spicy burrito."
	icon_state = "fuegoburrito"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/capsaicin = 5, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("плоская маисовая лепешка" = 2, "мясо" = 3, "перцы" = 1)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_LEGENDARY

/obj/item/food/yakiimo
	name = "yaki imo"
	desc = "Made with roasted sweet potatoes!"
	icon_state = "yakiimo"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("сладкая картоха" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/roastparsnip
	name = "roast parsnip"
	desc = "Sweet and crunchy."
	icon_state = "roastparsnip"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пастернак" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/melonfruitbowl
	name = "melon fruit bowl"
	desc = "For people who wants edible fruit bowls."
	icon_state = "melonfruitbowl"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("арбуз" = 1)
	foodtypes = FRUIT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/nachos
	name = "nachos"
	desc = "Chips from Space Mexico."
	icon_state = "nachos"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("начос" = 1)
	foodtypes = VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cheesynachos
	name = "cheesy nachos"
	desc = "The delicious combination of nachos and melting cheese."
	icon_state = "cheesynachos"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("начос" = 2, "сыр" = 1)
	foodtypes = VEGETABLES | FRIED | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/cubannachos
	name = "Cuban nachos"
	desc = "That's some dangerously spicy nachos."
	icon_state = "cubannachos"
	food_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/capsaicin = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("начос" = 2, "перец" = 1)
	foodtypes = VEGETABLES | FRIED | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/melonkeg
	name = "melon keg"
	desc = "Who knew vodka was a fruit?"
	icon_state = "melonkeg"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/ethanol/vodka = 15, /datum/reagent/consumable/nutriment/vitamin = 4)
	max_volume = 80
	bite_consumption = 5
	tastes = list("зерновой спирт" = 1, "фрукты" = 1)
	foodtypes = FRUIT | ALCOHOL

/obj/item/food/honeybar
	name = "honey nut bar"
	desc = "Oats and nuts compressed together into a bar, held together with a honey glaze."
	icon_state = "honeybar"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/honey = 5)
	tastes = list("овес" = 3, "орешки" = 2, "мед" = 1)
	foodtypes = GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/stuffedlegion
	name = "stuffed legion"
	desc = "The former skull of a damned human, filled with goliath meat. It has a decorative lava pool made of ketchup and hotsauce."
	icon_state = "stuffed_legion"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/capsaicin = 2)
	tastes = list("смерть" = 2, "камни" = 1, "мясо" = 1, "перцы" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_LEGENDARY

/obj/item/food/powercrepe
	name = "Powercrepe"
	desc = "With great power, comes great crepes. It looks like a pancake filled with jelly but packs quite a punch."
	icon_state = "powercrepe"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/cherryjelly = 5)
	force = 30
	throwforce = 15
	block_chance = 55
	armor_penetration = 80
	wound_bonus = -50
	attack_verb_continuous = list("шлёпает", "рубит")
	attack_verb_simple = list("шлёпает", "рубит")
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("вишня" = 1, "креп" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

///Shit typepath to allow you to suck on shit. Like the coder of this code probably did to penis.
/obj/item/food/chewable
	slot_flags = ITEM_SLOT_MASK
	///How long it lasts before being deleted in seconds
	var/succ_dur = 360
	///The delay between each time it will handle reagents
	var/succ_int = 100
	///Stores the time set for the next handle_reagents
	var/next_succ = 0

	//makes snacks actually wearable as masks and still edible the old-fashioned way.
/obj/item/food/chewable/proc/handle_reagents()
	if(reagents.total_volume)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if (src == C.wear_mask) // if it's in the human/monkey mouth, transfer reagents to the mob
				if(!reagents.trans_to(C, REAGENTS_METABOLISM, methods = INGEST))
					reagents.remove_any(REAGENTS_METABOLISM)
				return
		reagents.remove_any(REAGENTS_METABOLISM)

/obj/item/food/chewable/process(delta_time)
	if(iscarbon(loc))
		if(succ_dur <= 0)
			qdel(src)
			return
		succ_dur -= delta_time
		if((reagents?.total_volume) && (next_succ <= world.time))
			handle_reagents()
			next_succ = world.time + succ_int

/obj/item/food/chewable/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_MASK)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/food/chewable/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/food/chewable/lollipop
	name = "lollipop"
	desc = "A delicious lollipop. Makes for a great Valentine's present."
	icon = 'icons/obj/lollipop.dmi'
	icon_state = "lollipop_stick"
	inhand_icon_state = "lollipop_stick"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/omnizine = 2)	//Honk
	var/mutable_appearance/head
	var/headcolor = rgb(0, 0, 0)
	tastes = list("конфета" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/chewable/lollipop/Initialize()
	. = ..()
	head = mutable_appearance('icons/obj/lollipop.dmi', "lollipop_head")
	change_head_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))

/obj/item/food/chewable/lollipop/proc/change_head_color(C)
	headcolor = C
	cut_overlay(head)
	head.color = C
	add_overlay(head)

/obj/item/food/chewable/lollipop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..(hit_atom)
	throw_speed = 1
	throwforce = 0

/obj/item/food/chewable/lollipop/cyborg
	var/spamchecking = TRUE

/obj/item/food/chewable/lollipop/cyborg/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/spamcheck), 1200)

/obj/item/food/chewable/lollipop/cyborg/equipped(mob/living/user, slot)
	. = ..(user, slot)
	spamchecking = FALSE

/obj/item/food/chewable/lollipop/cyborg/proc/spamcheck()
	if(spamchecking)
		qdel(src)

/obj/item/food/chewable/bubblegum
	name = "bubblegum"
	desc = "A rubbery strip of gum. Not exactly filling, but it keeps you busy."
	icon_state = "bubblegum"
	inhand_icon_state = "bubblegum"
	color = "#E48AB5" // craftable custom gums someday?
	food_reagents = list(/datum/reagent/consumable/sugar = 5)
	tastes = list("конфета" = 1)
	succ_dur = 15 * 60
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/chewable/bubblegum/nicotine
	name = "nicotine gum"
	food_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/consumable/menthol = 5)
	tastes = list("мята" = 1)
	color = "#60A584"

/obj/item/food/chewable/bubblegum/happiness
	name = "HP+ gum"
	desc = "A rubbery strip of gum. It smells funny."
	food_reagents = list(/datum/reagent/drug/happiness = 15)
	tastes = list("растворитель" = 1)
	color = "#EE35FF"

/obj/item/food/chewable/bubblegum/bubblegum
	name = "bubblegum gum"
	desc = "A rubbery strip of gum. You don't feel like eating it is a good idea."
	color = "#913D3D"
	food_reagents = list(/datum/reagent/blood = 15)
	tastes = list("ад" = 1)
	succ_dur = 6 * 60

/obj/item/food/chewable/bubblegum/bubblegum/process()
	. = ..()
	if(iscarbon(loc))
		hallucinate(loc)

/obj/item/food/chewable/bubblegum/bubblegum/MakeEdible()
	AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				eatverbs = eatverbs,\
				bite_consumption = bite_consumption,\
				microwaved_type = microwaved_type,\
				junkiness = junkiness,\
				on_consume = CALLBACK(src, .proc/OnConsume))

/obj/item/food/chewable/bubblegum/bubblegum/proc/OnConsume(mob/living/eater, mob/living/feeder)
	if(iscarbon(eater))
		hallucinate(eater)

///This proc has a 5% chance to have a bubblegum line appear, with an 85% chance for just text and 15% for a bubblegum hallucination and scarier text.
/obj/item/food/chewable/bubblegum/bubblegum/proc/hallucinate(mob/living/carbon/victim)
	if(!prob(5)) //cursed by bubblegum
		return
	if(prob(15))
		new /datum/hallucination/oh_yeah(victim)
		to_chat(victim, span_colossus("<b>[pick("I AM IMMORTAL.","I SHALL TAKE YOUR WORLD.","I SEE YOU.","YOU CANNOT ESCAPE ME FOREVER.","NOTHING CAN HOLD ME.")]</b>"))
	else
		to_chat(victim, span_warning("[pick("You hear faint whispers.","You smell ash.","You feel hot.","You hear a roar in the distance.")]"))

/obj/item/food/chewable/gumball
	name = "gumball"
	desc = "A colorful, sugary gumball."
	icon = 'icons/obj/lollipop.dmi'
	icon_state = "gumball"
	worn_icon_state = "bubblegum"
	food_reagents = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/sal_acid = 2, /datum/reagent/medicine/oxandrolone = 2)	//Kek
	tastes = list("конфета")
	foodtypes = JUNKFOOD
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/chewable/gumball/Initialize()
	. = ..()
	color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))

/obj/item/food/chewable/gumball/cyborg
	var/spamchecking = TRUE

/obj/item/food/chewable/gumball/cyborg/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/spamcheck), 1200)

/obj/item/food/chewable/gumball/cyborg/equipped(mob/living/user, slot)
	. = ..(user, slot)
	spamchecking = FALSE

/obj/item/food/chewable/gumball/cyborg/proc/spamcheck()
	if(spamchecking)
		qdel(src)

/obj/item/food/taco
	name = "classic taco"
	desc = "A traditional taco with meat, cheese, and lettuce."
	icon_state = "taco"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("тако" = 4, "мясо" = 2, "сыр" = 2, "салат" = 1)
	foodtypes = MEAT | DAIRY | GRAIN | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/taco/plain
	name = "plain taco"
	desc = "A traditional taco with meat and cheese, minus the rabbit food."
	icon_state = "taco_plain"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("тако" = 4, "мясо" = 2, "сыр" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/branrequests
	name = "Bran Requests Cereal"
	desc = "A dry cereal that satiates your requests for bran. Tastes uniquely like raisins and salt."
	icon_state = "bran_requests"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/salt = 8)
	tastes = list("отруби" = 4, "причинычи" = 3, "соль" = 1)
	foodtypes = GRAIN | FRUIT | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butter
	name = "stick of butter"
	desc = "A stick of delicious, golden, fatty goodness."
	icon_state = "butter"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("масло" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butter/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>If you had a rod you could make <b>butter on a stick</b>.</span>"

/obj/item/food/butter/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		if(!R.use(1))//borgs can still fail this if they have no metal
			to_chat(user, span_warning("You do not have enough iron to put [src] on a stick!"))
			return ..()
		to_chat(user, span_notice("You stick the rod into the stick of butter."))
		var/obj/item/food/butter/on_a_stick/new_item = new(usr.loc)
		var/replace = (user.get_inactive_held_item() == R)
		if(!R && replace)
			user.put_in_hands(new_item)
		qdel(src)
		return TRUE
	..()

/obj/item/food/butter/on_a_stick //there's something so special about putting it on a stick.
	name = "butter on a stick"
	desc = "delicious, golden, fatty goodness on a stick."
	icon_state = "butteronastick"
	trash_type = /obj/item/stack/rods
	food_flags = FOOD_FINGER_FOOD

/obj/item/food/onionrings
	name = "onion rings"
	desc = "Onion slices coated in batter."
	icon_state = "onionrings"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	gender = PLURAL
	tastes = list("кляр" = 3, "лук" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/pineappleslice
	name = "pineapple slice"
	desc = "A sliced piece of juicy pineapple."
	icon_state = "pineapple_slice"
	juice_results = list(/datum/reagent/consumable/pineapplejuice = 3)
	tastes = list("ананас" = 1)
	foodtypes = FRUIT | PINEAPPLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/tinychocolate
	name = "chocolate"
	desc = "A tiny and sweet chocolate."
	icon_state = "tiny_chocolate"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/coco = 1)
	tastes = list("шоколад" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/canned
	name = "Canned Air"
	desc = "If you ever wondered where air came from..."
	food_reagents = list(/datum/reagent/oxygen = 6, /datum/reagent/nitrogen = 24)
	icon = 'icons/obj/food/canned.dmi'
	icon_state = "peachcan"
	food_flags = FOOD_IN_CONTAINER
	w_class = WEIGHT_CLASS_NORMAL
	max_volume = 30
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE


/obj/item/food/canned/proc/open_can(mob/user)
	to_chat(user, span_notice("You pull back the tab of <b>[src.name]</b>."))
	playsound(user.loc, 'sound/items/foodcanopen.ogg', 50)
	reagents.flags |= OPENCONTAINER
	preserved_food = FALSE
	MakeDecompose()

/obj/item/food/canned/attack_self(mob/user)
	if(!is_drainable())
		open_can(user)
		icon_state = "[icon_state]_open"
	return ..()

/obj/item/food/canned/attack(mob/living/M, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, span_warning("[capitalize(src.name)] lid hasn't been opened!"))
		return FALSE
	return ..()

/obj/item/food/canned/beans
	name = "tin of beans"
	desc = "Musical fruit in a slightly less musical container."
	icon_state = "beans"
	trash_type = /obj/item/trash/can/food/beans
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 9, /datum/reagent/consumable/ketchup = 4)
	tastes = list("бобы" = 1)
	foodtypes = VEGETABLES

/obj/item/food/canned/peaches
	name = "canned peaches"
	desc = "Just a nice can of ripe peaches swimming in their own juices."
	icon_state = "peachcan"
	trash_type = /obj/item/trash/can/food/peaches
	food_reagents = list(/datum/reagent/consumable/peachjuice = 20, /datum/reagent/consumable/sugar = 8, /datum/reagent/consumable/nutriment = 2)
	tastes = list("персики" = 7, "олово" = 1)
	foodtypes = FRUIT | SUGAR

/obj/item/food/canned/peaches/maint
	name = "Maintenance Peaches"
	desc = "I have a mouth and I must eat."
	icon_state = "peachcanmaint"
	trash_type = /obj/item/trash/can/food/peaches/maint
	tastes = list("персики" = 1, "олово" = 7)

/obj/item/food/canned/tomatoes
	name = "canned San Marzano tomatoes"
	desc = "A can of premium San Marzano tomatoes, from the hills of Southern Italy."
	icon_state = "tomatoescan"
	trash_type = /obj/item/trash/can/food/tomatoes
	food_reagents = list(/datum/reagent/consumable/tomatojuice = 20, /datum/reagent/consumable/salt = 2)
	tastes = list("tomato" = 7, "tin" = 1)
	foodtypes = VEGETABLES //fuck you, real life!

/obj/item/food/canned/pine_nuts
	name = "canned pine nuts"
	desc = "A small can of pine nuts. Can be eaten on their own, if you're into that."
	icon_state = "pinenutscan"
	trash_type = /obj/item/trash/can/food/pine_nuts
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("pine nuts" = 1)
	foodtypes = NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/crab_rangoon
	name = "Crab Rangoon"
	desc = "Has many names, like crab puffs, cheese won'tons, crab dumplings? Whatever you call them, they're a fabulous blast of cream cheesy crab."
	icon_state = "crabrangoon"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/nutriment/vitamin = 5)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("сливочный сыр" = 4, "краб" = 3, "хрупкость" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cornchips
	name = "boritos corn chips"
	desc = "Triangular corn chips. They do seem a bit bland but would probably go well with some kind of dipping sauce."
	icon_state = "boritos"
	trash_type = /obj/item/trash/boritos
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/cooking_oil = 2, /datum/reagent/consumable/salt = 3)
	junkiness = 20
	tastes = list("жареная кукуруза" = 1)
	foodtypes = JUNKFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cornchips/MakeLeaveTrash()
	if(trash_type)
		AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)


/obj/item/food/rationpack
	name = "ration pack"
	desc = "A square bar that sadly <i>looks</i> like chocolate, packaged in a nondescript grey wrapper. Has saved soldiers' lives before - usually by stopping bullets."
	icon_state = "rationpack"
	bite_consumption = 3
	junkiness = 15
	tastes = list("cardboard" = 3, "sadness" = 3)
	foodtypes = null //Don't ask what went into them. You're better off not knowing.
	food_reagents = list(/datum/reagent/consumable/nutriment/stabilized = 10, /datum/reagent/consumable/nutriment = 2) //Won't make you fat. Will make you question your sanity.

///Override for checkliked callback
/obj/item/food/rationpack/MakeEdible()
	AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				eatverbs = eatverbs,\
				bite_consumption = bite_consumption,\
				microwaved_type = microwaved_type,\
				junkiness = junkiness,\
				check_liked = CALLBACK(src, .proc/check_liked))

/obj/item/food/rationpack/proc/check_liked(fraction, mob/M)	//Nobody likes rationpacks. Nobody.
	return FOOD_DISLIKED

/obj/item/food/ant_candy
	name = "ant candy"
	desc = "A colony of ants suspended in hardened sugar. Those things are dead, right?"
	icon_state = "ant_pop"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/sugar = 5, /datum/reagent/ants = 3)
	tastes = list("candy" = 1, "insects" = 1)
	foodtypes = JUNKFOOD | SUGAR | GROSS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

//Curd cheese, a general term which I will now proceed to stretch as thin as the toppings on a supermarket sandwich:
//I'll use it as a substitute for ricotta, cottage cheese and quark, as well as any other non-aged, soft grainy cheese
/obj/item/food/curd_cheese
	name = "curd cheese"
	desc = "Known by many names throughout human cuisine, curd cheese is useful for a wide variety of dishes."
	icon_state = "curd_cheese"
	microwaved_type = /obj/item/food/cheese_curds
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/cream = 1)
	tastes = list("cream" = 1, "cheese" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheese_curds
	name = "cheese curds"
	desc = "Not to be mistaken for curd cheese. Tasty deep fried."
	icon_state = "cheese_curds"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("cheese" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheese_curds/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable,  /obj/item/food/firm_cheese)

/obj/item/food/firm_cheese
	name = "firm cheese"
	desc = "Firm aged cheese, similar in texture to firm tofu. Due to its lack of moisture it's particularly useful for cooking with, as it doesn't melt easily."
	icon_state = "firm_cheese"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("aged cheese" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/firm_cheese/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/firm_cheese_slice, 3, 30)

/obj/item/food/firm_cheese_slice
	name = "firm cheese slice"
	desc = "A slice of firm cheese. Perfect for grilling or making into delicious pesto."
	icon_state = "firm_cheese_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("aged cheese" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/firm_cheese_slice/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_cheese, rand(25 SECONDS, 35 SECONDS), TRUE, TRUE)

/obj/item/food/mozzarella
	name = "mozzarella cheese"
	desc = "Delicious, creamy, and cheesy, all in one simple package."
	icon_state = "mozzarella"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("mozzarella" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/griddle_toast
	name = "griddle toast"
	desc = "Thick cut bread, griddled to perfection."
	icon_state = "griddle_toast"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("toast" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/pesto
	name = "pesto"
	desc = "A combination of firm cheese, salt, herbs, garlic, oil, and pine nuts. Frequently used as a sauce for pasta or pizza, or eaten on bread."
	icon_state = "pesto"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("pesto" = 1)
	foodtypes = VEGETABLES | DAIRY | NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tomato_sauce
	name = "tomato sauce"
	desc = "Tomato sauce, perfect for pizza or pasta. Mamma mia!"
	icon_state = "tomato_sauce"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("tomato" = 1, "herbs" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bechamel_sauce
	name = "béchamel sauce"
	desc = "A classic white sauce common to several European cultures."
	icon_state = "bechamel_sauce"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("cream" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/roasted_bell_pepper
	name = "roasted bell pepper"
	desc = "A blackened, blistered bell pepper. Great for making sauces."
	icon_state = "roasted_bell_pepper"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/char = 1)
	tastes = list("bell pepper" = 1, "char" = 1)
	foodtypes = VEGETABLES
	burns_in_oven = TRUE

//DONK DINNER: THE INNOVATIVE WAY TO GET YOUR DAILY RECOMMENDED ALLOWANCE OF SALT... AND THEN SOME!
/obj/item/food/ready_donk
	name = "\improper Ready-Donk: Bachelor Chow"
	desc = "A quick Donk-dinner: now with flavour!"
	icon_state = "ready_donk"
	trash_type = /obj/item/trash/ready_donk
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	microwaved_type = /obj/item/food/ready_donk/warm
	tastes = list("food?" = 2, "laziness" = 1)
	foodtypes = MEAT | JUNKFOOD
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/ready_donk/examine_more(mob/user)
	var/list/msg = list(span_notice("<i>You browse the back of the box...</i>"))
	msg += "\t[span_info("Ready-Donk: a product of Donk Co.")]"
	msg += "\t[span_info("Heating instructions: open box and pierce film, heat in microwave on high for 2 minutes. Allow to stand for 60 seconds prior to eating. Product will be hot.")]"
	msg += "\t[span_info("Per 200g serving contains: 8g Sodium; 25g Fat, of which 22g are saturated; 2g Sugar.")]"
	return msg

/obj/item/food/ready_donk/warm
	name = "warm Ready-Donk: Bachelor Chow"
	desc = "A quick Donk-dinner, now with flavour! And it's even hot!"
	icon_state = "ready_donk_warm"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/omnizine = 3)
	microwaved_type = null
	tastes = list("food?" = 2, "laziness" = 1)

/obj/item/food/ready_donk/mac_n_cheese
	name = "\improper Ready-Donk: Donk-a-Roni"
	desc = "Neon-orange mac n' cheese in seconds!"
	microwaved_type = /obj/item/food/ready_donk/warm/mac_n_cheese
	tastes = list("cheesy pasta" = 2, "laziness" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD

/obj/item/food/ready_donk/warm/mac_n_cheese
	name = "warm Ready-Donk: Donk-a-Roni"
	desc = "Neon-orange mac n' cheese, ready to eat!"
	icon_state = "ready_donk_warm_mac"
	tastes = list("cheesy pasta" = 2, "laziness" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD

/obj/item/food/ready_donk/donkhiladas
	name = "\improper Ready-Donk: Donkhiladas"
	desc = "Donk Co's signature Donkhiladas with Donk sauce, for an 'authentic' taste of Mexico."
	microwaved_type = /obj/item/food/ready_donk/warm/donkhiladas
	tastes = list("enchiladas" = 2, "laziness" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | VEGETABLES | JUNKFOOD

/obj/item/food/ready_donk/warm/donkhiladas
	name = "warm Ready-Donk: Donkhiladas"
	desc = "Donk Co's signature Donkhiladas with Donk sauce, served as hot as the Mexican sun."
	icon_state = "ready_donk_warm_mex"
	tastes = list("enchiladas" = 2, "laziness" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | VEGETABLES | JUNKFOOD
