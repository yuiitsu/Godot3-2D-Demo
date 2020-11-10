extends Node2D


var speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	#position.y += speed * delta
	get_parent().set_offset(get_parent().get_offset() + (50*delta))
