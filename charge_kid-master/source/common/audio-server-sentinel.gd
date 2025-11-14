extends Node

onready var master_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
onready var sfx_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
onready var mus_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MUS"))
onready var reverb_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("REVERB"))
onready var deathfilter_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("DEATH FILTER"))

func _process(delta):
	#master_volume = compare_and_report_volume_change(sfx_volume, AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")), "Master")
	sfx_volume = compare_and_report_volume_change(sfx_volume, AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")), "SFX")
	mus_volume = compare_and_report_volume_change(mus_volume, AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MUS")), "MUS")
	reverb_volume = compare_and_report_volume_change(reverb_volume, AudioServer.get_bus_volume_db(AudioServer.get_bus_index("REVERB")), "REVERB")
	#deathfilter_volume = compare_and_report_volume_change(sfx_volume, AudioServer.get_bus_volume_db(AudioServer.get_bus_index("DEATH FILTER")), "DEATH FILTER")

func compare_and_report_volume_change(old_value: float, new_value: float, bus_name: String):
	if not old_value == new_value:
		print(bus_name + " volume changed from " + str(old_value) + " to " + str(new_value))
		return new_value
	return old_value
