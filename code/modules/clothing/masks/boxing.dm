/obj/item/clothing/mask/balaclava
	name = "балаклава"
	desc = "МНОГАДЕНЕГ"
	icon_state = "balaclava"
	inhand_icon_state = "balaclava"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/adjust)

/obj/item/clothing/mask/balaclava/attack_self(mob/user)
	adjustmask(user)

/obj/item/clothing/mask/luchador
	name = "маска Лучадора"
	desc = "Носится сильными бойцами, летающими высоко, чтобы победить своих врагов!"
	icon_state = "luchag"
	inhand_icon_state = "luchag"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL
	modifies_speech = TRUE

/obj/item/clothing/mask/luchador/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = replacetext_char(message, "капитан", "CAPITÁN")
		message = replacetext_char(message, "станция", "ESTACIÓN")
		message = replacetext_char(message, "сир", "SEÑOR")
		message = replacetext_char(message, "это ", "el ")
		message = replacetext_char(message, "мой ", "mi ")
		message = replacetext_char(message, "так ", "es ")
		message = replacetext_char(message, "такое", "es")
		message = replacetext_char(message, "друг", "amigo")
		message = replacetext_char(message, "братан", "amigo")
		message = replacetext_char(message, "привет", "hola")
		message = replacetext_char(message, " горячий", " caliente")
		message = replacetext_char(message, " очень ", " muy ")
		message = replacetext_char(message, "меч", "espada")
		message = replacetext_char(message, "библиотека", "biblioteca")
		message = replacetext_char(message, "предатель", "traidor")
		message = replacetext_char(message, "маг", "mago")
		message = uppertext(message)	//Things end up looking better this way (no mixed cases), and it fits the macho wrestler image.
		if(prob(25))
			message += " OLE!"
	speech_args[SPEECH_MESSAGE] = message

/obj/item/clothing/mask/luchador/tecnicos
	name = "маска Техникоса"
	desc = "Носится сильными бойцами, которые отстаивают справедливость и честно сражаются."
	icon_state = "luchador"
	inhand_icon_state = "luchador"

/obj/item/clothing/mask/luchador/rudos
	name = "маска Рудоса"
	desc = "Носят надежные бойцы, которые готовы сделать все, чтобы победить."
	icon_state = "luchar"
	inhand_icon_state = "luchar"

/obj/item/clothing/mask/russian_balaclava
	name = "русская балаклава"
	desc = "Защищает лицо от чрезвычайно опасных вспышек фотокамер."
	icon_state = "rus_balaclava"
	inhand_icon_state = "rus_balaclava"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL
