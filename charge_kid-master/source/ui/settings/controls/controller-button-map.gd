extends ButtonModel

onready var control_handler = main.control_handler



func _on_ButtonModel_pressed():
	._on_ButtonModel_pressed()
	var but_a = control_handler.get_type_button_list("ui_accept", InputEventJoypadButton)[0]
	var but_b = control_handler.get_type_button_list("ui_cancel", InputEventJoypadButton)[0]
	control_handler.swap_keys("ui_accept", but_a, "ui_cancel", but_b, InputEventJoypadButton)



func _process(_delta):
	var accept = control_handler.get_controller_button_name("ui_accept", main.controller_layout)
	var cancel = control_handler.get_controller_button_name("ui_cancel", main.controller_layout)
	self.text = "Menu Navigation: " + accept + " accepts, " + cancel + " cancels"


