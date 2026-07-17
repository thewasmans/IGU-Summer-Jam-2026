class_name DialogueEntry
extends Resource

@export var speaker_name: String
## Instant, en secondes depuis le début du dialogue, auquel cette entrée devient active.
@export_custom(PROPERTY_HINT_NONE, "suffix:seconds") var timecode: float = 0.0
@export_multiline var text: String
