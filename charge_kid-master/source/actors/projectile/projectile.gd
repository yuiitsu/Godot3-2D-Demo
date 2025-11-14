extends KinematicBody2D
class_name PlayerBullet

export(String, "StandartState", "StandingState", "ReturnState", "FuelChargeState", "HoldState" ) var initial_state
export(float) var speed
export(float) var return_speed
export(float) var return_acceleration
export(float) var fuel_speed
export(float) var range_distance
export(float) var gravity_accel

onready var direction: Vector2
onready var velocity: Vector2
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var animation_player = $AnimationPlayer
onready var left_player: bool = false
onready var leaving_the_scene: bool = false

onready var states: Dictionary = {
	"StandardState": StandardState.new(self),
	"StandingState": StandingState.new(self),
	"ReturnState" : ReturnState.new(self, player),
	"FuelChargeState" : FuelChargeState.new(self, player),
	"HoldState" : HoldState.new(self)
	}

onready var stack: Array = []

func _ready():
	stack.push_front(initial_state)
	states[initial_state].enter()

func _physics_process(delta):
	states[stack[0]].update(delta)
	
	# Prevents bullet from moving during teleport and kill animations.
	if not animation_player.is_playing() and not leaving_the_scene:
		velocity = move_and_slide(velocity)

func change_state(state: String) -> void:
	var previous_state = states[stack[0]]
	
	match stack[0]:
		"StandardState":
			stack.pop_front()
			stack.push_front(state)
		"ReturnState":
			if state != "HoldState":
				stack.pop_front()
			stack.push_front(state)
		"HoldState":
			stack.pop_front()
			if state != "ReturnState":
				stack.push_front(state)
	
	previous_state.exit()
	states[state].enter()

func get_state() -> String:
	return stack[0]

func destroy() -> void:
	if not leaving_the_scene:
		leaving_the_scene = true
		states[stack[0]].exit()
		$ProjectileParticles.emitting = false
		$FuelChargeParticles.emitting = false
		$HitBox/HitboxCollider.set_deferred("disabled", true)
		var death_timer = Timer.new()
		get_parent().add_child(death_timer)
		death_timer.start(0.2)
		yield(death_timer, "timeout")
		if self.is_inside_tree():
			self.queue_free()

func _on_HitBox_body_entered(body):
	if not body.is_in_group("bullet") and not body.is_in_group("blocks") and not body.is_in_group("platform") and not body.is_in_group("spikes"):
		if body.is_in_group("player") and (left_player or get_state() == "StandingState"):
			body.hit(self)
		elif not body.is_in_group("player"):
			body.hit(self)

func disable_enable_hitbox(set: bool) -> void:
	$HitBox/HitboxCollider.set_deferred("disabled", !set)

func _on_HitBox_body_exited(body):
	if body.is_in_group("player"):
		left_player = true


