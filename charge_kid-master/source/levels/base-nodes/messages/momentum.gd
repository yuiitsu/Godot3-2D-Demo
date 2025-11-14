extends Area2D



func _process(delta):
	if $Timer.is_stopped() and $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				$Text.write(" Try using the momentum \n of a bullet boost!")

func _ready():
	visible = true


