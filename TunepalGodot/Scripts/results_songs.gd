extends VBoxContainer

@onready var buttons = get_children()

func _ready():
	for button in buttons:
		button.visible = false
		
func populate(confidences):
	for i in range(0, confidences.size()):
		var button = buttons[i]
		button.set_text(str(confidences[i]["title"]) + " (" + String.num(confidences[i]["confidence"],2)+ "%)")
		button.visible = true
		if i == 99:
			break
