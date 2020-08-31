extends TileMap

class_name Grid

signal eat_food(food_entity, entity)
signal game_over()

onready var grid_size = Vector2(32, 19)
onready var half_cell_size = get_cell_size() / 2

var grid: Array

export var line_color: Color
export var line_thickness: int = 2


func _ready():
	init_grid()
	
	
func init_grid():
	grid = []
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			

func _draw():
	for x in range(grid_size.x):
		var start_point: Vector2 = Vector2(x * cell_size.x , 0)
		var end_point: Vector2 = Vector2(x * cell_size.x, grid_size.y * cell_size.y)
		draw_line(start_point, end_point, line_color, line_thickness)
		
	for y in range(grid_size.y):
		var start_point: Vector2 = Vector2(0, y * cell_size.y)
		var end_point: Vector2 = Vector2(grid_size.x * cell_size.x, y * cell_size.y)
		draw_line(start_point, end_point, line_color, line_thickness)


func place_entity_at_random_pos(entity: Node2D):
	var has_random_pos: bool = false
	var random_grid_pos: Vector2
	
	while has_random_pos == false:
		var temp_pos: Vector2 = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if get_entity_of_cell(temp_pos) == null:
			random_grid_pos = temp_pos
			has_random_pos = true
	
	place_entity(entity, random_grid_pos)
			
			
func get_entity_of_cell(grid_pos: Vector2):
	return grid[grid_pos.x][grid_pos.y] as Node2D
	

func set_entity_in_cell(entity: Node2D, grid_pos: Vector2):
	grid[grid_pos.x][grid_pos.y] = entity


func place_entity(entity: Node2D, grid_pos: Vector2):
	set_entity_in_cell(entity, grid_pos)
	entity.set_position(map_to_world(grid_pos) + half_cell_size)
	

func move_entity_in_direction(entity: Node2D, direction: Vector2):
	var old_grid_pos: Vector2 = world_to_map(entity.position)
	var new_grid_pos: Vector2 = old_grid_pos + direction
	#
	if !is_cell_inside_bounds(new_grid_pos):
		init_grid()
		emit_signal("game_over")
		return
	#
	set_entity_in_cell(null, old_grid_pos)
	#
	var entity_of_new_cell: Node2D = get_entity_of_cell(new_grid_pos)
	if entity_of_new_cell != null:
		if entity_of_new_cell.is_in_group("Food"):
			emit_signal("eat_food", entity_of_new_cell, entity)
		elif entity_of_new_cell.is_in_group("Snake"):
			init_grid()
			emit_signal("game_over")
	
	place_entity(entity, new_grid_pos)

	
func move_entity_to_position(entity: Node2D, position: Vector2):
	var old_grid_pos: Vector2 = world_to_map(entity.position)
	var new_grid_pos: Vector2 = world_to_map(position)
	
	set_entity_in_cell(null, old_grid_pos)
	place_entity(entity, new_grid_pos)
	
	
func is_cell_inside_bounds(cell_pos: Vector2):
	if cell_pos.x < grid_size.x and cell_pos.y >= 0 and cell_pos.y < grid_size.y and cell_pos.x >= 0:
		return true
		
	return false
