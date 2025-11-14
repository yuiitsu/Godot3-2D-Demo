extends Label

func write(message: String) -> void:
	var time = message.length()*0.03
	percent_visible = 0
	text = message
	$Tween.interpolate_property(self, "percent_visible", 0, 1, time,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func clear() -> void:
	text = ""
	percent_visible = 0


