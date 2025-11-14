extends StaticBody2D

export(Array,NodePath) var nodes

onready var is_active:bool = false
export (PackedScene) var particles

func _ready():
	if is_active:
		$Sprite.frame = 4
	else:
		$Sprite.frame = 0



func hit(bullet:KinematicBody2D = null):
	add_child(particles.instance())
	$SFX.play()
	if is_active:
		$Sprite/AnimationPlayer.play("Deactivate")
		is_active = false
	else:
		$Sprite/AnimationPlayer.play("Activate")
		is_active = true
	for nodepath in nodes:
		toggle(get_node(nodepath))
	if bullet != null:
		if bullet.get_state() == "StandardState":
			bullet.change_state("ReturnState")



func toggle(object:Node) -> void:
	if object.is_active():
		object.deactivate()
	else:
		object.activate()



func _on_PlayerHitbox_body_entered(body):
	if body.is_in_group("player"):
		$SFX.play()
		if is_active:
			$Sprite/AnimationPlayer.play("Deactivate")
			is_active = false
		else:
			$Sprite/AnimationPlayer.play("Activate")
			is_active = true
		for nodepath in nodes:
			toggle(get_node(nodepath))



