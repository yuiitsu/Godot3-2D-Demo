extends Node2D
class_name BaseLevel



export (int) var level

export (Array, bool) var bgm_playing
export (Array, bool) var speedrun_bgm_playing

export (bool) var auto_scroller
export (Array, NodePath) var checkpoints
var respawn_point: int = 0

export (PackedScene) var player_scene

onready var message = $MessageLabel
onready var message_timer = get_node("MessageLabel/Timer")

var player_died:bool = false

var level_length: float



func _ready():
	var last_tile = 0
	for tile in $LevelLimits.get_used_cells():
		if tile.x > last_tile:
			last_tile = tile.x
	level_length = last_tile*16
	
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var sound_control = main.get_node("BackgroundAndMusicHandler")
		var speedrun_mode = main.get_node("SpeedrunMode")
		var save_file = main.get_node("SaveFileHandler")
		
		if not speedrun_mode.is_active():
			sound_control.set_volume_bgm(bgm_playing)
		else:
			sound_control.set_volume_bgm(speedrun_bgm_playing)
		
		if level != 18:
			save_file.progress["levels"] = max(level, save_file.progress["levels"])
			save_file.save_progress()
	
	if auto_scroller and respawn_point > 0:
		var checkpoint = get_node(checkpoints[respawn_point - 1])
		$Player.position = checkpoint.position
		$Autoscroller.position = checkpoint.position + checkpoint.get_node("CameraRespawnPoint").position
		$PlayerCamera.align()
		
		var player = $Player
		var ripple = player.shader_effects("Ripple")
		ripple.position = player.position
		ripple.speed = 400
		ripple.wave_length = 120
		ripple.length_increase = 0
		ripple.amplitude = 20
		ripple.amplitude_decrease = 80
		ripple.pulses = 4
		player.get_parent().add_child(ripple)
		for particle in player.get_node("RespawnParticles").get_children():
			particle.emitting = true



func _process(delta):
	var player = get_tree().get_nodes_in_group("player")[0]
	if player != null:
		var pos: Vector2 = player.position - Vector2(message.rect_size.x/2, 0)
		pos -= Vector2(0,36 + message.rect_size.y/2)
		
		var screen_center: Vector2 = $PlayerCamera.get_camera_screen_center()
		var screen_size: Vector2 = get_viewport().size/2
		screen_size.x *= $PlayerCamera.zoom.x
		screen_size.y *= $PlayerCamera.zoom.y
		
		message.rect_position.x = clamp(pos.x,  screen_center.x - screen_size.x,
												screen_center.x + screen_size.x -
												message.rect_size.x)
		message.rect_position.y = clamp(pos.y,  screen_center.y - screen_size.y,
												screen_center.y + screen_size.y)


func write(text: String, time: float) -> void:
	message.write(text)
	message_timer.start(time)

func _on_Timer_timeout():
	message.clear()

func unlock_secret_key(n: int):
	if get_tree().get_nodes_in_group("main").size() > 0:
		var save_handler:SaveHandler = get_tree().get_nodes_in_group("main")[0].get_node("SaveFileHandler")
		if n < save_handler.progress["secrets"].size() - 1: #The last index is reserved for the secret stage
			save_handler.progress["secret"][n] = true
		else:
			print("ERROR: Invalid value of n in unlock_secret_key(n: int)")
			return
	else:
		print("No Main node found")

func set_player_died(variable :bool = true) -> void:
	yield(self, "tree_entered")
	player_died = true
