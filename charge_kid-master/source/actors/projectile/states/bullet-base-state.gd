extends State
class_name BulletBaseState

func activate_rigid_body() -> void:
	owner.get_node("PhysicalCollider").disabled = false

func move_bullet(direction:Vector2, speed:float) -> void:
	if not owner.get_node("AnimationPlayer").is_playing():
		owner.velocity = direction*speed
