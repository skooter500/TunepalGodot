extends VBoxContainer

@onready var buttons = get_children()

func _ready():
	for button in buttons:
		button.visible = false
		
func populate(distances):
	for i in range(0, distances.size()):
		var button = buttons[i]
		var check = true
		button.set_text(str(distances[i]["title"]) + " (" + String.num(distances[i]["distance"],2)+ "%)")
		button.visible = true
		if i == 49:
			break
