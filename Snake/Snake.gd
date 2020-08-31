extends Node2D

signal snake_move_triggered(entity, direction)
signal body_segment_move_triggered(segment, segment_pos)
signal generated_tail_segment(segment, segment_pos)

onready var direction = Vector2()
onready var body_segments: Array = [self]
onready var can_move: bool = false

const scene_tail = preload("res://Tail.tscn")


func _input(event):
	if event.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
	elif event.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
	elif event.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
	elif event.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
		
		
func _process(delta):
	if direction != Vector2() and can_move:
		var pre_segment_pos: Vector2 = self.position
		for i in range(body_segments.size()):
			var temp_pos: Vector2 = Vector2()
			if i == 0:
				emit_signal("snake_move_triggered", body_segments[i], direction)
			else:
				temp_pos = body_segments[i].position
				emit_signal("body_segment_move_triggered", body_segments[i], pre_segment_pos)
				pre_segment_pos = temp_pos
			
		# 延时移动
		can_move = false
		$MoveDelay.start()


func _on_MoveDelay_timeout():
	can_move = true
	
	
func eat_food():
	var tail_segment: Node2D = scene_tail.instance() as Node2D
	body_segments.append(tail_segment)
	#
	emit_signal("generated_tail_segment", tail_segment, body_segments[-2].position)
