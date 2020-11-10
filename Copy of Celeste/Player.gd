extends KinematicBody2D


var speed = 100
var gravity = 600
var jumpForce = 200
var velocity = Vector2()
var flashing = false
var flashingTime = 10
var Ghost = preload("res://Ghost.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function 


func _physics_process(delta):
	if !flashing:
		velocity.x = 0
		# velocity.y = 0
		#
		if Input.is_action_pressed("move_left"):
			velocity.x -= speed
		
		if Input.is_action_pressed("move_right"):
			velocity.x += speed
		
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# gravity
	velocity.y += gravity * delta
		
	# jump inputs
	if Input.is_action_pressed("jump") and is_on_floor() and !flashing:
		velocity.y -= jumpForce
		
	if Input.is_action_just_pressed("flash") and !is_on_floor():
		# velocity.x += speed * 2
		# $Timer.start()
		flashing = true
		gravity = 0
		velocity.y = 0
		# jumpForce = 0
		# speed = 500
		
		$Timer.start()
		if $Entiy.flip_h == true:
			velocity.x -= 300
		else:
			velocity.x += 300
		#$Timer.stop()
		
	if velocity.x < 0:
		$Entiy.flip_h = true
		
	if velocity.x > 0:
		$Entiy.flip_h = false
		

func flash(delta):
	if $Entiy.flip_h == true:
		position.x -= speed * delta * 10
	else:
		position.x += speed * delta * 10
	


func _on_Timer_timeout():
	
	if flashingTime > 0:
		flashingTime -= 1
		var ghost = Ghost.instance()
		ghost.position = position
		ghost.find_node('Sprite').flip_h = $Entiy.flip_h
		get_parent().add_child(ghost)
	else:
		flashingTime = 10
		velocity.x = 0
		gravity = 600
		flashing = false
		$Timer.stop()
