/obj/item/stock_parts
	name = "stock part"
	desc = "What?"
	icon = 'white/valtos/icons/stock_parts.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/rating = 1

/obj/item/stock_parts/Initialize()
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/item/stock_parts/get_part_rating()
	return rating

//Rating 1

/obj/item/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)

/obj/item/stock_parts/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	custom_materials = list(/datum/material/iron=30)

/obj/item/stock_parts/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)

/obj/item/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container designed to hold compressed matter awaiting reconstruction."
	icon_state = "matter_bin"
	custom_materials = list(/datum/material/iron=80)

//Rating 2

/obj/item/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	icon_state = "adv_capacitor"
	rating = 2
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "adv_scan_module"
	rating = 2
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)

/obj/item/stock_parts/manipulator/nano
	name = "nano-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "nano_mani"
	rating = 2
	custom_materials = list(/datum/material/iron=30)

/obj/item/stock_parts/micro_laser/high
	name = "high-power micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"
	rating = 2
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)

/obj/item/stock_parts/matter_bin/adv
	name = "advanced matter bin"
	desc = "A container designed to hold compressed matter awaiting reconstruction."
	icon_state = "advanced_matter_bin"
	rating = 2
	custom_materials = list(/datum/material/iron=80)

//Rating 3

/obj/item/stock_parts/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "super_capacitor"
	rating = 3
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "super_scan_module"
	rating = 3
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)

/obj/item/stock_parts/manipulator/pico
	name = "pico-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "pico_mani"
	rating = 3
	custom_materials = list(/datum/material/iron=30)

/obj/item/stock_parts/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	rating = 3
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)

/obj/item/stock_parts/matter_bin/super
	name = "super matter bin"
	desc = "A container designed to hold compressed matter awaiting reconstruction."
	icon_state = "super_matter_bin"
	rating = 3
	custom_materials = list(/datum/material/iron=80)

//Rating 4

/obj/item/stock_parts/capacitor/quadratic
	name = "quadratic capacitor"
	desc = "A capacity capacitor used in the construction of a variety of devices."
	icon_state = "quadratic_capacitor"
	rating = 4
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/scanning_module/triphasic
	name = "triphasic scanning module"
	desc = "A compact, ultra resolution triphasic scanning module used in the construction of certain devices."
	icon_state = "triphasic_scan_module"
	rating = 4
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)

/obj/item/stock_parts/manipulator/femto
	name = "femto-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "femto_mani"
	rating = 4
	custom_materials = list(/datum/material/iron=30)

/obj/item/stock_parts/micro_laser/quadultra
	name = "quad-ultra micro-laser"
	icon_state = "quadultra_micro_laser"
	desc = "A tiny laser used in certain devices."
	rating = 4
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)

/obj/item/stock_parts/matter_bin/bluespace
	name = "bluespace matter bin"
	desc = "A container designed to hold compressed matter awaiting reconstruction."
	icon_state = "bluespace_matter_bin"
	rating = 4
	custom_materials = list(/datum/material/iron=80)

// Subspace stock parts

/obj/item/stock_parts/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/analyzer
	name = "subspace wavelength analyzer"
	icon_state = "wavelength_analyzer"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)

/obj/item/stock_parts/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal made from pure glass used to transmit laser databursts to subspace."
	custom_materials = list(/datum/material/glass=50)

/obj/item/stock_parts/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	custom_materials = list(/datum/material/iron=50)
