extends Control

#MENU STUFF
@onready var record_bus_index
@onready var spectrum
@onready var timer = $Timer
@onready var record_button = $Record
@onready var active = false
@onready var stop = false

#FREQUENCY CONSTANTS
const fund_frequencies = [123.471, 130.813, 146.832, 164.814, 174.614, 195.998, 220, 246.942, 261.626, 293.665, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25, 587.33
			, 659.25, 698.46, 783.99, 880.00, 987.77, 1046.50, 1174.66, 1318.51, 1396.91, 1567.98, 1760.00, 1975.53, 2093.00, 2349.32, 2637.02, 2793.83, 3135.96, 3520, 3951.07, 4186.01, 4698.63, 5274.04, 5587.65, 6271.93, 7040, 7902.13]
const spellings = ["B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B"]

#DB STUFF
@onready var db = SQLite.new()
@onready var db_name = "res://Database/tunepal.db"
@onready var query_result

#THREAD STUFF
@onready var thread_count = OS.get_processor_count()

#NOTE STUFF
@onready var confidences
@onready var current_notes
@onready var note_string : String
var current_time
var temp_notes

#CSHARP STUFF
var my_csharp_script
var ednode


func _ready():
	record_bus_index = AudioServer.get_bus_index("Record")
	AudioServer.get_bus_effect(record_bus_index, 0).set_buffer_length(.5)
	#AudioServer.get_bus_effect(record_bus_index, 0).tap_back_pos = .05
	spectrum = AudioServer.get_bus_effect_instance(record_bus_index, 0)
	print(spellings.size(), " ", fund_frequencies.size())
	my_csharp_script = load("res://Scripts/edit_distance.cs")
	ednode = my_csharp_script.new()
	db.path = db_name
	db.open_db()
	db.read_only = true
	db.query("select tuneindex.id as id, tune_type, notation, source.id as sourceid, url, source.source as sourcename, title, alt_title, tunepalid, x, midi_file_name, key_sig, search_key from tuneindex, tunekeys, source where tunekeys.tuneid = tuneindex.id and tuneindex.source = source.id;")
	await get_tree().create_timer(.5).timeout
	query_result = db.query_result
	db.close_db()

func _physics_process(_delta):
	if timer.get_time_left() > 0:
		#await get_tree().create_timer(.1).timeout
		if current_time == null:
			current_time = timer.get_time_left()
		
		var frequency = 0
		var big = 0
		
		for i in range(100,8000):
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
		
		if big > 0.001:
			print(spellings[minIndex], " ", frequency, " Hz ", big)
			if temp_notes.size() != 0:
				var check = false
				for note in temp_notes:
					if note.note == spellings[minIndex]:
						check = true
						note.count += 1
						if note.count == 10:
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
	var sorted_notes = []
	for note in current_notes:
		if note.time > 0.05:
			sorted_notes.append(note)
	current_notes = []
	for note in sorted_notes:
		current_notes.append(note)
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
			average_time = (average / bin.size())
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
	var grouped_notes
	# Sort the notes based on their time values
	notes.sort_custom(t_sort)
	var time_interval = .05
	
	var enough_bins = false
	while enough_bins == false:
		grouped_notes = []
		var current_bin = []
		var previous_time = null
		for note in notes:
			@warning_ignore("shadowed_variable")
			var current_time = note["time"]
			if previous_time == null or current_time - previous_time <= time_interval:
				# Add the note to the current bin
				current_bin.append(note)
			else:
				# Start a new bin for notes played at a different time
				grouped_notes.append(current_bin)
				current_bin = [note]
		
			previous_time = current_time
	
		# Add the last bin to the grouped notes
		grouped_notes.append(current_bin)
		time_interval += .05
		if grouped_notes.size() <= 3:
			enough_bins = true
	return grouped_notes

func create_string(notes, time):
	var string : String
	for note in notes:
		var amount = note.time / time
		if amount < 1:
			amount = 1
		print(note.note, " ", amount)
		for i in range(amount):
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
	
