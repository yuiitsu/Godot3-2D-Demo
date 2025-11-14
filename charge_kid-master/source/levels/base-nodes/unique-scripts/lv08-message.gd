extends Area2D



export (String) var message
export (float) var message_time = 2.0
onready var switch = get_parent().get_node("Switch")
onready var player_has_entered: bool = false
var switch_state: bool setget switch_sentinel



func switch_sentinel(new_value) -> void:
	if new_value == true and switch_state == false and player_has_entered == false:
		get_parent().write(message, message_time)
		self.queue_free()
	switch_state = new_value

func _physics_process(_delta):
	self.switch_state = switch.is_active()
	
func _on_Lv6SpMessage_body_entered(body):
	if body.is_in_group("player"):
		player_has_entered = true
