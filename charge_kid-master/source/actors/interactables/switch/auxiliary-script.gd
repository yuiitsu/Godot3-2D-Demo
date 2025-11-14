extends Sprite


export (Color) var inactive_color
export (Color) var active_color
export (Color) var lit_color

export (PackedScene) var hit_particles

onready var light = $Lights


func light_up():
	light.get_material().set_shader_param("color", lit_color)

func light_down():
	if get_parent().is_active():
		light.get_material().set_shader_param("color", active_color)
	else:
		light.get_material().set_shader_param("color", inactive_color)

func _ready():
	light_down()



