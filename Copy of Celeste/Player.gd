extends KinematicBody2D


var speed = 80
var gravity = 500
var jumpForceHigh = 200
var jumpForceLow = 150
var velocity = Vector2()
var dashing = false
var dashingTime = 10
var dashSpeed = 300
var Ghost = preload("res://Ghost.tscn")
var state_machine


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $Entiy/AnimationPlayer/AnimationTree.get("parameters/playback")


func _physics_process(delta):
	if !dashing:
		velocity.x = 0
		# velocity.y = 0
		#
		if Input.is_action_pressed("move_left"):
			velocity.x -= speed
		
		if Input.is_action_pressed("move_right"):
			velocity.x += speed
		
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.length() == 0:
		state_machine.travel('Idle')
		
	if velocity.length() > 0:
		state_machine.travel('Run')
	
	
		
	# jump inputs
	if Input.is_action_just_pressed("jump") and is_on_floor() and !dashing:
		# velocity.y -= jumpForceHigh
		velocity.y -= jumpForceHigh
		#print(velocity.y)
		
	if Input.is_action_just_released("jump") and velocity.y < 0 :
		# velocity.y = -0
		velocity.y /= 3
		print(velocity.y)
		#if jumpForceHigh - abs(velocity.y) < jumpForceLow:
		#	var y = jumpForceLow - (jumpForceHigh - abs(velocity.y))
			#print('velocity.y: ' + str(velocity.y) + 'dis: ' + str(y))
			# velocity.y += abs(velocity.y) - y
		#	if y > 50:
				#velocity.y = 0
		#		velocity.y += jumpForceHigh - jumpForceLow
				#velocity.y -= y
			#print('velocity.y: ' + str(velocity.y))
			#velocity.y += 
	#if !is_on_floor():
	#	print(velocity.y)
	
	#if !is_on_floor():
		#print('gravity: ' + str(gravity * delta) + ', y: ' + str(velocity.y))
		
		
	if Input.is_action_just_pressed("dash") and !is_on_floor():
		dashing = true
		gravity = 0
		velocity.y = 0
		
		$Timer.start()
		if Input.is_action_pressed('move_up'):
			velocity.y = -150
		else:
			if $Entiy.flip_h == true:
				velocity.x -= dashSpeed
			else:
				velocity.x += dashSpeed
		
	if velocity.x < 0:
		$Entiy.flip_h = true
		
	if velocity.x > 0:
		$Entiy.flip_h = false
		
	velocity.y += gravity * delta

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
