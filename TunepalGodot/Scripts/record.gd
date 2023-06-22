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
const spellings = ["D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D"]

@onready var db = SQLite.new()
@onready var db_name = "res://Database/tunepal.db"

func _ready():
	db.path = db_name
	db.open_db()
	db.read_only = true
	#db.query("select tuneindex.id as id, tune_type, notation, source.id as sourceid, url, source.source as sourcename, title, alt_title, tunepalid, x, midi_file_name, key_sig from tuneindex, tunekeys, source where tuneindex.source = source.id and tunekeys.tuneid= tuneindex.id order by downloaded desc;")
	db.query("select tuneindex.id as id, tune_type, notation, source.id as sourceid, url, source.source as sourcename, title, alt_title, search_key from tuneindex, tunekeys, source where tunekeys.tuneid = tuneindex.id and tuneindex.source = source.id;")

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
	timer.start(1)
	note_array = []
	
	
func stop_recording():
	active = false
	print(note_array)
	record_button.text = "Record"
	var distances = []
	for song in range(0,db.query_result.size()/1000):
		var n = note_array.size()
		var temp = db.query_result[song]["search_key"]
		var search_key = []
		for i in temp:
			search_key.append(i)
		var m = search_key.size()
		
		var p : Array
		var d : Array
		for i in range(0,n+1):
			p.append(0)
			d.append(0)
		var _d : Array
		
		var t_j
		
		var cost
		
		for i in range(0,n):
			p[i] = i
		for j in range(1,m):
			t_j = search_key[j-1]
			d[0] = j
			for i in range(1,n):
				if note_array[i-1] == t_j:
					cost = 0
				else:
					cost = 1
				d[i] = min(min(d[i-1] + 1, p[i] + 1), p[i-1] + cost)
			_d = p
			p = d
			d = _d
		distances.append({"distance" : p[n-1], "id" : db.query_result[song]["id"]})
	distances.sort_custom(d_sort)
	for i in range(0,distances.size()):
		print(db.query_result[distances[i]["id"]]["title"], " ",distances[i]["distance"])
	
static func d_sort(a, b):
	if a["distance"] < b["distance"]:
		return true
	return false
func _on_record_pressed():
	if !active:
		start_recording()
	else:
		stop = true

func _on_timer_timeout():
	stop_recording()
