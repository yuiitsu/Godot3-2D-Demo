extends MarginContainer

export (String, "times", "secret_times") var category

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")



func _on_Timer_timeout():
	if category == "times" or save_file.progress["secrets"].back() == true:
		var times = [$Times/First,
					 $Times/Second,
					 $Times/Third,
					 $Times/Fourth,
					 $Times/Fifth]
		for i in range(5):
			if save_file.progress[category].size() >= i + 1:
				times[i].text = save_file.progress[category][i]["string"]
			else:
				times[i].text = "---"
	else:
		self.hide()


