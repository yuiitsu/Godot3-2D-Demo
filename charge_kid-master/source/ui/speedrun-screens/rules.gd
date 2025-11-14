extends MarginContainer



export (String, MULTILINE) var any_percent_rules
export (String, MULTILINE) var secret_percent_rules

onready var any_percent = get_parent().get_node("CenterContainer/MarginContainer/MarginContainer/Menu/Options/AnyPercent")
onready var secret_percent = get_parent().get_node("CenterContainer/MarginContainer/MarginContainer/Menu/Options/SecretPercent")
onready var rules_label = $Rules


func _process(_delta):
	if any_percent.has_focus():
		rules_label.text = any_percent_rules
	elif secret_percent.has_focus() and not secret_percent.disabled:
		rules_label.text = secret_percent_rules
	else:
		rules_label.text = ""


