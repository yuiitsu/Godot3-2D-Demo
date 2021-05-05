extends KinematicBody2D


var velocity = Vector2()
var g = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity.y += g * delta
	var snap = Vector2.DOWN * 16
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	
	print(is_on_floor(), velocity.y)
