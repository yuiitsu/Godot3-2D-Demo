extends PlayerBaseState
class_name DyingState


var number_of_deaths

func _init(owner: KinematicBody2D):
	self.owner = owner
	self.animation_player = owner.get_node("AnimationPlayer")

func enter():
	if self.owner.get_tree().get_nodes_in_group("main").size() > 0:
		var save = self.owner.get_tree().get_nodes_in_group("main")[0].get_node("SaveFileHandler")
		if save.progress["deaths"] < 20:
			save.progress["deaths"] += 1
		else:
			AchievementsAndStatsObserver.set_achievement("death")
	
	AchievementsAndStatsObserver.set_stat("deaths", number_of_deaths)
	owner.velocity = Vector2.ZERO
	owner.get_node("SFX/Death").play()
	owner.get_node("PlayerSprite").kill()
	owner.get_node("AnimationPlayer").play("Falling0")
	for particle in owner.get_node("DeathParticles").get_children():
		particle.emitting = true
	owner.can_boost = false
	
	# Deal with onscreen bullets.
	if owner.get_tree().get_nodes_in_group("bullet").size() > 0:
		var bullet = owner.get_tree().get_nodes_in_group("bullet")[0]
		if bullet.get_state() == "StandingState" and owner.get_tree().get_nodes_in_group("main").size() > 0:
			var main = owner.get_tree().get_nodes_in_group("main")[0]
			var next_player = main.player_scene.instance()
			next_player.has_bullet = false
		else:
			bullet.destroy()
	
	var shader = owner.shader_effects("Ripple")
	shader.position = owner.position
	shader.speed = 600
	shader.wave_length = 160
	shader.length_increase = 0
	shader.amplitude = 30
	shader.amplitude_decrease = 0
	shader.pulses = 4
	owner.get_parent().add_child(shader)
	
	var camera = owner.get_tree().get_nodes_in_group("camera")[0]
	camera.player_just_died()
	camera.shake_screen(24)
	
	var timer = Timer.new()
	owner.add_child(timer)
	timer.start(1)
	yield(timer, "timeout")
	
	if owner.get_parent().auto_scroller:
		if owner.get_tree().get_nodes_in_group("main").size() > 0:
			var main = owner.get_tree().get_nodes_in_group("main")[0]
			var level = owner.get_parent().level
			var level_scene
			if level == 18:
				level_scene = main.get_node("SaveFileHandler").secret_levels[0]
			else:
				level_scene = main.get_node("SaveFileHandler").levels[level - 1]
			var checkpoint = owner.get_parent().respawn_point
			var level_instance = main.change_scene(level_scene, checkpoint, 0, true)
		else:
			owner.get_tree().reload_current_scene()
	else:
		owner.queue_free()
		var level = owner.get_tree().get_nodes_in_group("level")[0]
		var next_player = level.player_scene.instance()
		next_player.position = owner.checkpoint
		next_player.checkpoint = owner.checkpoint
		
		owner.get_parent().add_child(next_player)
		var ripple = next_player.shader_effects("Ripple")
		ripple.position = next_player.position
		ripple.speed = 400
		ripple.wave_length = 120
		ripple.length_increase = 0
		ripple.amplitude = 20
		ripple.amplitude_decrease = 80
		ripple.pulses = 4
		next_player.get_parent().add_child(ripple)
		for particle in next_player.get_node("RespawnParticles").get_children():
			particle.emitting = true
		level.player_died = true


