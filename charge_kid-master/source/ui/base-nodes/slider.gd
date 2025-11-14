extends MenuOption
class_name MenuHSlider



export(Resource) var grabber
export(Resource) var highlighted_grabber

onready var slider = $SliderContainer/HSlider

onready var white: Color = Color("#f6f6e6")
onready var pink: Color = Color("#ff4c7b")



func _process(delta):
	if has_focus():
		slider.set('custom_icons/grabber', highlighted_grabber)
		$Label.set("custom_colors/font_color", pink)
		
		var directional_input: Vector2 = input_getter.get_directional_input(true)
		if switch_option_timer.is_stopped() and nav_timer.is_stopped():
			if directional_input.x != 0:
				if directional_input.x == 1:
					slider.value += slider.step
				elif directional_input.x == -1:
					slider.value -= slider.step
				switch_option_timer.start(switch_option_time)
	else:
		slider.set('custom_icons/grabber', grabber)
		$Label.set("custom_colors/font_color", white)



func _on_HSlider_value_changed(value):
	pass # Replace with function body.


