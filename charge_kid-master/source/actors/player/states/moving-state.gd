extends PlayerBaseState
class_name MovingState

var running: bool = false



func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")



func enter():
	running = false
	var list = ["Landing0", "Landing1"]
	if not list.has(animation_player.current_animation):
		owner.get_node("PlayerSprite").step_sound()
#	elif animation_player.current_animation == "Landing1":
#		running = true



func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.vertical_move(delta)
	owner.drop()
	if owner.is_on_floor():
		var list = ["Landing0", "Landing1", "Turning0", "Braking0", "Braking1", "Running"]
		if not list.has(animation_player.current_animation):
			if not running:
				animation_player.play("Walking")
			else:
				animation_player.play("Running")
		if get_directional_inputs().length() == 0 and abs(owner.velocity.x) >= owner.speed/2:
			animation_player.play("Braking0")
		store_checkpoint()
		
		#################Checking for any inputs########################
		if jump_input_pressed():
			return
		
		elif shoot_input_pressed():
			return
		
		elif boost_input_pressed():
			return
		
		elif bullet_boost_input_pressed():
			return
		
		elif get_directional_inputs().length() == 0 and owner.velocity.x == 0:
			owner.reset_states_machine()
		##################################################################
	
	else:
		owner.change_state("OnAirState")


