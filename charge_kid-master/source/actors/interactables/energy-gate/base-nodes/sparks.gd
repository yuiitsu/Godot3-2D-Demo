extends CPUParticles2D


onready var gate = get_parent().get_parent().get_parent()

func _ready():
	emission_rect_extents.y = gate.gate_height*8
	amount = gate.gate_height
	position.y = gate.gate_height*8 - 8

func _process(delta):
	emitting = gate.active



