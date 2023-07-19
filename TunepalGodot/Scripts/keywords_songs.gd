extends VBoxContainer

#Placeholder array to debug code, eventually this should come
#from database I think

@onready var stuff = get_node("../../../../RecordMenu/Control").get("db").query_result
@onready var current_tune_type 
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
			for time_signature in current_tune_type:
				if stuff[i]["title"].to_lower().contains(string) and time_signature == stuff[i]["tune_type"]: 
					check = true
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
			print(label[0].text)
			button.visible = true
			label[0].visible = true
			j += 1
		if j == 50:
			break
func _on_reels_hornpipes_toggled(button_pressed):
	current_tune_type = ["hornpipe", "reel", "polka"]
	
