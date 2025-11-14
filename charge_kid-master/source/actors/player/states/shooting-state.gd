extends PlayerBaseState
class_name ShootingState


var number_of_shots
var sfx : AudioStreamPlayer

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")
	owner.get_node("SFX/Shoot").pitch_scale = rand_range(0.9, 1.6)
	owner.get_node("SFX/Shoot").set_stream(owner.get_node("PlayerSprite").shoot_sounds[randi()%3])
	owner.get_node("SFX/Shoot").get_stream().set_loop(false)
	number_of_shots = AchievementsAndStatsObserver.get_stat("shots")
	



func enter():
	number_of_shots += 1
	AchievementsAndStatsObserver.set_stat("shots", number_of_shots)
	
	if !self.owner.get_tree().get_nodes_in_group("main").empty():
		var save = self.owner.get_tree().get_nodes_in_group("main")[0].get_node("SaveFileHandler")
		
		if save.progress["shots"] < 100:
			save.progress["shots"] += 1
		else:
			AchievementsAndStatsObserver.set_achievement("shoot")
	
	animation_player.play("Shooting")
	owner.get_node("SFX/Shoot").play()
	
	## If gravity is not aplied when the owner is on floor 
	## the is_on_floor() function will return false 
	## and after that the OnAirState will be triggered
	if !owner.is_on_floor():
		owner.velocity.y = 0.0
	owner.velocity.x = 0.0
	################----------------####################
	
	var bullet_instance = owner.bullet.instance()
	var bullet_positon = owner.position
	bullet_instance.direction = Vector2(owner.facing, 0)
	bullet_instance.position = bullet_positon 
	bullet_instance.initial_state = "StandardState"
	owner.get_parent().add_child(bullet_instance)
	if not owner.god_mode:
		owner.has_bullet = false



func update(delta):
	if owner.is_on_floor():
		owner.vertical_move(delta)
		if jump_input_pressed():
			return
	
	if boost_input_pressed():
		return
	
	if bullet_boost_input_pressed():
		return
	
	if animation_player.current_animation != "Shooting" and owner.get_state() == "ShootingState":
		owner.reset_states_machine()


