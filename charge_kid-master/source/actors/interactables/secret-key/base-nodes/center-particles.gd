extends Node2D

export (float) var distance
export (PackedScene) var particle

onready var activated: bool = false


func turn_on():
	if not activated:
		activated = true
		for i in range(16):
			add_particle(Vector2.UP.rotated(i*PI/8))


func accelerate():
	for particles in get_children():
		particles.amount = 6
		particles.speed_scale = 3


func add_particle(dir: Vector2):
	var node = particle.instance()
	node.position = distance*dir
	node.direction = -dir
	self.add_child(node)


