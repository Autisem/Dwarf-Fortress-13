/obj/item/sapling
	name = "sapling"
	desc = "Handle with care. Plant it ASAP otherwise it will die."
	var/health
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
