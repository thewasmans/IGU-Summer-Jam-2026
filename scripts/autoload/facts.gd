extends Node

signal fact_changed(fact_key: String, value: Variant, previous_value: Variant)

var _facts: Dictionary = {}

func set_fact(fact_key: String, value: Variant) -> void:
	var previous_value: Variant = _facts.get(fact_key)
	if _facts.has(fact_key) and previous_value == value:
		return
	_facts[fact_key] = value
	fact_changed.emit(fact_key, value, previous_value)

func get_fact(fact_key: String, default_value: Variant = null) -> Variant:
	return _facts.get(fact_key, default_value)

func has_fact(fact_key: String) -> bool:
	return _facts.has(fact_key)

func listen_fact(fact_key: String, callback: Callable) -> void:
	fact_changed.connect(func(changed_key: String, value: Variant, previous_value: Variant) -> void:
		if changed_key == fact_key:
			callback.call(value, previous_value)
	)
