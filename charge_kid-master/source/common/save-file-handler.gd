extends Node
class_name SaveHandler


export (Array, PackedScene) var levels
export (Array, PackedScene) var secret_levels

onready var file_handler:FileHandler = get_parent().get_node("FileHandler")
onready var main = get_parent()

var progress: Dictionary = {
	"levels": 0,
	"end": false,
	"secrets": [false, false, false, false, false, false],
	"times": [],
	"secret_times": [],
	"faster_autoscrollers": false,
	"shots": 0,
	"charges": 0,
	"deaths": 0
}

var model = progress.duplicate()



func save_progress() -> void:
	if main.enable_save:
		var file = File.new()
		file.open("user://save_progress.save", File.WRITE)
		file.store_line(to_json(progress))
		file.close()



func load_progress() -> void:
	if main.enable_save:
		var file = File.new()
		if file.file_exists("user://save_progress.save"):
			file.open("user://save_progress.save", File.READ)
			var file_string: String = file.get_line()
			if !file_handler.check_file_integrity(file_string, progress, file.get_path()):
				file_handler.make_backup_file(file.get_path(),file_string, model)
				file.close()
				return
			progress = parse_json(file_string)
			if progress["levels"] > levels.size() or progress["levels"] < 0:
				file_handler.make_backup_file(file.get_path(),file_string, model)
				file.open("user://save_progress.save", File.READ)
				file_string = file.get_line()
				progress = parse_json(file_string)
				print("ERROR: 'levels' number is greater than the real number of levels or negative")
				file.close()



func erase_progress() -> void:
	if main.enable_save:
		var file = File.new()
		file.open("user://save_progress.save", File.WRITE)
		progress["levels"] = 0
		progress["end"] = false
		progress["secrets"] = [false, false, false, false, false, false]
		file.store_line(to_json(progress))
		file.close()



func has_all_secrets() -> bool:
	for i in range(progress["secrets"].size() - 1):
		if progress["secrets"][i] == false:
			return false
	return true



func found_keys() -> int:
	var keys: int = 0
	for i in range(progress["secrets"].size() - 1):
		if progress["secrets"][i] == true:
			keys += 1
	return keys


