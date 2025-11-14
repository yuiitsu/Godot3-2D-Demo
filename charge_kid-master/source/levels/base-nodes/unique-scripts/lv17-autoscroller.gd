extends Node2D

export (float) var speed

onready var active: bool = true
onready var checkpoint_3_event_part: int = 0
onready var end_of_level: bool = false

onready var camera_placement = get_parent().get_node("Checkpoint3/CameraRespawnPoint")
onready var top_gate = get_parent().get_node("EnergyGate7")
onready var bottom_gate = get_parent().get_node("EnergyGate6")
onready var camera = get_parent().get_node("PlayerCamera")



func _ready():
	if get_tree().get_nodes_in_group("main").size() > 0:
		var main = get_tree().get_nodes_in_group("main")[0]
		var save_file = main.get_node("SaveFileHandler")
		var speedrun_mode = main.get_node("SpeedrunMode")
		if save_file.progress["faster_autoscrollers"] == true and speedrun_mode.is_active():
			speed *= 1.5



func _physics_process(delta):
	if get_tree().get_nodes_in_group("player").size() > 0:
		var player = get_tree().get_nodes_in_group("player")[0]
		if $PauseTimer.is_stopped() and active and player.get_state() != "DyingState":
			if self.position.x < get_parent().level_length - 256:
				self.position.x = clamp(self.position.x + speed*delta, 0, get_parent().level_length - 256)
				if player.position.x - self.position.x > 160:
					self.position.x = clamp(self.position.x + speed*delta*2, 0, get_parent().level_length - 256)
			else:
				if not end_of_level:
					camera.shake_screen(30, 2)
					$SFX.set_pitch_scale(rand_range(1,1.3))
					$SFX.play()
					self.speed *= 3
					end_of_level = true
					
				$EnergyGate.position.x += speed*delta



func _on_3rdPartEventStarter_body_entered(body):
	if body.is_in_group("player") and checkpoint_3_event_part == 0:
		active = false
		checkpoint_3_event_part = 1
		var final_pos = get_parent().get_node("3rdPartEventStarter").position
		$Tween.interpolate_property(self, "position", null, final_pos, 2.0, 
									Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()



func _on_Tween_tween_completed(object, key):
	if object == self:
		$PauseTimer.start(2)
		camera.shake_screen(30, 3)
		$SFX.set_pitch_scale(rand_range(1,1.3))
		$SFX.play()
	elif object == top_gate and checkpoint_3_event_part == 1:
		checkpoint_3_event_part = 2
		$Tween.interpolate_property(top_gate, "position", null, Vector2(2248, 360), 6.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		camera.shake_screen(30,3)
		$SFX.set_pitch_scale(rand_range(1,1.3))
		$SFX.play()
	elif object == top_gate and checkpoint_3_event_part == 2:
		checkpoint_3_event_part = 3
		$PauseTimer.start(3)
	elif object == bottom_gate and checkpoint_3_event_part == 3:
		checkpoint_3_event_part = 4
		$Tween.interpolate_property(bottom_gate, "position", null, Vector2(2248, -40), 6.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		camera.shake_screen(30,3)
		$SFX.set_pitch_scale(rand_range(1,1.3))
		$SFX.play()
	elif object == bottom_gate and checkpoint_3_event_part == 4:
		checkpoint_3_event_part = 5
		$PauseTimer.start(0.5)




func _on_PauseTimer_timeout():
	match checkpoint_3_event_part:
		0:
			camera.shake_screen(30, 3)
			$SFX.set_pitch_scale(rand_range(1,1.3))
			$SFX.play()
			
		1:
			$Tween.interpolate_property(top_gate, "position", null, Vector2(2248, 56), 2.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
		3:
			$Tween.interpolate_property(bottom_gate, "position", null, Vector2(2248, 264), 2.0,
										Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
		5:
			checkpoint_3_event_part = 6
			get_parent().get_node("Gate3").deactivate()
			get_parent().get_node("EnergyWire3").activate()
			$PauseTimer.start(2)
			active = true
		6:
			camera.shake_screen(30, 3)
			$SFX.set_pitch_scale(rand_range(1,1.3))
			$SFX.play()



