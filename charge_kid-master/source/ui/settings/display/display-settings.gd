extends Control


onready var main: Main
onready var pause_menu: bool
onready var loaded: bool = false

onready var windowed_button = $CenterContainer/Margin/Margin/Menu/Options/Windowed/ButtonModel
onready var windowed_label = $CenterContainer/Margin/Margin/Menu/Options/Windowed/Windowed
onready var windowed_size_label = $CenterContainer/Margin/Margin/Menu/Options/Windowed/Resolution
onready var fullscreen_button = $CenterContainer/Margin/Margin/Menu/Options/Fullscreen/CheckBox
onready var fullscreen_label = $CenterContainer/Margin/Margin/Menu/Options/Fullscreen/Label
onready var borderless_window_button = $CenterContainer/Margin/Margin/Menu/Options/BorderlessWindow/CheckBox
onready var borderless_window_label = $CenterContainer/Margin/Margin/Menu/Options/BorderlessWindow/Label
onready var return_button = $CenterContainer/Margin/Margin/Menu/Options/Return

# These screen sizes are 16:9 aspect ratio, the game's aspect ratio.
onready var screen_sizes = [Vector2(1024,576),
							Vector2(1152,648),
							Vector2(1280,720),
							Vector2(1366,768),
							Vector2(1600,900),
							Vector2(1920,1080), # Full HD
							Vector2(2560,1440), # 2k
							Vector2(3840,2160), # QHD
							Vector2(7680,4320), # 8k
							]

onready var window_size: Vector2 = Vector2(1024,576)



func _ready():
	fullscreen_button.pressed = OS.window_fullscreen
	if fullscreen_button.pressed or !OS.window_borderless:
		borderless_window_button.pressed = false
	else:
		borderless_window_button.pressed = true
	get_tree().paused = true
	if !get_tree().get_nodes_in_group("main").empty():
		main = get_tree().get_nodes_in_group("main")[0]
	refocus()



func _process(_delta):
	windowed_button.disabled = $CenterContainer/Margin/Margin/Menu/Options/Fullscreen/CheckBox.pressed
	borderless_window_button.disabled = $CenterContainer/Margin/Margin/Menu/Options/Fullscreen/CheckBox.pressed
	if windowed_button.disabled:
		fullscreen_button.focus_neighbour_bottom = return_button.get_path()
		return_button.focus_neighbour_top = fullscreen_button.get_path()
		windowed_label.set("custom_colors/font_color", Color("#7f7f76"))
		windowed_size_label.set("custom_colors/font_color", Color("#7f7f76"))
	else:
		fullscreen_button.focus_neighbour_bottom = borderless_window_button.get_path()
		return_button.focus_neighbour_top = windowed_button.get_path()
	window_size = OS.window_size
	if screen_sizes.has(window_size):
		windowed_size_label.text = window_size.x as String + "x" + window_size.y as String
	else:
		windowed_size_label.text = "Custom(" + str(window_size.x) + "x" + str(window_size.y) + ")"
	
	### Recolor windowed and fullscreen buttons due to focus ##########################
	if windowed_button.has_focus():
		windowed_label.set("custom_colors/font_color", Color("#ff4f78"))
		windowed_size_label.set("custom_colors/font_color", Color("#ff4f78"))
	elif !windowed_button.disabled:
		windowed_label.set("custom_colors/font_color", Color("#f4f4e4"))
		windowed_size_label.set("custom_colors/font_color", Color("#f4f4e4"))
	if fullscreen_button.has_focus():
		fullscreen_label.set("custom_colors/font_color", Color("#ff4f78"))
	else:
		fullscreen_label.set("custom_colors/font_color", Color("#f4f4e4"))
	###################################################################################
	
	loaded = true



func _on_Windowed_pressed():
	OS.window_fullscreen = false
	if screen_sizes.has(window_size):
		var pos = screen_sizes.find(window_size)
		var next_size = screen_sizes[pos + 1]
		if next_size.x <= OS.get_screen_size().x and next_size.y <= OS.get_screen_size().y:
			OS.window_size = next_size
		else:
			OS.window_size = screen_sizes[0]
	else:
		OS.window_size = screen_sizes[0]
	window_size = OS.window_size
	OS.center_window()
	save_display_options()



func _on_Fullscreen_toggle(button_pressed):
	if button_pressed != OS.window_fullscreen:
		OS.window_fullscreen = button_pressed
		window_size = OS.window_size
		save_propety("window_fullscreen")



func _on_BorderlessWindow_toggle(button_pressed):
	if button_pressed != OS.window_borderless:
		OS.window_borderless = button_pressed
		window_size = OS.window_size
		save_display_options()



func _on_Return_pressed():
	if not pause_menu:
		main.change_scene(main.settings_menu)
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().self_show()
		get_parent().refocus()
		self.queue_free()



func refocus() -> void:
	fullscreen_button.grab_focus()

func self_hide() -> void:
	$CenterContainer.hide()

func self_show() -> void:
	$CenterContainer.show()

func save_display_options() -> void:
	if main.enable_save:
		if !loaded:
			return
		var options_dictionary: Dictionary = {}
		options_dictionary["window_fullscreen"] = fullscreen_button.pressed
		options_dictionary["window_borderless"] = borderless_window_button.pressed
		options_dictionary["window_size.x"] = window_size.x
		options_dictionary["window_size.y"] = window_size.y
		var file = File.new()
		file.open("user://display_config.conf", File.WRITE)
		file.store_line(to_json(options_dictionary))
		file.close()

func save_propety(property: String) -> void:
	if main.enable_save:
		var file = File.new()
		var options_dictionary: Dictionary
		if !file.file_exists("user://display_config.conf"):
			save_display_options()
			
		file.open("user://display_config.conf", File.READ)
		options_dictionary = parse_json(file.get_line())
		file.close()
		match property:
			"window_fullscreen":
				options_dictionary["window_fullscreen"] = fullscreen_button.pressed
			"window_borderless":
				options_dictionary["window_borderless"] = borderless_window_button.pressed
			"window_size.x":
				options_dictionary["window_size.x"] = window_size.x
			"window_size.y":
				options_dictionary["window_size.y"] = window_size.y
			_:
				print("ERROR: nonexistante property in save_property()")
		file.open("user://display_config.conf", File.WRITE)
		file.store_line(to_json(options_dictionary))
		file.close()





