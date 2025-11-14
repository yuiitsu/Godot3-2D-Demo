extends Area2D



var button

func _process(delta):
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main
		main = get_tree().get_nodes_in_group("main")[0]
		if main.is_using_keyboard():
			button = main.control_handler.get_keyboard_key_name("action_shoot")
		elif main.is_using_controller():
			button = main.control_handler.get_controller_button_name("action_shoot", main.controller_layout)
	else:
		button = "X"
	
	if $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				if body.has_bullet:
					$Text.write(button + ": shoot")
	else:
		$Text.text = button + ": shoot"

func _ready():
	visible = true



