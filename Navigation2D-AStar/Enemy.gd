extends KinematicBody2D


onready var nav_2d = get_parent().find_node('Navigation2D')
onready var target = get_parent().find_node('KinematicBody2D')

var speed = 40.0
var path = PoolVector2Array()


func _process(delta):
	path = nav_2d.get_simple_path(position, target.position, true)
	path.remove(0)
	if path.size() > 0:
		var distance_to_next = position.distance_to(path[0])
		if distance_to_next > 0:
			var p = position.linear_interpolate(path[0], (speed * delta) / distance_to_next)
			position = p
		else:
			path.remove(0)
	
func _physics_process(delta):
	pass
