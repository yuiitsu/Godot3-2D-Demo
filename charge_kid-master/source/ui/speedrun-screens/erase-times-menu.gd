extends Control

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")
onready var pause_menu: bool



func _ready():
	get_tree().paused = true
	$CenterContainer/Panel/MenuContainer/Menu/Return.grab_focus()



func _on_Return_pressed():
	main.change_scene(main.speedrun_menu)



func erase_time(time: int, category: String):
	if save_file.progress[category].size() > time:
		save_file.progress[category].remove(time)
		$CenterContainer/Panel/MenuContainer/Menu/Times.update_times()
		save_file.save_progress()



func on_any_first_pressed():
	erase_time(0, "times")

func on_any_second_pressed():
	erase_time(1, "times")

func on_any_third_pressed():
	erase_time(2, "times")

func on_any_fourth_pressed():
	erase_time(3, "times")

func on_any_fifth_pressed():
	erase_time(4, "times")

func on_secret_first_pressed():
	erase_time(0, "secret_times")

func on_secret_second_pressed():
	erase_time(1, "secret_times")

func on_secret_third_pressed():
	erase_time(2, "secret_times")

func on_secret_fourth_pressed():
	erase_time(3, "secret_times")

func on_secret_fifth_pressed():
	erase_time(4, "secret_times")


