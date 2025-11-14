extends CenterContainer



onready var main = get_tree().get_nodes_in_group("main")[0]
onready var save_file = main.get_node("SaveFileHandler")
onready var speedrun_mode = main.get_node("SpeedrunMode")

var category: String



func _ready():
	var result: Dictionary = speedrun_mode.time()
	category = speedrun_mode.category
	
	###################Achievement Stuff#############################
	if speedrun_mode.minutes < 8 and speedrun_mode.category == "times":
		AchievementsAndStatsObserver.set_achievement("any_percent")
		
	elif speedrun_mode.minutes < 12 and speedrun_mode.category == "secret_times":
		AchievementsAndStatsObserver.set_achievement("secret_percent")
	##################################################################
	
	### Saving the new time ########################################################
	if save_file.progress[category] == []:
		save_file.progress[category] = [result]
	else:
		
		var done = false
		for i in range(save_file.progress[category].size()):
			if result["float"] < save_file.progress[category][i]["float"] and not done:
				save_file.progress[category].insert(i, result)
				done = true
		if not done:
			save_file.progress[category].append(result)
		
		while save_file.progress[category].size() > 5:
			save_file.progress[category].pop_back()
	
	save_file.save_progress()
	################################################################################
	
	### Writing the results on the screen ##########################################
	$Box/RunTime/Time.text = result["string"]
	$Box/PastTimes/BestTime/Time.text = save_file.progress[category][0]["string"]
	
	if save_file.progress[category].size() >= 2:
		$Box/PastTimes/OtherTimes/Second.text = save_file.progress[category][1]["string"]
	else:
		$Box/PastTimes/OtherTimes/Second.text = "---"
	
	if save_file.progress[category].size() >= 3:
		$Box/PastTimes/OtherTimes/Third.text = save_file.progress[category][2]["string"]
	else:
		$Box/PastTimes/OtherTimes/Third.text = "---"
	
	if save_file.progress[category].size() >= 4:
		$Box/PastTimes/OtherTimes/Fourth.text = save_file.progress[category][3]["string"]
	else:
		$Box/PastTimes/OtherTimes/Fourth.text = "---"
	
	if save_file.progress[category].size() >= 5:
		$Box/PastTimes/OtherTimes/Fifth.text = save_file.progress[category][4]["string"]
	else:
		$Box/PastTimes/OtherTimes/Fifth.text = "---"
	################################################################################



func _input(event):
	if event is InputEvent and $Timer.is_stopped():
		if event.is_action("ui_accept") or event.is_action("ui_cancel"):
			main.back_to_start()
