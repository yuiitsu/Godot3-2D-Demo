extends Area2D



func _process(delta):
	if $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				$Text.write("Try letting go of the \n bullet and holding again!")

func _ready():
	visible = true


