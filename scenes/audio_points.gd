extends Node
@export var dlg_intro : Dialogue
@export var dlg_phase_one_short_range : Dialogue
@export var dlg_phase_one_mid_range : Dialogue
@export var dlg_phase_one_long_range : Dialogue
@export var dialogue_manager : DialogueManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass	
func _on_short_range_player_completed():
	dialogue_manager.play_dialogue(dlg_phase_one_short_range)


func _on_mid_range_player_completed():
	dialogue_manager.play_dialogue(dlg_phase_one_mid_range)


func _on_long_range_player_completed():
	dialogue_manager.play_dialogue(dlg_phase_one_long_range)
