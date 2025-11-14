extends Camera2D
class_name PlayerCamera

var followed_node: Node2D

onready var dissipation: float = 0.0
onready var shake_amplitude: float = 0.0
onready var shake_direction: int = 1
onready var player_is_alive: bool = true

export (PackedScene) var tear_shader
export (float) var tear_frequency



func _ready():
	if get_parent().auto_scroller:
		followed_node = get_parent().get_node("Autoscroller")
	else:
		var player = get_tree().get_nodes_in_group("player")[0]
		followed_node = player
		yield(get_tree(), "physics_frame")
		limit_right = get_tree().get_nodes_in_group("level")[0].level_length



func _physics_process(delta):
	if is_instance_valid(followed_node) and followed_node != null:
		self.position = followed_node.position
	else:
		if not get_tree().get_nodes_in_group("player").empty():
			followed_node = get_tree().get_nodes_in_group("player")[0]
	
	screen_shake_routine(delta)
	
	if tear_frequency > 0:
		generate_tears(delta)



func screen_shake_routine(delta: float) -> void:
	if shake_amplitude > 0:
		limit_left = -shake_amplitude as int
		limit_right = get_tree().get_nodes_in_group("level")[0].level_length + shake_amplitude
		
		shake_amplitude = clamp(shake_amplitude - delta*dissipation, 0, 1000)
		
		if shake_amplitude > 4:
			offset.x += 4*delta*dissipation*shake_direction
			while abs(offset.x) > shake_amplitude:
				if offset.x > shake_amplitude:
					offset.x = shake_amplitude - (offset.x - shake_amplitude)
					shake_direction = -1
				elif offset.x < -shake_amplitude:
					offset.x = -shake_amplitude + (-offset.x - shake_amplitude)
					shake_direction = 1
		else:
			shake_amplitude = 0
			limit_left = 0
			limit_right = get_tree().get_nodes_in_group("level")[0].level_length
		
	elif offset.x != 0:
		offset.x = 0.0

func shake_screen(magnitude: float, magnitude_dissipation: float = 4) -> void:
	shake_direction = 1
	shake_amplitude = magnitude
	dissipation = magnitude*magnitude_dissipation



func generate_tears(delta: float) -> void:
	var rng = randi()%1000
	if rng > 1000 - tear_frequency/delta:
		var tear = tear_shader.instance()
		tear.duration = 0.1 + float(randi()%11)/100
		tear.tear_distance = float(randi()%101)/10000
		tear.tear_size = float(randi()%101)/1000
		tear.position.x = get_viewport().size.x/(2/zoom.x)
		tear.position.y = limit_top + randi()%(limit_bottom - limit_top + 1)
		self.add_child(tear)



func player_just_spawned() -> void:
	player_is_alive = true

func player_just_died() -> void:
	player_is_alive = false


