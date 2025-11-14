extends CPUParticles2D


func _ready():
	var rng = ((randi()%250) as float)/100 + 0.2
	$Timer.start(rng)


func _on_Timer_timeout():
	self.emitting = true

