extends PlayerBaseState
class_name JumpingState

onready var jumped: bool = false
onready var factor: float = 1

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")



func enter():
	owner.jump()
	owner.get_node("CoyoteTimer").stop()
	if abs(owner.velocity.x) < owner.speed:
		var list = ["Jumping0", "Jumping1", "Spinning", "Rolling"]
		animation_player.play(list[randi()%list.size()])
	else:
		var list = ["Reaching0", "Flipping", "Rolling"]
		animation_player.play(list[randi()%list.size()])



func update(delta):
	owner.horizontal_move(get_directional_inputs(), delta)
	owner.vertical_move(delta)
	
	################# Checking for any inputs ########################
	if shoot_input_pressed():
		return
	
	elif boost_input_pressed():
		return
	
	elif bullet_boost_input_pressed():
		return
	##################################################################
	
	if Input.is_action_just_released("action_jump") && owner.velocity.y < 0:
		owner.velocity.y /= 3
		owner.change_state("OnAirState")
	
	if owner.velocity.y >= 0:
		owner.change_state("OnAirState")



