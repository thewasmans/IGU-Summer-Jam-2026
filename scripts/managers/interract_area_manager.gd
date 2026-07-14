extends Manager
class_name InterractAreaManager

@export var level: Node

func initialize(game_manager:GameManager):
	super.initialize(game_manager)
	var areas := level.get_tree().get_nodes_in_group("AreaInterract")
	for area: Interract_Area in areas:
		area.player_entered.connect(_on_player_entered.bind(area))
		area.player_exited.connect(_on_player_exited)
		area.player_completed.connect(_on_player_exited)
		
func _on_player_entered(area: Interract_Area):
	if not area.completed:
		_game_manager.game_ui_manager._game_ui.set_visible_interract_label(true)

func _on_player_exited():
	_game_manager.game_ui_manager._game_ui.set_visible_interract_label(false)
