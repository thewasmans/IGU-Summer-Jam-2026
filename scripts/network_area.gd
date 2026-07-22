class_name NetworkArea
extends Area3D

@export_enum("low", "middle", "hight") var level: String = "middle"
var id: int

var fact_key: String:
	get:
		return "network/" + name + "_" + str(id)

func _on_body_entered(_body: Node3D) -> void:
	Facts.set_fact(fact_key, true)

func _on_body_exited(_body: Node3D) -> void:
	Facts.set_fact(fact_key, false)
