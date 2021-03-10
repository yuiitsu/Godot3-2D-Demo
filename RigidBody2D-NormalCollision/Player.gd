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
var Ghost = preload("res://Ghost.tscn")

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
		
		
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	#
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group('rigidbodies'):
			collision.collider.apply_central_impulse(-collision.normal * 50)
	#
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_update", is_grounded)
	
	# gravity
	velocity.y += gravity * delta
		
	# jump inputs
	if Input.is_action_just_pressed("jump") and is_on_floor() and !dashing:
		velocity.y -= jumpForceHigh
		
	if Input.is_action_just_released("jump") and !is_on_floor() and velocity.y < 0:
		velocity.y = -jumpForceLow
		
		
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

