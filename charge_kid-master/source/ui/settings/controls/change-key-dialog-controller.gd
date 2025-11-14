extends Control

export(PackedScene) var button_model

onready var main = get_tree().get_nodes_in_group("main")[0]
onready var parent: Node
onready var key: InputEventJoypadButton
onready var key_name: String
onready var control_handler: ButtonGetter
onready var cancel_button = $Center/Margin/Margin/VBoxContainer/CancelButton
onready var buttons = $Center/Margin/Margin/VBoxContainer/VBoxContainer

var command_list: Array
var button_node: ButtonModel



func _ready():
	parent.pause_mode = PAUSE_MODE_STOP
	self.pause_mode = PAUSE_MODE_PROCESS
	for command in main.actions.keys():
		if command.begins_with("action_"):
			command_list.append(command)
	$Center/Margin/Margin/VBoxContainer/Label.text = "Choose an action for " + key_name
	
	var previous_button: ButtonModel
	for command in command_list:
		var button_model_instance = button_model.instance()
		button_model_instance.command = command
		button_model_instance.text = main.actions[command]
		buttons.add_child(button_model_instance)
		if previous_button != null:
			previous_button.focus_neighbour_bottom = button_model_instance.get_path()
			button_model_instance.focus_neighbour_top = previous_button.get_path()
		previous_button = button_model_instance
		button_model_instance.connect("send_command", self, "receive_command")
	
	################ Setting the remaining buttons neighbours####################
	previous_button.focus_neighbour_bottom = cancel_button.get_path()
	cancel_button.focus_neighbour_top = previous_button.get_path()
	cancel_button.focus_neighbour_bottom = buttons.get_child(0).get_path()
	buttons.get_child(0).focus_neighbour_top = cancel_button.get_path()
	#############################################################################
	
	buttons.get_child(0).grab_focus()

func receive_command(command: String) -> void:
	var old_command: String
	for command in command_list:
		if control_handler.key_in_list(key, control_handler.get_type_button_list(command, InputEventJoypadButton)):
			old_command = command
	if old_command != command:
		InputMap.action_erase_event(old_command, key)
		InputMap.action_add_event(command, key)
	button_node.action = main.actions[command]
	exit()



func exit() -> void:
	parent.pause_mode = PAUSE_MODE_PROCESS
	self.pause_mode = PAUSE_MODE_INHERIT
	control_handler.save_inputmap()
	self.queue_free()
	button_node.grab_focus()



func _on_ReturnButton_pressed():
	exit()


