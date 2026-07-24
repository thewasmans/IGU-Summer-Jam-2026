extends Node

@export var	dlg_phase_one : Dialogue
@export var dlg_radio_weather: Dialogue
@export var player_character: Character
@export_range(0.0, 1.0, 0.01) var storm_shake_trauma: float = 1.0
@export var particles: Array[GPUParticles3D]

func _ready():
	for part in particles:
		part.emitting = false
	Facts.listen_fact("dialogues/radio_weather/entry_2_completed", _on_radio_entry_2_completed)
	await get_tree().create_timer(.1).timeout
	DialogueManager.play_dialogue(dlg_radio_weather)

func _on_large_point_player_entered():
	DialogueManager.play_dialogue(dlg_phase_one)
	
func _on_radio_entry_2_completed(_val: Variant, _prev: Variant):
	if _val:
		_play_storm_vfx()

func _play_storm_vfx() -> void:
	for part in particles:
		part.emitting = true
	await get_tree().create_timer(1).timeout
	player_character.shake_camera(storm_shake_trauma)
	await get_tree().create_timer(10).timeout
	Facts.set_fact("events/storm_happend", true)
