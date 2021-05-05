extends KinematicBody2D


var speed = 100
var gravity = 600
var jumpForceHigh = 200
var jumpForceLow = 100
var velocity = Vector2()
var dashing = false
var dashingTime = 10
var dashSpeed = 300
var is_grounded
var is_jumping = false
var Ghost = preload("res://Ghost.tscn")
var floor_velectiry_x = 0

const SLOPE_STOP_THRESHOLD = 11.0
var move_direction

signal grounded_update(is_grounded)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function 


func _physics_process(delta):
	if !dashing:
		velocity.x = 0
		# velocity.y = 0
		#
		if Input.is_action_pressed("move_left"):
			velocity.x -= speed
		
		if Input.is_action_pressed("move_right"):
			velocity.x += speed

	move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
			
			
	# gravity
	velocity.y += gravity * delta

	#var snap = Vector2.DOWN * 10 if !is_grounded else Vector2.ZERO
	var snap = Vector2.ZERO if is_jumping else Vector2.DOWN * 16
	
	if move_direction == 0 && abs(velocity.x) < SLOPE_STOP_THRESHOLD:
		velocity.x = 0
		
	if floor_velectiry_x != 0:
		velocity.x += floor_velectiry_x
		
	#print("floor_velocity: ", get_floor_velocity().x)
	var stop_on_slope = true if get_floor_velocity().x == 0 else false
		
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, stop_on_slope)
	#
	
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	#print(is_grounded, velocity.y, get_floor_velocity())
	if is_grounded:
		is_jumping = false
		floor_velectiry_x = 0
	#if was_grounded == null || is_grounded != was_grounded:
	#	emit_signal("grounded_update", is_grounded)
	
	
		
	# jump inputs
	if Input.is_action_just_pressed("jump") and !is_jumping and !dashing:
		velocity.y -= jumpForceHigh
		
		if get_floor_velocity().x != 0:
			floor_velectiry_x = get_floor_velocity().x
		
		is_jumping = true
		
	#if Input.is_action_just_released("jump") and !is_on_floor() and velocity.y < 0:
	#	velocity.y = -jumpForceLow
		
		
	if Input.is_action_just_pressed("dash") and !is_on_floor():
		dashing = true
		gravity = 0
		velocity.y = 0
		
		$Timer.start()
		if Input.is_action_pressed('move_up'):
			velocity.y = -dashSpeed
		else:
			if $Entiy.flip_h == true:
				velocity.x -= dashSpeed
			else:
				velocity.x += dashSpeed
		
	if velocity.x < 0:
		$Entiy.flip_h = true
		
	if velocity.x > 0:
		$Entiy.flip_h = false
		
	if position.y > 184:
		queue_free()
		
		

func flash(delta):
	if $Entiy.flip_h == true:
		position.x -= speed * delta * 10
	else:
		position.x += speed * delta * 10
	


func _on_Timer_timeout():
	
	if dashingTime > 0:
		dashingTime -= 1
		var ghost = Ghost.instance()
		ghost.position = position
		ghost.find_node('Sprite').flip_h = $Entiy.flip_h
		get_parent().add_child(ghost)
	else:
		dashingTime = 10
		velocity.x = 0
		velocity.y = 0
		gravity = 600
		dashing = false
		$Timer.stop()



func _on_Area2D_body_exited(body):
	set_collision_mask_bit(1, true)
