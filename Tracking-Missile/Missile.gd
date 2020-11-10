extends KinematicBody2D


var velocity = Vector2(0, 200)
var speed = 200
var target = Vector2()
var acceleration = Vector2.ZERO
var r_speed = 50


func _ready():
	target = get_parent().find_node('Player')
	rotation = 90
	#velocity = position.direction_to(target.position) * speed
 

func _physics_process(delta):
	# velocity = position.direction_to(target.position) * speed
	#look_at(target.position)
		#print(target.position.normalized().dot(position.normalized()))
		print(velocity.normalized().dot(target.position.normalized()))
	# if target.position.normalized().dot(position.normalized()) != 1:
		var line_velocity = Vector2.ZERO
		line_velocity = (target.position - position).normalized() * speed
		var rv = (line_velocity - velocity).normalized() * r_speed
		acceleration += rv
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
		#position += velocity * delta
	
	
		move_and_slide(velocity)
