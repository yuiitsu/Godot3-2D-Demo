extends Control

var main



func _ready():
	if get_tree().get_nodes_in_group("main").size() > 0:
		main = get_tree().get_nodes_in_group("main")[0]
		main.get_node("BackgroundAndMusicHandler").zero_all_bgm()
		var save_file = main.get_node("SaveFileHandler")
		save_file.progress["end"] = true
		save_file.save_progress()
	else:
		main = null



func _input(event):
	if event is InputEvent and $Timer.is_stopped():
		if event.is_action("ui_accept") or event.is_action("ui_cancel"):
			if main == null:
				get_tree().quit()
			else:
				main.change_scene(main.credits)


