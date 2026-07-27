extends Node

@export_file("*.tscn") var main_scene: String
@export_file("*.tscn") var option_menu: String

func _on_start_pressed():
	get_tree().change_scene_to_file(main_scene)

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file(option_menu)

func _on_quit_pressed():
	get_tree().quit()
