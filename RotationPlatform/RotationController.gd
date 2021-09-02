tool
extends Node2D

export var radius = Vector2.ONE * 10
export var rotation_duration = 4.0

var platforms = []
var angle_offset = 0
var child_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func _physics_process(delta):
	if child_count != get_child_count():
		child_count = get_child_count()
		_find_platforms()
		
	angle_offset += 3 * PI * delta / float(rotation_duration)
	angle_offset = wrapf(angle_offset, -PI, PI)
	_update_platform()
	
	
func _update_platform():
	if platforms.size() > 0:
		var spacing = 2 * PI / float(platforms.size())
		for i in platforms.size():
			var new_position = Vector2()
			var s = spacing * i + angle_offset
			new_position.x = cos(s) * radius.x
			new_position.y = sin(s) * radius.y
			platforms[i].position = new_position


func _find_platforms():
	platforms = []
	for child in get_children():
		if child.is_in_group('platform'):
			platforms.append(child)
