extends Node
@export var dlg_intro : Dialogue
@export var dlg_phase_one_short_range : Dialogue
@export var dlg_phase_one_mid_range : Dialogue
@export var dlg_phase_one_long_range : Dialogue

func _on_short_range_player_completed():
	DialogueManager.play_dialogue(dlg_phase_one_short_range)

func _on_mid_range_player_completed():
	DialogueManager.play_dialogue(dlg_phase_one_mid_range)

func _on_long_range_player_completed():
	DialogueManager.play_dialogue(dlg_phase_one_long_range)
