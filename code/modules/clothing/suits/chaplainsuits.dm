//Chaplain Suit Subtypes
//If any new staple chaplain items get added, put them in these lists
/obj/item/clothing/suit/chaplainsuit
	allowed = list()

/obj/item/clothing/suit/hooded/chaplainsuit
	allowed = list()

//Suits
/obj/item/clothing/suit/chaplainsuit/holidaypriest
	name = "парадная роба священника"
	desc = "Это праздник, мой сын."
	icon_state = "holidaypriest"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/chaplainsuit/nun
	name = "монашеский халат"
	desc = "Максимальное благочестие в этой звездной системе."
	icon_state = "nun"
	inhand_icon_state = "nun"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/chaplainsuit/bishoprobe
	name = "одежда епископа"
	desc = "Рад видеть десятины, которые вы собрали, были потрачены не зря."
	icon_state = "bishoprobe"
	inhand_icon_state = "bishoprobe"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/chaplainsuit/studentuni
	name = "студенческий халат"
	desc = "Форма ушедшего института обучения."
	icon_state = "studentuni"
	inhand_icon_state = "studentuni"
	body_parts_covered = ARMS|CHEST

/obj/item/clothing/suit/chaplainsuit/witchhunter
	name = "наряд охотника на ведьм"
	desc = "Этот изношенный наряд был очень полезен в те времена."
	icon_state = "witchhunter"
	inhand_icon_state = "witchhunter"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/hooded/chaplainsuit/monkhabit
	name = "платье монаха"
	desc = "В нескольких шагах выше оказали вретище."
	icon_state = "monkfrock"
	inhand_icon_state = "monkfrock"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/monkhabit

/obj/item/clothing/head/hooded/monkhabit
	name = "капюшон монаха"
	desc = "Ибо, когда человек хочет прикрыть свою лысину."
	icon_state = "monkhood"
	inhand_icon_state = "monkhood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/suit/chaplainsuit/monkrobeeast
	name = "одеяния восточного монаха"
	desc = "Лучше всего сочетается с бритой головой."
	icon_state = "monkrobeeast"
	inhand_icon_state = "monkrobeeast"
	body_parts_covered = GROIN|LEGS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/chaplainsuit/whiterobe
	name = "белая роба"
	desc = "Отлично подойдёт для духовных личностей или просто любителей поспать."
	icon_state = "whiterobe"
	inhand_icon_state = "whiterobe"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/chaplainsuit/clownpriest
	name = "роба последователя Хонкоматери"
	desc = "Тканевый костюм для клоуна."
	icon_state = "clownpriest"
	inhand_icon_state = "clownpriest"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	allowed = list()
