extends HBoxContainer

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")

onready var any_percent_list = get_node("AnyPercent")
onready var secret_percent_list = get_node("SecretPercent")



func _ready():
	update_times()
	
	if save_file.progress["secrets"].back() == false:
		secret_percent_list.hide()
	else:
		var any_times = [$AnyPercent/First,
						 $AnyPercent/Second,
						 $AnyPercent/Third,
						 $AnyPercent/Fourth,
						 $AnyPercent/Fifth]
		var secret_times = [$SecretPercent/First,
							$SecretPercent/Second,
							$SecretPercent/Third,
							$SecretPercent/Fourth,
							$SecretPercent/Fifth]
		
		for i in range(5):
			any_times[i].focus_neighbour_right = secret_times[i].get_path()
			any_times[i].focus_neighbour_left = secret_times[i].get_path()
			secret_times[i].focus_neighbour_right = any_times[i].get_path()
			secret_times[i].focus_neighbour_left = any_times[i].get_path()



func update_times():
	update_list(any_percent_list)
	update_list(secret_percent_list)

func update_list(list: VBoxContainer):
	var times = [   list.get_node("First"),
					list.get_node("Second"),
					list.get_node("Third"),
					list.get_node("Fourth"),
					list.get_node("Fifth") ]
	
	var category
	if list == any_percent_list:
		category = "times"
	else:
		category = "secret_times"
	
	for i in range(5):
		if save_file.progress[category].size() >= i + 1:
			times[i].text = save_file.progress[category][i]["string"]
		else:
			times[i].text = "---"
	
	


