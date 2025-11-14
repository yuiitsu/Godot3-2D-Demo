extends MarginContainer

func _physics_process(delta):
	var text: String
	if not get_tree().get_nodes_in_group("player").empty():
		text = ""
		var player = get_tree().get_nodes_in_group("player")[0]
		for i in range (0, player.stack.size()):
			if i == 0:
				$VBoxContainer/Label2.text = player.stack[i]
			else:
				text += player.stack[i] + "\n"
	$VBoxContainer/Label.text = text
