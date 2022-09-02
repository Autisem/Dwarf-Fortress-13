/obj/item/sapling
	name = "sapling"
	desc = "Handle with care. Plant it ASAP otherwise it will die."
	icon = 'dwarfs/icons/items/farming.dmi'
	var/health
	var/maxhealth
	var/plant_type
	var/growthstage
	var/damagedelta = 5 SECONDS
	var/lastcycle_damage

/obj/item/sapling/Initialize()
	. = ..()
	lastcycle_damage = world.time

/obj/item/sapling/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/sapling/process(delta_time)
	if(world.time > lastcycle_damage+damagedelta)
		lastcycle_damage = world.time
		if(health == 0)
			visible_message(span_warning("[src] withers away!"))
			qdel(src)
		health = max(0, health-rand(1,3))

/obj/item/sapling/examine(mob/user)
	. = ..()
	.+="<hr>"
	switch(health/maxhealth)
		if(1)
			.+="It looks healthy."
		if(0.6 to 0.9)
			.+="It looks ill."
		if(0.3 to 0.6)
			.+="It looks very ill."
		if(0.1 to 0.3)
			.+="It looks like it's about to die!"
		else
			.+="It's dead."
