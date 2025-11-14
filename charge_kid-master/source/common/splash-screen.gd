extends TextureRect

export (float) var transition_phase

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

func _process(_delta):
	get_material().set_shader_param("reveal", transition_phase)

func _input(event):
	if $AnimationPlayer.is_playing():
		if main.control_handler.any_button_action_is_pressed(event):
			skip_splash_screen()

func skip_splash_screen() -> void:
	if $AnimationPlayer.current_animation_position > 4 and $AnimationPlayer.current_animation_position < 8.5:
		$AnimationPlayer.advance(8.5 - $AnimationPlayer.current_animation_position)
	else:
		$AnimationPlayer.advance(4 - $AnimationPlayer.current_animation_position)
	return
