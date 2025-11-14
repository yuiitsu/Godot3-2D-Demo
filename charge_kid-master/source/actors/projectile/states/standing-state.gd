extends BulletBaseState
class_name StandingState

func _init(owner: Node):
	self.owner = owner

func enter() -> void:
	self.activate_rigid_body()

func update(delta):
	owner.velocity.y +=  owner.gravity_accel*delta
