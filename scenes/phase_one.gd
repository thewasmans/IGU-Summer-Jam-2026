extends Node

@export var	dlg_phase_one : Dialogue
@export var dlg_radio_weather: Dialogue
@export var player_character: Character
@export_range(0.0, 1.0, 0.01) var storm_shake_trauma: float = 1.0
@export var particles: Array[GPUParticles3D]
@export var sfx_avalanche_impact: AudioStreamPlayer3D
@export var ambiant_avalanche: AudioStreamPlayer3D

func _ready():
	for part in particles:
		part.emitting = false
	Facts.listen_fact("dialogues/radio_weather/entry_1_completed", _on_radio_entry_1_completed)
	Facts.listen_fact("dialogues/radio_weather/entry_2_completed", _on_radio_entry_2_completed)
	await get_tree().create_timer(3.0).timeout
	DialogueManager.play_dialogue(dlg_radio_weather)

func _on_large_point_player_entered():
	DialogueManager.play_dialogue(dlg_phase_one)
	
func _on_radio_entry_2_completed(_val: Variant, _prev: Variant):
	_play_storm_vfx()

func _play_storm_vfx() -> void:
	for part in particles:
		part.emitting = true
		
	await get_tree().create_timer(1).timeout
	sfx_avalanche_impact.play()
	player_character.shake_camera(storm_shake_trauma)
	
	await get_tree().create_timer(2).timeout
	create_tween()\
		.tween_property(ambiant_avalanche, "volume_db", -30.0, 10)
	
	await get_tree().create_timer(7).timeout
	Facts.set_fact("events/storm_happend", true)

func _on_radio_entry_1_completed(_val: Variant, _prev: Variant):
	ambiant_avalanche.play()
	create_tween()\
		.tween_property(ambiant_avalanche, "volume_db", 15.0, 15)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_EXPO)
