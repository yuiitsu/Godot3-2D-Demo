extends Control



onready var control_handler : ButtonGetter = get_tree().get_nodes_in_group("main")[0].control_handler
onready var main = get_tree().get_nodes_in_group("main")[0]
onready var menu = get_node("CenterContainer/MarginContainer/MarginContainer/VBoxContainer/VBoxContainer")

func _ready():
	menu.get_children()[0].grab_focus()
	if main.get_node("SpeedrunMode").is_active():
		menu.get_node("LevelList").disabled = true

func close_pause_menu() -> void:
	get_tree().paused = false
	self.queue_free()

func _on_Resume_pressed():
	get_tree().paused = false
	self.queue_free()

func _on_RestartLevel_pressed():
	get_tree().paused = false
	self.queue_free()
	if get_tree().get_nodes_in_group("main").size() > 0:
		var level = main.get_level().level
		main.change_scene(main.get_node("SaveFileHandler").levels[level - 1])
	else:
		get_tree().reload_current_scene()

func _on_Settings_pressed():
	self.pause_mode = PAUSE_MODE_STOP
	var new_window = main.settings_menu.instance()
	new_window.pause_menu = true
	self_hide()
	self.add_child(new_window)

func self_hide() -> void:
	$CenterContainer.hide()

func self_show() -> void:
	$CenterContainer.show()

func _on_Quit_pressed():
	get_tree().quit()

func _on_LevelList_pressed():
	self.pause_mode = PAUSE_MODE_STOP
	var new_window = main.level_select.instance()
	new_window.pause_menu = true
	self_hide()
	self.add_child(new_window)

func refocus() -> void:
	menu.get_children()[0].grab_focus()


func _on_MainMenu_pressed():
	close_pause_menu()
	main.back_to_start()
