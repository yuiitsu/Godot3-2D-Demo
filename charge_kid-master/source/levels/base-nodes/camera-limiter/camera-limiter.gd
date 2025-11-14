extends Area2D

export (int) var limit
var camera_center: Node2D



func _ready():
	camera_center = Node2D.new()
	get_parent().call_deferred("add_child", camera_center)
	camera_center.position.x = 256 + limit



func _on_CameraSetter_body_entered(body):
	if body.is_in_group("player"):
		if not get_tree().get_nodes_in_group("camera").empty():
			var camera: Camera2D = get_tree().get_nodes_in_group("camera")[0] as PlayerCamera
			camera.followed_node = camera_center
			camera.drag_margin_left = 0.0
			camera.drag_margin_right = 0.0

func _on_CameraSetter_body_exited(body):
	if body.is_in_group("player"):
		if not get_tree().get_nodes_in_group("camera").empty():
			var camera: Camera2D = get_tree().get_nodes_in_group("camera")[0] as PlayerCamera
			if camera.player_is_alive:
				camera.followed_node = body
				camera.drag_margin_left = 0.2
				camera.drag_margin_right = 0.2
			else:
				var timer = Timer.new()
				self.call_deferred("add_child",timer)
				yield(timer, "tree_entered")
				timer.start(0.1)
				yield(timer, "timeout")
				for player in $Exit.get_overlapping_bodies():
					if player.is_in_group("player"):
						return
				var player = get_tree().get_nodes_in_group("player")[0]
				camera.followed_node = player
				camera.drag_margin_left = 0.2
				camera.drag_margin_right = 0.2




