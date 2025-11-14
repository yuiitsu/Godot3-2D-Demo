extends Node
class_name SoundControl



export(float) var master_starting_volume
export(float) var bgm_starting_volume
export(float) var sfx_starting_volume
onready var master_volume_value: float
onready var bgm_volume_value: float
onready var sfx_volume_value: float

onready var main: Node = get_parent()
onready var file_handler: FileHandler = get_parent().get_node("FileHandler")
onready var mus = AudioServer.get_bus_index("MUS")
onready var low_pass_filter: AudioEffectFilter
export var max_freq = 22000
export var min_freq = 150
onready var pitch_shift: AudioEffect

onready var player:KinematicBody2D



func _ready():
	load_sound_config()



func _physics_process(delta):
	if !get_tree().get_nodes_in_group("player").empty():
		player = get_tree().get_nodes_in_group("player")[0]



func zero_all_bgm() -> void:
	for bgm in $BGM.get_children():
		bgm.volume_db = -80



func set_volume_bgm(list:Array):
	for i in range(list.size()):
		var bgm = $BGM.get_children()[i]
		if list[i] == true:
			$FadeInOut.interpolate_property(bgm, "volume_db", null, -6, 2.0,
											Tween.TRANS_LINEAR, Tween.EASE_IN)
			$FadeInOut.start()
		else:
			$FadeInOut.interpolate_property(bgm, "volume_db", null, -80, 2.0,
											Tween.TRANS_LINEAR, Tween.EASE_IN)
			$FadeInOut.start()



func accelerate_music(scale: float):
	if scale > 0:
		AudioServer.get_bus_effect(mus, 1).pitch_scale = 1/scale
		for bgm in $BGM.get_children():
			bgm.pitch_scale = scale



func music_filter_down(final_value):
	for bgm in $BGM.get_children():
		if bgm.volume_db > -80:
			bgm.volume_db = final_value



### Functions Related to Volume control #########################################
func load_sound_config():
	if main.enable_save:
		var config_model = {
			"Master": master_starting_volume,
			"MUS": bgm_starting_volume,
			"SFX": sfx_starting_volume
		}
		var file = File.new()
		if file.file_exists("user://" + main.sound_config + ".conf"):
			file.open("user://" + main.sound_config + ".conf", File.READ)
			var file_string: String = file.get_line()
			
			if !file_handler.check_file_integrity(file_string, config_model, file.get_path()):
				file_handler.make_backup_file(file.get_path(), file_string, config_model)
				file.open("user://" + main.sound_config + ".conf", File.READ)
				file_string = file.get_line()
			
			var sound_cfg:Dictionary = parse_json(file_string)
			for bus in sound_cfg.keys():
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear2db(sound_cfg[bus]))
			file.close()
		else:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(master_starting_volume))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUS"), linear2db(bgm_starting_volume))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_starting_volume))
		master_volume_value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
		bgm_volume_value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MUS")))
		sfx_volume_value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func change_master_volume_value(linear_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(linear_value))

func change_bgm_volume_value(linear_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUS"), linear2db(linear_value))

func change_sfx_volume_value(linear_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(linear_value))
#################################################################################


