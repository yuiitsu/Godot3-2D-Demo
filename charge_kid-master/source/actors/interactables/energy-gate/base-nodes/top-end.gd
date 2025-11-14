extends StaticBody2D



onready var gate = get_parent().get_parent().get_parent()

func _process(delta):
	if not Engine.editor_hint:
		if gate.is_active():
			$AnimationPlayer.play("On")
			$CPUParticles2D.emitting = true
			$RippleSource.amplitude = 3
		else:
			$AnimationPlayer.play("Off")
			$CPUParticles2D.emitting = false
			$RippleSource.amplitude = 0



