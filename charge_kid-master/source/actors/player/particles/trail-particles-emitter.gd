extends Node2D

export (bool) var emitting setget emit
export (PackedScene) var particles

onready var player: Player = get_parent().get_parent()



func emit(new_value):
	if new_value == true:
		$Timer.start()
	else:
		$Timer.stop()
	emitting = new_value



func _on_Timer_timeout():
	var particle = particles.instance()
	particle.position = player.position
	particle.frame = player.get_node("PlayerSprite").frame
	player.get_parent().add_child(particle)
	$Timer.start()


