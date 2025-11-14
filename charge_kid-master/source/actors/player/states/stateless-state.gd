extends PlayerBaseState
class_name StatelessState

func _init(owner: KinematicBody2D):
	self.owner = owner

func enter():
	owner.velocity = Vector2.ZERO


