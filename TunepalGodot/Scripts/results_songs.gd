extends VBoxContainer

@onready var buttons = get_children()

func _ready():
	for button in buttons:
		button.visible = false
		
func populate(distances):
	for i in range(0, buttons.size()):
		var button = buttons[i]
		var check = true
		button.set_text(str(distances[i]["title"]) + " " + str(distances[i]["distance"]))
		button.visible = true
