/obj/item/gem
	name = "uncut gem"
	desc = "Крутой"
	w_class = WEIGHT_CLASS_TINY
	icon = 'white/rashcat/icons/dwarfs/objects/gems.dmi'
	var/cut_type = /obj/item/gem/cut
	var/scan_state
	var/max_amount = 3

/obj/item/gem/Initialize()
	. = ..()
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/gem/cut

/obj/item/gem/diamond
	name = "uncut diamond"
	desc = "Diamond. Uncut"
	icon_state = "diamond_uncut"
	cut_type = /obj/item/gem/cut/diamond
	scan_state = "diamond"
	max_amount = 2

/obj/item/gem/cut/diamond
	name = "diamond"
	desc = "Diamond"
	icon_state = "diamond"

/obj/item/gem/ruby
	name = "uncut ruby"
	desc = "Ruby. Uncut."
	icon_state = "ruby_uncut"
	cut_type = /obj/item/gem/cut/ruby
	scan_state = "ruby"

/obj/item/gem/cut/ruby
	name = "ruby"
	desc = "Ruby."
	icon_state = "ruby"

/obj/item/gem/saphire
	name = "uncut saphire"
	desc = "Saphire. Uncut."
	icon_state = "saphire_uncut"
	cut_type = /obj/item/gem/cut/saphire
	scan_state = "saphire"

/obj/item/gem/cut/saphire
	name = "saphire"
	icon_state = "Saphire."
	desc = "Такой камень подошел бы королю."

/obj/item/damaz
	name = "Damaz"
	desc = "A book?"
	icon = 'white/rashcat/icons/dwarfs/objects/tools.dmi'
	icon_state = "damaz"

/obj/item/damaz/proc/can_use(mob/user)
	var/allowed = isdwarf(user)
	if(!allowed)
		to_chat(user, span_warning("Thy are not worthy!"))
	return allowed
