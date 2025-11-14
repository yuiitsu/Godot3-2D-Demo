extends Area2D

export (String) var message
export (float) var message_time = 2.0



func _on_Lv15Unique_body_entered(body):
	if body.is_in_group("player") and not $Timer.is_stopped():
		get_parent().write(message, message_time)

func _on_SubArea_body_exited(body):
	if body.is_in_group("player"):
		$Timer.start()


