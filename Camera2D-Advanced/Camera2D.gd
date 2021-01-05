extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shake_num = 10
var facing = 0
var up_facing = 0
const LOOK_AHEAD_FACTOR = 0.8
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

onready var tween = $Tween
onready var prev_camera_pos = get_camera_position()
onready var player = get_node("../Player")

# Smoothing duration in seconds
const SMOOTHING_DURATION: = 0.2

# The node to follow
onready var target: Node2D = get_node("../Player")

# Current position of the camera
var current_position: Vector2

# Position the camera is moving towards
var destination_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	#auto_set_limits()
	current_position = position
	print(get_viewport_rect().size.x * zoom.x)
	print(get_camera_position())
	pass
	

func _process(delta):
	#position = player.position.round()
	#force_update_scroll()
	#destination_position = target.position
	#current_position += Vector2(destination_position.x - current_position.x, destination_position.y - current_position.y) / SMOOTHING_DURATION * delta
	
	#position = current_position.round()
	# force_update_scroll()
	pass
	
	
func check_facing():
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	if new_facing != 0 and facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * zoom.x * LOOK_AHEAD_FACTOR * facing
		tween.interpolate_property(self, "position:x", position.x, target_offset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		tween.start()
	pass


func auto_set_limits():
	limit_left = 0
	limit_right = 320
	limit_top = 0
	limit_bottom = 0
	print(offset_h)
	
	var tilemaps = get_tree().get_nodes_in_group("tilemap")
	#var tilemaps = get_parent().find_node("TileMap")
	#var used = tilemaps.get_used_rect()
	#print(used.position.x)
	#print(used.position.y)
	#print(used.end.x * tilemaps.cell_size.x)
	#print(used.end.y * tilemaps.cell_size.x)
	for tilemap in tilemaps:
		if tilemap is TileMap:
			var used = tilemap.get_used_rect()
			limit_left = min(used.position.x * tilemap.cell_size.x, limit_left)
			limit_right = max(used.end.x * tilemap.cell_size.x, limit_right)
			limit_top = min(used.position.y * tilemap.cell_size.y, limit_top)
			limit_bottom = max(used.end.y * tilemap.cell_size.y, limit_bottom)
			
	print(limit_left)
	print(limit_right)
	print(limit_top)
	print(limit_bottom)



func _on_Player_grounded_update(is_grounded):
	drag_margin_v_enabled = !is_grounded
	print(position)
	#var new_facing = sign(get_camera_position().y - prev_camera_pos.y)
	#if new_facing != 0 and up_facing != new_facing:
	#	up_facing = new_facing
	#var target_offset = get_viewport_rect().size.y * zoom.y * LOOK_AHEAD_FACTOR * -1
	#print(position.y, target_offset)
	#tween.interpolate_property(self, "position", position, Vector2(50, 50), SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
	#tween.start()
	#position.x = 200
	#print(offset)
	#offset = Vector2(50, 50)
	pass
