extends Area2D

onready var revealed = false

func _on_SecretRoom_body_entered(body):
	if body.is_in_group("player") and not revealed:
		$FalseBlocks.get_material().set_shader_param("reveal", 1)
		$Timer.start()
		revealed = true
		$SFX.play()

func _on_Timer_timeout():
	$FalseBlocks.get_material().set_shader_param("reveal", 2)


