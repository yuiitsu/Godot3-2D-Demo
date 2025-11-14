extends Area2D

export (String, MULTILINE) var message
export (float) var message_time = 2.0

onready var message_sent: bool = false
onready var switch: Node = get_parent().get_node("Switch")

func _on_UniqueMessage_body_entered(body):
	if body.is_in_group("player") and not switch.is_active() and not message_sent:
		get_parent().write(message, message_time)
		message_sent = true



