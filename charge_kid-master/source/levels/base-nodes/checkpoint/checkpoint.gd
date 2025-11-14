extends Area2D

export (int) var checkpoint_number

func _ready():
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			get_parent().respawn_point = checkpoint_number

func _on_Checkpoint_body_entered(body):
	if body.is_in_group("player"):
		get_parent().respawn_point = checkpoint_number


