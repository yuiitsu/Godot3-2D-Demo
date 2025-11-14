extends BulletBaseState
class_name ReturnState

var speed: float
var direction: Vector2
var player: KinematicBody2D
var hitbox: Area2D

func _init(owner: Node, player_node):
	self.owner = owner
	self.player = player_node
	self.hitbox = owner.get_node("HitBox")

func enter():
	owner.get_node("PhysicalCollider").set_deferred("disabled", false)
	speed = 0
	for body in hitbox.get_overlapping_bodies():
		if body.is_in_group("player") and not Input.is_action_pressed("action_shoot"):
			body.hit(owner)
			owner.destroy()

func update(delta):
	if  Input.is_action_pressed("action_shoot"):
		owner.change_state("HoldState")
	else:
		direction = (player.position - owner.position).normalized()
		speed += delta*owner.return_acceleration
		speed = clamp(speed, 0, owner.return_speed)
	
	move_bullet(direction, speed)


