extends HBoxContainer

onready var white: Color = Color("#f6f6e6")
onready var pink: Color = Color("#ff4c7b")

func _process(_delta):
	if $Default.has_focus():
		$Label.set("custom_colors/font_color", pink)
	else:
		$Label.set("custom_colors/font_color", white)
