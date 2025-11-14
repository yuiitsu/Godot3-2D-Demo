tool
extends Node


export (int) var column_number setget set_column_number
export (int) var column_gap setget set_column_gap
export (int) var gate_height setget initialize_gate
export (bool) var active setget initial_value
export (String, "Vertical", "Horizontal") var direction setget initial_position
export (PackedScene) var hit_particles

func set_column_gap(new_value: int) -> void:
	if new_value < 0:
		new_value = 0
	column_gap = new_value
	if Engine.editor_hint:
		set_column_number(column_number)

func set_column_number(new_value : int) -> void:
	if new_value < 1:
		new_value = 1
	column_number = new_value
	if Engine.editor_hint:
		for column_cell in self.get_children():
			if column_cell.name != "ColumnCell" and column_cell.name != "SFX":
				self.remove_child(column_cell)
		for i in range(1, column_number):
			var new_column = $ColumnCell.duplicate()
			new_column.position.x = i*16 + column_gap*i
			self.add_child(new_column)

func initial_value(new_value : bool) -> void:
	active = new_value
	for column_cell in self.get_children():
		if column_cell.name != "SFX":
			for cell in column_cell.get_children():
				if cell.name != "Sparks":
					cell.set_active( new_value )

func initialize_gate(new_value: int) -> void:
	if new_value < 1:
		new_value = 1
	gate_height = new_value
	if Engine.editor_hint:
		for column_cell in self.get_children():
			if column_cell.name != "SFX":
				column_cell.get_node("Sparks/BottomEnd").position.y = gate_height*16
				var source_node
				source_node = column_cell.get_node("EnergyGateCell")
				column_cell.get_node("Sparks/Hitbox/CollisionShape2D").shape.extents = Vector2(2,gate_height*8 + 8)
				column_cell.get_node("Sparks/Hitbox/CollisionShape2D").position.y = gate_height*8 - 8
				for child in column_cell.get_children():
					if child.name != "EnergyGateCell" and child.name != "Sparks":
						column_cell.remove_child(child)
				for i in range(1, gate_height):
					var new_cell = source_node.duplicate()
					new_cell.position.y = i*16
					column_cell.add_child(new_cell)

func initial_position(new_value: String) -> void:
	if Engine.editor_hint:
		match new_value:
			"Vertical":
				self.rotation_degrees = 0
			"Horizontal":
				self.rotation_degrees = -90
	direction = new_value



func add_cells() -> void:
	for i in range(1, column_number):
		var new_column = $ColumnCell.duplicate()
		new_column.position.x = i*16 + column_gap*i
		self.add_child(new_column)
	var source_node = get_node("ColumnCell/EnergyGateCell")
	for column_cell in self.get_children():
		if column_cell.name != "SFX":
			var hitbox:Area2D = column_cell.get_node("Sparks/Hitbox")
			hitbox.connect("body_entered", self, "on_hitbox_body_entered")
			hitbox.connect("area_entered", self, "on_hitbox_area_entered")
			for i in range(1, gate_height):
				var new_cell = source_node.duplicate()
				new_cell.position.y = i*16
				column_cell.add_child(new_cell)

func activate() -> void:
	self.active = not active
	

func deactivate() -> void:
	self.active = false
	

func is_active() -> bool:
	return active


func _ready():
	add_cells()
	sfx_point_on_center()
	desynchronize_sfx()
	for column_cell in self.get_children():
		if column_cell.name != "SFX":
			column_cell.get_node("Sparks/Hitbox/CollisionShape2D").shape.extents = Vector2(2,gate_height*8 + 8)
			column_cell.get_node("Sparks/Hitbox/CollisionShape2D").position.y = gate_height*8 - 8


func on_hitbox_body_entered(body):
	if not Engine.editor_hint and body.is_in_group("player") and self.is_active():
		if body.get_state() == "BulletBoostingState" or body.get_state() == "BoostingState":
			spawn_particles(body.position)
		else:
			body.change_state("DyingState")

func on_hitbox_area_entered(area):
	if not Engine.editor_hint and area.get_parent().is_in_group("bullet") and self.is_active():
		spawn_particles(area.get_parent().position)

func spawn_particles(spawn_point: Vector2) -> void:
	var level = get_tree().get_nodes_in_group("level")[0]
	var particles = hit_particles.instance()
	particles.position = spawn_point
	level.add_child(particles)

func desynchronize_sfx() -> void:
	var number_of_sound_sources = min(column_number, 3)
	var alternate: int = 1
	var j = 1
	for i in range(1, number_of_sound_sources):
		if i % 2 == 0:
			j += 1
		var duplicate = $SFX/AudioStreamPlayer2D.duplicate()
		$SFX.add_child(duplicate)
		duplicate.position.x += alternate*8*j
	if not Engine.editor_hint:
		var i = 1
		for audio_stream in get_node("SFX").get_children():
			audio_stream.play(randf() * 0.6)
			i+=1

func sfx_point_on_center() -> void:
	var x_center: float = (column_number*16 + column_gap*(column_number - 1))/2
	var y_center: float = (gate_height*16)/2
	$SFX.position = Vector2(x_center, y_center)
