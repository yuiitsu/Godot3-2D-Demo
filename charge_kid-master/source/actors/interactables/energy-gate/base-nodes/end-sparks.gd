extends CPUParticles2D




func _process(delta):
	if not Engine.editor_hint:
		if get_parent().is_active():
			self.emitting = true
		else:
			self.emitting = false


