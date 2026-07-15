class_name PhoneUI
extends Control

@export var app_name_label: Label
@export var home_app: PhoneApp
@export var messages_app: PhoneMessagesApp

var apps: Array[PhoneApp]:
	get:
		return [home_app, messages_app]

var _current_app_index: int = 0

func _ready() -> void:
	hide()
	_update_current_app()

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
