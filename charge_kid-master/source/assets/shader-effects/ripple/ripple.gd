extends Node2D



export (float, 1000) var speed
export (float, 1000) var wave_length
export (float, 1000) var length_increase
export (float, 100) var amplitude
export (float, 200) var amplitude_decrease
export (int) var pulses

onready var shader = $Shader.get_material()



func _ready():
	shader.set_shader_param("speed", speed/2)
	shader.set_shader_param("wave_length", wave_length/2)
	shader.set_shader_param("length_increase", length_increase/2)
	shader.set_shader_param("amplitude", amplitude/2)
	shader.set_shader_param("amplitude_decrease", amplitude_decrease/2)
	shader.set_shader_param("pulses", pulses)
	shader.set_shader_param("scale", get_viewport().size)
	$Shader.scale = get_viewport().size
	self.position = Vector2(int(position.x) + 0.5, int(position.y) + 0.5)

func _process(delta):
	shader.set_shader_param("time", 5 - $Timer.time_left)

func _on_Timer_timeout():
	self.queue_free()
