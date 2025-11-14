extends Node

onready var old_dir_input: Vector2 = Vector2.ZERO
onready var actual_dir_input: Vector2 = Vector2.ZERO
var control_handler

func _process(_delta):
	if get_tree().paused:
		control_handler = get_parent().control_handler
		actual_dir_input = control_handler.get_directional_input(true)
		if actual_dir_input.length_squared() != 0 and old_dir_input.length_squared() == 0:
			$MenuNavTimer/Timer.start()
		if actual_dir_input.length_squared() == 0 and old_dir_input.length_squared() != 0:
			$MenuNavTimer.stop()
		old_dir_input = control_handler.get_directional_input(true)

func _on_Timer_timeout():
	$MenuNavTimer.start()


