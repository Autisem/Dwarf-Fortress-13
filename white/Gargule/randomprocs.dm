//dodging merge-conflicts (no-procs in file "backdoors")
/mob/living/proc/compoundDamage(var/mob/living/A,var/mod=1)
	adjustBruteLoss(A.bruteloss*mod)
	adjustOxyLoss(A.oxyloss*mod)
	adjustToxLoss(A.toxloss*mod)
	adjustFireLoss(A.fireloss*mod)
	adjustCloneLoss(A.cloneloss*mod)
	adjustStaminaLoss(A.staminaloss*mod)

/mob/living/carbon/human/species/lizard/Initialize()
	..()
	if(src.dna.features["tail_lizard"] == "Alien")
		src.dna.features["tail_lizard"] = "Smooth"
		update_body()


/obj/item/clothing/mask/gas/sechailer/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot == 2 && isstrictlytype(src,/obj/item/clothing/mask/gas/sechailer) && !broken_hailer)
		if(cooldown < world.time - 100)
			playsound(user,'white/Gargule/sounds/shitMask.ogg',75,1)
			cooldown = world.time

/obj/item/nullrod/claymore
	var/cooldown = 0

/obj/item/nullrod/claymore/attack_self(mob/user)
	..()
	if(isstrictlytype(src,/obj/item/nullrod/claymore) && cooldown < world.time - 100)
		playsound(user,'white/Gargule/sounds/inTheNameOfGod.ogg',75,1)
		cooldown = world.time

/mob/living/carbon/alien/humanoid/royal/queen/tamed/default_can_use_topic(src_object)//tgui sasat
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE)
		. = min(., shared_living_ui_distance(src_object)) // Check the distance...
