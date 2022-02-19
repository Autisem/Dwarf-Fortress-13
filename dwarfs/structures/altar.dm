/obj/structure/dwarf_altar
	name = "Алтарь"
	desc = "Руны оо мм ммм."
	icon = 'white/rashcat/icons/dwarfs/objects/altar.dmi'
	icon_state = "altar_inactive"
	density = TRUE
	anchored = TRUE
	layer = FLY_LAYER
	var/busy = FALSE
	var/active = FALSE
	var/resources = 0
	var/list/available_rituals = list(/datum/ritual/summon_tools,/datum/ritual/summon_frog,/datum/ritual/summon_dwarf,/datum/ritual/summon_seeds)
	var/list/allowed_resources = list(/obj/item/blacksmith/ingot/gold=25,
									/obj/item/gem/cut/diamond=50,
									/obj/item/gem/cut/ruby=40,
									/obj/item/gem/cut/saphire=30,
									)

/obj/structure/dwarf_altar/Initialize()
	. = ..()
	set_light(1)

/obj/structure/dwarf_altar/proc/activate()
	icon_state = "altar_active"

/obj/structure/dwarf_altar/attack_ghost(mob/user)
	summon_dwarf(user)

/obj/structure/dwarf_altar/proc/summon_dwarf(mob/user)
	if(!active)
		return FALSE
	var/dwarf_ask = tgui_alert(usr, "Стать дворфом?", "КОПАТЬ?", list("Да", "Нет"))
	if(dwarf_ask != "Да" || !src || QDELETED(src) || QDELETED(user))
		return FALSE
	if(!active)
		to_chat(user, span_warning("Уже занято!"))
		return FALSE
	var/mob/living/carbon/human/D = new /mob/living/carbon/human(loc)
	D.set_species(/datum/species/dwarf)
	D.equipOutfit(/datum/outfit/dwarf)
	D.key = user.key
	D.mind.assigned_role = "Dwarf"
	active = FALSE
	to_chat(D, "<span class='big bold'>Я Дварф в невероятно диких условиях.</span>")
	deactivate()

/obj/structure/dwarf_altar/proc/deactivate()
	icon_state = "altar_inactive"

/obj/structure/dwarf_altar/attackby(obj/item/I, mob/living/user, params)
	if((I.type in allowed_resources))
		to_chat(user, span_notice("Жертвую [I.name]"))
		resources+=allowed_resources[I.type]
		qdel(I)
	else if(istype(I, /obj/item/damaz))
		var/obj/item/damaz/D = I
		if(!D.can_use(user))
			return
		ui_interact(user)
	else
		..()

/obj/structure/dwarf_altar/attack_hand(mob/user)
	if(ishuman(user) && !isdwarf(user))
		if(!active)
			to_chat(user, span_warning("Алтарь не готов!"))
			return
		var/mob/living/carbon/human/M = user
		var/dwarf_ask = tgui_alert(M, "Стать дворфом?", "КОПАТЬ?", list("Да", "Нет"))
		if(dwarf_ask != "Да" || !src || QDELETED(src) || QDELETED(M))
			return FALSE
		if(!active)
			to_chat(M, span_warning("Не повезло!"))
			return FALSE
		M.set_species(/datum/species/dwarf)
		M.unequip_everything()
		M.equipOutfit(/datum/outfit/dwarf)
		active = FALSE
		to_chat(M, span_notice("Становлюсь дворфом."))

/obj/structure/dwarf_altar/proc/perform_rite(rite, mob/user)
	var/datum/ritual/R = new rite
	if(busy)
		return
	busy = TRUE
	to_chat(user, span_notice("Начинаю ритуал"))
	activate()
	if(!do_after(user, 3 SECONDS, target = src))
		busy = FALSE
		deactivate()
		return
	switch(initial(R.true_name))
		if("seeds")
			for(var/seed in list(/obj/item/seeds/plump, /obj/item/seeds/tower))
				for(var/i in 1 to 2)
					new seed(loc)
		if("dwarf")
			active = TRUE
			notify_ghosts("Новый дворф готов.", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Спавн дворфа доступен.")
		if("frog")
			new /mob/living/simple_animal/hostile/retaliate/frog(loc)
		if("tools")
			for(var/tool in list(/obj/item/blacksmith/smithing_hammer, /obj/item/blacksmith/tongs))
				new tool(loc)
	busy = FALSE
	to_chat(user, span_notice("Заканчиваю ритуал"))
	deactivate()
	qdel(R)

/obj/structure/dwarf_altar/proc/generate_rituals()
	var/list/rituals = list()
	for(var/rt in available_rituals)
		var/list/rite = list()
		var/datum/ritual/R = rt
		rite["name"] = initial(R.name)
		rite["cost"] = initial(R.cost)
		rite["desc"] = initial(R.desc)
		rite["path"] = R
		rituals+=list(rite)
	return rituals

/obj/structure/dwarf_altar/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "DwarfAltar")
    ui.open()

/obj/structure/dwarf_altar/ui_data(mob/user)
	var/list/data = list()
	var/list/rituals = generate_rituals()
	data["favor"] = resources
	data["rituals"] = rituals
	return data

/obj/structure/dwarf_altar/ui_act(action, params)
	. = ..()
	var/cost = params["cost"]
	if(cost>resources)
		to_chat(usr, span_warning("Не хватает ресурсов!"))
		return
	resources-=cost
	perform_rite(params["path"], usr)
	update_icon()
