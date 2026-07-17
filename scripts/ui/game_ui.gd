class_name GameUI
extends Control

@export var label_interract: Label
@export var progress_interract: ProgressBar
@export var dialogue_box: Control
@export var dialogue_speaker_label: Label
@export var dialogue_text_label: Label

var _game_manager:GameManager

func initialize(game_manager:GameManager):
	_game_manager = game_manager
	label_interract.hide()
	progress_interract.hide()
	dialogue_box.hide()

func set_visible_interract_label(enable: bool):
	label_interract.visible = enable

func set_visible_progress_interract(enable: bool):
	progress_interract.visible = enable

func set_value_progress_interract(progress_value: float):
	progress_interract.value = progress_value / progress_interract.max_value

func show_dialogue_entry(speaker_name: String, text: String) -> void:
	dialogue_speaker_label.text = speaker_name
	dialogue_text_label.text = text
	dialogue_box.show()

func hide_dialogue_box() -> void:
	dialogue_box.hide()
