extends Control

func _on_search_bar_text_submitted(new_text):
	var matches = []
	var buttons = $ScrollContainer/Songs.get_children()
	var items = $ScrollContainer/Songs.songs
	for button in buttons:
		button.text = ""
		button.set_visible(false)
	if new_text == "":
		return
	for i in items:
		if i.to_lower().contains(new_text.to_lower()): 
			matches.append(i)
	var i = 0
	if matches.size() == 0:
		return
	for button in buttons:
		print(matches[i])
		button.set_visible(true)
		button.text = matches[i]
		i += 1
		if i == matches.size():
			return
