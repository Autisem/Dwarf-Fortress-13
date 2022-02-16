#define HITS_TO_CRIT(damage) round(100 / damage, 0.1)
/**
 *
 * The purpose of this element is to widely provide the ability to examine an object and determine its stats, with the ability to add
 * additional notes or information based on type or other factors
 *
 */
/datum/element/weapon_description
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	// Additional proc to be run for specific object types
	var/attached_proc

	// Flavor text crimes used in build_weapon_text()
	var/list/crimes = list("Нападениях", "Убийствах", "Ограблениях", "Террористических актах", "Различных проступках", "Случаях уклонения от налогов", "Мятежах")
	var/list/victims = list("человека", "моль", "фелинида", "ящера", "агента синдиката", "клоуна", "мима", "противника", "мимокрокодила")

/datum/element/weapon_description/Attach(datum/target, attached_proc)
	. = ..()
	if(!isitem(target)) // Do not attach this to anything that isn't an item
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/warning_label)
	RegisterSignal(target, COMSIG_TOPIC, .proc/topic_handler)
	// Don't perform the assignment if there is nothing to assign, or if we already have something for this bespoke element
	if(attached_proc && !src.attached_proc)
		src.attached_proc = attached_proc

/datum/element/weapon_description/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_PARENT_EXAMINE, COMSIG_TOPIC))

/**
 *
 * This proc is called when the user examines an object with the associated element. This produces a hyperlinked
 * text line provided that the given item meets the weapon-determining criteria (Sufficient force or notes)
 *
 * Arguments:
 * 	* source - Object being examined, cast into an item variable
 *  * user - Unused
 *  * examine_texts - The output text list of the original examine function
 */
/datum/element/weapon_description/proc/warning_label(obj/item/item, mob/user, list/examine_texts)
	SIGNAL_HANDLER

	if(item.force >= 5 || item.throwforce >= 5 || item.override_notes || item.offensive_notes || attached_proc) /// Only show this tag for items that could feasibly be weapons, shields, or those that have special notes
		examine_texts += span_notice("<hr>На [item.ru_na()] есть обновляющася блюспейс <a href='?src=[REF(item)];examine=1'>этикетка</a>.")

/**
 *
 * Details the stats of the examined weapon
 *
 * This function is called when the user clicks the hyperlink provided by
 * warning_label(). It calls build_label_text() and outputs its return value to the user
 *
 * Arguments:
 *  * source - Object being examined, sent to build_label_text()
 *  * href-list - List provided by the href of input values, used to know what hyperlinked action is being attempted
 */

/datum/element/weapon_description/proc/topic_handler(atom/source, user, href_list)
	SIGNAL_HANDLER

	if(href_list["examine"])
		to_chat(user, span_notice("<div class='examine_block'>[build_label_text(source)]</div>"))

/**
 *
 * Compiles a warning label detailing various statistics of the examined weapon
 *
 * This function is called by the "examine" function of Topic(), and compiles a number of relevant
 * weapon stats into a message that is then shown to the user
 * Arguments:
 *  * source - The object whose stats are being examined
 */
/datum/element/weapon_description/proc/build_label_text(obj/item/source)
	var/list/readout = list("") // Readout is used to store the text block output to the user so it all can be sent in one message

	// Meaningless flavor text. The number of crimes is constantly changing because of the complex Nanotrasen legal system and the esoteric nature of time itself!
	readout += "[span_warning("ВНИМАНИЕ:")] Этот предмет был обозначен NT как потенциально опасный ввиду его использования в [span_warning("[rand(2,99)] [crimes[rand(1, crimes.len)]]")] за прошедший час.\n"

	// Doesn't show the base notes for items that have the override notes variable set to true
	if(!source.override_notes)
		// Make sure not to divide by 0 on accident
		if(source.force > 0)
			readout += "Наши исследования показали, что нужно ударить всего [span_warning("[HITS_TO_CRIT(source.force)] раз")] чтобы отправить в нокаут [victims[rand(1, victims.len)]] без брони."
		else
			readout += "Согласно нашим исследованиям, этим нельзя никому навредить."

		if(source.throwforce > 0)
			readout += "В случае с бросками, понадобится бросить [span_warning("[HITS_TO_CRIT(source.throwforce)] раз")]."
		else
			readout += "В случае с бросками, эта штука не сможет никому навредить."
		if(source.armour_penetration > 0 || source.block_chance > 0)
			readout += "Предмет имеет [span_warning("[weapon_tag_convert(source.armour_penetration)]")] пробивную характеристику и [span_warning("[weapon_tag_convert(source.block_chance)]")] возможность блокирования ударов."
	// Custom manual notes
	if(source.offensive_notes)
		readout += source.offensive_notes

	// Check if we have an additional proc, if so, add it to the readout
	if(attached_proc)
		readout += call(source, attached_proc)()

	// Finally bringing the fields together
	return readout.Join("\n")

/**
 *
 * Converts percentile based stats to an adjective appropriate for the
 * examined warning label
 *
 * Arguments:
 *  * tag_val: The value of the item to be added to the tag
 */
/datum/element/weapon_description/proc/weapon_tag_convert(tag_val)
	switch(tag_val)
		if(0)
			return "нулевую"
		if(1 to 25)
			return "незначительную"
		if(26 to 50)
			return "стандартную"
		if(51 to 75)
			return "выдающуюся"
		if(76 to INFINITY)
			return "крайне выдающуюся"
		else
			return "странную"
