extends Control

var record_bus_index: int
var record_effect: AudioEffectRecord
var recording: AudioStream

func _ready():
	record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	
	
func start_recording():
	record_effect.set_recording_active(true)
	
func stop_recording():
	record_effect.set_recording_active(false)
	recording = record_effect.get_recording()
	for i in recording.data:
		print(i)

func _on_record_pressed():
	if record_effect.is_recording_active():
		stop_recording()
	else:
		start_recording()
	