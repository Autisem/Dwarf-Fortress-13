/* Table Frames
 * Contains:
 *		Frames
 *		Wooden Frames
 */


/*
 * Normal Frames
 */

/obj/structure/table_frame
	name = "рама стола"
	desc = "Четыре металлические ножки с четырьмя каркасными стержнями для стола. Вы могли бы легко пройти через это."
	icon = 'icons/obj/structures.dmi'
	icon_state = "nu_table_frame"
	density = FALSE
	anchored = FALSE
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	max_integrity = 100
	var/framestack
	var/framestackamount = 2


/obj/structure/table_frame/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, span_notice("Начинаю разбирать [src]..."))
	I.play_tool_sound(src)
	if(!I.use_tool(src, user, 3 SECONDS))
		return TRUE
	playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	deconstruct(TRUE)
	return TRUE


/obj/structure/table_frame/attackby(obj/item/I, mob/user, params)
	if(isstack(I))
		var/obj/item/stack/material = I
		if(material.tableVariant)
			if(material.get_amount() < 1)
				to_chat(user, span_warning("Надо бы [material.name] чтобы закончить это!"))
				return
			if(locate(/obj/structure/table) in loc)
				to_chat(user, span_warning("Здесь уже есть стол!"))
				return
			to_chat(user, span_notice("Начинаю добавлять [material] к [src]..."))
			if(!do_after(user, 2 SECONDS, target = src) || !material.use(1) || (locate(/obj/structure/table) in loc))
				return
			make_new_table(material.tableVariant)
		return
	return ..()


/obj/structure/table_frame/proc/make_new_table(table_type, custom_materials, carpet_type) //makes sure the new table made retains what we had as a frame
	var/obj/structure/table/T = new table_type(loc)
	T.frame = type
	T.framestack = framestack
	T.framestackamount = framestackamount
	if (carpet_type)
		T.buildstack = carpet_type
	if(custom_materials)
		T.set_custom_materials(custom_materials)
	qdel(src)

/obj/structure/table_frame/deconstruct(disassembled = TRUE)
	if(framestack)
		new framestack(get_turf(src), framestackamount)
	qdel(src)
