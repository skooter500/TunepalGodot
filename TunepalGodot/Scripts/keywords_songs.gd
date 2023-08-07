extends VBoxContainer

@onready var stuff = get_node("../../../../RecordMenu/Control").get("db").query_result
@onready var current_tune_type = ["all"]
@onready var buttons = get_children()
@onready var labels = []
func _on_search_bar_text_submitted(new_text):
	for button in buttons:
		labels.append(button.get_children())
		button.visible = false
	for label in labels:
		label[0].visible = false
	var regex = RegEx.new()
	regex.compile("\\b\\w+\\b")
	var strings = regex.search_all(new_text)
	var matches = []
	for i in strings:
		matches.append(i.get_string().to_lower())
	var j = 0
	for i in range(0, stuff.size()):
		var button = buttons[j]
		var label = labels[j]
		var check = false
		for string in matches:
<<<<<<< HEAD
			if current_tune_type != ["all"]:
				for time_sig in current_tune_type:
					if stuff[i]["title"].to_lower().contains(string) and time_sig == stuff[i]["time_sig"]: 
						check = true
			elif stuff[i]["title"].to_lower().contains(string):
				check = true
=======
			for time_signature in current_tune_type:
				if stuff[i]["title"].to_lower().contains(string) and time_signature == stuff[i]["tune_type"]: 
					check = true
				elif stuff[i]["title"].to_lower().contains(string) and time_signature == "all":
					check = true
>>>>>>> 700cd799ad97696cf66091b41d2932dbb2df8641
		if check:
			button.set_text("  " + stuff[i]["title"])
			var string = ""
			if stuff[i]["shortName"] != null:
				string = string + stuff[i]["shortName"]
			if stuff[i]["tune_type"] != null:
				string = string + " | " + stuff[i]["tune_type"]
			if stuff[i]["key_sig"] != null:
				string = string + " | " + stuff[i]["key_sig"]
			label[0].set_text(string)
			#print(label[0].text)
			button.visible = true
			label[0].visible = true
			j += 1
		if j == 50:
			break
func _on_all_toggled(button_pressed):
	current_tune_type = ["all"]
func _on_reels_hornpipes_toggled(button_pressed):
	current_tune_type = ["C", "C|", "4/4", "2/2", "4/2"]
func _on_jigs_slides_etc_toggled(button_pressed):
	current_tune_type = ["12/8", "6/8"]
func _on_slip_jigs_hop_jigs_toggled(button_pressed):
	current_tune_type = ["9/8"]
func _on_waltzes_mazurkas_toggled(button_pressed):
	current_tune_type = ["3/4"]
func _on_unsusual_jigs_toggled(button_pressed):
	current_tune_type = ["3/8"]
func _on_unusual_english_hornpipes_toggled(button_pressed):
	current_tune_type = ["3/2", "6/4"]
