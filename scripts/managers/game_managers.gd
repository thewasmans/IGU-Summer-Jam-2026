extends Node
class_name GameManager

signal initialized

@export var game_data: GameData
@export_category("Managers")
@export var game_ui_manager: GameUIManager
@export var area_interract_manager: InterractAreaManager
@export var phone_manager: PhoneManager
@export var dialogue_manager: DialogueManager

var game_state:GameState
var managers:Array[Manager]:
	get:
		return [game_ui_manager, area_interract_manager, phone_manager, dialogue_manager]

func initialize():
	game_state = GameState.new(game_data)
	for manager in managers:
		manager.initialize(self)
	initialized.emit()
