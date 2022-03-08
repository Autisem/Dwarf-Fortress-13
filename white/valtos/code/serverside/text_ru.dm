// Для 513 в самый раз
// Люммокс пидорас

/proc/cp1252_to_utf8(text) //Временный прок. Транслирует не всё, но оно и не нужно
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a < 224 || a > 255)
			t += ascii2text(a)
			continue
		t += ascii2text(a + 848)
	return t

/proc/up2ph(text) // реальный рабочий костыль для плеерпанели, желательно не трогать
	for(var/s in GLOB.rus_unicode_conversion)
		text = replacetext(text, s, "&#[GLOB.rus_unicode_conversion[s]];")
	return text

/proc/r_jobgen(text)
	var/list/strip_chars = list("_"," ","(",")")
	for(var/char in strip_chars)
		text = replacetext_char(text, char, "")
	return lowertext(text)

/proc/pointization(text)
	if (!text)
		return
	if (copytext_char(text,1,2) == "*") //Emotes allowed.
		return text
	if (copytext_char(text,-1) in list("!", "?", ".", ":", ";", ","))
		return text
	text += "."
	return text

/proc/r_antidaunize(t as text)
	if(t)
		t = lowertext(t[1]) + copytext(t, 1 + length(t[1]))
	return t

/proc/r_json_decode(text) //now I'm stupid
	for(var/s in GLOB.rus_unicode_conversion_hex)
		text = replacetext(text, "\\u[GLOB.rus_unicode_conversion_hex[s]]", s)
	return json_decode(text)

/proc/ru_comms(freq)
	if(freq == "Common")
		return "Основной"
	else if (freq == "Security")
		return "Безопасность"
	else if (freq == "Engineering")
		return "Инженерия"
	else if (freq == "Command")
		return "Командование"
	else if (freq == "Science")
		return "Научный"
	else if (freq == "Medical")
		return "Медбей"
	else if (freq == "Supply")
		return "Снабжение"
	else if (freq == "Service")
		return "Обслуживание"
	else if (freq == "Exploration")
		return "Рейнджеры"
	else if (freq == "AI Private")
		return "Приватный ИИ"
	else if (freq == "Syndicate")
		return "Синдикат"
	else if (freq == "CentCom")
		return "ЦентКом"
	else if (freq == "Red Team")
		return "Советы"
	else if (freq == "Blue Team")
		return "Нацисты"
	else if (freq == "Green Team")
		return "Чечня"
	else if (freq == "Yellow Team")
		return "Хохлы"
	else if (freq == "Yohei")
		return "Криптосвязь"
	else
		return freq

/proc/r_stutter(text) //ненавижу пиндосов
	var/list/soglasnie = list(	"б","в","г","д","ж","з","к","л","м","н","п","р","с","т","ф","х","ц","ч","ш","щ",
								"Б","В","Г","Д","Ж","З","К","Л","М","Н","П","Р","С","Т","Ф","Х","Ц","Ч","Ш","Щ",
								"b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z",
								"B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z")
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (prob(80) && (ascii2text(a) in soglasnie))
			if (prob(10))
				t += text("[ascii2text(a)]-[ascii2text(a)]-[ascii2text(a)]-[ascii2text(a)]")
			else
				if (prob(20))
					t += text("[ascii2text(a)]-[ascii2text(a)]-[ascii2text(a)]")
				else
					if (prob(5))
						t += ""
					else
						t += text("[ascii2text(a)]-[ascii2text(a)]")
		t += ascii2text(a)
	return copytext_char(sanitize(t),1,MAX_MESSAGE_LEN * length(ascii2text(text2ascii(t))))

/proc/kartavo(message)
	message = replacetextEx(message, "р", "л")
	message = replacetextEx(message, "Р", "Л")
	return message

/proc/difilexish(message)
	if(prob(25))
		message = "Таки... [message]"
	message = replacetextEx(message, "р", "г'")
	message = replacetextEx(message, "Р", "Г'")
	return message

/proc/ukrainish(message)
	message = replacetext_char(message, "здравствуйте", "здрастуйтэ")
	message = replacetext_char(message, "привет", "прывит")
	message = replacetext_char(message, "утро", "ранку")
	message = replacetext_char(message, "как", "як")
	message = replacetext_char(message, "извините", "я выбачаюсь")
	message = replacetext_char(message, "свидания", "побачэння")
	message = replacetext_char(message, "понимаю", "розумию")
	message = replacetext_char(message, "спасибо", "дякую")
	message = replacetext_char(message, "пожалуйста", "будь-ласка")
	message = replacetext_char(message, "зовут", "зваты")
	message = replacetext_char(message, "меня", "мэнэ")
	message = replacetext_char(message, "кто", "хто")
	message = replacetext_char(message, "нибудь", "нэбудь")
	message = replacetext_char(message, "говорит", "розмовляйе")
	message = replacetext_char(message, "заблудился", "заблукав")
	message = replacetext_char(message, "понял", "зрозумил")
	message = replacetext_char(message, "не", "нэ")
	message = replacetext_char(message, "тебя", "тэбе")
	message = replacetext_char(message, "люблю", "кохаю")
	message = replacetextEx(message, "и", "i")
	message = replacetextEx(message, "ы", "и")
	message = replacetextEx(message, "И", "I")
	message = replacetextEx(message, "Ы", "И")
	return message

/proc/asiatish(message)
	message = replacetext_char(message, "ра", "ля")
	message = replacetext_char(message, "ла", "ля")
	message = replacetext_char(message, "ло", "льо")
	message = replacetext_char(message, "да", "тя")
	message = replacetext_char(message, "бо", "по")
	message = replacetext_char(message, "за", "ся")
	message = replacetext_char(message, "чу", "сю")
	message = replacetext_char(message, "та", "тя")
	message = replacetext_char(message, "же", "се")
	message = replacetext_char(message, "хо", "ха")
	message = replacetext_char(message, "гд", "кт")
	message = replacetextEx(message, "д", "т")
	message = replacetextEx(message, "ч", "с")
	message = replacetextEx(message, "з", "с")
	message = replacetextEx(message, "р", "л")
	message = replacetextEx(message, "ы", "и")
	message = replacetextEx(message, "Д", "Т")
	message = replacetextEx(message, "Ч", "С")
	message = replacetextEx(message, "З", "С")
	message = replacetextEx(message, "Р", "Л")
	message = replacetextEx(message, "Ы", "И")
	return message

/proc/ddlc_text(text)
	var/t = ""
	for(var/i = 1, i <= length_char(text), i++)
		t += pick(GLOB.ddlc_chars)
	return t
