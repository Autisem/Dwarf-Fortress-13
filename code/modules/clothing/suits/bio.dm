//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "био-капюшон"
	icon_state = "bio"
	desc = "Капюшон, защищающий голову и лицо от биологических загрязнений."
	permeability_coefficient = 0.01
	clothing_flags = THICKMATERIAL | BLOCK_GAS_SMOKE_EFFECT | SNUG_FIT
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 80, FIRE = 30, ACID = 100)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT
	resistance_flags = ACID_PROOF
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF

/obj/item/clothing/suit/bio_suit
	name = "био-костюм"
	desc = "Костюм, который защищает от биологического загрязнения."
	icon_state = "bio"
	inhand_icon_state = "bio_suit"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 0.5
	allowed = list()
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 80, FIRE = 30, ACID = 100)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	strip_delay = 70
	equip_delay_other = 70
	resistance_flags = ACID_PROOF

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
	icon_state = "bio_general"

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio_general"

//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "костюм чумного доктора"
	desc = "Тогда он защищал врачей от Черной смерти. Вы держите пари, что это поможет вам против вирусов."
	icon_state = "plaguedoctor"
	inhand_icon_state = "bio_suit"
	strip_delay = 40
	equip_delay_other = 20

/obj/item/clothing/suit/bio_suit/plaguedoctorsuit/Initialize()
	. = ..()
	allowed += list(/obj/item/storage/book/bible, /obj/item/nullrod)
