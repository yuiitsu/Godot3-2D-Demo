extends MenuHSlider

onready var sound_control: SoundControl = get_tree().get_nodes_in_group("sound_control")[0]

func _ready():
	slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('MUS')))

func _on_HSlider_value_changed(value):
	sound_control.change_bgm_volume_value(value)
