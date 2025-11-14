extends Sprite


func _physics_process(delta):
	get_material().set_shader_param("reveal", $Timer.time_left)
