extends BulletBaseState
class_name FuelChargeState

onready var player: KinematicBody2D
onready var speed: float
onready var direction: Vector2

func _init(owner: Node, player_0):
	self.owner = owner
	self.player = player_0

func enter():
	speed = owner.fuel_speed
	owner.get_node("PhysicalCollider").set_deferred("disabled", true)
	owner.set_collision_mask_bit(0, false)
	owner.set_collision_layer_bit(0, false)
	
	owner.left_player = true
	for body in owner.get_node("HitBox").get_overlapping_bodies():
		if body.is_in_group("player"):
			body.hit(owner)
	
	##### Particles ######################################################
	owner.get_node("FuelChargeParticles").emitting = true
	owner.get_node("ProjectileParticles").emitting = false
	######################################################################

func exit():
	owner.get_node("FuelChargeParticles").emitting = false
	owner.get_node("ProjectileParticles").emitting = true
	owner.speed = 0

func update(delta):
	direction = (player.position - owner.position).normalized()
	move_bullet(direction, speed)
