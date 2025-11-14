extends Node
class_name Main

export (PackedScene) var start_scene
export (PackedScene) var pause_menu
export (PackedScene) var debugger_layer
export (PackedScene) var controls_menu
export (PackedScene) var sound_menu
export (PackedScene) var display_menu
export (PackedScene) var level_select
export (PackedScene) var settings_menu
export (PackedScene) var speedrun_menu
export (PackedScene) var erase_times_menu
export (PackedScene) var credits
export (String) var sound_config
export (bool) var enable_save
export (bool) var debugging

onready var actions: Dictionary = {
	"action_jump": "Jump/Boost",
	"action_shoot": "Shoot",
	"action_bullet_boost": "Bullet Boost",
	"left": "Left",
	"right": "Right",
	"up": "Up",
	"down": "Down",
	"ui_pause": "Pause/Unpause",
	"ui_accept": "Menu Accept",
	"ui_cancel": "Menu Cancel"
	}

onready var control_handler = ButtonGetter.new(actions)
onready var old_dir_input: Vector2 = Vector2.ZERO
onready var actual_dir_input: Vector2 = Vector2.ZERO
onready var last_input_device: String = "Keyboard"
onready var controller_layout: String = "Microsoft"
onready var file_handler: FileHandler = $FileHandler
onready var display_dictionary_model: Dictionary = {
		"window_fullscreen" : true,
		"window_borderless" : true,
		"window_size.x" : OS.window_size.x,
		"window_size.y" : OS.window_size.y
		}

var actual_scene: PackedScene



func _ready():
	OS.set_current_screen(0)
	if debugging:
		$HudContainer.add_child(debugger_layer.instance())
	self.add_child(control_handler)
	load_display_options()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$SplashScreen/AnimationPlayer.play("Transition")



func start():
	var start = start_scene.instance()
	$Scene.add_child(start)
	actual_scene = start_scene
	control_handler.initialize_inputmap()



func back_to_start():
	change_scene(start_scene)



func change_scene(next_scene: PackedScene, spawn_point: int = 0, next_level: int = 0, player_died: bool = false):
	get_tree().paused = false
	for scene in $Scene.get_children():
		scene.queue_free()
	for scene in $HudContainer.get_children():
		if not scene.is_in_group("speedrun_timer"):
			scene.queue_free()
	
	var scene_instance = next_scene.instance()
	if $SpeedrunMode.is_active() and scene_instance is BaseLevel:
		scene_instance.get_node("ScreenTransition").active = false
	if spawn_point > 0:
		scene_instance.get_node("ScreenTransition").active = false
		scene_instance.respawn_point = spawn_point
	if next_level > 0:
		scene_instance.next_level = next_level
	if player_died:
		scene_instance.player_died = true
	
	$Scene.call_deferred("add_child", scene_instance)
	actual_scene = next_scene
	return scene_instance



func get_level() -> BaseLevel:
	return $Scene.get_children()[0]



func _process(delta):
	# Pausing
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("esc"):
		if not get_tree().get_nodes_in_group("player").empty() and not get_tree().paused:
			if $PauseTimer.is_stopped():
				get_tree().paused = true
				$HudContainer.add_child(pause_menu.instance())
				$PauseTimer.start()
	
	# Unpausing
	if Input.is_action_just_pressed("ui_pause"):
		if not get_tree().get_nodes_in_group("player").empty() and get_tree().paused:
			if $PauseTimer.is_stopped() and not get_tree().get_nodes_in_group("pause_menu").empty():
				get_tree().paused = false
				get_tree().get_nodes_in_group("pause_menu")[0].queue_free()
				$PauseTimer.start()



### DETECT WHICH DEVICE THE PLAYER IS USING #######################################
func _input(event):
	if event is InputEventKey:
		last_input_device = "Keyboard"
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		last_input_device = "Controller"

func is_using_keyboard() -> bool:
	if last_input_device == "Keyboard":
		return true
	else:
		return false

func is_using_controller() -> bool:
	if last_input_device == "Controller":
		return true
	else:
		return false
###################################################################################



func load_display_options() -> void:
	if enable_save:
		var file = File.new()
		if !file.file_exists("user://display_config.conf"):
			OS.window_fullscreen = true
			return
		file.open("user://display_config.conf", File.READ)
		var file_string = file.get_line()
		var validate: bool = file_handler.check_file_integrity(file_string, display_dictionary_model,
																"user://display_config.conf")
		if !validate:
			file_handler.make_backup_file("user://display_config.conf",file_string, display_dictionary_model)
		var dictionary:Dictionary = parse_json(file_string)
		for key in dictionary.keys():
			OS.set(key, dictionary[key])
		OS.window_fullscreen = dictionary["window_fullscreen"]
		file.close()
		if not OS.window_fullscreen:
			OS.window_borderless = dictionary["window_borderless"]
			OS.window_size.x = dictionary["window_size.x"]
			OS.window_size.y = dictionary["window_size.y"]
			OS.center_window()


