class_name Dialogue
extends Resource

## Identifiant unique utilisé pour construire les clés de fact (dialogue et entrées).
@export var dialogue_id: String
## Durée totale du dialogue, en secondes. Détermine combien de temps la dernière entrée reste active.
@export_custom(PROPERTY_HINT_NONE, "suffix:seconds") var duration: float = 0.0
@export var entries: Array[DialogueEntry]
