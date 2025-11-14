tool
extends StaticBody2D
class_name TriggeredPlatform

export (bool) var active setget trigger
export (float) var delay_time
export (Array, NodePath) var chain_reaction

func trigger(new_value: bool) -> void:
	if Engine.editor_hint:
		if new_value == true:
			$Sprite.frame = 0
		else:
			$Sprite.frame = 3
	active = new_value

func _ready():
	if !Engine.editor_hint:
		if active:
			$Sprite.frame = 0
			$Hitbox.disabled = false
		else:
			$Sprite.frame = 3
			$Hitbox.disabled = true



func activate() -> void:
	if not is_active():
		$OpenGate.play()
		
		if delay_time > 0:
			$DelayTimer.start(delay_time)
			yield($DelayTimer, "timeout")
		
		$AnimationPlayer.play("Activate")
		active = true
		if chain_reaction.size() > 0:
			for object in chain_reaction:
				get_node(object).activate()
	else:
		deactivate()



func deactivate() -> void:
	if is_active():
		$CloseGate.play()
		
		if delay_time > 0:
			$DelayTimer.start(delay_time)
			yield($DelayTimer, "timeout")
		
		$AnimationPlayer.play("Deactivate")
		active = false
		if chain_reaction.size() > 0:
			for object in chain_reaction:
				get_node(object).deactivate()
	else:
		activate()



func is_active() -> bool:
	return active



func hit(bullet: PhysicsBody2D) -> void:
	if bullet.stack[0] == "StandardState":
		bullet.change_state("ReturnState")
