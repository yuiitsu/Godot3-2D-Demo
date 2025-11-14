extends Node2D

export (Array, PackedScene) var particles
export (bool) var emitting = false



func _process(_delta):
	if emitting:
		for particle in particles:
			add_child(particle.instance())
		emitting = false


