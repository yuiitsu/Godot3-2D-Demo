extends PlayerBaseState
class_name OnAirState

var coyote
var bunny
var post_bullet_boost



func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
	self.bunny = owner.get_node("BunnyTimer")
	self.coyote = owner.get_node("CoyoteTimer")



func enter():
	post_bullet_boost = abs(owner.velocity.x)/owner.air_friction
	
	var list = ["Reaching0", "Reaching1", "Rolling", "Flipping", "Spinning"]
	if not list.has(animation_player.current_animation):
		list = ["Falling0", "Falling1"]
		animation_player.play(list[randi()%list.size()])



func update(delta):
	if owner.get_previous_state() == "BoostingState" and owner.velocity.y < 0:
		owner.vertical_move(delta, 3)
	elif owner.get_previous_state() == "BulletBoostingState" and owner.velocity.y < 0:
		owner.vertical_move(delta, 3)
	else:
		owner.vertical_move(delta)
	
	if owner.get_previous_state() == "BulletBoostingState" and post_bullet_boost > 0:
		owner.horizontal_move(get_directional_inputs(), delta, 1.0, true)
		post_bullet_boost -= delta
	else:
		owner.horizontal_move(get_directional_inputs(), delta)
	
	if not owner.is_on_floor():
		var list = ["Reaching0", "Reaching1", "Rolling", "Flipping"]
		if list.has(animation_player.current_animation) and abs(owner.velocity.x) < owner.speed/2:
			list = ["Falling0", "Falling1"]
			animation_player.play(list[randi()%list.size()])
		elif animation_player.current_animation == "Spinning" and abs(owner.velocity.x) > owner.speed/2:
			list = ["Falling0", "Falling1"]
			animation_player.play(list[randi()%list.size()])
		
		################# Checking for any inputs ########################
		if jump_input_pressed():
			return
		elif shoot_input_pressed():
			return
		elif boost_input_pressed():
			return
		elif bullet_boost_input_pressed():
			return
		##################################################################
		
	elif owner.is_on_floor() and owner.velocity.y > 0:
		var list = ["Reaching0", "Reaching1", "Flipping", "Rolling"]
		if list.has(animation_player.current_animation):
			animation_player.play("Landing1")
		else:
			animation_player.play("Landing0")
		owner.reset_states_machine()


