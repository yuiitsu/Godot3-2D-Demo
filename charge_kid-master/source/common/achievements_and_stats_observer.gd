extends Node

onready var return_int = 0
onready var return_bool = false

onready var achievements: Array = [ "beat_the_game",
									"any_percent",
									"secret_percent",
									"shoot",
									"charge",
									"clutch",
									"secret_clutch",
									"beat_the_secret",
									"key1",
									"key2",
									"key3",
									"key4",
									"key5",
									"death",
									"platinum"
]

signal set_achievement(achievement_api_name)
signal clear_achievement(achievement_api_name)
signal reset_all_stat(achievements_too)
signal set_stat(stat_api_name, value)
signal indicate_achievement_progress(
	achievement_name_api, 
		current_progress, 
			max_progress)
signal get_stat(
	stat_name,
	variable_name,
	emitter
)

signal get_achievement(
	achievement_name,
	variable_name,
	emiter
)

func _process(delta):
	if all_achievements_unlocked():
		set_achievement("platinum")

func set_achievement(achievement_name: String) -> void:
	#Use this function to comunicate that a 
	#condition for an achievement has been achieved (hahaha)
	emit_signal("set_achievement", achievement_name)

func clear_achievement(achievement_name: String) -> void:
	#For some debugging reason you might want to clear the
	#state of an achievement (achieved to non-achieved)
	emit_signal("clear_achievement", achievement_name)

func reset_all_stat(achievements_too:bool) -> void:
	#For debugging reasons you call this to clear all stats,
	#and it clear all the achievements if the value of
	#achievements_too is true
	emit_signal("reset_all_stat", achievements_too)

func set_stat(stat_api_name:String, value) -> void:
	#Some achievements are directly linked to some stats
	#i.e. number of jumps, number of relics collected, etc
	#on that function you send the ACTUAL VALUE of the stat,
	#do not mistake that with the value of the increment.
	#Take note that value can be a float or an int
	emit_signal("set_stat", stat_api_name, value)

func indicate_achievement_progress(achievement_name_api: String, current_progress: int, max_progress: int) -> void:
	#This function is used to show milestones of play,
	#i.e. achievements with progress goes from 0 to 10 
	#(on 10 it is achieved) but you want the player to notice when 
	#he is halfway, so you call this function when it reachs 5
	emit_signal("indicate_achievement_progress", achievement_name_api, current_progress, max_progress)

func get_stat(stat_name: String) -> int:
	emit_signal("get_stat", stat_name, "return_int", self)
	return return_int

func get_achievement(achievement_name: String) -> bool:
	emit_signal("get_achievement",achievement_name, "return_bool", self)
	return return_bool

func all_achievements_unlocked() -> bool:
	for i in range(achievements.size()-1):
		if not get_achievement(achievements[i]):
			return false
	return true
