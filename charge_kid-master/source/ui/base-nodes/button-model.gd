extends MenuOption
class_name ButtonModel

export (bool) var no_accept_sound

func _process(_delta):
	if has_focus() and self.disabled:
		set("custom_colors/font_color_disabled", Color("#535e69"))
	elif not has_focus() and self.disabled:
		set("custom_colors/font_color_disabled", Color("#242a3b"))

func _on_ButtonModel_pressed():
	if not no_accept_sound:
		main.get_node("MenuNavigation/MenuAccept").play()
		main.get_node("MenuNavigation/MenuAcceptTimer").start()
		if main.get_node("MenuNavigation/MenuNavigate").is_playing():
			main.get_node("MenuNavigation/MenuNavigate").stop()
