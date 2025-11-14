extends Area2D

export (String, MULTILINE) var message
export (float) var message_time = 2.0

func _on_Area2D4_body_entered(body):
	if body.is_in_group("player") and $Timer.is_stopped():
		var level = get_tree().get_nodes_in_group("level")[0]
		level.write(message, message_time)
		$Timer.start()
