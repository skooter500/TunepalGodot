extends Control

var record_bus_index: int
var record_effect: AudioEffectRecord
var recording: AudioStream
var spectrum: AudioEffectSpectrumAnalyzerInstance

func _ready():
	record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	spectrum = AudioServer.get_bus_effect_instance(record_bus_index, 1)
	
	
func start_recording():
	record_effect.set_recording_active(true)
	
func stop_recording():
	record_effect.set_recording_active(false)
	recording = record_effect.get_recording()
	var frequency = 0
	var big = 0
	for i in range(0,500):
		if (spectrum.get_magnitude_for_frequency_range(i,i+1)[0] > big):
			big = spectrum.get_magnitude_for_frequency_range(i,i+1)[0]
			frequency = i
	print(frequency, " Hz ", big)
	

func _on_record_pressed():
	if record_effect.is_recording_active():
		stop_recording()
	else:
		start_recording()
	
