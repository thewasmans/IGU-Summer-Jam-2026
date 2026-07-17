extends CanvasLayer

const TOGGLE_KEY := KEY_F1

var _panel: PanelContainer
var _tree: Tree
var _panel_visible: bool = false

func _ready() -> void:
	layer = 128
	_build_ui()
	Facts.fact_changed.connect(_on_fact_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == TOGGLE_KEY:
		_set_panel_visible(not _panel_visible)

func _on_fact_changed(_fact_key: String, _value: Variant, _previous_value: Variant) -> void:
	if _panel_visible:
		_refresh()

func _set_panel_visible(new_visible: bool) -> void:
	_panel_visible = new_visible
	_panel.visible = new_visible
	if new_visible:
		_refresh()

func _refresh() -> void:
	_tree.clear()
	var root: TreeItem = _tree.create_item()
	var folders: Dictionary = {"": root}

	var facts: Dictionary = Facts.get_all_facts()
	var keys: Array = facts.keys()
	keys.sort()

	for fact_key: String in keys:
		var segments: PackedStringArray = fact_key.trim_prefix("/").split("/")
		var parent: TreeItem = root
		var current_path: String = ""
		for i in segments.size() - 1:
			current_path = current_path + segments[i] if current_path == "" else current_path + "/" + segments[i]
			if not folders.has(current_path):
				var folder_item: TreeItem = _tree.create_item(parent)
				folder_item.set_text(0, segments[i])
				folder_item.set_selectable(0, false)
				folder_item.set_selectable(1, false)
				folders[current_path] = folder_item
			parent = folders[current_path]

		var leaf: TreeItem = _tree.create_item(parent)
		leaf.set_text(0, segments[-1])
		var value: Variant = facts[fact_key]
		if value is bool:
			leaf.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
			leaf.set_checked(1, value)
			leaf.set_editable(1, false)
		else:
			leaf.set_text(1, str(value))

func _build_ui() -> void:
	_panel = PanelContainer.new()
	_panel.name = "DebugFactsPanel"
	_panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_panel.position = Vector2(16, 16)
	_panel.custom_minimum_size = Vector2(480, 600)
	_panel.visible = false
	add_child(_panel)

	var margin: MarginContainer = MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 8)
	_panel.add_child(margin)

	var vbox: VBoxContainer = VBoxContainer.new()
	margin.add_child(vbox)

	var title: Label = Label.new()
	title.text = "Facts debug panel (F1 to toggle)"
	vbox.add_child(title)

	_tree = Tree.new()
	_tree.custom_minimum_size = Vector2(464, 560)
	_tree.hide_root = true
	_tree.columns = 2
	_tree.column_titles_visible = true
	_tree.set_column_title(0, "Path")
	_tree.set_column_title(1, "Value")
	_tree.set_column_expand(0, true)
	_tree.set_column_expand(1, true)
	vbox.add_child(_tree)
