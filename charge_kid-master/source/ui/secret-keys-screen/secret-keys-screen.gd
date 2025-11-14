extends Control
class_name SecretKeysScreen



export (PackedScene) var end_scene

var next_level: int

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")



func _ready():
	var label = $CenterContainer/Label
	var keys = String(save_file.found_keys()) + "/" + String(save_file.progress["secrets"].size() - 1)
	label.text = keys + " keys broken."
	AchievementsAndStatsObserver.set_achievement("key" + String(save_file.found_keys()))



func _input(event):
	if event is InputEvent and $Timer.is_stopped():
		if event.is_action("ui_accept") or event.is_action("ui_cancel"):
				if next_level >= 17:
					main.change_scene(end_scene)
				elif next_level >= 1:
					main.change_scene(save_file.levels[next_level])
				else:
					main.back_to_start()


