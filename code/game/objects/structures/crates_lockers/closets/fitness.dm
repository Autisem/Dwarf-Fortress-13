/obj/structure/closet/athletic_mixed
	name = "спортивный гардероб"
	desc = "Это хранилище для спортивной одежды."
	icon_door = "mixed"

/obj/structure/closet/athletic_mixed/PopulateContents()
	..()
	new /obj/item/clothing/under/shorts/purple(src)
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)
	new /obj/item/clothing/under/costume/jabroni(src)


/obj/structure/closet/boxinggloves
	name = "боксерские перчатки"
	desc = "Это хранилище для боксерских перчаток."

/obj/structure/closet/boxinggloves/PopulateContents()
	..()
	new /obj/item/clothing/gloves/boxing/blue(src)
	new /obj/item/clothing/gloves/boxing/green(src)
	new /obj/item/clothing/gloves/boxing/yellow(src)
	new /obj/item/clothing/gloves/boxing(src)


/obj/structure/closet/masks
	name = "шкаф для масок"
	desc = "ЭТО ЯЩИК ДЛЯ МАСОК БОЙЦОВ ОЛЕ!"

/obj/structure/closet/masks/PopulateContents()
	..()
	new /obj/item/clothing/mask/luchador(src)
	new /obj/item/clothing/mask/luchador/rudos(src)
	new /obj/item/clothing/mask/luchador/tecnicos(src)


/obj/structure/closet/lasertag/red
	name = "красный комплект снаряжения для лазертага"
	desc = "Это хранилище оборудования для лазертага."
	icon_door = "red"

/obj/structure/closet/lasertag/red/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser/redtag(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/redtag(src)
	new /obj/item/clothing/head/helmet/redtaghelm(src)


/obj/structure/closet/lasertag/blue
	name = "синий комплект снаряжения для лазертага"
	desc = "Это хранилище оборудования для лазертага."
	icon_door = "blue"

/obj/structure/closet/lasertag/blue/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser/bluetag(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/bluetag(src)
	new /obj/item/clothing/head/helmet/bluetaghelm(src)
