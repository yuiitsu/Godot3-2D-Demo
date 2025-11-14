extends Control



export (PackedScene) var level_button

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")
onready var progress = 0
onready var level_list = get_node("CenterContainer/MarginContainer/MarginContainer/VBoxContainer/LevelList")
onready var return_button = get_node("CenterContainer/MarginContainer/MarginContainer/VBoxContainer/Return")

var pause_menu



func _ready():
	get_tree().paused = true
	progress = save_file.progress["levels"]
	
	# Creating level buttons
	for level in range(progress):
		var button = level_button.instance()
		button.level = level + 1
		if pause_menu:
			button.pause_menu = true
		level_list.add_child(button)
	
	if secret_level_unlocked():
		var button = level_button.instance()
		button.level = -1
		level_list.add_child(button)
		progress += 1
	
	# Setting level buttons' neighbors
	for level in range(progress):
		if level > 0:
			level_list.get_child(level).focus_neighbour_top = level_list.get_child(level - 1).get_path()
		else:
			level_list.get_child(level).focus_neighbour_top = return_button.get_path()
		if level < progress - 1:
			level_list.get_child(level).focus_neighbour_bottom = level_list.get_child(level + 1).get_path()
		else:
			level_list.get_child(level).focus_neighbour_bottom = return_button.get_path()
	
	# Setting return button neighbors
	return_button.focus_neighbour_top = level_list.get_child(progress - 1).get_path()
	return_button.focus_neighbour_bottom = level_list.get_child(0).get_path()
	
	level_list.get_child(0).grab_focus()



func _on_Return_pressed():
	if not pause_menu:
		main.back_to_start()
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().refocus()
		get_parent().self_show()
		self.queue_free()

func secret_level_unlocked() -> bool:
	var keys = save_file.progress["secrets"]
	var result: bool = true
	for i in range(keys.size() - 1):
		result = result and keys[i]
	return result
