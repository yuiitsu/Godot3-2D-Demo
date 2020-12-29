extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shake_num = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	auto_set_limits()
	#pass


func auto_set_limits():
	limit_left = 0
	limit_right = 320
	limit_top = 0
	limit_bottom = 0
	print(offset_h)
	
	var tilemaps = get_tree().get_nodes_in_group("tilemap")
	#var tilemaps = get_parent().find_node("TileMap")
	#var used = tilemaps.get_used_rect()
	#print(used.position.x)
	#print(used.position.y)
	#print(used.end.x * tilemaps.cell_size.x)
	#print(used.end.y * tilemaps.cell_size.x)
	for tilemap in tilemaps:
		if tilemap is TileMap:
			var used = tilemap.get_used_rect()
			limit_left = min(used.position.x * tilemap.cell_size.x, limit_left)
			limit_right = max(used.end.x * tilemap.cell_size.x, limit_right)
			limit_top = min(used.position.y * tilemap.cell_size.y, limit_top)
			limit_bottom = max(used.end.y * tilemap.cell_size.y, limit_bottom)
			
	print(limit_left)
	print(limit_right)
	print(limit_top)
	print(limit_bottom)

