extends CenterContainer


onready var main = get_tree().get_nodes_in_group("main")[0]
onready var speedrun_mode = main.get_node("SpeedrunMode")
onready var save_file = main.get_node("SaveFileHandler")
onready var time: int = 5
onready var countdown = $VBoxContainer/Countdown



func _ready():
	speedrun_mode.get_node("Countdown").play()
	main.get_node("BackgroundAndMusicHandler").zero_all_bgm()

func _on_Timer_timeout():
	if time > 1:
		time -= 1
		countdown.text = String(time)
		speedrun_mode.get_node("Countdown").play()
		$Timer.start()
	else:
		speedrun_mode.go()
		main.change_scene(save_file.levels[0])

