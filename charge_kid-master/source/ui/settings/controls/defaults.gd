extends ButtonModel

onready var label = get_parent().get_node("Label")

func _process(delta):
	if has_focus() and not self.disabled:
		label.set("custom_colors/font_color", Color("#ff4f78"))
	if not has_focus() and not self.disabled:
		label.set("custom_colors/font_color", Color("#f4f4e4"))
