extends ButtonModel

onready var control_handler: ButtonGetter
onready var type
onready var key: InputEventJoypadButton

var action: String

func _ready():
	action = control_handler.search_actions_by_key(key, type, ["ui_accept", "ui_cancel"])[0]
