class_name NetworkAreaManager
extends Manager

const LEVELS: Array[String] = ["low", "middle", "hight"]

@export var level: Node

var areas: Array[NetworkArea] = []

func initialize(game_manager: GameManager) -> void:
	super.initialize(game_manager)
	areas.assign(level.get_tree().get_nodes_in_group("NetworkArea"))
	for i in areas.size():
		areas[i].id = i
		Facts.set_fact(areas[i].fact_key, false)
		Facts.listen_fact(areas[i].fact_key, func(_value: Variant, _previous: Variant) -> void:
			_update_network_level()
		)
	_update_network_level()

func player_have_network(for_level: String = "") -> bool:
	for area in areas:
		if (for_level == "" or area.level == for_level) and Facts.get_fact(area.fact_key) == true:
			return true
	return false

func current_level() -> String:
	var best_index: int = -1
	for area in areas:
		if Facts.get_fact(area.fact_key) == true:
			best_index = maxi(best_index, LEVELS.find(area.level))
	return LEVELS[best_index] if best_index >= 0 else "disconnected"

func _update_network_level() -> void:
	Facts.set_fact("network/level_connexion", current_level())
