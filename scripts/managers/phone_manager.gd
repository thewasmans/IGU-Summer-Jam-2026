class_name PhoneManager
extends Manager

@export var phone_ui_prefab: PackedScene
@export var root_scene: Node
@export var player_character: Character

var _phone_ui: PhoneUI
var _is_open: bool = false

func initialize(game_manager: GameManager) -> void:
	super.initialize(game_manager)
	_phone_ui = phone_ui_prefab.instantiate()
	root_scene.add_child(_phone_ui)
	Facts.set_fact("phone_open", false)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return
	if event.physical_keycode == KEY_P:
		_toggle_phone()
	elif _is_open and event.physical_keycode == KEY_TAB:
		_phone_ui.next_app()
	elif _is_open and event.is_action_pressed("action_interract"):
		_phone_ui.interact_current_app()

func _toggle_phone() -> void:
	_is_open = not _is_open
	if _is_open:
		_phone_ui.open()
	else:
		_phone_ui.close()
	if player_character:
		player_character.frozen = _is_open
	Facts.set_fact("phone_open", _is_open)
