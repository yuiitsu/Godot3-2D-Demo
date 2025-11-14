extends Control
class_name MenuOption

export(float) var switch_option_time

onready var main: Node = get_tree().get_nodes_in_group("main")[0]
onready var nav_timer: Timer = main.get_node("MenuNavigation/MenuNavTimer")
onready var accept_timer: Timer = main.get_node("MenuNavigation/MenuAcceptTimer")
onready var input_getter: ButtonGetter = main.control_handler

var switch_option_timer: Timer

func _ready():
	switch_option_timer = Timer.new()
	switch_option_timer.autostart = false
	switch_option_timer.one_shot = true
	self.add_child(switch_option_timer)
	switch_option_timer.wait_time = switch_option_time
	self.connect("focus_entered", self, "_on_focus_entered")
	self.connect("focus_exited", self, "_on_focus_exited")


func _process(_delta):
	main  = get_tree().get_nodes_in_group("main")[0]
	
	if has_focus():
		if switch_option_timer.is_stopped() and nav_timer.is_stopped():
			if input_getter.get_directional_input(true).y == 1:
				check_and_grab_focus(focus_neighbour_bottom)
			elif input_getter.get_directional_input(true).y == -1:
				check_and_grab_focus(focus_neighbour_top)
			elif input_getter.get_directional_input(true).x == 1:
				check_and_grab_focus(focus_neighbour_right)
			elif input_getter.get_directional_input(true).x == -1:
				check_and_grab_focus(focus_neighbour_left)
		if input_getter.get_directional_input(true) == Vector2.ZERO and !switch_option_timer.is_stopped():
			switch_option_timer.stop()

func check_and_grab_focus(path :NodePath):
	var option = get_node_or_null(path)
	if option != null:
		option.grab_focus()

func _on_focus_entered():
	if switch_option_timer.is_inside_tree():
		switch_option_timer.start(switch_option_time)

func _on_focus_exited():
	if accept_timer.is_stopped():
		main.get_node("MenuNavigation/MenuNavigate").play()
