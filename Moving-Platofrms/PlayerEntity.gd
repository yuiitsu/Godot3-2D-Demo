extends KinematicBody2D


var speed = 100
var gravity = 600
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity.y += gravity * delta
	print("PlayerEntity: ", velocity.y, is_on_floor())
	
	#var snap = Vector2.ZERO if is_jumping else Vector2.DOWN * 128
	velocity = move_and_slide_with_snap(velocity, Vector2.ZERO, Vector2.UP, true)
