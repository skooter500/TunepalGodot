extends Control

@onready var record_bus_index = AudioServer.get_bus_index("Record")
@onready var spectrum = AudioServer.get_bus_effect_instance(record_bus_index, 0)
@onready var timer = $Timer
@onready var record_button = $Record
@onready var active = false
@onready var stop = false
@onready var note_string : String
const fund_frequencies = [293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25, 587.33
			, 659.25, 698.46, 783.99, 880.00, 987.77, 1046.50, 1174.66, 1318.51, 1396.91, 1567.98, 1760.00, 1975.53, 2093.00, 2349.32]
const spellings = ["D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D"]

@onready var db = SQLite.new()
@onready var db_name = "res://Database/tunepal.db"
@onready var query_result

@onready var thread_count = OS.get_processor_count()

@onready var confidences
@onready var current_notes

var my_csharp_script
var ednode

var current_time
var temp_notes

func _ready():
	my_csharp_script = load("res://Scripts/edit_distance.cs")
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
		if current_time == null:
			current_time = timer.get_time_left()
		
		var frequency = 0
		var big = 0
		
		for i in range(290,2350):
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
		
		if big > 0.05:
			print(spellings[minIndex], " ", frequency, " Hz ", big)
			if temp_notes.size() != 0:
				var check = false
				for note in temp_notes:
					if note.note == spellings[minIndex]:
						check = true
						note.count += 1
						if note.count == 3:
							temp_notes = []
							if current_notes.size() == 0:
								current_time = current_time - timer.get_time_left()
								current_notes.append({"note" : spellings[minIndex], "time" : current_time})
								print("ENTERED")
								current_time = timer.get_time_left()
							elif current_notes[current_notes.size()-1]["note"] != spellings[minIndex]:
								current_time = current_time - timer.get_time_left()
								current_notes.append({"note" : spellings[minIndex], "time" : current_time})
								print("ENTERED")
								current_time = timer.get_time_left()
							else:
								current_time = current_time - timer.get_time_left()
								current_notes[current_notes.size()-1]["time"] += current_time
								print("EXTENDED")
								current_time = timer.get_time_left()
				if check == false:
					temp_notes.append({"note" : spellings[minIndex], "count" : 1})
			else:
				temp_notes.append({"note" : spellings[minIndex], "count" : 1})
				
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
	current_notes = []
	temp_notes = []
	record_button.text = "Recording..."
	timer.start(12)
	note_string = ""
	
	
func stop_recording():
	active = false
	confidences = []
	for note in current_notes:
		if note.time < .05:
			current_notes.erase(note)
	var sorted_notes = []
	for note in current_notes:
		sorted_notes.append(note)
	var bins = group_notes(sorted_notes)
	var average_time
	var largest = 0
	for bin in bins:
		print("BIN")
		var count = 0
		var average = 0
		for note in bin:
			print(note.note, " ", note.time)
			average += note.time
			count += 1
		if count > largest:
			largest = count
			print(average, " ", bin.size())
			average_time = (average / bin.size()) * 2
	print("AVERAGE TIME: ", average_time)
	note_string = create_string(current_notes, average_time)
	print(note_string)
	var time = Time.get_ticks_msec()
	#note_string = "AFADGGGAGFDDEFDCAFADGGGAGGGBCDBGAGFFDGGGAGFDEFDCAFFDGGGAGGGDGGGAGFEDDD"
	#note_string = "DDEBBABBEBBBABDBAGFDADBDADFDADDAF"
	#print(note_string.length())
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
	#for i in range(confidences.size()):
		#if confidences[i]["title"] == "Pigtown Fling, The":
			#print(i, " ", confidences[i]["title"], " ", confidences[i]["confidence"])

func group_notes(notes):
	var grouped_notes = []
	# Sort the notes based on their time values
	notes.sort_custom(t_sort)
	
	var current_bin = []
	var previous_time = null
	
	for note in notes:
		var current_time = note["time"]
		
		if previous_time == null or current_time - previous_time <= 0.1:
			# Add the note to the current bin
			current_bin.append(note)
		else:
			# Start a new bin for notes played at a different time
			grouped_notes.append(current_bin)
			current_bin = [note]
		
		previous_time = current_time
	
	# Add the last bin to the grouped notes
	grouped_notes.append(current_bin)
	
	return grouped_notes

func create_string(notes, time):
	var string : String
	for note in notes:
		var amount = note.time / time
		print(note.note, " ", amount)
		for i in range(amount):
			if amount > 4:
				break
			string = string + note.note
	return string
	
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
	
static func t_sort(a, b):
	if a["time"] < b["time"]:
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
	
