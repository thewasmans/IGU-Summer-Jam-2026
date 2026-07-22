extends Node
@export var dlg_phase_one : Dialogue
@export var dialogue_manager : DialogueManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


func _on_interract_area_player_completed():
	dialogue_manager.play_dialogue(dlg_phase_one)
