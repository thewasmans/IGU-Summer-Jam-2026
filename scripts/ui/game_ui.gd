class_name GameUI
extends Control

@export var label_interract: Label
@export var progress_interract: ProgressBar

var _game_manager:GameManager

func initialize(game_manager:GameManager):
	_game_manager = game_manager
	label_interract.hide()
	progress_interract.hide()

func set_visible_interract_label(enable: bool):
	label_interract.visible = enable

func set_visible_progress_interract(enable: bool):
	progress_interract.visible = enable
	
func set_value_progress_interract(progress_value: float):
	progress_interract.value = progress_value / progress_interract.max_value
	
