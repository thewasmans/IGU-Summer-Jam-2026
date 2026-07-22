@tool
extends EditorPlugin

var current_selection: CollisionShape3D = null
var tool_button: Button = null

func _enter_tree() -> void:
	tool_button = Button.new()
	tool_button.text = "Apply Scale to Shape"
	tool_button.pressed.connect(_on_button_pressed)
	get_editor_interface().get_selection().selection_changed.connect(_on_selection_changed)

func _exit_tree() -> void:
	if tool_button:
		_remove_button_from_toolbar()
		tool_button.queue_free()

func _on_selection_changed() -> void:
	var selected_nodes = get_editor_interface().get_selection().get_selected_nodes()
	
	if selected_nodes.size() == 1 and selected_nodes[0] is CollisionShape3D:
		var node = selected_nodes[0] as CollisionShape3D
		if node.shape and (node.shape is BoxShape3D or node.shape is SphereShape3D):
			current_selection = node
			_add_button_to_toolbar()
			return
			
	current_selection = null
	_remove_button_from_toolbar()

func _add_button_to_toolbar() -> void:
	if tool_button.get_parent() == null:
		add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, tool_button)

func _remove_button_from_toolbar() -> void:
	if tool_button.get_parent() != null:
		remove_control_from_container(CONTAINER_SPATIAL_EDITOR_MENU, tool_button)

func _on_button_pressed() -> void:
	if not current_selection or not current_selection.shape:
		return

	var parent := current_selection.get_parent()
	var parent_node3d := parent as Node3D
	var parent_scale := parent_node3d.scale if parent_node3d else Vector3.ONE
	var combined_scale := current_selection.scale * parent_scale
	if combined_scale == Vector3.ONE:
		return

	if current_selection.shape is BoxShape3D:
		_process_box(current_selection.shape, combined_scale, parent_node3d)
	elif current_selection.shape is SphereShape3D:
		_process_sphere(current_selection.shape, combined_scale, parent_node3d)

func _process_box(box_shape: BoxShape3D, combined_scale: Vector3, parent_node3d: Node3D) -> void:
	var undo_redo = get_undo_redo()
	undo_redo.create_action("Apply Transform Scale to BoxShape3D")
	undo_redo.add_do_property(box_shape, "size", box_shape.size * combined_scale)
	undo_redo.add_do_property(current_selection, "scale", Vector3.ONE)
	undo_redo.add_undo_property(box_shape, "size", box_shape.size)
	undo_redo.add_undo_property(current_selection, "scale", current_selection.scale)
	if parent_node3d:
		undo_redo.add_do_property(parent_node3d, "scale", Vector3.ONE)
		undo_redo.add_undo_property(parent_node3d, "scale", parent_node3d.scale)
	undo_redo.commit_action()

func _process_sphere(sphere_shape: SphereShape3D, combined_scale: Vector3, parent_node3d: Node3D) -> void:
	var is_uniform = is_equal_approx(combined_scale.x, combined_scale.y) and is_equal_approx(combined_scale.y, combined_scale.z)

	if not is_uniform:
		_show_warning_dialog(sphere_shape, combined_scale, parent_node3d)
	else:
		_execute_sphere_scale(sphere_shape, combined_scale.x, parent_node3d)

func _show_warning_dialog(sphere_shape: SphereShape3D, combined_scale: Vector3, parent_node3d: Node3D) -> void:
	var dialog = ConfirmationDialog.new()
	dialog.title = "Warning: Non-Uniform Scale"
	dialog.dialog_text = "The current Sphere shape will be lost (deformed ellipsoids are not natively supported by SphereShape3D).\nApplying this transform will reset it to a perfect sphere based on the X scale axis."

	dialog.confirmed.connect(func():
		_execute_sphere_scale(sphere_shape, combined_scale.x, parent_node3d)
		dialog.queue_free()
	)
	dialog.canceled.connect(func():
		dialog.queue_free()
	)

	get_editor_interface().get_base_control().add_child(dialog)
	dialog.popup_centered()

func _execute_sphere_scale(sphere_shape: SphereShape3D, multiplier: float, parent_node3d: Node3D) -> void:
	var undo_redo = get_undo_redo()
	undo_redo.create_action("Apply Transform Scale to SphereShape3D")
	undo_redo.add_do_property(sphere_shape, "radius", sphere_shape.radius * multiplier)
	undo_redo.add_do_property(current_selection, "scale", Vector3.ONE)
	undo_redo.add_undo_property(sphere_shape, "radius", sphere_shape.radius)
	undo_redo.add_undo_property(current_selection, "scale", current_selection.scale)
	if parent_node3d:
		undo_redo.add_do_property(parent_node3d, "scale", Vector3.ONE)
		undo_redo.add_undo_property(parent_node3d, "scale", parent_node3d.scale)
	undo_redo.commit_action()
