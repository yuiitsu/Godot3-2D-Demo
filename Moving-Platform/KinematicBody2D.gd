extends KinematicBody2D


var velocity = Vector2()
var g = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity.y += g * delta
	velocity = move_and_slide_with_snap(velocity, Vector2.ZERO, Vector2.UP, true)
	
	print(is_on_floor(), velocity.y)
