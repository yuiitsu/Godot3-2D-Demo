extends Area2D



export (String) var message
export (float) var message_time = 2.0

onready var tank = get_parent().get_node("FuelTank2")
onready var took_charge: bool = false



func _physics_process(_delta):
	if not tank.has_fuel:
		took_charge = true

func _on_SubArea_body_exited(body):
	if body.is_in_group("player"):
		took_charge = false



func on_body_entered(body):
	if body.is_in_group("player") and not took_charge:
		get_parent().write(message, message_time)
		took_charge = true


