extends KinematicBody2D


var velocity = Vector2()
var speed = 300
var target = Vector2()


func _ready():
	target = get_parent().find_node('Player')
 

func _physics_process(delta):
	velocity = position.direction_to(target.position) * speed
	look_at(target.position)
	move_and_slide(velocity)
