extends Node2D


export (float) var speed;
export (float) var radius;
export (float) var amplitude;
export (float) var pulses;

onready var shader = $Shader.get_material()

func _process(delta):
	shader.set_shader_param("time", 1 - $Timer.time_left)
	shader.set_shader_param("speed", speed)
	shader.set_shader_param("radius", radius)
	shader.set_shader_param("amplitude", amplitude)
	shader.set_shader_param("pulses", pulses)
	shader.set_shader_param("scale", get_viewport().size)
	$Shader.scale = get_viewport().size
