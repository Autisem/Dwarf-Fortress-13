/obj/item/clothing/suit/armor
	allowed = null
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate/plasteel)

/obj/item/clothing/suit/armor/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/datum/component/armor_plate/plasteel/ap = GetComponent(/datum/component/armor_plate/plasteel)
		if(ap?.amount)
			var/mutable_appearance/armor_overlay = mutable_appearance('icons/mob/clothing/suit.dmi', "armor_plasteel_[ap.amount]")
			. += armor_overlay

/obj/item/clothing/suit/armor/vest
	name = "бронежилет"
	desc = "Тонкий бронированный жилет Тип I, обеспечивающий достойную защиту от большинства видов повреждений."
	icon_state = "armoralt"
	inhand_icon_state = "armoralt"
	blood_overlay_type = "armor"
	dog_fashion = /datum/dog_fashion/back

/obj/item/clothing/suit/armor/vest/alt
	desc = "Бронированный жилет Тип I, обеспечивающий достойную защиту от большинства видов повреждений."
	icon_state = "armor"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/vest/marine
	name = "tactical armor vest"
	desc = "A set of the finest mass produced, stamped plasteel armor plates, containing an environmental protection unit for all-condition door kicking."
	icon_state = "marine_command"
	inhand_icon_state = "armor"
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 50, BULLET = 50, LASER = 30, ENERGY = 25, BOMB = 50, BIO = 100, FIRE = 40, ACID = 50, WOUND = 20)
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/armor/vest/marine/security
	name = "large tactical armor vest"
	icon_state = "marine_security"

/obj/item/clothing/suit/armor/vest/marine/engineer
	name = "tactical utility armor vest"
	icon_state = "marine_engineer"

/obj/item/clothing/suit/armor/vest/marine/medic
	name = "tactical medic's armor vest"
	icon_state = "marine_medic"

/obj/item/clothing/suit/armor/vest/old
	name = "старый бронежилет"
	desc = "Бронежилет Тип I старого поколения. Ввиду использования старых технологий создания бронежилета, является менее маневрененным для перемещения."
	icon = 'white/rebolution228/icons/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/suits_mob.dmi'
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 15, BIO = 0, RAD = 0, FIRE = 30, ACID = 10, WOUND = 5)
	icon_state = "armor_old"
	inhand_icon_state = "armor"
	slowdown = 0.4

/obj/item/clothing/suit/armor/vest/blueshirt
	name = "большой бронежилет"
	desc = "Большой, но удобный кусок брони, защищающий вас от некоторых угроз."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	custom_premium_price = PAYCHECK_HARD

/obj/item/clothing/suit/armor/vest/cuirass
	name = "cuirass"
	desc = "A lighter plate armor used to still keep out those pesky arrows, while retaining the ability to move."
	icon_state = "cuirass"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/hos
	name = "бронепальто"
	desc = "Великолепное пальто, усиленное специальным сплавом для дополнительной защиты и стиля для тех, кто командует присутствием."
	icon_state = "hos"
	inhand_icon_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 70, ACID = 90, WOUND = 10)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "бронированный плащ"
	desc = "Тренч, усиленный специальным легким кевларом. Воплощение тактической штатской одежды."
	icon_state = "hostrench"
	inhand_icon_state = "hostrench"
	flags_inv = 0
	strip_delay = 80

/obj/item/clothing/suit/armor/vest/warden
	name = "куртка надзирателя"
	desc = "Темно-синяя бронированная куртка с синими плечевыми надписями и надписью «Warden» на одном из нагрудных карманов."
	icon_state = "warden_alt"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	strip_delay = 70
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "бронежилет надзирателя"
	desc = "Красный пиджак с серебряными бортиками и бронепластинами сверху."
	icon_state = "warden_jacket"

/obj/item/clothing/suit/armor/vest/leather
	name = "защитное пальто"
	desc = "Кожаное пальто в легкой броне предназначалось как повседневная одежда для высокопоставленных офицеров. Несет герб Безопасности NanoTrasen."
	icon_state = "leathercoat-sec"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/leather/noname
	desc = "Кожаное пальто в легкой броне. Элегантно и практично." //временный костыль-подпорка для сноса говна зерги.
/obj/item/clothing/suit/armor/vest/capcarapace
	name = "капитанский панцирь"
	desc = "Огнеупорный бронированный нагрудник, усиленный керамическими пластинами и пластиковыми полтронами, для обеспечения дополнительной защиты, при этом обеспечивая максимальную мобильность и гибкость. Выпускается только для лучших станций, хотя это действительно раздражает ваши соски."
	icon_state = "capcarapace"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 50, BOMB = 25, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)
	dog_fashion = null
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	name = "жилет капитана синдиката"
	desc = "Зловеще выглядящий жилет из усовершенствованной брони, надетый на черно-красную огнезащитную куртку. Золотой воротник и плечи означают, что это принадлежит высокопоставленному чиновнику синдиката."
	icon_state = "syndievest"

/obj/item/clothing/suit/toggle/captains_parade
	name = "парадная куртка капитана"
	desc = "Когда бронежилет недостаточно моден."
	icon_state = "capformal"
	inhand_icon_state = "capspacesuit"
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 50, BOMB = 25, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)
	togglename = "buttons"

/obj/item/clothing/suit/toggle/captains_parade/Initialize()
	. = ..()
	allowed = GLOB.security_wintercoat_allowed

/obj/item/clothing/suit/armor/riot
	name = "костюм анти-бунт"
	desc = "Костюм из полугибкого поликарбонатных бронепластин с плотной набивкой для защиты от атак ближнего боя. Помогает владельцу сопротивляться толканию в тесных помещениях."
	icon_state = "riot"
	inhand_icon_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80, WOUND = 20)
	clothing_flags = BLOCKS_SHOVE_KNOCKDOWN
	strip_delay = 80
	equip_delay_other = 60

/obj/item/clothing/suit/armor/bone
	name = "костяная броня"
	desc = "Броневая пластина племени, созданная из кости животных."
	icon_state = "bonearmor"
	inhand_icon_state = "bonearmor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 35, BULLET = 25, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/obj/item/clothing/suit/armor/bulletproof
	name = "пуленепробиваемая броня"
	desc = "Тяжелый пуленепробиваемый жилет Тип III, который в меньшей степени защищает владельца от традиционного снарядного оружия и взрывчатых веществ."
	icon_state = "bulletproof"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 15, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 20)
	strip_delay = 70
	equip_delay_other = 50

/obj/item/clothing/suit/armor/laserproof
	name = "отражательный жилет"
	desc = "Жилет, который отлично защищает владельца от энергетических снарядов, а также иногда отражает их."
	icon_state = "armor_reflec"
	inhand_icon_state = "armor_reflec"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	armor = list(MELEE = 10, BULLET = 10, LASER = 60, ENERGY = 60, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/hit_reflect_chance = 50

/obj/item/clothing/suit/armor/laserproof/IsReflect(def_zone)
	if(!(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/armor/vest/det_suit
	name = "бронежилет детектива"
	desc = "Бронежилет с детективным значком на нем."
	icon_state = "detective-armor"
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/det_suit/Initialize()
	. = ..()
	allowed = GLOB.detective_vest_allowed

/obj/item/clothing/suit/armor/vest/infiltrator
	name = "жилет лазутчика"
	desc = "Этот жилет изготовлен из крайне гибких материалов, которые легко поглощают удары."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	armor = list(MELEE = 40, BULLET = 40, LASER = 30, ENERGY = 40, BOMB = 70, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	strip_delay = 80

//All of the armor below is mostly unused

/obj/item/clothing/suit/armor/centcom
	name = "броня ЦентКома"
	desc = "Костюм, который защищает от некоторых повреждений."
	icon_state = "centcom"
	inhand_icon_state = "centcom"
	w_class = WEIGHT_CLASS_BULKY
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list()
	clothing_flags = THICKMATERIAL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/heavy
	name = "тяжелая броня"
	desc = "Тяжело бронированный костюм, который защищает от среднего вреда."
	icon_state = "heavy"
	inhand_icon_state = "swat_suit"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.9
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/tdome/red
	name = "костюм купола грома"
	desc = "Красноватая броня."
	icon_state = "tdred"
	inhand_icon_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "костюм купола грома"
	desc = "Блевотная броня."	//classy.
	icon_state = "tdgreen"
	inhand_icon_state = "tdgreen"


/obj/item/clothing/suit/armor/riot/knight
	name = "латный доспех"
	desc = "Классический костюм броней, очень эффективен при остановке атак ближнего боя."
	icon_state = "knight_green"
	inhand_icon_state = "knight_green"
	allowed = list()

/obj/item/clothing/suit/armor/riot/knight/yellow
	icon_state = "knight_yellow"
	inhand_icon_state = "knight_yellow"

/obj/item/clothing/suit/armor/riot/knight/blue
	icon_state = "knight_blue"
	inhand_icon_state = "knight_blue"

/obj/item/clothing/suit/armor/riot/knight/red
	icon_state = "knight_red"
	inhand_icon_state = "knight_red"

/obj/item/clothing/suit/armor/riot/knight/greyscale
	name = "рыцарский доспех"
	desc = "Классический костюм доспехов, который может быть изготовлен из разных материалов."
	icon_state = "knight_greyscale"
	inhand_icon_state = "knight_greyscale"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	armor = list(MELEE = 35, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 40, ACID = 40, WOUND = 15)

/obj/item/clothing/suit/armor/vest/durathread
	name = "дюратканевый жилет"
	desc = "Жилет из прочной нити с полосками кожи, выступающих в качестве баллистических пластин."
	icon_state = "durathread"
	inhand_icon_state = "durathread"
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 200
	resistance_flags = FLAMMABLE
	armor = list(MELEE = 20, BULLET = 10, LASER = 30, ENERGY = 40, BOMB = 15, BIO = 0, RAD = 0, FIRE = 40, ACID = 50)

/obj/item/clothing/suit/armor/vest/russian
	name = "русский жилет"
	desc = "Пуленепробиваемый жилет с лесным камуфляжем. Хорошо что тут куча лесов, чтобы в них прятаться, не так ли?"
	icon_state = "rus_armor"
	inhand_icon_state = "rus_armor"
	armor = list(MELEE = 25, BULLET = 30, LASER = 0, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 20, FIRE = 20, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/vest/russian_coat
	name = "русское боевое пальто"
	desc = "Используется в экстремально холодных фронтах, изготовлено из реальных медведей."
	icon_state = "rus_coat"
	inhand_icon_state = "rus_coat"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 50, RAD = 20, FIRE = -10, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/elder_atmosian
	name = "Древняя Атмосианская броня"
	desc = "Превосходная броня, сделанная из самых прочных и редких доступных человеку материалов."
	icon_state = "h2armor"
	inhand_icon_state = "h2armor"
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	armor = list(MELEE = 15, BULLET = 10, LASER = 30, ENERGY = 30, BOMB = 10, BIO = 10, RAD = 20, FIRE = 65, ACID = 40, WOUND = 15)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/toggle/armor/vest/centcom_formal
	name = "пальто офицера ЦентКома"
	desc = "Отлично подходит для суицидальных миссий!"
	icon_state = "centcom_formal"
	inhand_icon_state = "centcom"
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(MELEE = 35, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 35, BIO = 10, RAD = 10, FIRE = 10, ACID = 60)
	togglename = "buttons"

/obj/item/clothing/suit/toggle/armor/vest/centcom_formal/Initialize()
	. = ..()
	allowed = GLOB.security_wintercoat_allowed

/obj/item/clothing/suit/toggle/armor/hos/hos_formal
	name = "парадное пальто Начальника Охраны "
	desc = "Когда бронежилет недостаточно модный."
	icon_state = "hosformal"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, RAD = 0, FIRE = 70, ACID = 90, WOUND = 10)
	togglename = "buttons"

/obj/item/clothing/suit/toggle/armor/hos/hos_formal/Initialize()
	. = ..()
	allowed = GLOB.security_wintercoat_allowed
