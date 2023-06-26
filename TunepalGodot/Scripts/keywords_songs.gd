extends VBoxContainer

#Placeholder array to debug code, eventually this should come
#from database I think

func _ready():
	var buttons = get_children()
	for button in buttons:
		button.visible = false
	
