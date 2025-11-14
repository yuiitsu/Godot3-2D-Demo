extends CPUParticles2D



func _ready():
	var time =randi()%51/10 as float
	$Timer.start(time)

func _on_Timer_timeout():
	self.emitting = true
	var time = 1 + randi()%41/10 as float
	$Timer.start(time)
