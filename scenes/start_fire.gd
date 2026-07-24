extends Node
@export var	dlg_found_matches : Dialogue
@export var	dlg_start_fire : Dialogue

func _on_get_matches_player_completed():
	$GetMatches/FullMatches.hide()
	DialogueManager.play_dialogue(dlg_found_matches)
	Facts.set_fact("matches_found",true)

func _on_start_fireplace_player_completed():
	DialogueManager.play_dialogue(dlg_start_fire)
	$StartFireplace/FireParticles.show()
	Facts.set_fact("events/phase_two_completed",true)
