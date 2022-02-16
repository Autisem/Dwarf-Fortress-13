

/obj/item/stack/sticky_tape
	name = "клейкая лента"
	singular_name = "клейкая лента"
	desc = "Используется для приклеивания вещей, а иногда и для приклеивания упомянутых вещей к людям."
	icon = 'icons/obj/tapes.dmi'
	icon_state = "tape_w"
	var/prefix = "sticky"
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	amount = 5
	max_amount = 5
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 5)
	splint_factor = 0.8
	merge_type = /obj/item/stack/sticky_tape
	var/list/conferred_embed = EMBED_HARMLESS
	var/overwrite_existing = FALSE

/obj/item/stack/sticky_tape/afterattack(obj/item/I, mob/living/user)
	if(!istype(I))
		return

	if(I.embedding && I.embedding == conferred_embed)
		to_chat(user, span_warning("<b>[capitalize(I)]</b> уже обёрнут в <b>[src]</b>!"))
		return

	user.visible_message(span_notice("<b>[user]</b> начинает оборачивать <b>[I]</b> при помощи <b>[src]</b>.") , span_notice("Начинаю оборачивать <b>[I]</b> при помощи <b>[src]</b>."))

	if(do_after(user, 30, target=I))
		use(1)
		if(istype(I, /obj/item/clothing/gloves/fingerless))
			var/obj/item/clothing/gloves/tackler/offbrand/O = new /obj/item/clothing/gloves/tackler/offbrand
			to_chat(user, span_notice("Оборачиваю <b>[I]</b> в <b>[O]</b> используя <b>[src]</b>."))
			QDEL_NULL(I)
			user.put_in_hands(O)
			return

		if(I.embedding && I.embedding == conferred_embed)
			to_chat(user, span_warning("[I] уже покрыт [src]!"))
			return

		I.embedding = conferred_embed
		I.updateEmbedding()
		to_chat(user, span_notice("Заканчиваю оборачивать <b>[I]</b> используя <b>[src]</b>."))
		I.name = "[prefix] [I.name]"

		if(istype(I, /obj/item/storage/bag/tray))
			var/obj/item/shield/trayshield/new_item = new(user.loc)
			to_chat(user, span_notice("Наматываю [src] на [I]."))
			var/replace = (user.get_inactive_held_item()==I)
			qdel(I)
			if(src.use(3) == 0)
				user.dropItemToGround(src)
				qdel(src)
			if(replace)
				user.put_in_hands(new_item)
			playsound(user, 'white/valtos/sounds/ducttape1.ogg', 50, 1)
		if(istype(I, /obj/item/shard) && !istype(I, /obj/item/melee/shank))
			var/obj/item/melee/shank/new_item = new(user.loc)
			to_chat(user, span_notice("Наматываю [src] на [I]."))
			var/replace = (user.get_inactive_held_item()==I)
			qdel(I)
			if(src.use(3) == 0)
				user.dropItemToGround(src)
				qdel(src)
			if(replace)
				user.put_in_hands(new_item)
			playsound(user, 'white/valtos/sounds/ducttape1.ogg', 50, 1)
		if(ishuman(I) && (user.zone_selected == "mouth" || user.zone_selected == "head"))
			var/mob/living/carbon/human/H = I
			if(H.head && (H.head.flags_cover & HEADCOVERSMOUTH))
				to_chat(user, span_danger("Надо снять [H.head] сначала."))
				return
			if(H.wear_mask) //don't even check to see if the mask covers the mouth as the tape takes up mask slot
				to_chat(user, span_danger("Надо снять [H.wear_mask] сначала."))
				return
			playsound(loc, 'white/valtos/sounds/ducttape1.ogg', 30, 1)
			to_chat(user, span_notice("Начинаю заклеивать рот [H]."))
			if(do_mob(user, H, 20))
				// H.wear_mask = new/obj/item/clothing/mask/tape(H)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/tape(H), ITEM_SLOT_MASK)
				to_chat(user, span_notice("Заматываю рот [H]."))
				playsound(loc, 'white/valtos/sounds/ducttape1.ogg', 50, 1)
				if(src.use(2) == 0)
					user.dropItemToGround(src)
					qdel(src)
				log_combat(user, H, "mouth-taped")
			else
				to_chat(user, span_warning("У меня не вышло заткнуть [H]."))

/obj/item/stack/sticky_tape/super
	name = "супер клейкая лента"
	singular_name = "супер клейкая лента"
	desc = "Вполне возможно, самое вредное вещество в галактике. Используйте с крайней осторожностью."
	icon_state = "tape_y"
	prefix = "очень липкий"
	conferred_embed = EMBED_HARMLESS_SUPERIOR
	splint_factor = 0.6
	merge_type = /obj/item/stack/sticky_tape/super

/obj/item/stack/sticky_tape/pointy
	name = "заостренная лента"
	singular_name = "заостренная лента"
	desc = "Используется для приклеивания к вещам, для того, чтобы приклеивать эти вещи к людям."
	icon_state = "tape_evil"
	prefix = "заострённый"
	conferred_embed = EMBED_POINTY
	merge_type = /obj/item/stack/sticky_tape/pointy

/obj/item/stack/sticky_tape/pointy/super
	name = "супер заостренная лента"
	singular_name = "супер заостренная лента"
	desc = "Вы не знали, что лента может выглядеть так зловеще. Добро пожаловать на Космическую Станцию 13."
	icon_state = "tape_spikes"
	prefix = "невероятно острый"
	conferred_embed = EMBED_POINTY_SUPERIOR
	merge_type = /obj/item/stack/sticky_tape/pointy/super

/obj/item/stack/sticky_tape/surgical
	name = "хирургическая лента"
	singular_name = "хирургическая лента"
	desc = "Используется для сращивания поломаных костей как и костный гель. Не для пранков."
	//icon_state = "tape_spikes"
	prefix = "surgical"
	conferred_embed = list("embed_chance" = 70, "pain_mult" = 0, "jostle_pain_mult" = 0, "ignore_throwspeed_threshold" = TRUE)
	splint_factor = 0.4
	custom_price = PAYCHECK_MEDIUM
	merge_type = /obj/item/stack/sticky_tape/surgical
