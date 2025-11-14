extends Node2D

export (Array, PackedScene) var particles
onready var emitting = false
onready var player = get_parent().get_parent()



func _process(_delta):
	if emitting:
		for particle in particles:
			var instance = particle.instance()
			instance.transform.x.x = -player.facing
			add_child(instance)
		emitting = false


