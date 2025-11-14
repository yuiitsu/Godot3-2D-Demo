extends Area2D

export (bool) var pause_timer

func on_body_entered(body):
	if body.is_in_group("player"):
		var autoscroller = get_parent().get_node("Autoscroller")
		var tween = autoscroller.get_node("Tween")
		if autoscroller.position.x < self.position.x and not tween.is_active():
			if pause_timer:
				var timer = autoscroller.get_node("PauseTimer")
				timer.start(1 + 12/autoscroller.factor)
			tween.interpolate_property(autoscroller, "position", null, self.position, 1.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
			tween.start()


