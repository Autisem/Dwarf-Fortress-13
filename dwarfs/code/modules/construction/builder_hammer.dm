/obj/item/builder_hammer
	name = "builder's hammer"
	desc = "A building engineers main tool - the hammer."
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "builder_hammer"
	usesound = 'dwarfs/sounds/tools/hammer/hammer_hit.ogg'
	tool_behaviour = TOOL_BUILDER_HAMMER
	atck_type = BLUNT
	//What do we want to build -> selected in gui
	var/obj/structure/blueprint/selected_blueprint

/obj/item/builder_hammer/proc/generate_blueprints(user)
    var/list/buildable = subtypesof(/obj/structure/blueprint) - /obj/structure/blueprint/large
    var/list/blueprints = list()
    var/list/cats = list()
    //init categories
    for(var/s in buildable)
        var/obj/structure/blueprint/S = s
        var/category = initial(S.cat)
        if(!cats[category])
            cats[category] = list()
    //build recipes data for categories
    for(var/s in buildable)
        var/obj/structure/blueprint/S = new s
        var/obj/structure/original = S.target_structure
        var/category = S.cat
        var/list/blueprint = list()
        var/list/reqs = S.reqs
        var/list/resources = list() // list of lists where each list is a resource data
        for(var/i in reqs)
            var/amt = reqs[i]
            var/obj/O = i
            var/icon_path = icon2path(initial(O.icon), user, initial(O.icon_state))
            var/list/resource = list("name"=initial(O.name),"amount"=amt,"icon"=icon_path)
            resources += list(resource)

        blueprint["name"] = initial(original.name)
        blueprint["desc"] = initial(original.desc)
        blueprint["icon"] = icon2path(initial(original.icon), user, initial(original.icon_state))
        blueprint["path"] = S.type
        blueprint["reqs"] = resources
        cats[category]+=list(blueprint)
        qdel(S)
        //add all categories to blueprints
    for(var/cat in cats)
        blueprints += list(list("name"=cat, "blueprints"=cats[cat]))
    return blueprints

/obj/item/builder_hammer/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "BuilderHammer")
    ui.open()

/obj/item/builder_hammer/ui_data(mob/user)
	var/list/data = list()
	var/list/blueprints = generate_blueprints(user)
	data["blueprints"] = blueprints
	return data

/obj/item/builder_hammer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/path = text2path(params["path"])
	var/obj/structure/blueprint/B = path
	to_chat(usr, span_notice("Selected [initial(B.name)] for building."))
	selected_blueprint = B
	ui.close()
