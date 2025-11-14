extends Node
class_name ButtonGetter

onready var map_model: Dictionary
onready var gamepad_map: Dictionary
onready var actions_dictionary: Dictionary
onready var buttons_order: Dictionary
onready var buttons_index: Array
onready var actions_list: Array
onready var main = get_parent()
onready var file_handler: FileHandler = main.get_node("FileHandler")

signal done

func _init(actions_dictionary_0: Dictionary):
	
	self.actions_dictionary = actions_dictionary_0.duplicate()
	self.actions_list = actions_dictionary.keys().duplicate()
	
	self.gamepad_map = {
	"DPAD Up": ["Up", "Up", "Up"],
	"DPAD Down": ["Down", "Down", "Down"],
	"DPAD Left": ["Left", "Left", "Left"],
	"DPAD Right": ["Right", "Right", "Right"],
	
	"Face Button Bottom": ["A", "α", "B"],
	"Face Button Right": ["B", "γ", "A"],
	"Face Button Left": ["X", "β", "Y"],
	"Face Button Top": ["Y", "δ", "X"],
	
	"L": ["LB", "L1", "L"],
	"R": ["RB", "R1", "R"],
	"L2": ["LT", "L2", "LZ"],
	"R2": ["RT", "R2", "RZ"],
	
	"L3": ["L-Stick", "L3", "L-Stick"],
	"R3": ["R-Stick", "R3", "R-Stick"],
	
	"Start": ["Start", "Options", "+"],
	"Select": ["Back", "Share", "-"],
	}
	
	self.buttons_order = {
	"DPAD Up": 0,
	"DPAD Down": 1,
	"DPAD Left": 2,
	"DPAD Right": 3,
	
	"Face Button Bottom": 4,
	"Face Button Right": 5,
	"Face Button Left": 6,
	"Face Button Top": 7,
	
	"R": 8,
	"R2": 9,
	"L": 10,
	"L2": 11,
	
	"R3": 12,
	"L3": 13,
	
	"Start": 14,
	"Select": 15,
	}
	
	self.buttons_index = [
	"Face Button Bottom", "Face Button Right", "Face Button Left", "Face Button Top",
	"L", "R", "L2", "R2", "L3", "R3",
	"Select", "Start",
	"DPAD Up", "DPAD Down", "DPAD Left", "DPAD Right"
	]

func _ready():
	self.map_model = make_inputmap_dictionary()
	emit_signal("done")

func erase_all_actions() -> void:
	for action in actions_list:
			InputMap.erase_action(action)

func change_key_binding(action: String, key: InputEvent, type) -> bool:
	var button_list: Array
	button_list = get_type_button_list(action, type)
	if button_list.size() >= 1:
		for old_event in button_list:
			InputMap.action_erase_event(action, old_event)
	
	InputMap.action_add_event(action, key)
	return true

func swap_keys(action1:String, key1: InputEvent, action2:String, key2:InputEvent, type) -> void:
	change_key_binding(action1, key2, type)
	if action2 != "":
		change_key_binding(action2, key1, type)

func find_and_erase_another_action_with_same_key(exception: String, key: InputEvent):
	for action in actions_list:
		if action != exception && key_in_list(key, InputMap.get_action_list(action)):
			for event in InputMap.get_action_list(action):
				InputMap.action_erase_event(action, event)

func find_another_action_with_same_key(exception: String, key: InputEvent, type) -> bool:
	for action in actions_list:
		if action != exception && key_in_list(key, get_type_button_list(action, type)):
			return true
	return false

func find_and_return_another_action_with_same_key(exception: String, key: InputEvent, type) -> String:
	for action in actions_list:
		if action != exception && key_in_list(key, get_type_button_list(action, type)):
			return action
	return ""

func key_in_list(key:InputEvent, list: Array) -> bool:
	if key is InputEventKey:
		for action in list:
			if action.as_text() == key.as_text():
				return true
	elif key is InputEventJoypadButton:
		for action in list:
			if Input.get_joy_button_string(key.button_index) == Input.get_joy_button_string(action.button_index):
				return true
	return false


# Functions that get button names. Each action needs to have two actions, the first must always be keyboard
# and the second must always be joypad.

func get_type_button_list(action: String, type) -> Array:
	if not action in InputMap.get_actions():
		return []
	if !InputMap.get_action_list(action).empty():
		var button_list: Array = []
		for button in InputMap.get_action_list(action):
			if button is type:
				button_list.push_back(button)
		return button_list
	return []

func get_keyboard_key_name(action: String) -> String:
	var button_string: String
	
	if InputMap.get_action_list(action).size() == 0:
		return ""
	
	button_string = get_type_button_list(action, InputEventKey)[0].as_text()
	return button_string

func get_controller_button_name(action: String, model: String = "Microsoft") -> String:
	var button_string = "Select"
	var button_list: Array = get_type_button_list(action, InputEventJoypadButton)
	
	if button_list.empty():
		return ""
	
	for i in range(button_list.size()):
		var button = buttons_index[button_list[i].button_index]
		if buttons_order[button_string] > buttons_order[button]:
			button_string = button
	
	match model:
		"Microsoft":
			button_string = self.gamepad_map[button_string][0]
		"Sony":
			button_string = self.gamepad_map[button_string][1]
		"Nintendo":
			button_string = self.gamepad_map[button_string][2]
	
	return button_string



func is_keyboard_or_gamepad_key(event: InputEvent) -> bool:
	return event is InputEventKey or event is InputEventJoypadButton

func just_pressed(event: InputEvent) -> bool:
	return event.is_pressed() and !event.is_echo()

func equalize_equivalent_keys(action1: String, action2: String):
	for event in InputMap.get_action_list(action2):
		InputMap.action_erase_event(action2, event)
	for event in InputMap.get_action_list(action1):
		InputMap.action_add_event(action2, event)

func initialize_inputmap(filename: String = "inputmap") -> void:
	if main.enable_save:
		var input_save := File.new()
		if input_save.file_exists("user://" + filename + ".conf"):
			input_save.open("user://" + filename + ".conf", File.READ)
			var file_string: String = input_save.get_line()
			if !file_handler.check_file_integrity(file_string, map_model, input_save.get_path()):
				file_handler.make_backup_file(input_save.get_path(), file_string, map_model)
				input_save.open("user://" + filename + ".conf", File.READ)
				file_string = input_save.get_line()
			var inputmap_dictionary: Dictionary = parse_json(file_string)
			main.controller_layout = inputmap_dictionary["Controller Layout"]
			for action in actions_list:
				InputMap.action_erase_events(action)
				var input_key = InputEventKey.new()
				input_key.scancode = inputmap_dictionary[action]["Keyboard"]["scancode"]
				input_key.device = inputmap_dictionary[action]["Keyboard"]["device"]
				InputMap.action_add_event(action, input_key)
				for button in inputmap_dictionary[action]["JoypadButtons"]:
					var input_button = InputEventJoypadButton.new()
					input_button.button_index = button["button_index"]
					input_button.device = button["device"]
					InputMap.action_add_event(action, input_button)

func save_inputmap(filename: String = "inputmap") -> void:
	if main.enable_save:
		var inputmap_dictionary: Dictionary = make_inputmap_dictionary()
		var save_file := File.new()
		save_file.open("user://" + filename + ".conf", File.WRITE)
		save_file.store_line(to_json(inputmap_dictionary))
		save_file.close()

func make_inputmap_dictionary() -> Dictionary:
	var inputmap_dictionary: Dictionary = {}
	for action in actions_list:
		var action_keys: Dictionary = {}
		action_keys["JoypadButtons"] = []
		for event in InputMap.get_action_list(action):
			if event is InputEventKey:
				action_keys["Keyboard"] = {
					"device" : event.device,
					"scancode" : event.scancode
				}
			elif event is InputEventJoypadButton:
				action_keys["JoypadButtons"].append({
					"device" : event.device,
					"button_index" : event.button_index
				})
		
		inputmap_dictionary[action] = action_keys.duplicate()
		inputmap_dictionary["Controller Layout"] = main.controller_layout
	return inputmap_dictionary

func search_actions_by_key(key: InputEvent, type, exception: Array) -> Array:
	var return_list: Array = []
	for action in actions_list:
		if not action in exception and key_in_list(key, InputMap.get_action_list(action)):
			return_list.append(action) 
	return return_list



### THUMBSTICK INPUTS #############################################################
const DEADZONE: float = 0.4

func get_l_stick(device = 0) -> Vector2:
	var input: Vector2 = Vector2.ZERO
	input.x = Input.get_joy_axis(device, JOY_ANALOG_LX)
	input.y = Input.get_joy_axis(device, JOY_ANALOG_LY)
	return input

func get_r_stick(device = 0) -> Vector2:
	var input: Vector2 = Vector2.ZERO
	input.x = Input.get_joy_axis(device, JOY_ANALOG_RX)
	input.y = Input.get_joy_axis(device, JOY_ANALOG_RY)
	return input

func get_l_stick_directional(device = 0) -> Vector2:
	var stick: Vector2 = get_l_stick(device)
	var direction: Vector2 = Vector2.ZERO
	
	if stick.length_squared() >= DEADZONE*DEADZONE:
		var angle: float = stick.angle()
		
		# Getting Y axis direction:
		if angle > PI/8 and angle < 7*PI/8:
			direction.y = 1
		elif angle < -PI/8 and angle > -7*PI/8:
			direction.y = -1
		
		# Getting X axis direction:
		if angle < 3*PI/8 and angle > -3*PI/8:
			direction.x = 1
		elif angle > 5*PI/8 or angle < -5*PI/8:
			direction.x = -1
			
	return direction

func get_r_stick_directional(device = 0) -> Vector2:
	var stick: Vector2 = get_r_stick(device)
	var direction: Vector2 = Vector2.ZERO
	
	if stick.length_squared() >= DEADZONE*DEADZONE:
		var angle: float = stick.angle()
		
		# Getting Y axis direction:
		if angle > PI/8 and angle < 7*PI/8:
			direction.y = 1
		elif angle < -PI/8 and angle > -7*PI/8:
			direction.y = -1
		
		# Getting X axis direction:
		if angle < 3*PI/8 and angle > -3*PI/8:
			direction.x = 1
		elif angle > 5*PI/8 or angle < -5*PI/8:
			direction.x = -1
	
	return direction
###################################################################################



### DIRECTIONAL INPUTS ############################################################
enum {L_STICK, R_STICK, BOTH_STICKS, NONE}

func get_directional_input(menu: bool = false, device = 0, get_from_sticks = L_STICK) -> Vector2:
	# Getting from sticks:
	var analog: Vector2 = Vector2.ZERO
	if get_from_sticks == R_STICK or get_from_sticks == BOTH_STICKS:
		analog = get_r_stick_directional(device)
	elif get_from_sticks == L_STICK or get_from_sticks == BOTH_STICKS:
		analog = get_l_stick_directional(device)
	
	# Getting from D-Pad or keyboard:
	var digital: Vector2 = Vector2.ZERO
	if menu == false:
		digital.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		digital.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	else:
		digital.x = Input.get_action_strength("menu_right") - Input.get_action_strength("menu_left")
		digital.y = Input.get_action_strength("menu_down") - Input.get_action_strength("menu_up")
	
	if digital == Vector2.ZERO:
		return analog
	else:
		return digital
###################################################################################



func any_button_action_is_pressed(event: InputEvent) -> bool:
	if event is InputEventKey or event is InputEventJoypadButton:
		for action in actions_list:
			if event.is_action(action) and Input.is_action_just_pressed(action):
				return true
	return false


