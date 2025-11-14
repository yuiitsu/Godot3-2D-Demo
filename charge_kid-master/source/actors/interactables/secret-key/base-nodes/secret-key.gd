extends StaticBody2D

export (int) var key_number

export (PackedScene) var hit_particles
export (PackedScene) var white_transition
export (PackedScene) var black_transition

export (PackedScene) var secret_keys_scene
export (PackedScene) var end_scene
export (PackedScene) var secret_end_scene
export (PackedScene) var speedrun_finish

onready var state: int = 0

var phase_1_called:bool = false

func _ready():
	$AnimationPlayer.play("Anim0")
	$Sprite/EnergyRays.hide()
	
func start_phase_1():
	if phase_1_called == false:
		$PHASE1A.play()
		$PARTICLES.set_volume_db(-24)
		$PARTICLES.play()
	phase_1_called = true

func start_phase_2():
	$Sprite/EnergyRays.position.y = -1
	$Sprite/EnergyRays/LeftRay.position.x = -4
	$Sprite/EnergyRays/RightRay.position.x = 4
	$Sprite/EnergyRays.show()
	
	if get_tree().get_nodes_in_group("sound_control").size()>0:
		var bgm = get_tree().get_nodes_in_group("sound_control")[0]
		bgm.music_filter_down(-9)
	
	$PHASE2A.play()
	$PARTICLES.set_volume_db(-18)
	
	for node in $Sprite/Phase2BottomParticles.get_children():
		node.emitting = true
	for node in $Sprite/Phase2TopParticles.get_children():
		node.emitting = true
		
	$Sprite/RippleSource.speed = -1
	$Sprite/RippleSource.radius = 64
	$Sprite/RippleSource.amplitude = 4
	$Sprite/RippleSource.pulses = 6

func start_phase_3():
	$Sprite/EnergyRays.position.y = 2
	if get_tree().get_nodes_in_group("sound_control").size()>0:
		var bgm = get_tree().get_nodes_in_group("sound_control")[0]
		bgm.music_filter_down(-15)
		$PHASE3A.play()
		$PARTICLES.set_volume_db(-12)

	
	for node in $Sprite/Phase2TopParticles.get_children():
		node.emitting = false
	for node in $Sprite/Phase3TopParticles.get_children():
		node.emitting = true
	
	$Sprite/RippleSource.speed = -2
	$Sprite/RippleSource.radius = 128
	$Sprite/RippleSource.amplitude = 6
	$Sprite/RippleSource.pulses = 6

func start_phase_4():
	$Sprite/EnergyRays.position.y = 0
	$Sprite/EnergyRays/LeftRay.position.x = -8
	$Sprite/EnergyRays/RightRay.position.x = 8
	if get_tree().get_nodes_in_group("sound_control").size()>0:
		var bgm = get_tree().get_nodes_in_group("sound_control")[0]
		bgm.music_filter_down(-24)
		$PHASE4A.set_volume_db(0)
		$PHASE4A.play()
		$PARTICLES.set_volume_db(-9)

	
	for node in $Sprite/Phase4BottomParticles.get_children():
		node.emitting = true
	for node in $Sprite/Phase2BottomParticles.get_children():
		node.emitting = false
	
	$Sprite/RippleSource.speed = -4
	$Sprite/RippleSource.radius = 194
	$Sprite/RippleSource.amplitude = 12
	$Sprite/RippleSource.pulses = 6



func pause_player():
	if get_tree().get_nodes_in_group("player").size() > 0:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.change_state("StatelessState")



func spawn_white_transition():
	var transition = white_transition.instance()
	transition.position = self.position
	get_parent().add_child(transition)
	if get_tree().get_nodes_in_group("sound_control").size()>0:
		var bgm = get_tree().get_nodes_in_group("sound_control")[0]
		bgm.zero_all_bgm()
		$FINAL.play()
		$FadeOut.interpolate_property($PARTICLES, "volume_db", 0, -80, 1, 
										Tween.TRANS_EXPO, Tween.EASE_OUT)
		$FadeOut.interpolate_property($PHASE1B, "volume_db", 0, -80, 0.4, 
										Tween.TRANS_EXPO, Tween.EASE_OUT)
		$FadeOut.interpolate_property($PHASE2B, "volume_db", 0, -80, 0.4, 
										Tween.TRANS_EXPO, Tween.EASE_OUT)
		$FadeOut.interpolate_property($PHASE3B, "volume_db", 0, -80, 0.4, 
										Tween.TRANS_EXPO, Tween.EASE_OUT)
		$FadeOut.interpolate_property($PHASE4B, "volume_db", 0, -80, 0.4, 
										Tween.TRANS_EXPO, Tween.EASE_OUT)
		$FadeOut.start()
		


func spawn_black_transition():
	var transition = black_transition.instance()
	var camera = get_tree().get_nodes_in_group("camera")[0]
	transition.position = camera.get_camera_screen_center()
	get_parent().add_child(transition)



func go_to_next_level():
	
	# Check if there is something going on with the player node.
	if get_tree().get_nodes_in_group("player").size() > 0:
		var player = get_tree().get_nodes_in_group("player")[0] as Player
		if player.get_state() == "DyingState":
			return
	else:
		return
	
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var save_file = main.get_node("SaveFileHandler")
		var level = get_tree().get_nodes_in_group("level")[0].level
		var speedrun_mode = main.get_node("SpeedrunMode")
		
		# We're gonna break down in many possible cases to know where
		# to send the player to. Let's start when speedrun mode is off.
		if not speedrun_mode.is_active():
			
			# Before checking which level you're in, let's see if it's the last
			# key. If it is, send the player to the secret level right away.
			if save_file.progress["secrets"][key_number] == false and key_number < 5:
				if save_file.found_keys() == 4:
					main.change_scene(save_file.secret_levels[0])
					save_file.progress["secrets"][key_number] = true
					save_file.save_progress()
					AchievementsAndStatsObserver.set_achievement("key5")
					if level == 17:
						save_file.progress["end"] = true
						save_file.save_progress()
						AchievementsAndStatsObserver.set_achievement("beat_the_game")
						if not get_parent().player_died:
							AchievementsAndStatsObserver.set_achievement("clutch")
					return
			
			# If the player already found all the keys, send them to the next
			# level directly, if not, show them the screen counting the keys.
			if not save_file.has_all_secrets():
				if level != 17 and level != 18:
					main.change_scene(secret_keys_scene, 0, level)
				elif level == 17:
					main.change_scene(secret_keys_scene, 0, level)
					# Do stuff done at the last finish line too.
					save_file.progress["end"] = true
					save_file.save_progress()
					AchievementsAndStatsObserver.set_achievement("beat_the_game")
					if not get_parent().player_died:
						AchievementsAndStatsObserver.set_achievement("clutch")
				
				# We save these for last so we can know if it's the first time
				# the key is being broken.
				save_file.progress["secrets"][key_number] = true
				save_file.save_progress()
				
			# If the player has all keys, send them to the next level or to
			# the end screen directly.
			else:
				if level != 17 and level != 18:
					main.change_scene(save_file.levels[level])
					
				elif level == 17:
					main.change_scene(end_scene)
					AchievementsAndStatsObserver.set_achievement("beat_the_game")
					if not get_parent().player_died:
						AchievementsAndStatsObserver.set_achievement("clutch")
					
				elif level == 18:
					# If it's the first time the secret level is beaten, send the
					# player to the special end screen.
					if save_file.progress["secrets"][key_number] == false:
						main.change_scene(secret_end_scene)
						save_file.progress["secrets"][key_number] = true
						save_file.save_progress()
						AchievementsAndStatsObserver.set_achievement("beat_the_secret")
						if not get_parent().player_died:
							AchievementsAndStatsObserver.set_achievement("secret_clutch")
					else:
						main.change_scene(end_scene)
					if not get_parent().player_died:
						AchievementsAndStatsObserver.set_achievement("secret_clutch")
		
		# Now, the cases where the player is at speedrun mode.
		else:
			
			# If it's the first time the key is being broken,
			# stop the speedrun and send them back to the main menu, or
			# send them to the secret level if it's the last key.
			if save_file.progress["secrets"][key_number] == false:
				speedrun_mode.time()
				save_file.progress["secrets"][key_number] = true
				save_file.save_progress()
				if level == 17:
					if not get_parent().player_died:
						AchievementsAndStatsObserver.set_achievement("clutch")
				if not save_file.has_all_secrets():
					main.change_scene(secret_keys_scene, 0, -1)
				else:
					main.change_scene(save_file.secret_levels[0])
				return
			
			if level != 17 and level != 18:
				main.change_scene(save_file.levels[level])
				
			elif level == 17 and speedrun_mode.category == "times":
				main.change_scene(speedrun_finish)
				if not get_parent().player_died:
					AchievementsAndStatsObserver.set_achievement("clutch")
				
			elif level == 17 and speedrun_mode.category == "secret_times":
				main.change_scene(save_file.secret_levels[0])
				if not get_parent().player_died:
					AchievementsAndStatsObserver.set_achievement("clutch")
			
			elif level == 18:
				main.change_scene(speedrun_finish)
				if not get_parent().player_died:
					AchievementsAndStatsObserver.set_achievement("secret_clutch")



func shake_screen(intensity: float = 24, damping: float = 4):
	var camera = get_tree().get_nodes_in_group("camera")[0]
	camera.shake_screen(intensity, damping)



func hit(bullet: PlayerBullet):
	bullet.change_state("ReturnState")
	if state < 5:
		state += 1
		$AnimationPlayer.play("Anim" + String(state))
		
		var particles = hit_particles.instance()
		particles.position = bullet.position
		get_parent().add_child(particles)
		
		if state == 1:
			shake_screen()






func _on_PHASE1A_finished():
	$PHASE1B.play()


func _on_PHASE2A_finished():
	$PHASE2B.play()


func _on_PHASE3A_finished():
	$PHASE3B.play()


func _on_PHASE4A_finished():
	$PHASE4B.play()
