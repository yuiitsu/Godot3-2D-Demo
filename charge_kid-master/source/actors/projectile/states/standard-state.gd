extends BulletBaseState
class_name StandardState

var speed: float = owner.speed
var direction: Vector2 = owner.direction
var range_distance: float
var delta_S := Vector2()

func _init(owner: Node):
	self.owner = owner

func enter():
	owner.get_node("PhysicalCollider").disabled = false
	speed = owner.speed
	direction = owner.direction
	delta_S = Vector2()
	range_distance = owner.range_distance

func update(delta):
	track_distance(delta)
	if delta_S.length() > range_distance or check_for_collisions_with_blocks():
		owner.change_state("ReturnState")
	move_bullet(direction, speed)

func track_distance(delta: float) -> void:
	delta_S += speed*direction*delta

func check_for_collisions_with_blocks() -> bool:
	for body in owner.get_node("HitBox").get_overlapping_bodies():
		if body.is_in_group("blocks"):
			return true
	return false


