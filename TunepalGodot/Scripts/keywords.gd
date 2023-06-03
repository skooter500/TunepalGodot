extends Control


#Idk how to dynamically show buttons and text... yet
func _on_search_bar_text_submitted(new_text):
	var matches = []
	var buttons = $ScrollContainer/Songs.get_children
	var items = $ScrollContainer/Songs.songs
	if new_text == "":
		return
	for i in items:
		if i.to_lower().contains(new_text.to_lower()): 
			matches.append(i)
	#Not finished!
