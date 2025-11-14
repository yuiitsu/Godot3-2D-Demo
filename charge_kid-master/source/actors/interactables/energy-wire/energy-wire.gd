tool
extends Node2D



export (bool) var active setget change_state

func change_state(new_value) -> void:
	active = new_value
	get_material().set_shader_param("active", active)



func _ready():
	#get_material().set_shader_param("inactive_color", Color("#7d7d7d"))
	get_material().set_shader_param("active", active)



func activate() -> void:
	self.active = true
	var timer = Timer.new()
	self.add_child(timer)
	
	self.position.x += 2
	timer.start(0.1)
	yield(timer, "timeout")
	
	self.position.x -= 3
	timer.start(0.1)
	yield(timer, "timeout")
	
	self.position.x += 1
	timer.queue_free()

func deactivate() -> void:
	active = false
	get_material().set_shader_param("active", false)



func is_active() -> bool:
	return active




