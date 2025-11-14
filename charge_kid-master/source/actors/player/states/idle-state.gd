extends PlayerBaseState
class_name IdleState



func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")



func enter():
	owner.get_node("IdleTimer").start(7.0)



func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.vertical_move(delta)
	owner.drop()
	if owner.is_on_floor():
		var list = ["Landing0", "Turning0", "Braking0", "Braking1",
					"TooIdle", "Waving0", "Waving1"]
		if not list.has(animation_player.current_animation):
			animation_player.play("Idle")
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
		
		elif get_directional_inputs().x != 0:
			owner.change_state("MovingState")
			return
		
		return
		##################################################################
	
	else:
		owner.change_state("OnAirState")
		return



func exit():
	owner.get_node("IdleTimer").stop()


