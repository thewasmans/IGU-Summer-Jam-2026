class_name PhoneSecoursApp
extends PhoneApp

enum State { IDLE, CONFIRM, CALLING, DONE }

@export var storm_fact_key: String = "events/storm_happend"
## Fact set as soon as the call is confirmed by the player.
@export var fact_key: String = "secours_called"
## Fact set once every message from the emergency services has arrived.
@export var completion_fact_key: String = "secours_instructions_received"

## Message sent by the player once the call is confirmed.
@export var caller_message: String = "Besoin d'aide, la tempête a tout dévasté ici !"
## Messages sent one by one by the emergency services after the call, each delayed by message_delay.
@export var messages: Array[String] = [
	"Nous avons bien reçu votre demande.",
	"On va vous envoyer une équipe.",
	"Mais nous avons besoin de vous localiser.",
	"Et on va vous donner des instructions pour vous garder en sécurité jusqu'à l'arrivée.",
	"Pour vous localiser vous devez activer votre géolocalisation.",
]
## Minimum delay before a message arrives, regardless of its length.
@export_custom(PROPERTY_HINT_NONE, "suffix:seconds") var base_delay: float = 0.5
## Extra delay added per character in the message, so longer messages take longer to arrive.
@export_custom(PROPERTY_HINT_NONE, "suffix:seconds") var delay_per_character: float = 0.03
## Upper bound on the delay, so very long messages don't take forever to arrive.
@export_custom(PROPERTY_HINT_NONE, "suffix:seconds") var max_delay: float = 4.0

@export var message_label: Label
@export var hint_label: Label

var _state: State = State.IDLE

func _ready() -> void:
	Facts.listen_fact(storm_fact_key, func(_value: Variant, _previous: Variant) -> void:
		_update_display()
	)
	_update_display()

func interact() -> void:
	if not _is_storm_active():
		return
	match _state:
		State.IDLE:
			_state = State.CONFIRM
			message_label.text = "Appeler les secours ?"
			hint_label.text = "Appuie sur [ E ] pour confirmer"
		State.CONFIRM:
			_state = State.CALLING
			Facts.set_fact(fact_key, true)
			message_label.text = "Vous: %s" % caller_message
			hint_label.text = "Appel en cours..."
			_play_messages()
		State.CALLING, State.DONE:
			pass

func _play_messages() -> void:
	for message in messages:
		await get_tree().create_timer(_delay_for_message(message)).timeout
		message_label.text += "\nSecours: %s" % message
	_state = State.DONE
	hint_label.text = "Instructions reçues"
	Facts.set_fact(completion_fact_key, true)

func _delay_for_message(message: String) -> float:
	return clampf(base_delay + message.length() * delay_per_character, base_delay, max_delay)

func _update_display() -> void:
	if _state != State.IDLE:
		return
	if _is_storm_active():
		message_label.text = "Appuie sur [ E ] pour appeler les secours"
		hint_label.text = ""
	else:
		message_label.text = "Aucun réseau disponible"
		hint_label.text = "Indisponible"

func _is_storm_active() -> bool:
	return Facts.get_fact(storm_fact_key) == true
