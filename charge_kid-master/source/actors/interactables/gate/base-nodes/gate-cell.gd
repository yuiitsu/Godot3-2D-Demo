tool
extends Node2D

export(bool) var active setget initial_value
export(int) var gap_size setget set_gap
onready var delay

func set_gap(new_value: int) -> void:
	gap_size = new_value
	if get_children().size() > 2:
		$TriggeredPlatform2.position.x = 16 + gap_size

func initial_value(new_value: bool) -> void:
	active = new_value
	for child in self.get_children():
		if child is TriggeredPlatform:
			child.trigger(new_value)

func activate() -> void:
	if delay > 0:
		$DelayTimer.start(delay)
		yield($DelayTimer, "timeout")
	for cell in self.get_children():
		if cell is TriggeredPlatform:
			cell.activate()

func deactivate() -> void:
	if delay > 0:
		$DelayTimer.start(delay)
		yield($DelayTimer, "timeout")
	for cell in self.get_children():
		if cell is TriggeredPlatform:
			cell.deactivate()
