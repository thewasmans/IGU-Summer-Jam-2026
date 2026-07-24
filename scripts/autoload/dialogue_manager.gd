extends Node

signal dialogue_started(dialogue: Dialogue)
signal entry_started(dialogue: Dialogue, entry: DialogueEntry, entry_index: int)
signal entry_completed(dialogue: Dialogue, entry: DialogueEntry, entry_index: int)
signal dialogue_completed(dialogue: Dialogue)

var _current_dialogue: Dialogue
var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)

func is_playing() -> bool:
	return _current_dialogue != null

func play_dialogue(dialogue: Dialogue) -> void:
	if is_playing():
		push_warning("DialogueManager: dialogue '%s' already playing, ignoring '%s'." % [_current_dialogue.dialogue_id, dialogue.dialogue_id])
		return
	_current_dialogue = dialogue
	dialogue_started.emit(dialogue)
	_play_entry(0)

func _play_entry(entry_index: int) -> void:
	var dialogue := _current_dialogue
	if entry_index >= dialogue.entries.size():
		_finish_dialogue(dialogue)
		return
	var entry := dialogue.entries[entry_index]
	entry_started.emit(dialogue, entry, entry_index)
	var wait_time := _entry_duration(dialogue, entry_index)
	if wait_time > 0.0:
		_timer.start(wait_time)
		await _timer.timeout
	_finish_entry(dialogue, entry, entry_index)
	_play_entry(entry_index + 1)

func _entry_duration(dialogue: Dialogue, entry_index: int) -> float:
	var next_timecode := dialogue.duration
	if entry_index + 1 < dialogue.entries.size():
		next_timecode = dialogue.entries[entry_index + 1].timecode
	return maxf(next_timecode - dialogue.entries[entry_index].timecode, 0.0)

func _finish_entry(dialogue: Dialogue, entry: DialogueEntry, entry_index: int) -> void:
	Facts.set_fact(_entry_fact_key(dialogue, entry_index), true)
	entry_completed.emit(dialogue, entry, entry_index)

func _finish_dialogue(dialogue: Dialogue) -> void:
	_current_dialogue = null
	Facts.set_fact(_dialogue_fact_key(dialogue), true)
	dialogue_completed.emit(dialogue)

static func _dialogue_fact_key(dialogue: Dialogue) -> String:
	return "dialogues/%s/dialogue_completed" % dialogue.dialogue_id

static func _entry_fact_key(dialogue: Dialogue, entry_index: int) -> String:
	return "dialogues/%s/entry_%d_completed" % [dialogue.dialogue_id, entry_index]
