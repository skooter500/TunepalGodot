extends Control

@onready var record_bus_index = AudioServer.get_bus_index("Record")
@onready var spectrum = AudioServer.get_bus_effect_instance(record_bus_index, 0)
@onready var timer = $Timer
@onready var record_button = $Record
@onready var label_box = $LabelBox
@onready var label = $LabelBox/Label
@onready var active = false
@onready var stop = false
@onready var note_string : String
const fund_frequencies = [293.66, 329.63, 369.99, 392.00, 440.00, 493.88, 554.37, 587.33
			, 659.25, 739.99, 783.99, 880.00, 987.77, 1108.73, 1174.66, 1318.51, 1479.98, 1567.98, 1760.00, 1975.53, 2217.46, 2349.32]
const spellings = ["D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D"]

@onready var db = SQLite.new()
@onready var db_name = "res://Database/tunepal.db"
@onready var query_result

@onready var thread_count = OS.get_processor_count()

@onready var confidences

var my_csharp_script
var ednode

func _ready():
	my_csharp_script = load("res://edit_distance.cs")
	ednode = my_csharp_script.new()
	db.path = db_name
	db.open_db()
	db.read_only = true
	db.query("select tuneindex.id as id, tune_type, notation, source.id as sourceid, url, source.source as sourcename, title, alt_title, tunepalid, x, midi_file_name, key_sig, search_key from tuneindex, tunekeys, source where tunekeys.tuneid = tuneindex.id and tuneindex.source = source.id;")
	await get_tree().create_timer(.5).timeout
	query_result = db.query_result
	db.close_db()

func _process(_delta):
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
		if note_string.length() != 0:
			if spellings[minIndex] != note_string[note_string.length()-1]:
				note_string = note_string + spellings[minIndex]
		else:
			note_string = spellings[minIndex]
		#print(frequency, " Hz ", big)
		
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
	note_string = ""
	
	
func stop_recording():
	var time = Time.get_ticks_msec()
	active = false
	confidences = []
	#note_string = "AFADGGGAGFDDEFDCAFADGGGAGGGBCDBGAGFFDGGGAGFDEFDCAFFDGGGAGGGDGGGAGFEDDD"
	print(note_string.length())
	var length = float(query_result.size()) / float(thread_count)
	var threads = []
	
	for i in thread_count:
		var thread = Thread.new()
		threads.append(thread)
	
	for i in threads.size():
		var callable
		callable = Callable(self,"search").bind(int(i*length),int((i+1)*length),int(i))
		threads[i].start(callable)

	var return_array = []
	for i in threads.size():
		var return_value = threads[i].wait_to_finish()
		return_array.append(return_value)
	
	for array in return_array:
		for i in array:
			confidences.append(i)
	
	confidences.sort_custom(d_sort)
	get_node("../../ResultMenu").visible = true
	get_node("../").visible = false
	get_node("../../ResultMenu/Control/ScrollContainer/Songs").populate(confidences)
	record_button.text = "Record"
	print("Time = " + String.num(((float(Time.get_ticks_msec()) - float(time))/1000), 3) + " sec")
	
func search(start, end, thread):
	print(start, " ", end)
	var info = []
	for id in range(start, end):
		var search_key = query_result[id]["search_key"]
		if !search_key.length() < 50:
			var confidence = ednode.edSubstring(note_string, search_key, thread)
			info.append({"confidence" : confidence, "id" : query_result[id]["id"], "title" : query_result[id]["title"]})
	return info
			
static func d_sort(a, b):
	if a["confidence"] > b["confidence"]:
		return true
	return false

func _on_record_pressed():
	if !active:
		start_recording()
	else:
		stop = true

func _on_timer_timeout():
	record_button.text = "Processing..."
	await get_tree().create_timer(.5).timeout
	stop_recording()
	
