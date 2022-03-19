/obj/structure/chair/comfy/stone
	name = "stone chair"
	desc = "Not so comfy."
	icon = 'dwarfs/icons/structures/chairs.dmi'
	icon_state = "sandstonechair"
	color = rgb(255,255,255)
	resistance_flags = LAVA_PROOF
	max_integrity = 150
	buildstacktype = /obj/item/stack/sheet/stone

/obj/structure/chair/comfy/stone/GetArmrest()
	return mutable_appearance('white/valtos/icons/objects.dmi', "stoool_armrest")

/obj/structure/chair/comfy/stone/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		user.visible_message(span_notice("[user] tries to disasseble stone chair using <b>wrench</b>.") , \
		span_notice("You try to disassemble stone chair..."))
		return
	else
		return ..()

/obj/structure/chair/comfy/stone/throne
	name = "stone throne"
	desc = "Amazing looks, still not very comfy."
	icon = 'dwarfs/icons/structures/throne.dmi'
	icon_state = "throne"
	max_integrity = 650

/obj/structure/chair/comfy/stone/throne/GetArmrest()
	return mutable_appearance('white/valtos/icons/objects.dmi', "throne_armrest")
