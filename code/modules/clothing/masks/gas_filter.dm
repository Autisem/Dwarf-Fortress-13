///Filtering ratio for high amounts of gas
#define HIGH_FILTERING_RATIO 0.001
///Filtering ratio for min amount of gas
#define LOW_FILTERING_RATIO 0.0005
///Min amount of high filtering gases for high filtering ratio
#define HIGH_FILTERING_MOLES 0.001
///Min amount of mid filtering gases for high filtering ratio
#define MID_FILTERING_MOLES 0.0025
///Min amount of low filtering gases for high filtering ratio
#define LOW_FILTERING_MOLES 0.0005
///Min amount of wear that the filter gets when used
#define FILTERS_CONSTANT_WEAR 0.05

/obj/item/gas_filter
	name = "atmospheric gas filter"
	desc = "A piece of filtering cloth to be used with atmospheric gas masks and emergency gas masks."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "gas_atmos_filter"
	///Amount of filtering points available
	var/filter_status = 100
	///strength of the filter against high filtering gases
	var/filter_strength_high = 10
	///strength of the filter against mid filtering gases
	var/filter_strength_mid = 8
	///strength of the filter against low filtering gases
	var/filter_strength_low = 5
	///General efficiency of the filter (between 0 and 1)
	var/filter_efficiency = 0.5

/obj/item/gas_filter/examine(mob/user)
	. = ..()
	. += span_notice("[src] is at <b>[filter_status]%</b> durability.")

/obj/item/gas_filter/damaged
	name = "damaged gas filter"
	desc = "A piece of filtering cloth to be used with atmospheric gas masks and emergency gas masks, it seems damaged."
	filter_status = 50 //override on initialize

/obj/item/gas_filter/damaged/Initialize()
	. = ..()
	filter_status = rand(35, 65)
