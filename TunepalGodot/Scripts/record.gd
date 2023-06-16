extends Control

@onready var record_bus_index = AudioServer.get_bus_index("Record")
@onready var spectrum = AudioServer.get_bus_effect_instance(record_bus_index, 0)
@onready var timer = $Timer
@onready var record_button = $Record
@onready var active = false
@onready var stop = false
@onready var note_array = []
const fund_frequencies = [293.66, 329.63, 369.99, 392.00, 440.00, 493.88, 554.37, 587.33
			, 659.25, 739.99, 783.99, 880.00, 987.77, 1108.73, 1174.66, 1318.51, 1479.98, 1567.98, 1760.00, 1975.53, 2217.46, 2349.32]
const spellings = ["D,", "E,", "F,", "G,", "A,", "B,", "C", "D", "E", "F", "G", "A", "B","c", "d", "e", "f", "g", "a", "b", "c'", "d'", "e'", "f'", "g'", "a'", "b'", "c''", "d''"]

func _process(delta):
	if timer.get_time_left() > 0:
		var frequency = 0
		var big = 0
		for i in range(20,20000):
			if (spectrum.get_magnitude_for_frequency_range(i,i+1)[0] > big):
				big = spectrum.get_magnitude_for_frequency_range(i,i+1)[0]
				frequency = i
		var minIndex = -1
		var minDiff = 1.79769e308
		for i in range(0,fund_frequencies.size()):
			var diff = abs(frequency - fund_frequencies[i])
			if (diff < minDiff):
				minDiff = diff
				minIndex = i
		if spellings[minIndex] != note_array.back():
			note_array.append(spellings[minIndex])
		print(frequency, " Hz ", big)
		
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
	note_array = []
	
	
func stop_recording():
	active = false
	print(note_array)
	record_button.text = "Record"

func _on_record_pressed():
	if !active:
		start_recording()
	else:
		stop = true

func _on_timer_timeout():
	stop_recording()
