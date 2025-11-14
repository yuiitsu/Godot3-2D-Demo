extends State
class_name PlayerBaseState

onready var animation_player: AnimationPlayer



func enter():
	return



func get_directional_inputs() -> Vector2:
	var directionals = Vector2(owner.control_handler.get_directional_input().x , 0)
	if directionals.x != 0:
		owner.facing = sign(directionals.x)
	return directionals



func shoot_input_pressed() -> bool:
	if Input.is_action_just_pressed("action_shoot") and owner.has_bullet:
		owner.change_state("ShootingState")
		return true
	return false



func jump_input_pressed() -> bool:
	var coyote = owner.get_node("CoyoteTimer")
	var bunny = owner.get_node("BunnyTimer")
	
	if Input.is_action_just_pressed("action_jump"):
		if not coyote.is_stopped():
			owner.change_state("JumpingState")
			coyote.stop()
			return true
		else:
			bunny.start()
			return false
	
	if Input.is_action_pressed("action_jump") and owner.is_on_floor() and not bunny.is_stopped():
		owner.change_state("JumpingState")
		bunny.stop()
		return true
	
	return false



func boost_input_pressed() -> bool:
	var buffer = owner.get_node("BoostBuffer")
	var coyote = owner.get_node("CoyoteTimer")
	
	if coyote.is_stopped():
		if Input.is_action_just_pressed("action_jump"):
			if owner.can_boost:
				owner.change_state("BoostingState")
				return true
			else:
				buffer.start()
	
		if Input.is_action_pressed("action_jump") and not buffer.is_stopped() and owner.can_boost:
			owner.change_state("BoostingState")
			buffer.stop()
			return true
	
	return false



func bullet_boost_input_pressed() -> bool:
	var timer = owner.get_node("BoostBuffer")
	if Input.is_action_just_pressed("action_bullet_boost"):
		timer.start()
	if !timer.is_stopped() and is_holding_bullet() and owner.can_boost:
		owner.change_state("BulletBoostingState")
		timer.stop()
		return true
	return false



func is_holding_bullet() -> bool:
	if owner.get_tree().get_nodes_in_group("bullet").size() > 0:
		var bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
		if bullet.get_state() == "HoldState" or bullet.get_state() == "ReturnState":
			return true
		else:
			return false
	else:
		return false



func boosting_particles(switch: bool):
	for particle in owner.get_node("BoostParticles").get_children():
		particle.emitting = switch
	
	if switch == true:
		var shader = owner.shader_effects("Ripple")
		shader.position = owner.position
		shader.speed = 600
		shader.wave_length = 80
		shader.length_increase = 0
		shader.amplitude = 30
		shader.amplitude_decrease = 60
		shader.pulses = 2
		owner.get_parent().add_child(shader)



func store_checkpoint() -> void:
	var left: bool = false
	var right: bool = false
	for body in owner.get_node("LeftLedgeDetector").get_overlapping_bodies():
		if body.is_in_group("blocks") or body.is_in_group("platform"):
			left = true
	for body in owner.get_node("RightLedgeDetector").get_overlapping_bodies():
		if body.is_in_group("blocks") or body.is_in_group("platform"):
			right = true
	
	if left and right and owner.get_node("SpikesSentinel").get_overlapping_areas().empty():
		owner.checkpoint = owner.position




