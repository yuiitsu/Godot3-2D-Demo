extends ButtonModel

var command

signal send_command(command)

func _on_ButtonModel_pressed() -> void:
	._on_ButtonModel_pressed()
	emit_signal("send_command",command)
