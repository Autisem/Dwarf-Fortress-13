/obj/structure/forge
	name = "forge"
	desc = "Heats up various things, sometimes even ingots."
	icon = 'white/kacherkin/icons/dwarfs/obj/forge.dmi'
	icon_state = "forge_on"
	light_range = 9
	light_color = "#BB661E"
	density = TRUE
	anchored = TRUE
	var/fuel = 180
	var/fuel_consumption = 1
	var/list/fuel_values = list(/obj/item/stack/sheet/mineral/coal = 15, /obj/item/stack/sheet/mineral/wood = 10)
	var/busy_heating = FALSE

/obj/structure/forge/Initialize(mapload)
	. = ..()
	flick("forge_start", src)
	START_PROCESSING(SSprocessing, src)

/obj/structure/forge/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/forge/process(delta_time)
	if(fuel >= fuel_consumption)
		fuel-=fuel_consumption
	else
		fuel = 0
		if(icon_state != "forge_off")
			icon_state = "forge_off"
			flick("forge_shutdown", src)

/obj/structure/forge/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(I.type in fuel_values)
		var/obj/item/stack/S = I
		src.visible_message(span_notice("[user] throws [S] into [src]."), span_notice("You throw [S] into [src]."))
		fuel+=S.amount*fuel_values[I.type]
		qdel(S)
		if(icon_state != "forge_on")
			icon_state = "forge_on"
			flick("forge_start", src)
	else if(istype(I, /obj/item/blacksmith/tongs))
		if(I.contents.len)
			if(!fuel)
				to_chat(user, span_warning("No fuel."))
				return
			if(istype(I.contents[I.contents.len], /obj/item/blacksmith/ingot))
				if(!busy_heating)
					busy_heating = TRUE
					if(do_after(user, 10, src))
						var/obj/item/blacksmith/ingot/N = I.contents[I.contents.len]
						N.heattemp = 350
						I.icon_state = "tongs_hot"
						to_chat(user, span_notice("You heat up [N]."))
					busy_heating = FALSE
		else
			to_chat(user, span_warning("Are you retarded?"))
			return

/obj/structure/furnace
	name = "smelter"
	desc = "Looks weird, probably useless."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 0
	light_color = "#BB661E"
	var/furnacing = FALSE
	var/furnacing_type = "iron"

/obj/structure/furnace/proc/furnaced_thing()
	icon_state = "furnace"
	furnacing = FALSE
	light_range = 0

	switch(furnacing_type)
		if("iron")
			new /obj/item/blacksmith/ingot(drop_location())
		if("gold")
			new /obj/item/blacksmith/ingot/gold(drop_location())
		if("glass")
			new /obj/item/stack/sheet/glass/five(drop_location())

/obj/structure/furnace/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(furnacing)
		to_chat(user, span_alert("[src] is already smelting."))
		return

	if(istype(I, /obj/item/stack/ore/iron) || istype(I, /obj/item/stack/ore/gold) || istype(I, /obj/item/stack/sheet/iron) || istype(I, /obj/item/stack/ore/glass))
		var/obj/item/stack/S = I
		if(S.amount >= 5)
			S.use(5)
			furnacing = TRUE
			icon_state = "furnace_on"
			light_range = 3
			to_chat(user, span_notice("[src] lights up."))
			if(istype(I, /obj/item/stack/ore/gold))
				furnacing_type = "gold"
			else if(istype(I, /obj/item/stack/ore/glass))
				furnacing_type = "glass"
			else
				furnacing_type = "iron"
			addtimer(CALLBACK(src, .proc/furnaced_thing), 15 SECONDS)
		else
			to_chat(user, "<span class=\"alert\">You need at least 5 pieces.</span>")

/obj/structure/anvil
	name = "anvil"
	desc = "Hit it really hard."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "anvil"
	density = TRUE
	var/acd = FALSE
	var/obj/item/blacksmith/ingot/current_ingot = null
	var/list/allowed_things = list()

/obj/structure/anvil/Topic(href, list/href_list)
	. = ..()
	if(.)
		return .
	if(!usr.is_holding_item_of_type(/obj/item/blacksmith/smithing_hammer)||!(usr in view(1, src)))
		usr<<browse(null, "window=Anvil")
		return
	if(href_list["hit"])
		hit(usr)
	if(href_list["miss"])
		miss(usr)

/obj/structure/anvil/proc/hit(mob/user)
	var/mob/living/carbon/human/H = user
	if(current_ingot.progress_current == current_ingot.progress_need)
		current_ingot.progress_current++
		playsound(src, 'white/valtos/sounds/anvil_hit.ogg', 70, TRUE)
		to_chat(user, span_notice("[current_ingot] is ready. Hit it again to keep smithing or cool it down."))
		user<<browse(null, "window=Anvil")
		return
	else
		playsound(src, 'white/valtos/sounds/anvil_hit.ogg', 70, TRUE)
		user.visible_message(span_notice("<b>[user]</b> hits \the anvil with \a hammer.") , \
						span_notice("You hit \the anvil with \a hammer."))
		current_ingot.progress_current++
		H.adjustStaminaLoss(rand(1, 5))
		H.mind.adjust_experience(/datum/skill/smithing, rand(0, 4) * current_ingot.mod_grade)
		return

/obj/structure/anvil/proc/miss(mob/user)
	// var/mob/living/carbon/human/H = user
	current_ingot.durability--
	if(current_ingot.durability == 0)
		to_chat(user, span_warning("the ingot crumbles into countless metal pieces..."))
		current_ingot = null
		LAZYCLEARLIST(contents)
		icon_state = "[initial(icon_state)]"
		user<<browse(null, "window=Anvil")
	playsound(src, 'white/valtos/sounds/anvil_hit.ogg', 70, TRUE)
	user.visible_message(span_warning("<b>[user]</b> hits \the anvil with \a hammer incorrectly.") , \
						span_warning("You hit \the anvil with \a hammer incorrectly."))
	return

/obj/structure/anvil/fullsteel
	name = "heavy anvil"
	desc = "Can't move."
	icon = 'white/kacherkin/icons/dwarfs/obj/objects.dmi'
	icon_state = "old_anvil_full"

/obj/structure/anvil/Initialize()
	. = ..()
	for(var/item in subtypesof(/datum/smithing_recipe))
		var/datum/smithing_recipe/SR = new item()
		allowed_things += SR

/obj/structure/anvil/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(acd)
		return

	if(!ishuman(user))
		to_chat(user, span_warning("My hands are too weak to do this!"))
		return

	var/mob/living/carbon/human/H = user

	acd = TRUE
	addtimer(VARSET_CALLBACK(src, acd, FALSE), H.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER) SECONDS)

	if(istype(I, /obj/item/blacksmith/smithing_hammer))
		var/obj/item/blacksmith/smithing_hammer/hammer = I
		if(current_ingot)
			if(current_ingot.heattemp <= 0)
				icon_state = "[initial(icon_state)]_cold"
				to_chat(user, span_warning("\the [current_ingot] is to cold too keep working."))
				return
			if(current_ingot.recipe)
				var/height = 30
				var/dat = {"<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Наковальня</title>
    <style>* { padding: 0; margin: 0; } canvas { background: #eee; display: block; margin: 0 auto; }</style>
</head>
<body>
<div>
<canvas id="myCanvas" width="300" height="62" style="left: 50%;"></canvas>
<button onclick="ClickButton()" style="transform: translate(-50%);left: 50%;position: relative;">Hit</button>
</div>
<script>
    function ClickButton(){
        let c = collision()
        if(c && !cooldown){
            score++;
            cooldownlast=0;
            cooldown=true;
			window.location = ("byond://?src=[REF(src)];hit=1")
        }
        else if (!c && !cooldown){
            cooldownlast=0;
            cooldown=true;
			window.location = ("byond://?src=[REF(src)];miss=1")
        }
    }

    let canvas = document.getElementById("myCanvas");
    let ctx = canvas.getContext("2d");
    let linewidth = 1
    let x = 0
	let speed = [1+current_ingot.mod_grade];
    let right = true;
    let cooldown = false;
    let cooldownlast = 0
    let score = 0;
    let fieldwidth = [20+H.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SMITHING_MODIFIER)+hammer.level*3];
    let fx1 = 50
    let fx2 = 250-fieldwidth
    let cooldown_m = 30;


    function collision() {
        return ((x>fx1)&&(x<(fx1+fieldwidth))||(x>(fx2))&&(x<(fx2+fieldwidth)))
    }

    function drawfield(){
        ctx.beginPath();
        ctx.rect(fx1, 32, fieldwidth, 30);
        ctx.fillStyle = "red";
        ctx.opacity = 0.1
        ctx.fill();
        ctx.closePath();

        ctx.beginPath();
        ctx.rect(fx2, 32, fieldwidth, 30);
        ctx.fillStyle = "red";
        ctx.opacity = 0.1
        ctx.fill();
        ctx.closePath();
    }

    function drawline(){
        ctx.beginPath();
        ctx.rect(x, 32, linewidth, 30);
        ctx.fillStyle = "blue";
        ctx.fill();
        ctx.closePath();
    }

    function drawScore() {
        ctx.font = "16px Arial";
        ctx.fillStyle = "#0095DD";
        ctx.fillText("Ударов: "+score, 115, 20);
    }

    function checkcooldown(){
        // console.log(cooldownlast)
        if(cooldownlast>cooldown_m){
            cooldown = false;
        }
        else{
            cooldown = true;
        }
    }
	function drawSep(){
        ctx.beginPath();
        ctx.rect(0, 30, canvas.width, 2);
        ctx.fillStyle = "black";
        ctx.fill();
        ctx.closePath();
    }

    function draw() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        drawfield();
        drawline();
        drawScore();
		drawSep();
        // console.log(x)
        checkcooldown()
        cooldownlast+=speed;
        if(right && x<canvas.width){
            x+=speed;
        }
        else if(right && x>=canvas.width){
            right = !right
        }
        if(!right && x>0){
            x-=speed;
        }
        else if(!right && x<=0){
            right = !right
        }

        requestAnimationFrame(draw);
    }

    draw()


</script>
</body>
</html>"}
				if(current_ingot.progress_current <= current_ingot.progress_need)
					var/datum/browser/popup = new(user, "Anvil", "Anvil", 500, height+120)
					popup.set_content(dat)
					popup.open()
					return
				if(current_ingot.progress_current > current_ingot.progress_need)
					current_ingot.progress_current = 0
					current_ingot.mod_grade++
					current_ingot.progress_need = round(current_ingot.progress_need * 1.1)
					playsound(src, 'white/valtos/sounds/anvil_hit.ogg', 70, TRUE)
					to_chat(user, span_notice("You begin to upgrade \the [current_ingot]."))
					return
			else
				var/list/metal_allowed_list = list()
				for(var/datum/smithing_recipe/SR in allowed_things)
					if(SR.metal_type_need == current_ingot.type_metal)
						metal_allowed_list += SR
				var/datum/smithing_recipe/sel_recipe = input("Choose:", "What to forge?", null, null) as null|anything in metal_allowed_list
				if(!sel_recipe)
					to_chat(user, span_warning("You did not decide what to forge yet."))
					return
				if(current_ingot.recipe)
					to_chat(user, span_warning("Too late to change your mind."))
					return
				current_ingot.recipe = new sel_recipe.type()
				current_ingot.recipe.max_resulting = H.mind.get_skill_modifier(/datum/skill/smithing, SKILL_RANDS_MODIFIER)
				playsound(src, 'white/valtos/sounds/anvil_hit.ogg', 70, TRUE)
				to_chat(user, span_notice("You begin to forge..."))
				return
		else
			to_chat(user, span_warning("Nothing to forge here."))
			return

	if(istype(I, /obj/item/blacksmith/tongs))
		if(current_ingot)
			if(I.contents.len)
				to_chat(user, span_warning("You are already holding something!"))
				return
			else
				if(current_ingot.heattemp > 0)
					I.icon_state = "tongs_hot"
				else
					I.icon_state = "tongs_cold"
				current_ingot.forceMove(I)
				current_ingot = null
				icon_state = "[initial(icon_state)]"
				to_chat(user, span_notice("You grab the ingot with \the [I]."))
				return
		else
			if(I.contents.len)
				if(current_ingot)
					to_chat(user, span_warning("You are already holding \a [current_ingot]."))
					return
				var/obj/item/blacksmith/ingot/N = I.contents[I.contents.len]
				if(N.heattemp > 0)
					icon_state = "[initial(icon_state)]_hot"
				else
					icon_state = "[initial(icon_state)]_cold"
				N.forceMove(src)
				current_ingot = N
				I.icon_state = "tongs"
				to_chat(user, span_notice("You place \the [current_ingot] onto \the [src]."))
				return
			else
				to_chat(user, span_warning("Nothing to grab with [I]."))
				return
	return ..()
