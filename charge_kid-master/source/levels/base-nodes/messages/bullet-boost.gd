extends Area2D



func _process(delta):
	var button
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		if main.is_using_keyboard():
			button = main.control_handler.get_keyboard_key_name("action_bullet_boost")
		elif main.is_using_controller():
			button = main.control_handler.get_controller_button_name("action_bullet_boost", main.controller_layout)
	else:
		button = "F"
	
	if $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				if body.can_boost:
					$Text.write(button + " while holding bullet:\n boost to bullet")
	else:
		$Text.text = button + " while holding bullet:\n boost to bullet"

func _ready():
	visible = true

