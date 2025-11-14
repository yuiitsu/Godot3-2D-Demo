extends Node
const print_output:bool = true

var MUS_BUS : int
var SFX_BUS : int
var MASTER_BUS : int

var OUTPUT_FILE: File

var timer: Timer

func _ready():
	timer = Timer.new()
	self.add_child(timer)
	timer.start(3)
	timer.connect("timeout", self, "_on_Timer_timeout")
	MUS_BUS = AudioServer.get_bus_index("MUS")
	print(MUS_BUS)
	SFX_BUS = AudioServer.get_bus_index("SFX")
	print(SFX_BUS)
	MASTER_BUS = AudioServer.get_bus_index("Master")
	print(MASTER_BUS)
	
	OUTPUT_FILE = File.new()
	OUTPUT_FILE.open("sound_debugging_output.dat", File.WRITE_READ)
	OUTPUT_FILE.store_line("=======================================")




func _on_Timer_timeout():
	OUTPUT_FILE.store_line(" ")
	perr("\n")
	var line = "Master volume: " + String(AudioServer.get_bus_volume_db(MASTER_BUS))
	OUTPUT_FILE.store_line(line)
	perr(line)
	line = "MUS volume: " + String(AudioServer.get_bus_volume_db(MUS_BUS))
	OUTPUT_FILE.store_line(line)
	perr(line)
	line = "SFX volume: " + String(AudioServer.get_bus_volume_db(SFX_BUS))
	perr(line)
	OUTPUT_FILE.store_line(line)

func perr(s: String) -> void:
	if print_output:
		print (s)
