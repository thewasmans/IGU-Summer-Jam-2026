class_name PhoneUI
extends Control

## Bars shown for each network strength, weakest to strongest.
const NETWORK_BARS: Dictionary = {
	"disconnected": "No Network",
	"low": "▂",
	"middle": "▂▄",
	"hight": "▂▄▆",
}

@export var app_name_label: Label
@export var home_app: PhoneApp
@export var messages_app: PhoneMessagesApp
@export var secours_app: PhoneSecoursApp
@export var geoloc_app: PhoneGeolocApp
@export var geoloc_icon: Control
@export var network_icon: Label

var apps: Array[PhoneApp]:
	get:
		return [home_app, messages_app, secours_app, geoloc_app]

var _current_app_index: int = 0

func _ready() -> void:
	hide()
	_update_current_app()
	Facts.listen_fact(geoloc_app.fact_key, func(value: Variant, _previous: Variant) -> void:
		geoloc_icon.visible = value == true
	)
	geoloc_icon.visible = Facts.get_fact(geoloc_app.fact_key) == true
	Facts.listen_fact("network/level_connexion", func(value: Variant, _previous: Variant) -> void:
		_update_network_icon(value)
	)
	_update_network_icon(Facts.get_fact("network/level_connexion"))

func open() -> void:
	_current_app_index = 0
	show()
	_update_current_app()

func close() -> void:
	hide()

func next_app() -> void:
	_current_app_index = (_current_app_index + 1) % apps.size()
	_update_current_app()

func interact_current_app() -> void:
	apps[_current_app_index].interact()

func _update_current_app() -> void:
	for i in apps.size():
		apps[i].visible = i == _current_app_index
	app_name_label.text = apps[_current_app_index].app_name

func _update_network_icon(level: Variant) -> void:
	var level_str: String = level if level is String else ""
	network_icon.visible = level_str != ""
	network_icon.text = NETWORK_BARS.get(level_str, "")
