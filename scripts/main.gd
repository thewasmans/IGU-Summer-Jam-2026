class_name Main
extends Node

@export var game_manager: GameManager
@export var player_character: Character

@export_range(0.0, 1.0, 0.01) var storm_shake_trauma: float = 1.0

@export var particles: Array[GPUParticles3D]

@export var example_dialogue: Dialogue

func _ready() -> void:
	game_manager.initialize()
	for part in particles:
		part.emitting = false

func _on_timer_timeout() -> void:
	if player_character:
		for part in particles:
			part.emitting = true
		await get_tree().create_timer(1).timeout
		player_character.shake_camera(storm_shake_trauma)
		await get_tree().create_timer(10).timeout
		Facts.set_fact("events/storm_happend", true)
