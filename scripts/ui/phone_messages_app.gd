class_name PhoneMessagesApp
extends PhoneApp

@export var contact_name: String = "Maman"
@export var auto_message_text: String = "Tout va bien, ne t'inquiète pas."
@export var fact_key: String = "message_sent"

@export var message_label: Label
@export var hint_label: Label

var _sent: bool = false

func interact() -> void:
	if _sent:
		return
	_sent = true
	message_label.text = "%s: %s" % [contact_name, auto_message_text]
	hint_label.text = "Message envoyé"
	Facts.set_fact(fact_key, true)
