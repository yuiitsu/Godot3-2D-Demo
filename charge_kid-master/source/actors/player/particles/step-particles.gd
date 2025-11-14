extends Node2D



export (float, 0, 1) var time_between_frames
export (float, 0, 1) var lifetime
export (PackedScene) var sparks

func _ready():
	$Sprite.frame = randi()%4
	$Tick.start(time_between_frames)
	$Lifetime.start(lifetime)

func _on_Tick_timeout():
	var rand_num = randi()%4
	while rand_num == $Sprite.frame:
		rand_num = randi()%4
	$Sprite.frame = rand_num
	rand_num = randi()%10
	if rand_num == 0:
		var spark = sparks.instance()
		spark.position = self.position
		get_parent().add_child(spark)
	$Tick.start(time_between_frames)

func _on_Lifetime_timeout():
	queue_free()
