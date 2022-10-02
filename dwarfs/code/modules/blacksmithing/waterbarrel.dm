/obj/structure/dwarf_waterbarrel
	name = "barrel with dirty water"
	desc = "Do. Not. Drink."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "barrel_dirty"
	anchored = TRUE
	density = TRUE
	layer = TABLE_LAYER

/obj/structure/dwarf_waterbarrel/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/tongs))
		if(I.contents.len)
			if(istype(I.contents[I.contents.len], /obj/item/ingot))
				var/obj/item/ingot/N = I.contents[I.contents.len]
				if(N.progress_current == N.progress_need + 1)
					for(var/i in 1 to rand(1, N.recipe.max_resulting))
						if(N.grade >= 5)
							N.grade = 5
							if(prob(10))
								N.grade = 6
						var/obj/item/O = new N.recipe.result(get_turf(src))
						var/grd_name = grade_name(N.grade)
						O.name = "[grd_name][O.name][grd_name]"
						O.grade = N.grade
						O.apply_grade(N.grade)
					qdel(N)
					LAZYCLEARLIST(contents)
					playsound(src, 'sound/effects/vaper.ogg', 100)
					I.update_appearance()
				else
					return
	else
		. = ..()
