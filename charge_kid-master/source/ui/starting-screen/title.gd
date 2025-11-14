extends TextureRect


export (float) var shader_top;
export (float) var shader_bot;
export (float) var shader_dist;
export (bool) var shader_outside;

onready var shader = self.get_material()
onready var animation = $AnimationPlayer
onready var timer = $AnimationPlayer/Timer



func _process(delta):
	shader.set_shader_param("tear_top", shader_top)
	shader.set_shader_param("tear_bot", shader_bot)
	shader.set_shader_param("tear_dist", shader_dist)
	shader.set_shader_param("tear_outside", shader_outside)



func _on_Timer_timeout():
	var rng = randi()%animation.get_animation_list().size()
	animation.play(rng as String)
	rng = float(randi()%11)/10 + 1.0
	timer.start(rng)


