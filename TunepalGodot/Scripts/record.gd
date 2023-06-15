extends Control

var record_bus_index: int
var spectrum: AudioEffectSpectrumAnalyzerInstance
@onready var timer = $Timer
@onready var record_button = $Record
@onready var active = false
@onready var stop = false
@onready var frequency_array = []

func _ready():
	record_bus_index = AudioServer.get_bus_index("Record")
	spectrum = AudioServer.get_bus_effect_instance(record_bus_index, 0)
	
func _process(delta):
	if timer.get_time_left() > 0:
		var frequency = 0
		var big = 0
		for i in range(20,20000):
			if (spectrum.get_magnitude_for_frequency_range(i,i+1)[0] > big):
				big = spectrum.get_magnitude_for_frequency_range(i,i+1)[0]
				frequency = i
		print(frequency, " Hz ", big)
		frequency_array.append(frequency)
	if active and stop:
		active = false
		timer.stop()
		record_button.text = "Record"
	
func start_recording():
	stop = false
	active = true
	record_button.text = "Recording in 3"
	await get_tree().create_timer(1).timeout
	if stop:
		stop = false
		return
	record_button.text = "Recording in 2"
	await get_tree().create_timer(1).timeout
	if stop:
		stop = false
		return
	record_button.text = "Recording in 1"
	await get_tree().create_timer(1).timeout
	if stop:
		stop = false
		return
	record_button.text = "Recording..."
	timer.start(10)
	frequency_array = []
	
	
func stop_recording():
	active = false
	print(frequency_array)
	record_button.text = "Record"

func _on_record_pressed():
	if !active:
		start_recording()
	else:
		stop = true

func _on_timer_timeout():
	stop_recording()
