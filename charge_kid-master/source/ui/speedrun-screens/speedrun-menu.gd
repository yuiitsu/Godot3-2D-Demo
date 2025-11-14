extends Control

export (PackedScene) var speedrun_start
export (ShortCut) var return_shortcut



onready var main: Node
onready var save_file: Node
onready var pause_menu: bool



func _ready():
	get_tree().paused = true
	if not get_tree().get_nodes_in_group("main").empty():
		main = get_tree().get_nodes_in_group("main")[0]
		save_file = main.get_node("SaveFileHandler")
		
		var secret_percent = $CenterContainer/MarginContainer/MarginContainer/Menu/Options/SecretPercent
		var checkbox = $CenterContainer/MarginContainer/MarginContainer/Menu/Options/FasterSidescrollers/CheckBox
		checkbox.pressed = save_file.progress["faster_autoscrollers"]
		secret_percent.disabled = not save_file.progress["secrets"].back()
	refocus()



func _on_Return_pressed():
	main.back_to_start()



func _on_Any_pressed():
	main.get_node("SpeedrunMode").ready("times")
	main.change_scene(speedrun_start)



func _on_Secret_pressed():
	main.get_node("SpeedrunMode").ready("secret_times")
	main.change_scene(speedrun_start)



func _on_FasterSidescrollers_toggle(button_pressed):
	save_file.progress["faster_autoscrollers"] = button_pressed
	save_file.save_progress()



func _on_Erase_pressed():
	main.change_scene(main.erase_times_menu)



func refocus() -> void:
	$CenterContainer/MarginContainer/MarginContainer/Menu/Options/AnyPercent.grab_focus()



