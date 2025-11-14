extends Node2D



export (float) var min_distance
export (float) var max_distance
export (PackedScene) var ripples

onready var player = null
onready var dist_to_one: Vector2 = Vector2.ZERO
onready var dist_to_other: Vector2 = Vector2.ZERO
onready var one_position: Vector2 = Vector2.ZERO
onready var other_position: Vector2 = Vector2.ZERO

onready var one_sprite = $OneEnd/PortalSprite
onready var other_sprite = $OtherEnd/PortalSprite
onready var one_shader = $OneEnd/RippleSource
onready var other_shader = $OtherEnd/RippleSource



func _ready():
	one_position = self.position + $OneEnd.position
	other_position = self.position + $OtherEnd.position



func _physics_process(delta):
	if get_tree().get_nodes_in_group("player").size() > 0:
		player = get_tree().get_nodes_in_group("player")[0]
		if player.get_state() != "DyingState":
			dist_to_one = one_position - player.position
			dist_to_other = other_position - player.position
	
	var x_one = 1 - clamp((dist_to_one.length() - min_distance)/(max_distance - min_distance), 0, 1)
	var x_other = 1 - clamp((dist_to_other.length() - min_distance)/(max_distance - min_distance), 0, 1)
	var x = max(x_one, x_other)
	
	one_shader.amplitude = 3 + x*7
	other_shader.amplitude = 3 + x*7
	one_sprite.time_to_change_frame = 0.2 - x*0.175
	other_sprite.time_to_change_frame = 0.2 - x*0.175
	
	$PROX.volume_db = linear2db(x*0.7)
	
	if dist_to_one.length() <= dist_to_other.length():
		one_shader.speed = -(2 + x_one*6)
		other_shader.speed = -one_shader.speed
	else:
		other_shader.speed = -(2 + x_other*6)
		one_shader.speed = -other_shader.speed



func on_one_end_body_entered(body):
	if (body.is_in_group("player") or body.is_in_group("bullet")) and $Timer.is_stopped():
		var dif = body.position - one_position
		body.position = other_position + dif
		$SFX.set_pitch_scale(rand_range(1.8,2.1))
		$SFX.play()
		$Timer.start()
		
		let_out_ripples($OneEnd)
		let_out_ripples($OtherEnd)



func on_other_end_body_entered(body):
	if (body.is_in_group("player") or body.is_in_group("bullet")) and $Timer.is_stopped():
		var dif = body.position - other_position
		body.position = one_position + dif
		$SFX.set_pitch_scale(rand_range(1.8,2.1))
		$SFX.play()
		$Timer.start()
		
		let_out_ripples($OneEnd)
		let_out_ripples($OtherEnd)



func let_out_ripples(end):
	var shader = ripples.instance()
	shader.speed = 500
	shader.wave_length = 30
	shader.length_increase = 0
	shader.amplitude = 30
	shader.amplitude_decrease = 100
	shader.pulses = 1
	shader.position = end.position + self.position
	get_parent().add_child(shader)



func _on_Timer_timeout():
	$PROX.play()


