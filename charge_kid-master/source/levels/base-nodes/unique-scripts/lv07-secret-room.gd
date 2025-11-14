extends Area2D

onready var played_sfx = false

func _on_SecretRoomCamera_body_entered(body):
	if body.is_in_group("player"):
		if not get_tree().get_nodes_in_group("camera").empty():
			var camera: Camera2D = get_tree().get_nodes_in_group("camera")[0] as PlayerCamera
			if camera.player_is_alive:
				camera.followed_node = body
				camera.drag_margin_left = 0.2
				camera.drag_margin_right = 0.2
				camera.limit_bottom = 464
				camera.limit_left = 560
				if not played_sfx:
					$SFX.play()
					played_sfx = true



func _on_Exit_body_entered(body):
	if body.is_in_group("player"):
		if not get_tree().get_nodes_in_group("camera").empty():
			var camera: Camera2D = get_tree().get_nodes_in_group("camera")[0] as PlayerCamera
			if camera.player_is_alive:
				camera.limit_bottom = 304
				camera.limit_left = 0


