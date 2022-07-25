/obj/item/builder_hammer
	name = "builder's hammer"
	desc = ">:D"
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "builder_hammer"
	tool_behaviour = TOOL_BUILDER_HAMMER
	//What do we want to build -> selected in gui
	var/obj/structure/blueprint/selected_blueprint

/turf/open/floor/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_BUILDER_HAMMER)
		var/obj/item/builder_hammer/H = I
		if(!H.selected_blueprint)
			to_chat(user, span_warning("[H] doesn't have a blueprint selected!"))
			return
		var/obj/structure/blueprint/B = new H.selected_blueprint
		var/list/dimensions = B.dimensions
		qdel(B)
		var/list/turfs = RECT_TURFS(dimensions[1], dimensions[2], src)
		for(var/turf/T in turfs)
			if(T.is_blocked_turf())
				to_chat(user, span_warning("You have to free the space required to place the blueprint first!"))
				return
		new H.selected_blueprint(src)
		H.selected_blueprint = null
	else
		. = ..()

/obj/item/builder_hammer/attack_self(mob/user, modifiers)
	var/list/blueprints = subtypesof(/obj/structure/blueprint)
	var/list/names = list()
	for(var/t in blueprints)
		var/obj/structure/blueprint/B = t
		names[initial(B.name)] = B

	var/answer = input(user, "Select a blueprint to build", "Blueprint selection.") as null|anything in names
	if(!answer)
		return
	to_chat(user, span_notice("You selected [answer] to be built."))
	selected_blueprint = names[answer]
