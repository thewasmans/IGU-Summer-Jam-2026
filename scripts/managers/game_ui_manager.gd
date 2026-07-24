class_name GameUIManager
extends Manager

@export var game_ui_prefab: PackedScene
@export var root_scene: Node
var _game_ui:GameUI

func initialize(game_manager:GameManager):
	super.initialize(game_manager)
	_game_ui = game_ui_prefab.instantiate()
	_game_ui.initialize(game_manager)
	root_scene.add_child(_game_ui)
	DialogueManager.entry_started.connect(_on_dialogue_entry_started)
	DialogueManager.dialogue_completed.connect(_on_dialogue_completed)

func _on_dialogue_entry_started(_dialogue: Dialogue, entry: DialogueEntry, _entry_index: int) -> void:
	_game_ui.show_dialogue_entry(entry.speaker_name, entry.text)

func _on_dialogue_completed(_dialogue: Dialogue) -> void:
	_game_ui.hide_dialogue_box()
