extends ButtonModel
class_name ControllerSettingsButton



export(int) var device
export(String, "DPAD Up", "DPAD Down", "DPAD Left", "DPAD Right",
				"Face Button Bottom", "Face Button Right", "Face Button Left",
				"Face Button Top", "L", "R", "L2", "R2", 
				"L3", "R3", "Start", "Select") var button

onready var button_getter: ButtonGetter = main.control_handler
onready var gamepad_index = {
	"DPAD Up": 12,
	"DPAD Down": 13,
	"DPAD Left": 14,
	"DPAD Right": 15,
	
	"Face Button Bottom": 0,
	"Face Button Right": 1,
	"Face Button Left": 2,
	"Face Button Top": 3,
	
	"L": 4,
	"R": 5,
	"L2": 6,
	"R2": 7,
	
	"L3": 8,
	"R3": 9,
	
	"Start": 11,
	"Select": 10
	}

var action: String
var input_event: InputEventJoypadButton
var menu: Node



func _ready():
	input_event = InputEventJoypadButton.new()
	input_event.button_index = gamepad_index[button]
	input_event.device = device
	
	find_and_set_button_action()



func _process(delta):
	self.text = action



func _on_ButtonModel_pressed():
	._on_ButtonModel_pressed()
	var button_name
	match main.controller_layout:
		"Microsoft":
			button_name = button_getter.gamepad_map[button][0]
		"Sony":
			button_name = button_getter.gamepad_map[button][1]
		"Nintendo":
			button_name = button_getter.gamepad_map[button][2]
	menu.open_dialog_box(input_event, button_name, self)



func reload_button() -> void:
	find_and_set_button_action()



func find_and_set_button_action() -> void:
	for command in button_getter.actions_list:
		if button_getter.key_in_list(input_event,
					button_getter.get_type_button_list(command, InputEventJoypadButton)):
			if !command.begins_with("ui_") or command == "ui_pause":
				action = main.actions[command]
				break
		action = "None"


