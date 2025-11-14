extends Node2D

export (float) var duration
export (float) var tear_distance
export (float) var tear_size

onready var shader = $Shader.get_material()



func _ready():
	$Timer.start(duration)
	$Shader.scale = get_viewport().size
	$Shader.scale.y *= tear_size
	shader.set_shader_param("dist", tear_distance)
	shader.set_shader_param("scale", scale)



func _on_Timer_timeout():
	self.queue_free()


