extends CPUParticles2D

func _ready():
	emitting = true
	one_shot = true
	for child in get_children():
		child.emitting = true
		child.one_shot = true

func _process(_delta):
	var is_over = true
	if not emitting:
		for child in get_children():
			if child.emitting:
				is_over = false
		if is_over:
			queue_free()



