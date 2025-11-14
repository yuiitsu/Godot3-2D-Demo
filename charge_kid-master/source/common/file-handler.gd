extends Node
class_name FileHandler

signal done

func check_file_integrity(file_string: String, model: Dictionary, file_path: String) -> bool:
	var error_message = validate_json(file_string)
	
	if error_message:
		print(error_message)
		print("ERROR:" + file_path + " file is not on Json format")
		emit_signal("done")
		return false
	var file_json = parse_json(file_string)
	if not file_json is Dictionary:
		print("ERROR: "+ file_path + " not storing a Dictionary")
		emit_signal("done")
		return false
	return compare_dictionaries_from_files(file_json, model, file_path)

func compare_dictionaries_from_files(file_json: Dictionary, model: Dictionary, file_path: String) -> bool:
	if file_json.keys().size() != model.keys().size():
		print("ERROR: key numbers different in " + file_path)
		emit_signal("done")
		return false
	
	for i in range(0, file_json.keys().size()):
		if not file_json.keys()[i] in model.keys():
			print("ERROR:" + file_json.keys()[i] + " on " + file_path + " is not a valid key")
			emit_signal("done")
			return false
		if not model.keys()[i] in file_json.keys():
			print("ERROR:" + model.keys()[i] + " not in " + file_path)
			emit_signal("done")
			return false
	
	for key in file_json:
		if typeof(file_json[key]) != typeof(model[key]):
			if !(typeof(file_json[key]) in [TYPE_INT,TYPE_REAL] and typeof(model[key]) in [TYPE_INT,TYPE_REAL]):
				#For some reason the parse_json() function translates 0 to 0.0 (int to float)
				print("ERROR: Variable " + key + " in " + file_path + " of wrong type")
				emit_signal("done")
				return false
		
		if typeof(file_json[key]) == TYPE_DICTIONARY:
			if !compare_dictionaries_from_files(file_json[key], model[key], file_path):
				emit_signal("done")
				return false
		
	emit_signal("done")
	return true

func make_backup_file(file_path: String, file_string: String, model: Dictionary) -> void:
	var file : = File.new()
	var backup_file_path = file_path + ".backup"
	if file.file_exists(backup_file_path):
		var i = 0
		while(file.file_exists(backup_file_path + str(i))):
			i += 1
		backup_file_path += str(i)
	file.open(backup_file_path, File.WRITE)
	file.store_line(file_string)
	file.close()
	file.open(file_path, File.WRITE)
	file.store_line(to_json(model))
	file.close()
	print(file_path + " backup saved as " + backup_file_path + " and file rewritten to standard")
