extends BulletBaseState
class_name HoldState

func _init(owner: Node):
	self.owner = owner

func update(delta):
	if !Input.is_action_pressed("action_shoot"):
		owner.change_state("ReturnState")
	
	move_bullet(Vector2.ZERO, 0)
