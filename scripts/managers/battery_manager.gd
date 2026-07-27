class_name BatteryManager
extends Manager

const FACT_BATTERY_LEVEL := "battery/level"
const FACT_PHONE_OUT := "battery/phone_out"

@export var max_battery: float = 100.0
@export var drain_rate_idle: float = 0.0
@export var drain_rate_phone_out: float = 2.0

var current_battery: float

func initialize(game_manager: GameManager):
	super.initialize(game_manager)
	current_battery = max_battery
	Facts.set_fact(FACT_BATTERY_LEVEL, current_battery)
	Facts.set_fact(FACT_PHONE_OUT, false)

func _process(delta: float) -> void:
	if current_battery <= 0.0:
		return

	var phone_out: bool = Facts.get_fact(FACT_PHONE_OUT) == true
	var rate := drain_rate_phone_out if phone_out else drain_rate_idle
	if rate > 0.0:
		_drain(rate * delta)

func _drain(amount: float) -> void:
	current_battery = max(current_battery - amount, 0.0)
	Facts.set_fact(FACT_BATTERY_LEVEL, current_battery)

func get_percent() -> float:
	return (current_battery / max_battery) * 100.0
