extends Node
@export var	dlg_phase_one : Dialogue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_large_point_player_entered():
	DialogueManager.play_dialogue(dlg_phase_one)
	

	
