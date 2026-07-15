class_name Interract_Area
extends Area3D

signal player_entered
signal player_exited
signal player_completed

## Define the behavior of the interract[br][br]
## [b]Pressed[/b]: the interraction is completed when the player press the action_interract.[br][br]
## [b]Stay[/b]: the interraction is completed when the player stay pressed the key until the end of the completion.[br] [br]
## [b]Entered[/b]: the interraction is completed when the player entered in the area
## [b]Wait[/b]: the interraction is completed when the player entered in the area and waiting the the stay time
@export_enum("Pressed", "Stay", "Entered", "Wait") var interract_type: String = "Pressed"
## Used for Stay and Wait [b]interract_type[/b]
@export_custom(PROPERTY_HINT_NONE, "suffix:seconds") var stay_time: float = 5
@export var locked_by_facts: Array[String]
## This field only use like a comment to help the level designer
@export var description: String
var timer : Timer:
	get:
		return %Timer
var can_interract: bool
var interract_started: bool
var completed: bool

func _ready():
	Facts.set_fact(str(get_path()) + "_completed", "false")

func _unhandled_input(event: InputEvent) -> void:
	if can_interract and not completed and not area_locked_by_fact():
		if interract_type == "Pressed":
			if event.is_action_pressed("action_interract"):
				_complete_interract()
		elif interract_type == "Stay":
			if event.is_action_pressed("action_interract"):
				interract_started = true
				%Timer.start(stay_time)
			elif event.is_action_released("action_interract") and interract_started:
				interract_started = false
				%Timer.stop()
		elif interract_type == "Entered":
			_complete_interract()
		elif interract_type == "Wait" and not interract_started:
			interract_started = true
			%Timer.start(stay_time)

func _on_body_entered(_body):
	can_interract = true
	player_entered.emit()

func _on_body_exited(_body):
	can_interract = false
	interract_started = false
	%Timer.stop()
	player_exited.emit()

func _on_timer_timeout():
	_complete_interract()
	
func _complete_interract():
	Facts.set_fact(str(get_path()) + "_completed", "true")
	completed = true
	player_completed.emit()

func area_locked_by_fact() -> bool:
	for fact in locked_by_facts:
		if Facts.get_fact(fact) == false:
			return true
	return false
