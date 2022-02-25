
/obj/machinery/processor
	name = "кухонный комбайн"
	desc = "Промышленный измельчитель, используемый для обработки мяса и других продуктов. Во время работы держите руки подальше от области забора."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "processor1"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 500
	active_power_usage = 5000
	var/broken = FALSE
	var/processing = FALSE
	var/rating_speed = 1
	var/rating_amount = 1
