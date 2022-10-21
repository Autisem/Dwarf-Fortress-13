/obj/item/shield
	name = "shield"
	icon = 'icons/obj/shields.dmi'
	block_chance = 50
	parrysound = 'dwarfs/sounds/weapons/shield/shield_parry.ogg'
	skill = /datum/skill/combat/shield

/obj/item/shield/proc/on_shield_block(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "attack", damage = 0, attack_type = MELEE_ATTACK)
	return TRUE
