tool
extends Node2D



export (int) var gate_height setget initialize_gate
export (int) var gap_size setget set_gap
export (bool) var active setget initial_value
export (float) var delay_between_cells
export (bool) var close_in_inverse_order
export (String, "Left", "Up", "Down", "Right") var direction setget set_direction

func set_direction(new_value: String) -> void:
	direction = new_value
	match new_value:
		"Up":
			self.rotation_degrees = 90
		"Left":
			self.rotation_degrees = 0
		"Right":
			self.rotation_degrees = 180
		"Down" :
			self.rotation_degrees = -90
	pass

func set_gap(new_value: int) -> void:
	if new_value < 0:
		gap_size = 0
	else:
		gap_size = new_value
	for gate_cell in get_children():
		gate_cell.set_gap(gap_size)

func initial_value(new_value : bool) -> void:
	active = new_value
	for cell in self.get_children():
		cell.initial_value(new_value)

func initialize_gate(new_value: int) -> void:
	if new_value <= 0:
		return
	gate_height = new_value
	if Engine.editor_hint:
		var source_node
		source_node = self.get_node("GateCell")
	
		for gate_cell in self.get_children():
			if gate_cell.name != "GateCell":
				self.remove_child(gate_cell)
		for i in range(1, gate_height):
			var new_cell = source_node.duplicate()
			new_cell.position.y = i*16
			self.add_child(new_cell)



func add_cells() -> void:
	var source_node = self.get_node("GateCell")
	for i in range(1, gate_height):
			var new_cell = source_node.duplicate()
			new_cell.position.y = i*16
			self.add_child(new_cell)

func activate() -> void:
	if !active:
		active = true
	for cell in self.get_children():
		cell.activate()

func deactivate() -> void:
	if active:
		active = false
	for cell in self.get_children():
		cell.deactivate()

func is_active() -> bool:
	return active



func _ready():
	add_cells()
	var i: int = 0
	var j: int
	if close_in_inverse_order:
		j = self.get_children().size()
	else:
		j = 0
	for cell in self.get_children():
		cell.delay = delay_between_cells * abs(j - i)
		i += 1


