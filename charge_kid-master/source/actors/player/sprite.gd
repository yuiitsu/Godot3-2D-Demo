extends Sprite



export (PackedScene) var uncharged_step_particles
export (PackedScene) var charged_step_particles
export (PackedScene) var uncharged_player_sparks
export (PackedScene) var charged_player_sparks

export (Array, AudioStream) var step_sounds
export (Array, AudioStream) var land_sounds
export (Array, AudioStream) var jump_sounds 
export (Array, AudioStream) var boost_sounds
export (Array, AudioStream) var shoot_sounds
export (Array, AudioStream) var fuel_pickup_sounds

onready var player = get_parent()
onready var step_particles: PackedScene = uncharged_step_particles
onready var player_sparks: PackedScene = uncharged_player_sparks


func _ready():
	self.get_material().set_shader_param("activate", false)
	self.get_material().set_shader_param("erase", false)
	var rand = randi()%30 + 20
	$PlayerSparksTimer.start(rand/10)

func _physics_process(delta):
	get_material().set_shader_param("fuel", player.can_boost)
	$ProjectileParticles.emitting = player.has_bullet
	flip_sprite()
	
	if player.can_boost:
		step_particles = charged_step_particles
		player_sparks = charged_player_sparks
		for particle in player.get_node("FuelParticles").get_children():
			particle.emitting = true
	else:
		step_particles = uncharged_step_particles
		player_sparks = uncharged_player_sparks
		for particle in player.get_node("FuelParticles").get_children():
			particle.emitting = false
	
	if player.get_state() == "DyingState" and $Timer.is_stopped():
		self.position = position.rotated(deg2rad(180))
		var angle = randi()%90 - 45
		self.position = position.rotated(deg2rad(angle))
		$Timer.start()

func flip_sprite() -> void:
	if player.facing > 0 && !self.transform.x.x == 1:
		self.transform.x.x = 1
	elif player.facing < 0 && !self.transform.x.x == -1:
		self.transform.x.x = -1



func standing() -> void:
	for i in range(4):
		var particles = step_particles.instance()
		particles.position = player.position + Vector2(4*i - 6, 8)
		player.get_parent().add_child(particles)

func step_sound() -> void:
	player.get_node("SFX/Step").pitch_scale = rand_range(2.3,2.6)
	player.get_node("SFX/Step").set_stream(step_sounds[randi()%10])
	player.get_node("SFX/Step").get_stream().set_loop(false)
	player.get_node("SFX/Step").play()
	

func steps() -> void:
	var particles = step_particles.instance()
	particles.position = player.position + Vector2(0, 8)
	player.get_parent().add_child(particles)

func land() -> void:
	player.get_node("SFX/Land").pitch_scale = rand_range(2.4, 2.6)
	player.get_node("SFX/Land").set_stream(land_sounds[randi()%3])
	player.get_node("SFX/Land").get_stream().set_loop(false)
	player.get_node("SFX/Land").play()
	var spawn_position = player.position
	for i in range(4):
		var particles_a = step_particles.instance()
		particles_a.position = spawn_position + Vector2(4*i - 2, 8)
		player.get_parent().add_child(particles_a)
		var particles_b = step_particles.instance()
		particles_b.position = spawn_position + Vector2(-4*i + 2, 8)
		player.get_parent().add_child(particles_b)
		var timer = Timer.new()
		add_child(timer)
		timer.start(0.1)
		yield(timer, "timeout")
		timer.queue_free()

func shoot_particles() -> void:
	for particle in player.get_node("ShootParticles").get_children():
		particle.emitting = true



func kill() -> void:
	$ProjectileParticles.visible = false
	self.get_material().set_shader_param("activate", true)
	var angle = randi()%360 - 180
	self.position = Vector2(4,0).rotated(deg2rad(angle))
	$Timer2.start()
	
func death_sound() -> void:
	player.get_node("SFX/Death").pitch_scale = rand_range(1.1,1.3)
	player.get_node("SFX/Death").get_stream().set_loop(false)

func _on_Timer2_timeout():
	self.get_material().set_shader_param("erase", true)

func _on_PlayerSparksTimer_timeout():
	var spark = player_sparks.instance()
	spark.position = player.position
	player.get_parent().add_child(spark)
	var rand = randi()%15
	$PlayerSparksTimer.start(rand/10)



func _on_IdleTimer_timeout():
	var list = ["Waving0", "Waving1"]
	player.get_node("AnimationPlayer").play(list[randi()%list.size()])
	player.get_node("AnimationPlayer").queue("TooIdle")
	player.get_node("IdleTimer").start(3.0)


