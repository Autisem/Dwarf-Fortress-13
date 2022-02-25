/obj/item/clothing/suit/armor/light_plate
	name = "chest plate"
	desc = "Covers only chest area."
	body_parts_covered = CHEST|GROIN
	icon_state = "light_plate"
	inhand_icon_state = "light_plate"
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	armor = list("melee" = 35, "bullet" = 30, "laser" = 25, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "wound" = 35)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/suit/armor/heavy_plate
	name = "plate armor"
	desc = "Sturdy but heavy."
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	w_class = WEIGHT_CLASS_GIGANTIC
	slowdown = 1
	icon_state = "heavy_plate"
	inhand_icon_state = "heavy_plate"
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	flags_inv = HIDEJUMPSUIT
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 20, "wound" = 50)
	custom_materials = list(/datum/material/iron = 10000)
	var/footstep = 1
	var/mob/listeningTo
	var/list/random_step_sound = list('white/valtos/sounds/armorstep/heavystep1.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep2.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep3.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep4.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep5.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep6.ogg'=1,\
									  'white/valtos/sounds/armorstep/heavystep7.ogg'=1)

/obj/item/clothing/suit/armor/heavy_plate/proc/on_mob_move()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.wear_suit != src)
		return
	if(footstep > 2)
		playsound(src, pick(random_step_sound), 100, TRUE)
		footstep = 0
	else
		footstep++

/obj/item/clothing/suit/armor/heavy_plate/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_OCLOTHING)
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		return
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/on_mob_move)
	listeningTo = user

/obj/item/clothing/suit/armor/heavy_plate/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)

/obj/item/clothing/suit/armor/heavy_plate/Destroy()
	listeningTo = null
	return ..()

/obj/item/clothing/under/chainmail
	name = "chainmail"
	desc = "Great protection from stabs and slashes for its weight."
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "chainmail"
	inhand_icon_state = "chainmail"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 0, "energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0, "wound" = 30)
	custom_materials = list(/datum/material/iron = 10000)
	species_exception = list(/datum/species/dwarf)
	has_sensor = NO_SENSORS

/obj/item/clothing/head/helmet/plate_helmet
	name = "plate helmet"
	desc = "Protects your head from all unexpected and expected attacks."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "plate_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5, "wound" = 50)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/gloves/plate_gloves
	name = "plate gloves"
	desc = "Will save your hands from unexpected losses."
	worn_icon = 'white/valtos/icons/clothing/mob/glove.dmi'
	icon = 'white/valtos/icons/clothing/gloves.dmi'
	icon_state = "plate_gloves"
	armor = list("melee" = 25, "bullet" = 30, "laser" = 20,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 25, "wound" = 30)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/shoes/jackboots/plate_boots
	name = "plate boots"
	desc = "The boots."
	worn_icon = 'white/valtos/icons/clothing/mob/shoe.dmi'
	icon = 'white/valtos/icons/clothing/shoes.dmi'
	icon_state = "plate_boots"
	armor = list("melee" = 25, "bullet" = 30, "laser" = 20,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 25, "wound" = 30)
	custom_materials = list(/datum/material/iron = 10000)

/obj/item/clothing/head/helmet/dwarf_crown
	name = "crown"
	desc = "Worthy of a real king."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "dwarf_king"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5, "wound" = 15)
	custom_materials = list(/datum/material/gold = 10000)
	actions_types = list(/datum/action/item_action/send_message_action)
	var/mob/assigned_count = null

/obj/item/clothing/head/helmet/dwarf_crown/Initialize()
	. = ..()
	GLOB.dwarf_crowns+=src

/obj/item/clothing/head/helmet/dwarf_crown/Destroy()
    . = ..()
    GLOB.dwarf_crowns-=src

/datum/action/item_action/send_message_action
	name = "Send message to subjects"

/obj/item/clothing/head/helmet/dwarf_crown/proc/send_message(mob/user, msg)
	message_admins("DF: [ADMIN_LOOKUPFLW(user)]: [msg]")
	for(var/mob/M in GLOB.dwarf_list)
		to_chat(M, span_revenbignotice("[msg]"))
		SEND_SOUND(M, 'white/valtos/sounds/siren.ogg')

/obj/item/clothing/head/helmet/dwarf_crown/attack_self(mob/user)
	. = ..()
	var/busy = FALSE
	var/mob/king
	for(var/obj/item/clothing/head/helmet/dwarf_crown/C in GLOB.dwarf_crowns)
		if(C.assigned_count && C.assigned_count?.stat != DEAD)
			busy = TRUE
			king = C.assigned_count
	if(busy && assigned_count != user)
		if(user != king)
			to_chat(user, span_warning("YOU HAVE NO POWER!"))
		else
			to_chat(user, span_warning("YOU ALREADY HAVE POWER!"))
		return

	if(is_species(user, /datum/species/dwarf) && (!assigned_count || assigned_count?.stat == DEAD))
		assigned_count = user
		send_message(user, "<b>[user]</b> has been chosen as our leader!")
	if(assigned_count == user)
		var/msg = stripped_input(user, "What to say?", "Message:")
		if(!msg)
			return
		user.whisper("[msg]")
		send_message(user, "<b>[user]</b>: [pointization(msg)]")
	else
		to_chat(user, span_warning("YOU HAVE NO POWER!"))

/obj/item/clothing/shoes/dwarf
	worn_icon = 'white/valtos/icons/dwarfs/feet.dmi'
	name = "dwarf boots"
	icon = 'white/valtos/icons/dwarfs/shoes.dmi'
	icon_state = "dwarf"
	inhand_icon_state = "dwarf"
	desc = "So small a child can wear them."

/obj/item/clothing/under/dwarf
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	name = "dwarf tunic"
	desc = "Typical green shirt. Smells of alcohol."
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "dwarf"
	species_exception = list(/datum/species/dwarf)
	has_sensor = NO_SENSORS
