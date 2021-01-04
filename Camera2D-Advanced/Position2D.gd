extends Position2D


var grid_size = Vector2(320, 184)
var grid_x = 1
var grid_y = 0

onready var player = get_parent().find_node("Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	# set_as_toplevel(true)
	# update_grid_position()
	pass
	

func _physics_process(delta):
	update_grid_position()


func update_grid_position():
	if player.position.x > grid_x * grid_size.x:
		# position = Vector2(grid_x * grid_size.x, position.y)
		position.x += grid_size.x
		grid_x += 1
	
	if player.position.x < position.x and position.x >= grid_size.x:
		position.x = position.x - grid_size.x
		grid_x -= 1
		
	if player.position.y < grid_y * grid_size.y:
		position.y = position.y - grid_size.y
		grid_y -= 1
		
	if player.position.y > grid_y * grid_size.y + grid_size.y:
		position.y = position.y + grid_size.y
		grid_y += 1
