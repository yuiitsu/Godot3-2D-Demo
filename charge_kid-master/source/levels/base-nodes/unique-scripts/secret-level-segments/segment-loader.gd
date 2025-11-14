extends Area2D

onready var autoscroller = get_parent().get_node("Autoscroller")
onready var loaded = false

var segment



func _ready():
	segment = autoscroller.pick_a_segment()
	self.monitoring = true



func on_body_entered(body):
	if body.is_in_group("player") and not loaded:
		segment = segment.instance()
		for child in segment.get_children():
			var node = child.duplicate()
			node.position = self.position + child.position
			get_parent().call_deferred("add_child", node)
		loaded = true


