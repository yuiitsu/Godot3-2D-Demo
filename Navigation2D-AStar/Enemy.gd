extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var nav_2d = get_parent().find_node('Navigation2D')
onready var target = get_parent().find_node('KinematicBody2D')

var speed = 50.0
var path = PoolVector2Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	# path = nav_2d.get_simple_path(position, target.position)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = speed * delta
	path = nav_2d.get_simple_path(position, target.position, true)
	print(path)
	var start_point = position
	for i in range(path.size()):
		if path.size() > 0:
			var distance_to_next = start_point.distance_to(path[0])
			#if distance_to_next > 10:
			if distance <= distance_to_next and distance >= 0.0:
				var p = start_point.linear_interpolate(path[0], distance / distance_to_next)
				position = p
				break
			else:
				#position = path[0]
				#break
				path.remove(0)
		
			#distance -= distance_to_next
			#start_point = path[0]
			#path.remove(0)
	
