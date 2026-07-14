class_name GameUI
extends Control

@export var label_interract: Label

var _game_manager:GameManager

func initialize(game_manager:GameManager):
	_game_manager = game_manager
	label_interract.hide()

func set_visible_interract_label(enable: bool):
	label_interract.visible = enable
