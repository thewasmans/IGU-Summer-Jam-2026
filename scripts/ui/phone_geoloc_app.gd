class_name PhoneGeolocApp
extends PhoneApp

## Fact set to true once the player activates geolocation.
@export var fact_key: String = "geoloc_activated"

@export var message_label: Label
@export var hint_label: Label

var _activated: bool = false

func _ready() -> void:
	if not Facts.has_fact(fact_key):
		Facts.set_fact(fact_key, false)
	_update_display()

func interact() -> void:
	if _activated:
		return
	_activated = true
	Facts.set_fact(fact_key, true)
	_update_display()

func _update_display() -> void:
	if _activated:
		message_label.text = "Géolocalisation activée."
		hint_label.text = "Position partagée avec les secours"
	else:
		message_label.text = "Appuie sur [ E ] pour activer la géolocalisation"
		hint_label.text = ""
