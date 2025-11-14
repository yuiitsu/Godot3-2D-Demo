extends MarginContainer

export (PackedScene) var second_page

onready var main = get_tree().get_nodes_in_group("main")[0]



func _ready():
	if get_tree().get_nodes_in_group("main").size() > 0:
		main = get_tree().get_nodes_in_group("main")[0]
	else:
		main = null

func _input(event):
	if event is InputEvent and $Timer.is_stopped():
		if event.is_action("ui_accept") or event.is_action("ui_cancel"):
			if second_page != null:
				main.change_scene(second_page)
			else:
				main.back_to_start()
			


