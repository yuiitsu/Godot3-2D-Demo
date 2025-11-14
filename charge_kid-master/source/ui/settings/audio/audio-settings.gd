extends Control

export(ShortCut) var return_shortcut

onready var main: Main
onready var pause_menu: bool
onready var sound_control: SoundControl = get_tree().get_nodes_in_group("sound_control")[0]
onready var master_slider = $CenterContainer/MarginContainer/MarginContainer/Options/Buttons/Master
onready var bgm_slider = $CenterContainer/MarginContainer/MarginContainer/Options/Buttons/BGM
onready var sfx_slider = $CenterContainer/MarginContainer/MarginContainer/Options/Buttons/SFX

func _ready():
	get_tree().paused = true
	if !get_tree().get_nodes_in_group("main").empty():
		main = get_tree().get_nodes_in_group("main")[0]
	master_slider.grab_focus()

func _on_Return_pressed():
	save_sound_settings()
	if not pause_menu:
		main.change_scene(main.settings_menu)
	else:
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		get_parent().self_show()
		get_parent().refocus()
		self.queue_free()

func save_sound_settings() -> void:
	var save:= File.new()
	save.open("user://" + main.sound_config + ".conf", File.WRITE)
	var sound_cfg:Dictionary = {
		"Master":db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('Master'))),
		"MUS":db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('MUS'))),
		"SFX": db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('SFX')))
	}
	save.store_line(to_json(sound_cfg))
	save.close()
	pass

func _on_Default_pressed():
	master_slider.slider.value = sound_control.master_starting_volume
	bgm_slider.slider.value = sound_control.bgm_starting_volume
	sfx_slider.slider.value = sound_control.sfx_starting_volume
