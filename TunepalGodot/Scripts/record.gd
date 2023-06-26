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

var my_csharp_script
var ednode

func _ready():
	
	
	my_csharp_script = load("res://edit_distance.cs")
	ednode = my_csharp_script.new()
	
	# var edn = ednode.edSubstring("BDEE", "DGGGDGBDEFGAB")
	# print(edn)
	
	label_box.visible = false
	db.path = db_name
	db.open_db()
	db.read_only = true
	db.query("select tuneindex.id as id, tune_type, notation, source.id as sourceid, url, source.source as sourcename, title, alt_title, tunepalid, x, midi_file_name, key_sig, search_key from tuneindex, tunekeys, source where tunekeys.tuneid = tuneindex.id and tuneindex.source = source.id;")
	await get_tree().create_timer(.5).timeout
	query_result = db.query_result
	db.close_db()
	#var distance = edit_distance("DGGGDGBDEFGAB","BDEE")
	#print (distance)

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
	note_string = ""
	
	
func stop_recording():
	active = false
	note_string = "DDEBBABBEBBBABDBAGFDADBDADFDADDAFDEBBABBAFECDBAFDEFDEEDDE"
	var distances = []
	for id in range(0,query_result.size()):
		var search_key = query_result[id]["search_key"]
		var distance = edit_distance(search_key, note_string)
		distances.append({"distance" : distance, "id" : query_result[id]["id"], "title" : query_result[id]["title"]})
	distances.sort_custom(d_sort)
	for i in range(0,distances.size()):
		print(i+1, " ", distances[i]["title"], " ",distances[i]["distance"])
	get_node("../../ResultMenu").visible = true
	get_node("../").visible = false
	get_node("../../ResultMenu/Control/ScrollContainer/Songs").populate(distances)
	record_button.text = "Record"
	#label.text = distances[0]["title"]
	#label_box.visible = true

func edit_distance(s1, s2):
	var l1 = s1.length()
	var l2 = s2.length()
	var matrix : Array[Array]
	for i in range(0,l1+1):
		matrix.append([0])
	for i in range(1,l2+1):
		matrix[0].append(i)
	var cost = 0
	for i in range(1, l1+1):
		var c1 = s1[i-1]
		for j in range(1, l2+1):
			var c2 = s2[j-1]
			if c1 == c2:
				cost = 0
			else:
				cost = 1
			matrix[i].append(min(matrix[i-1][j]+1, matrix[i][j-1]+1, matrix[i-1][j-1]+cost))
	#print(matrix)
	var smallest = 1000000
	for i in range(0, l1+1):
		if matrix[i][l2] < smallest:
			smallest = matrix[i][l2]
	return smallest
	
static func d_sort(a, b):
	if a["distance"] < b["distance"]:
		return true
	return false

func _on_record_pressed():
	if !active:
		start_recording()
		label_box.visible = false
	else:
		stop = true

func _on_timer_timeout():
	record_button.text = "Processing..."
	await get_tree().create_timer(.5).timeout
	stop_recording()
	
