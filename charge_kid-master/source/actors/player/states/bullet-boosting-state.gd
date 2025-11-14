extends PlayerBaseState
class_name BulletBoostingState

var bullet: KinematicBody2D
var relative_position_to_bullet: Vector2
var boost_velocity: Vector2
var boost_speed: float
var boost_time: float
var boost_timer: float

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	owner.get_node("SFX/Boost").pitch_scale = rand_range(1.0, 1.3)
	owner.get_node("SFX/Boost").set_stream(owner.get_node("PlayerSprite").boost_sounds[randi()%3])
	owner.get_node("SFX/Boost").get_stream().set_loop(false)
	owner.get_node("SFX/Boost").play()
	owner.set_collision_mask_bit(1, false)
	owner.can_boost = false
	boost_time = 0
	boost_timer = 0
	bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
	relative_position_to_bullet = (bullet.position - owner.position)
	
	boost_velocity = 2*owner.boost_speed*relative_position_to_bullet.normalized()
	boost_time = relative_position_to_bullet.length()/owner.boost_speed
	
	animation_player.play("Rolling")
	boosting_particles(true)
	owner.velocity = boost_velocity
	boost_speed = boost_velocity.length()

func update(delta):
	boost_timer += delta
	
	if boost_input_pressed():
		return
	if bullet_boost_input_pressed():
		return
	
	if boost_timer >= boost_time or owner.has_bullet:
		owner.change_state("OnAirState")
	else:
		bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
		owner.velocity = (bullet.position - owner.position).normalized()*boost_speed



func exit():
	owner.set_collision_mask_bit(1, true)
	boosting_particles(false)
	var list = []
	if abs(owner.velocity.x) <= owner.speed/2:
		list = ["Jumping0", "Jumping1", "Spinning"]
		animation_player.play(list[randi()%list.size()])
	else:
		list = ["Reaching0", "Flipping", "Rolling"]
		animation_player.play(list[randi()%list.size()])



