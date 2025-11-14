extends Area2D



# This node is only present on levels 1 to 16, won't appear on levels
# 17 and the secret level.
func _on_FinishLine_body_entered(body):
	if body.is_in_group("player") and get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var speedrun_mode = main.get_node("SpeedrunMode")
		var level_scene = get_tree().get_nodes_in_group("level")[0]
		var level = level_scene.level
		if speedrun_mode.is_active() and speedrun_mode.category == "secret_times":
			if level == 3 or level == 7 or level == 11 or level == 13:
				return

		var next_level = main.get_node("SaveFileHandler").levels[level]
		main.change_scene(next_level)

