
/mob/living/simple_animal/proc/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	bruteloss = round(clamp(bruteloss + amount, 0, maxHealth * 2), DAMAGE_PRECISION)
	if(updating_health)
		updatehealth()
	return amount

/mob/living/simple_animal/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount *  CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else
		. = adjustHealth(amount *  CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustStaminaLoss(amount, updating_health = FALSE, forced = FALSE)
	if(forced)
		staminaloss = max(0, min(max_staminaloss, staminaloss + amount))
	else
		staminaloss = max(0, min(max_staminaloss, staminaloss + amount ))
	update_stamina()
