extends KinematicBody2D
class_name Player

export(bool) var god_mode

export(PackedScene) var bullet

export(float) var label_time
export(float) var factor

export(bool) var has_bullet

export(float) var acceleration
export(float) var speed
export(float) var friction
export(float) var air_friction

export(float) var boost_distance
export(float) var boost_time
onready var boost_speed: float = boost_distance/boost_time

export(float) var jump_height
export(float) var gravity

var main
var control_handler

onready var jump_speed = sqrt(2*jump_height*gravity)
onready var falling_speed: float = jump_speed
onready var velocity: Vector2 = Vector2.ZERO

onready var states: Dictionary = {
	"IdleState" : IdleState.new(self),
	"MovingState" : MovingState.new(self),
	"OnAirState" : OnAirState.new(self),
	"JumpingState" : JumpingState.new(self),
	"ShootingState" : ShootingState.new(self),
	"BoostingState" : BoostingState.new(self),
	"BulletBoostingState": BulletBoostingState.new(self),
	"DyingState" : DyingState.new(self),
	"StatelessState" : StatelessState.new(self)
	}

onready var stack: Array = []
onready var animation_player = $AnimationPlayer

onready var can_boost: bool
onready var facing: float = 1.0 setget change_facing

var checkpoint: Vector2



func _ready():
	if !get_tree().get_nodes_in_group("main").empty():
		main = get_tree().get_nodes_in_group("main")[0]
		control_handler = main.control_handler
	else:
		var actions: Dictionary = {
		"action_jump": "Jump",
		"action_shoot": "Shoot",
		"action_bullet_boost": "Boost",
		"left": "Left",
		"right": "Right",
		"up": "Up",
		"down": "Down",
		"ui_pause": "Pause"
		}
		control_handler = ButtonGetter.new(actions)
	stack.push_front("IdleState")
	
	var timer = Timer.new()
	add_child(timer)
	timer.start(0.1)
	yield(timer, "timeout")
	timer.queue_free()
	var camera = get_tree().get_nodes_in_group("camera")[0]
	camera.player_just_spawned()



func _physics_process(delta):
	states[get_state()].update(delta)
	
	if get_state() != "DyingState" and get_state() != "StatelessState":
		velocity = move_and_slide(velocity, Vector2(0, -1))
		if is_on_floor():
			$CoyoteTimer.start()



func change_state(state: String):
	var previous_state = stack[0]
	states[previous_state].exit()
	states[state].enter()
	if state == "IdleState" or state == "MovingState":
		stack.clear()
	stack.push_front(state)

func pop_state():
	stack.pop_front()

func reset_states_machine():
	if not is_on_floor():
		change_state("OnAirState")
	elif self.velocity.x != 0:
			change_state("MovingState")
	else:
		change_state("IdleState")

func get_state() -> String:
	return stack[0]

func get_previous_state() -> String:
	if stack.size() > 1:
		return stack[1]
	else:
		return stack[0]



func horizontal_move(direction: Vector2, delta: float,
					fac: float = 1.0, air_brake: bool = false):
	if direction.x != 0:
		velocity += direction*delta*acceleration*fac
	elif velocity.x != 0:
		var deacceleration = friction
		if air_brake:
			deacceleration = air_friction
		var signal_velocity = velocity.x/abs(velocity.x)
		velocity.x -= sign(velocity.x)*deacceleration*delta*fac
		if signal_velocity != velocity.x/abs(velocity.x):
			velocity.x = 0
	velocity.x = clamp(velocity.x, -speed, speed)
	return

func vertical_move(delta: float, fac: float = 1):
	self.velocity.y += gravity*delta*fac
	if self.velocity.y > falling_speed:
		self.velocity.y = falling_speed



func jump():
	get_node("SFX/Jump").pitch_scale = rand_range(1,1.1)
	get_node("SFX/Jump").set_stream($PlayerSprite.jump_sounds[randi()%3])
	get_node("SFX/Jump").get_stream().set_loop(false)
	get_node("SFX/Jump").play()
	self.velocity.y = -jump_speed



func change_facing(new_value):
	if new_value != facing:
		if self.is_on_floor():
			if abs(self.velocity.x) >= speed/2:
				$AnimationPlayer.play("Braking1")
			else:
				$AnimationPlayer.play("Turning0")
		else:
			$AnimationPlayer.play("Turning1")
	facing = new_value



func is_on_platform() -> bool:
	for body in $PlatformSentinel.get_overlapping_bodies():
		if body.is_in_group("platform"):
			return true
	return false

func is_on_blocks() -> bool:
	for body in $PlatformSentinel.get_overlapping_bodies():
		if body.is_in_group("blocks"):
			return true
	return false



func hit(projectile: PhysicsBody2D) -> void:
	match projectile.get_state():
		"StandingState":
			$SFX/BulletPickup.play()
		"FuelChargeState":
			recharge_fuel()
		
	projectile.speed = 0
	self.has_bullet = true
	if self.get_state() == "BulletBoostingState":
		$BoostTimer.stop()
		_on_BoostTimer_timeout()
	projectile.destroy()
	
func fuel_pickup_sound():
	get_node("SFX/FuelPickup").set_stream(get_node("PlayerSprite").fuel_pickup_sounds[randi()%3])
	get_node("SFX/FuelPickup").get_stream().set_loop(false)
	get_node("SFX/FuelPickup").play()

func recharge_fuel() -> void:
	if can_boost == false and self.owner != null:
		if self.owner.get_tree().get_nodes_in_group("main").size() > 0:
			var save = self.owner.get_tree().get_nodes_in_group("main")[0].get_node("SaveFileHandler")
			if save.progress["charges"] < 100:
				save.progress["charges"] += 1
			else:
				AchievementsAndStatsObserver.set_achievement("charge")
	fuel_pickup_sound()
	can_boost = true
	for particle in $FuelParticles.get_children():
		particle.emitting = true



func _on_BoostTimer_timeout():
	if get_state() == "BulletBoostingState":
		for particle in $FuelParticles.get_children():
			particle.emitting = false



func drop() -> void:
	if control_handler.get_directional_input().y == 1 && $DropTimer.is_stopped() && is_on_floor() && is_on_platform():
		self.set_collision_mask_bit(1,false)
		$DropTimer.start()

func _on_DropTimer_timeout():
	self.set_collision_mask_bit(1,true)



func _on_SpikesSentinel_body_entered(body):
	if body.is_in_group("spikes"):
		change_state("DyingState")



func shader_effects(shader: String):
	match shader:
		"Ripple":
			return $ShaderEffects.ripple_effect.instance()


