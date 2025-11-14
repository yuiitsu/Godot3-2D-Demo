extends Area2D

onready var puzzle_solved: bool = false
onready var lever = get_parent().get_node("LeverBody")


func _on_Lv15Lever_body_exited(body):
	if not puzzle_solved and body.is_in_group("player"):
		if body.get_state() != "DyingState" and lever.is_active:
			puzzle_solved = true
		elif body.get_state() == "DyingState" and lever.is_active:
			lever.hit()


