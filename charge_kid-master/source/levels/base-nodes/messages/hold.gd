extends Area2D



func _process(delta):
	var button
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		if main.is_using_keyboard():
			button = main.control_handler.get_keyboard_key_name("action_shoot")
		elif main.is_using_controller():
			button = main.control_handler.get_controller_button_name("action_shoot", main.controller_layout)
	else:
		button = "X"
	
	if $Text.percent_visible == 0:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				$Text.write("Hold " + button + ": hold bullet in place")
	else:
		$Text.text = "Hold " + button + ": hold bullet in place"

func _ready():
	visible = true


