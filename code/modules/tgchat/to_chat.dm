/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * Circumvents the message queue and sends the message
 * to the recipient (target) as soon as possible.
 */
/proc/to_chat_immediate(
	target,
	html,
	type = null,
	text = null,
	avoid_highlighting = FALSE,
	html_en
)
	// Useful where the integer 0 is the entire message. Use case is enabling to_chat(target, some_boolean) while preventing to_chat(target, "")
	html = "[html]"
	text = "[text]"

	if(!target)
		return
	if(!html && !text)
		return // just ignore them
	if(target == world)
		target = GLOB.clients

	// Build a message
	var/message = list()
	if(type) message["type"] = type
	if(text) message["text"] = text
	if(html) message["html"] = html
	if(avoid_highlighting) message["avoidHighlighting"] = avoid_highlighting
	var/message_blob = TGUI_CREATE_MESSAGE("chat/message", message)
	var/message_html = message_to_html(message)
	if(islist(target))
		for(var/_target in target)
			var/client/client = CLIENT_FROM_VAR(_target)
			if(client)
				// Send to tgchat
				if(html_en && client.prefs?.en_chat)
					message["html"] = html_en
					message_blob = TGUI_CREATE_MESSAGE("chat/message", message)
				client.tgui_panel?.window.send_raw_message(message_blob)
				// Send to old chat
				SEND_TEXT(client, message_html)
		return
	var/client/client = CLIENT_FROM_VAR(target)
	if(client)
		// Send to tgchat
		if(html_en && client.prefs?.en_chat)
			message["html"] = html_en
			message_blob = TGUI_CREATE_MESSAGE("chat/message", message)
		client.tgui_panel?.window.send_raw_message(message_blob)
		// Send to old chat
		SEND_TEXT(client, message_html)

/**
 * Sends the message to the recipient (target).
 *
 * Recommended way to write to_chat calls:
 * ```
 * to_chat(client,
 *     type = MESSAGE_TYPE_INFO,
 *     html = "You have found <strong>[object]</strong>")
 * ```
 */
/proc/to_chat(
	target,
	html,
	type = null,
	text = null,
	avoid_highlighting = FALSE,
	html_en
)
	if(isnull(Master) || Master.current_runlevel == RUNLEVEL_INIT || !SSchat?.initialized)
		to_chat_immediate(target, html, type, text, avoid_highlighting, html_en)
		return

	// Useful where the integer 0 is the entire message. Use case is enabling to_chat(target, some_boolean) while preventing to_chat(target, "")
	html = "[html]"
	text = "[text]"

	if(!target)
		return
	if(!html && !text)
		return // go fuck too
	if(target == world)
		target = GLOB.clients

	// Build a message
	var/message = list()
	if(type) message["type"] = type
	if(text) message["text"] = text
	if(html) message["html"] = html
	if(avoid_highlighting) message["avoidHighlighting"] = avoid_highlighting
	if(html_en) message["html"] = html_en
	SSchat.queue(target, message)
