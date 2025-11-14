extends Node2D

export (float) var speed
export (Array, PackedScene) var segments

onready var active: bool = true
onready var factor: float = 1.0
onready var second_part: int = 0
onready var third_part_sequence: Array = []
onready var end_of_level: bool = false
onready var available_segments: Array = []

onready var camera = get_parent().get_node("PlayerCamera")
onready var level = get_parent()



func _ready():
	available_segments = segments.duplicate(true)
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var save_file = main.get_node("SaveFileHandler")
		var speedrun_mode = main.get_node("SpeedrunMode")
		if save_file.progress["faster_autoscrollers"] == true and speedrun_mode.is_active():
			factor = 1.5



func _physics_process(delta):
	if get_tree().get_nodes_in_group("player").size() > 0:
		var player = get_tree().get_nodes_in_group("player")[0]
		
		if $PauseTimer.is_stopped() and active and player.get_state() != "DyingState":
			if self.position.x < level.level_length - 256:
				self.position.x = clamp(self.position.x + speed*factor*delta, 0, level.level_length - 256)
				if player.position.x - self.position.x > 160 and second_part <= 0:
					self.position.x = clamp(self.position.x + speed*factor*delta*2, 0, level.level_length - 256)
			else:
				if not end_of_level:
					camera.shake_screen(30, 2)
					$SFX.set_pitch_scale(rand_range(1,1.3))
					$SFX.play()
					self.speed *= 3
					end_of_level = true
				$EnergyGate.position.x += speed*factor*delta
		
		if self.position.x >= 1798 and self.position.x <= 2400 and second_part == 0:
			second_part += 1
			generate_gate_challenge()



func _on_PauseTimer_timeout():
	camera.shake_screen(30, 3)
	$SFX.set_pitch_scale(rand_range(1,1.3))
	$SFX.play()



func _on_Accelerator_body_entered(body):
	if body.is_in_group("player"):
		if self.position.x < 1152 and not $Tween.is_active():
			$Tween.interpolate_property(self, "position", null, Vector2(1152,160), 1.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()



func _on_tween_all_completed():
	if second_part > 0 and second_part < 6/factor:
		second_part += 1
		generate_gate_challenge()
	elif second_part != 0:
		second_part = -1





##### SECOND PART CODE ##############################################################

var last_challenge = null

func generate_gate_challenge():
	var next
	if last_challenge == null:
		next = randi()%4
	else:
		next = randi()%3
		if next >= last_challenge:
			next += 1
	
	last_challenge = next
	match next:
		0:
			up_to_down_gate()
		1:
			down_to_up_gate()
		2:
			left_to_right_gate()
		3:
			right_to_left_gate()

func up_to_down_gate():
	$HGate.position.y = -184
	$Tween.interpolate_property($HGate, "position", null, Vector2(-280,184), 6,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func down_to_up_gate():
	$HGate.position.y = 184
	$Tween.interpolate_property($HGate, "position", null, Vector2(-280,-184), 6,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func left_to_right_gate():
	$VGate.position.x = -296
	$Tween.interpolate_property($VGate, "position", null, Vector2(296,-184), 6,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func right_to_left_gate():
	$VGate.position.x = 296
	$Tween.interpolate_property($VGate, "position", null, Vector2(-296,-184), 6,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func reset_challenge():
	last_challenge = null

#####################################################################################





##### THIRD PART CODE ###############################################################

func pick_a_segment() -> PackedScene:
	var rng = randi()%available_segments.size()
	var segment = available_segments[rng]
	available_segments.remove(rng)
	return segment

#####################################################################################








