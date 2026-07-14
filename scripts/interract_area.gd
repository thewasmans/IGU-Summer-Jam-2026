class_name Interract_Area
extends Area3D

signal player_entered
signal player_exited
signal player_completed

@export var description: String
var can_interract: bool
var completed: bool

func _unhandled_input(event: InputEvent) -> void:
	if can_interract and not completed:
		if event.is_action_pressed("action_interract"):
			completed = true
			player_completed.emit()

func _on_body_entered(_body):
	can_interract = true
	player_entered.emit()

func _on_body_exited(_body):
	can_interract = false
	player_exited.emit()
