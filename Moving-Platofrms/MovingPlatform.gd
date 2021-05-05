extends Node2D

const IDLE_DURATION = 1.0

export var move_to = Vector2.RIGHT * 192
export var speed = 50.0

var follow = Vector2.ZERO

onready var platform = $Platform
onready var tween = $MoveTween


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tween()
	pass
	
	
func _init_tween():
	var duration = move_to.length() / float(speed)
	print(duration)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()


func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
	pass

