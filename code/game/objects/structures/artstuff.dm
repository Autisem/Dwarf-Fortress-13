
///////////
// EASEL //
///////////

/obj/structure/easel
	name = "мольберт"
	desc = "Только для лучшего искусства!"
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "easel"
	density = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 60
	var/obj/item/canvas/painting = null

//Adding canvases
/obj/structure/easel/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/canvas))
		var/obj/item/canvas/C = I
		user.dropItemToGround(C)
		painting = C
		C.forceMove(get_turf(src))
		C.layer = layer+0.1
		user.visible_message(span_notice("[user] ставит [C] на [src].") ,span_notice("Ставлю [C] на [src]."))
	else
		return ..()


//Stick to the easel like glue
/obj/structure/easel/Move()
	var/turf/T = get_turf(src)
	. = ..()
	if(painting && painting.loc == T) //Only move if it's near us.
		painting.forceMove(get_turf(src))
	else
		painting = null

/obj/item/canvas
	name = "холст"
	desc = "Нарисуй свою душу на этом холсте!"
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "11x11"
	flags_1 = UNPAINTABLE_1
	resistance_flags = FLAMMABLE
	var/width = 11
	var/height = 11
	var/list/grid
	/// empty canvas color
	var/canvas_color = "#ffffff"
	/// Is it clean canvas or was there something painted on it at some point, used to decide when to show wip splotch overlay
	var/used = FALSE
	var/finalized = FALSE //Blocks edits
	var/icon_generated = FALSE
	var/icon/generated_icon
	///boolean that blocks persistence from saving it. enabled from printing copies, because we do not want to save copies.
	var/no_save = FALSE

	var/datum/painting/painting_metadata

	// Painting overlay offset when framed
	var/framed_offset_x = 11
	var/framed_offset_y = 10

	pixel_x = 10
	pixel_y = 9

/obj/item/canvas/Initialize(mapload)
	. = ..()
	reset_grid()

	painting_metadata = new
	painting_metadata.title = "Безымянная картина"
	painting_metadata.creation_round_id = GLOB.round_id
	painting_metadata.width = width
	painting_metadata.height = height

/obj/item/canvas/proc/reset_grid()
	grid = new/list(width,height)
	for(var/x in 1 to width)
		for(var/y in 1 to height)
			grid[x][y] = canvas_color

/obj/item/canvas/attack_self(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/canvas/ui_state(mob/user)
	if(finalized)
		return GLOB.physical_obscured_state
	else
		return GLOB.default_state

/obj/item/canvas/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Canvas", name)
		ui.open()

/obj/item/canvas/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent == INTENT_HELP)
		ui_interact(user)
	else
		return ..()

/obj/item/canvas/ui_data(mob/user)
	. = ..()
	.["grid"] = grid
	.["name"] = painting_metadata.title
	.["author"] = painting_metadata.creator_name
	.["medium"] = painting_metadata.medium
	.["date"] = painting_metadata.creation_date
	.["finalized"] = finalized
	.["editable"] = !finalized //Ideally you should be able to draw moustaches on existing paintings in the gallery but that's not implemented yet
	.["show_plaque"] = istype(loc,/obj/structure/sign/painting)
	.["paint_tool_color"] = get_paint_tool_color(user.get_active_held_item())

/obj/item/canvas/examine(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/canvas/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	switch(action)
		if("paint")
			if(finalized)
				return TRUE
			var/obj/item/I = user.get_active_held_item()
			var/tool_color = get_paint_tool_color(I)
			if(!tool_color)
				return FALSE
			var/list/data = params["data"]
			//could maybe validate continuity but eh
			for(var/point in data)
				var/x = text2num(point["x"])
				var/y = text2num(point["y"])
				grid[x][y] = tool_color
			var/medium = get_paint_tool_medium(I)
			if(medium && painting_metadata.medium && painting_metadata.medium != medium)
				painting_metadata.medium = "Микс медиум"
			else
				painting_metadata.medium = medium
			used = TRUE
			update_appearance()
			. = TRUE
		if("finalize")
			. = TRUE
			finalize(user)

/obj/item/canvas/proc/finalize(mob/user)
	if(painting_metadata.loaded_from_json || finalized)
		return
	finalized = TRUE
	painting_metadata.creator_ckey = user.ckey
	painting_metadata.creator_name = user.real_name
	painting_metadata.creation_date = time2text(world.realtime)
	painting_metadata.creation_round_id = GLOB.round_id
	generate_proper_overlay()
	try_rename(user)

/obj/item/canvas/update_overlays()
	. = ..()
	if(icon_generated)
		var/mutable_appearance/detail = mutable_appearance(generated_icon)
		detail.pixel_x = 1
		detail.pixel_y = 1
		. += detail
		return
	if(!used)
		return

	var/mutable_appearance/detail = mutable_appearance(icon, "[icon_state]wip")
	detail.pixel_x = 1
	detail.pixel_y = 1
	. += detail

/obj/item/canvas/proc/generate_proper_overlay()
	if(icon_generated)
		return
	var/png_filename = "data/paintings/temp_painting.png"
	var/image_data = get_data_string()
	var/result = rustg_dmi_create_png(png_filename, "[width]", "[height]", image_data)
	if(result)
		CRASH("Error generating painting png : [result]")
	painting_metadata.md5 = md5(lowertext(image_data))
	generated_icon = new(png_filename)
	icon_generated = TRUE
	update_appearance()

/obj/item/canvas/proc/get_data_string()
	var/list/data = list()
	for(var/y in 1 to height)
		for(var/x in 1 to width)
			data += grid[x][y]
	return data.Join("")

//Todo make this element ?
/obj/item/canvas/proc/get_paint_tool_color(obj/item/painting_implement)
	if(!painting_implement)
		return
	if(istype(painting_implement, /obj/item/paint_palette))
		var/obj/item/paint_palette/palette = painting_implement
		return palette.current_color
	if(istype(painting_implement, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/crayon = painting_implement
		return crayon.paint_color
	else if(istype(painting_implement, /obj/item/pen))
		var/obj/item/pen/P = painting_implement
		switch(P.colour)
			if("black")
				return "#000000"
			if("blue")
				return "#0000ff"
			if("red")
				return "#ff0000"
		return P.colour
	else if(istype(painting_implement, /obj/item/soap) || istype(painting_implement, /obj/item/reagent_containers/glass/rag))
		return canvas_color

/// Generates medium description
/obj/item/canvas/proc/get_paint_tool_medium(obj/item/painting_implement)
	if(!painting_implement)
		return
	if(istype(painting_implement, /obj/item/paint_palette))
		return "Масло на холсте"
	else if(istype(painting_implement, /obj/item/toy/crayon/spraycan))
		return "Краска на холсте"
	else if(istype(painting_implement, /obj/item/toy/crayon))
		return "Мелок на холсте"
	else if(istype(painting_implement, /obj/item/pen))
		return "Краска на холсте"
	else if(istype(painting_implement, /obj/item/soap) || istype(painting_implement, /obj/item/reagent_containers/glass/rag))
		return //These are just for cleaning, ignore them
	else
		return "Неизвестный медиум"

/obj/item/canvas/proc/try_rename(mob/user)
	if(painting_metadata.loaded_from_json) // No renaming old paintings
		return
	var/new_name = stripped_input(user,"Как назовём наш шедевр?")
	if(new_name != painting_metadata.title && new_name && user.canUseTopic(src, BE_CLOSE))
		painting_metadata.title = new_name
	var/sign_choice = tgui_alert(user, "Подпишем или оставим анонимным?", "Подпись?", list("Да", "Нет"))
	if(sign_choice != "Да")
		painting_metadata.creator_name = "Аноним"

	SStgui.update_uis(src)


/obj/item/canvas/nineteen_nineteen
	name = "холст (19x19)"
	icon_state = "19x19"
	width = 19
	height = 19
	pixel_x = 6
	pixel_y = 9
	framed_offset_x = 8
	framed_offset_y = 9

/obj/item/canvas/twentythree_nineteen
	name = "холст (23x19)"
	icon_state = "23x19"
	width = 23
	height = 19
	pixel_x = 4
	pixel_y = 10
	framed_offset_x = 6
	framed_offset_y = 8

/obj/item/canvas/twentythree_twentythree
	name = "холст (23x23)"
	icon_state = "23x23"
	width = 23
	height = 23
	pixel_x = 5
	pixel_y = 9
	framed_offset_x = 5
	framed_offset_y = 6

/obj/item/canvas/twentyfour_twentyfour
	name = "универсальный стандартный холст ИИ"
	desc = "Помимо того, что он очень большой, ИИ может воспринимать их как отображение из своей внутренней базы данных после того, как вы его повесили."
	icon_state = "24x24"
	width = 24
	height = 24
	pixel_x = 2
	pixel_y = 1
	framed_offset_x = 4
	framed_offset_y = 5

/obj/item/wallframe/painting
	name = "рамка картины"
	desc = "Идеальная витрина для ваших любимых воспоминаний о смертельной ловушке."
	icon = 'icons/obj/decals.dmi'
	custom_materials = list(/datum/material/wood = 2000)
	flags_1 = NONE
	icon_state = "frame-empty"
	result_path = /obj/structure/sign/painting
	pixel_shift = 30

/obj/structure/sign/painting
	name = "Картина"
	desc = "Искусство или \"Искусство\"? Выбирай."
	icon = 'icons/obj/decals.dmi'
	icon_state = "frame-empty"
	base_icon_state = "frame"
	custom_materials = list(/datum/material/wood = 2000)
	buildable_sign = FALSE
	///Canvas we're currently displaying.
	var/obj/item/canvas/current_canvas
	///Description set when canvas is added.
	var/desc_with_canvas
	var/persistence_id

/obj/structure/sign/painting/Initialize(mapload, dir, building)
	. = ..()
	SSpersistent_paintings.painting_frames += src
	if(dir)
		setDir(dir)

/obj/structure/sign/painting/Destroy()
	. = ..()
	SSpersistent_paintings.painting_frames -= src

/obj/structure/sign/painting/attackby(obj/item/I, mob/user, params)
	if(!current_canvas && istype(I, /obj/item/canvas))
		frame_canvas(user,I)
	else if(current_canvas && current_canvas.painting_metadata.title == initial(current_canvas.painting_metadata.title) && istype(I,/obj/item/pen))
		try_rename(user)
	else
		return ..()

/obj/structure/sign/painting/examine(mob/user)
	. = ..()
	if(persistence_id)
		. += span_notice("<hr>Все картины помещённые сюда будут сохранены.")
	if(current_canvas)
		current_canvas.ui_interact(user)
		. += span_notice("<hr>Кусачки помогут снять картину.")

/obj/structure/sign/painting/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(current_canvas)
		current_canvas.forceMove(drop_location())
		current_canvas = null
		to_chat(user, span_notice("Достаю картину из рамки."))
		update_appearance()
		return TRUE

/obj/structure/sign/painting/proc/frame_canvas(mob/user,obj/item/canvas/new_canvas)
	if(user.transferItemToLoc(new_canvas,src))
		current_canvas = new_canvas
		if(!current_canvas.finalized)
			current_canvas.finalize(user)
		to_chat(user,span_notice("Устанавливаю в рамку [current_canvas]."))
	update_appearance()

/obj/structure/sign/painting/proc/try_rename(mob/user)
	if(current_canvas.painting_metadata.title == initial(current_canvas.painting_metadata.title))
		current_canvas.try_rename(user)

/obj/structure/sign/painting/update_name(updates)
	name = current_canvas ? "картина - [current_canvas.painting_metadata.title]" : initial(name)
	return ..()

/obj/structure/sign/painting/update_desc(updates)
	desc = current_canvas ? desc_with_canvas : initial(desc)
	return ..()

/obj/structure/sign/painting/update_icon_state()
	icon_state = "[base_icon_state]-[current_canvas?.generated_icon ? "overlay" : "empty"]"
	return ..()

/obj/structure/sign/painting/update_overlays()
	. = ..()
	if(!current_canvas?.generated_icon)
		return

	var/mutable_appearance/MA = mutable_appearance(current_canvas.generated_icon)
	MA.pixel_x = current_canvas.framed_offset_x
	MA.pixel_y = current_canvas.framed_offset_y
	. += MA
	var/mutable_appearance/frame = mutable_appearance(current_canvas.icon,"[current_canvas.icon_state]frame")
	frame.pixel_x = current_canvas.framed_offset_x - 1
	frame.pixel_y = current_canvas.framed_offset_y - 1
	. += frame

/**
 * Loads a painting from SSpersistence. Called globally by said subsystem when it inits
 *
 * Deleting paintings leaves their json, so this proc will remove the json and try again if it finds one of those.
 */
/obj/structure/sign/painting/proc/load_persistent()
	if(!persistence_id)
		return
	var/list/valid_paintings = SSpersistent_paintings.get_paintings_with_tag(persistence_id)
	if(!length(valid_paintings))
		return //aborts loading anything this category has no usable paintings
	var/datum/painting/painting = pick(valid_paintings)
	var/png = "data/paintings/images/[painting.md5].png"
	var/icon/I = new(png)
	var/obj/item/canvas/new_canvas
	var/w = I.Width()
	var/h = I.Height()
	for(var/T in typesof(/obj/item/canvas))
		new_canvas = T
		if(initial(new_canvas.width) == w && initial(new_canvas.height) == h)
			new_canvas = new T(src)
			break
	if(!istype(new_canvas))
		CRASH("Found painting size with no matching canvas type")
	new_canvas.painting_metadata = painting
	new_canvas.fill_grid_from_icon(I)
	new_canvas.generated_icon = I
	new_canvas.icon_generated = TRUE
	new_canvas.finalized = TRUE
	new_canvas.name = "картина - [painting.title]"
	current_canvas = new_canvas
	current_canvas.update_appearance()
	update_appearance()

/obj/structure/sign/painting/proc/save_persistent()
	if(!persistence_id || !current_canvas || current_canvas.no_save || current_canvas.painting_metadata.loaded_from_json)
		return
	if(SANITIZE_FILENAME(persistence_id) != persistence_id)
		stack_trace("Invalid persistence_id - [persistence_id]")
		return
	var/data = current_canvas.get_data_string()
	var/md5 = md5(lowertext(data))
	var/list/current = SSpersistent_paintings.paintings[persistence_id]
	if(!current)
		current = list()
	for(var/datum/painting/entry in SSpersistent_paintings.paintings)
		if(entry.md5 == md5) // No duplicates
			return
	current_canvas.painting_metadata.md5 = md5
	if(!current_canvas.painting_metadata.tags)
		current_canvas.painting_metadata.tags = list(persistence_id)
	else
		current_canvas.painting_metadata.tags |= persistence_id
	var/png_directory = "data/paintings/images/"
	var/png_path = png_directory + "[md5].png"
	var/result = rustg_dmi_create_png(png_path,"[current_canvas.width]","[current_canvas.height]",data)
	if(result)
		CRASH("Error saving persistent painting: [result]")
	SSpersistent_paintings.paintings += current_canvas.painting_metadata

/obj/item/canvas/proc/fill_grid_from_icon(icon/I)
	var/h = I.Height() + 1
	for(var/x in 1 to width)
		for(var/y in 1 to height)
			grid[x][y] = I.GetPixel(x,h-y)

//Presets for art gallery mapping, for paintings to be shared across stations
/obj/structure/sign/painting/library
	name = "публичная рамка"
	desc = "Искусство для публики от публики."
	desc_with_canvas = "Искусство (или \"искусство\"). Да это любой сможет."
	persistence_id = "library"

/obj/structure/sign/painting/library_secure
	name = "особая рамка"
	desc = "Для шедевров."
	desc_with_canvas = "Шедевр."
	persistence_id = "library_secure"

/obj/structure/sign/painting/library_private // keep your smut away from prying eyes, or non-librarians at least
	name = "приватная рамка"
	desc = "Слишком нелегальный экземпляр."
	desc_with_canvas = "Это искусство лучше упрятать от смердов."
	persistence_id = "library_private"

/// Simple painting utility.
/obj/item/paint_palette
	name = "палитра"
	desc = "Кисточка включена."
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "palette"
	lefthand_file = 'icons/mob/inhands/equipment/palette_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/palette_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	///Chosen paint color
	var/current_color

/obj/item/paint_palette/attack_self(mob/user, modifiers)
	. = ..()
	var/chosen_color = input(user, "Выбери новый цвет", "Палитра") as color|null
	if(chosen_color)
		current_color = chosen_color
