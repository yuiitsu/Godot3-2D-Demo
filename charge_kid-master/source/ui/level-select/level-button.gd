extends ButtonModel


onready var save_file = main.get_node("SaveFileHandler")

var level: int
var pause_menu: bool



func _ready():
	if level > 0:
		self.text = "Level " + String(level)
	else:
		self.text = "Secret Level" 

func _on_LevelButton_pressed():
	if level < 0:
		main.change_scene(save_file.secret_levels[abs(level) - 1])
		return
	main.change_scene(save_file.levels[level - 1])


