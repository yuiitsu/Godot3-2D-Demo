extends Area2D



export (String) var message
export (float) var message_time = 2.0
onready var tank = get_parent().get_node("FuelTank2")
var tank_state: bool setget tank_sentinel

func tank_sentinel(new_value) -> void:
	if new_value == false and tank_state == true:
		$Timer.start()
	tank_state = new_value

func _physics_process(_delta):
	self.tank_state = tank.has_fuel

func _on_body_entered(body):
	if body.is_in_group("player") and not $Timer.is_stopped():
		get_parent().write(message, message_time)

