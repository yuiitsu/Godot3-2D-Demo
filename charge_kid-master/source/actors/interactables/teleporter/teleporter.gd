extends StaticBody2D



export (PackedScene) var particle_effects
export (bool) var active

onready var animation_player = $AnimationPlayer
onready var level = get_parent()



func _ready():
	if active:
		animation_player.play("Ready")

func _physics_process(delta):
	if not active:
		animation_player.play("Inactive")



func activate() -> void:
	if not active:
		active = true
		animation_player.play("Hit")

func deactivate() -> void:
	active = false

func is_active() -> bool:
	return active



func hit(bullet: PlayerBullet) -> void:
	if animation_player.current_animation == "Ready" and bullet.get_state() != "FuelChargeState":
		animation_player.play("Hit")
		$SFX.set_pitch_scale(rand_range(0.8,1.2))
		$SFX.play()
		
		if not get_tree().get_nodes_in_group("player").empty():
			var player = get_tree().get_nodes_in_group("player")[0] as Player
			if player.get_state() != "DyingState":
				player.change_state("StatelessState")
				if player.facing > 0:
					player.animation_player.play("TeleportInRight")
				else:
					player.animation_player.play("TeleportInLeft")
				bullet.animation_player.play("TeleportIn")
				
				yield(player.animation_player, "animation_finished")
				swap_positions(bullet, player)
				level.get_node("PlayerCamera").shake_screen(16)
				if player.facing > 0:
					player.animation_player.play("TeleportOutRight")
				else:
					player.animation_player.play("TeleportOutLeft")
				bullet.animation_player.play("TeleportOut")
				
				yield(player.animation_player, "animation_finished")
				player.change_state("IdleState")
				bullet.disable_enable_hitbox(true)
	else:
		bullet.change_state("ReturnState")



func swap_positions(bullet: PlayerBullet, player: Player) -> void:
	if bullet != null and player != null:
		var dummy = player.position
		bullet.disable_enable_hitbox(false)
		player.position = self.position + Vector2(0,-16)
		bullet.position = dummy



func on_animation_finished(animation):
	match animation:
		"Hit":
			animation_player.play("Recharging")
		"Recharging":
			animation_player.play("Ready")

func spawn_particles() -> void:
	var particles = particle_effects.instance()
	particles.position = self.position
	get_parent().add_child(particles)




