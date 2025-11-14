extends Node2D

export (float) var ratio = 2
var camera: Camera2D



func _process(delta):
	if get_tree().get_nodes_in_group("camera").size() > 0:
		camera = get_tree().get_nodes_in_group("camera")[0]
		position.x = camera.get_camera_screen_center().x/ratio - 128



