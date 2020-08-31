extends Node2D


const scene_snake = preload("res://Snake.tscn")
const scene_food = preload("res://Food.tscn")

onready var grid: Grid = get_node("Grid")

var snake: Node2D


func init_entities():
	snake = scene_snake.instance() as Node2D
	snake.connect("snake_move_triggered", self, "_on_Snake_move_triggered")
	snake.connect("body_segment_move_triggered", self, "_on_Snake_body_segment_move_triggered")
	snake.connect("generated_tail_segment", self, "_on_Snake_generated_tail_segment")
	add_child(snake)
	grid.place_entity_at_random_pos(snake)
	#
	init_food()
	
	
func init_food():
	var food: Node2D = scene_food.instance() as Node2D
	add_child(food)
	grid.place_entity_at_random_pos(food)
	
	
func _ready():
	randomize()
	init_entities()
	

func _on_Snake_move_triggered(entity: Node2D, direction: Vector2):
	grid.move_entity_in_direction(entity, direction)	

	
func _on_Snake_body_segment_move_triggered(segment: Node2D, segement_pos: Vector2):
	grid.move_entity_to_position(segment, segement_pos)


func _on_Grid_eat_food(food_entity, entity):
	if entity.has_method("eat_food"):
		entity.eat_food()
		food_entity.queue_free()
		init_food()
		
		
func _on_Snake_generated_tail_segment(segment: Node2D, segment_pos: Vector2):
	add_child(segment)
	grid.place_entity(segment, grid.world_to_map(segment_pos))


func _on_Grid_game_over():
	delete_entities_of_group("Food")
	delete_entities_of_group("Snake")
	
	init_entities()
	
	
func delete_entities_of_group(group_name: String):
	var entities: Array = get_tree().get_nodes_in_group(group_name)
	for entity in entities:
		entity.queue_free()
