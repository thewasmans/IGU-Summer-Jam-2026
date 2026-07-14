extends Manager
class_name InterractAreaManager

@export var level: Node

var game_ui: GameUI
var current_area: Interract_Area

func initialize(game_manager:GameManager):
	super.initialize(game_manager)
	var areas := level.get_tree().get_nodes_in_group("AreaInterract")
	for area: Interract_Area in areas:
		area.player_entered.connect(_on_player_entered.bind(area))
		area.player_exited.connect(_on_player_exited)
		area.player_completed.connect(_on_player_exited)
	game_ui = _game_manager.game_ui_manager._game_ui
		
func _on_player_entered(area: Interract_Area):
	current_area = area
	if area.interract_type == "Pressed":
		if not area.completed:
			game_ui.set_visible_interract_label(true)
	elif area.interract_type == "Stay":
		if not area.completed:
			game_ui.set_visible_interract_label(true)
			game_ui.set_value_progress_interract(0)
			game_ui.set_visible_progress_interract(true)

func _on_player_exited():
	game_ui.set_visible_interract_label(false)
	game_ui.set_visible_progress_interract(false)

func _process(delta: float):
	if current_area:
		if current_area.interract_started:
			game_ui.set_value_progress_interract(current_area.timer.wait_time - current_area.timer.time_left)
		else:
			game_ui.set_value_progress_interract(0)
