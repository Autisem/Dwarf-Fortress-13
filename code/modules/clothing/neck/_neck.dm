/obj/item/clothing/neck
	name = "ожерелье"
	icon = 'icons/obj/clothing/neck.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40

/obj/item/clothing/neck/worn_overlays(isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(body_parts_covered & HEAD)
			if(damaged_clothes)
				. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
			if(HAS_BLOOD_DNA(src))
				. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

/obj/item/clothing/neck/tie
	name = "галстук"
	desc = "Привязной галстук из неоткани."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bluetie"
	inhand_icon_state = ""	//no inhands
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_EASY

/obj/item/clothing/neck/tie/blue
	name = "синий галстук"
	icon_state = "bluetie"

/obj/item/clothing/neck/tie/red
	name = "красный галстук"
	icon_state = "redtie"

/obj/item/clothing/neck/tie/black
	name = "чёрный галстук"
	icon_state = "blacktie"

/obj/item/clothing/neck/tie/horrible
	name = "ужасный галстук"
	desc = "Привязной галстук из неоткани. Выглядит отвратительно."
	icon_state = "horribletie"

/obj/item/clothing/neck/tie/detective
	name = "провисший галстук"
	desc = "Свободно связанный галстук, идеальный аксессуар для переутомленного детектива."
	icon_state = "detective"

/obj/item/clothing/neck/stethoscope
	name = "стетоскоп"
	desc = "Устаревший медицинский аппарат для прослушивания звуков человеческого тела. Это также заставляет вас выглядеть так, как будто вы знаете, что делаете."
	icon_state = "stethoscope"

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] puts <b>[src.name]</b> to [user.ru_ego()] chest! It looks like [user.ru_who()] won't hear much!"))
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == INTENT_HELP)
			var/body_part = parse_zone(user.zone_selected)

			var/heart_strength = span_danger("отсутствие")
			var/lung_strength = span_danger("отсутствие")

			var/obj/item/organ/heart/heart = M.getorganslot(ORGAN_SLOT_HEART)
			var/obj/item/organ/lungs/lungs = M.getorganslot(ORGAN_SLOT_LUNGS)

			if(!(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH))))
				if(heart && istype(heart))
					heart_strength = span_danger("нестабильность")
					if(heart.beating)
						heart_strength = "здоровый звук"
				if(lungs && istype(lungs))
					lung_strength = span_danger("напряженно")
					if(!(M.failed_last_breath || M.losebreath))
						lung_strength = "здоровый звук"

			var/diagnosis = (body_part == BODY_ZONE_CHEST ? "Слышу [heart_strength] пульса и [lung_strength] дыхания." : "Я еле слышу [heart_strength] пульса.")
			user.visible_message(span_notice("[user] пристраивает [src] в [body_part] [M] и слушает внимательно.") , span_notice("Прикладываю [src] к [body_part] [M]. [diagnosis]"))
			return
	return ..(M,user)

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf //Default white color, same functionality as beanies.
	name = "белый шарф"
	icon_state = "scarf"
	desc = "Стильный шарф. Идеальный зимний аксессуар для тех, у кого острое чувство моды, и для тех, кто просто не может справиться с холодным бризом на шеях."
	w_class = WEIGHT_CLASS_TINY
	dog_fashion = /datum/dog_fashion/head
	custom_price = PAYCHECK_EASY

/obj/item/clothing/neck/scarf/black
	name = "чёрный шарф"
	icon_state = "scarf"
	color = "#4A4A4B" //Grey but it looks black

/obj/item/clothing/neck/scarf/pink
	name = "розовый шарф"
	icon_state = "scarf"
	color = "#F699CD" //Pink

/obj/item/clothing/neck/scarf/red
	name = "красный шарф"
	icon_state = "scarf"
	color = "#D91414" //Red

/obj/item/clothing/neck/scarf/green
	name = "зелёный шарф"
	icon_state = "scarf"
	color = "#5C9E54" //Green

/obj/item/clothing/neck/scarf/darkblue
	name = "тёмно-синий шарф"
	icon_state = "scarf"
	color = "#1E85BC" //Blue

/obj/item/clothing/neck/scarf/purple
	name = "фиолетовый шарф"
	icon_state = "scarf"
	color = "#9557C5" //Purple

/obj/item/clothing/neck/scarf/yellow
	name = "жёлтый шарф"
	icon_state = "scarf"
	color = "#E0C14F" //Yellow

/obj/item/clothing/neck/scarf/orange
	name = "оранжевый шарф"
	icon_state = "scarf"
	color = "#C67A4B" //Orange

/obj/item/clothing/neck/scarf/cyan
	name = "голубой шарф"
	icon_state = "scarf"
	color = "#54A3CE" //Cyan


//Striped scarves get their own icons

/obj/item/clothing/neck/scarf/zebra
	name = "зебровый шарф"
	icon_state = "zebrascarf"

/obj/item/clothing/neck/scarf/christmas
	name = "рождественский шарф"
	icon_state = "christmasscarf"

//The three following scarves don't have the scarf subtype
//This is because Ian can equip anything from that subtype
//However, these 3 don't have corgi versions of their sprites
/obj/item/clothing/neck/stripedredscarf
	name = "полосатый красный шарф"
	icon_state = "stripedredscarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/stripedgreenscarf
	name = "полосатый зелёный шарф"
	icon_state = "stripedgreenscarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/stripedbluescarf
	name = "полосатый синий шарф"
	icon_state = "stripedbluescarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/petcollar
	name = "ошейник"
	desc = "Для домашних животных."
	icon_state = "petcollar"
	var/tagname = null
/*
/obj/item/clothing/neck/petcollar/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(ishuman(M))
		return FALSE
	return ..()
*/
/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = stripped_input(user, "Хотите изменить имя на теге?", "Назовите своего нового питомца", "Шепард", MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "золотая цепочка"
	desc = "Как же чётко быть гангстером."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"

/obj/item/clothing/neck/neckerchief
	icon = 'icons/obj/clothing/masks.dmi' //In order to reuse the bandana sprite
	w_class = WEIGHT_CLASS_TINY
	var/sourceBandanaType

/obj/item/clothing/neck/neckerchief/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/mutable_appearance/realOverlay = mutable_appearance('icons/mob/clothing/mask.dmi', icon_state)
		realOverlay.pixel_y = -3
		. += realOverlay

/obj/item/clothing/neck/neckerchief/AltClick(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.get_item_by_slot(ITEM_SLOT_NECK) == src)
			to_chat(user, span_warning("Не могу развязать [src] пока оно на мне!"))
			return
		if(user.is_holding(src))
			var/obj/item/clothing/mask/bandana/newBand = new sourceBandanaType(user)
			var/currentHandIndex = user.get_held_index_of_item(src)
			var/oldName = src.name
			qdel(src)
			user.put_in_hand(newBand, currentHandIndex)
			user.visible_message(span_notice("Развязываю [oldName] обратно к [newBand.name].") , span_notice("[user] развязывает [oldName] обратно к [newBand.name]."))
		else
			to_chat(user, span_warning("Надо бы держать в руках [src], чтобы развязать!"))

/obj/item/clothing/neck/beads
	name = "пластиковые бусы"
	desc = "Дешевые бусы из пластика. Прояви командный дух! Собери их! Раскидай их! Возможности безграничны!"
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "beads"
	color = "#ffffff"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	custom_materials = (list(/datum/material/plastic = 500))

/obj/item/clothing/neck/beads/Initialize()
	. = ..()
	color = color = pick("#ff0077","#d400ff","#2600ff","#00ccff","#00ff2a","#e5ff00","#ffae00","#ff0000", "#ffffff")
