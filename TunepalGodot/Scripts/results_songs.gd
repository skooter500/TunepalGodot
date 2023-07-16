extends VBoxContainer

@onready var original_button = get_child(0)
@onready var buttons = []
@onready var information

func _ready():
	remove_child(original_button)

func _process(_delta):
	for button in buttons:
		if button.button_pressed:
			get_node("../../../../ResultMenu").visible = false
			get_node("../../../../ABCMenu/Control/ColorRect/ABC").text = information[button.index]["notation"]
			get_node("../../../../ABCMenu").visible = true

func delete():
	for button in buttons:
		remove_child(button)
		button.free()
	buttons = []

func populate(confidences):
	information = confidences
	for i in range(0, confidences.size()):
		var button = original_button.duplicate()
		button.index = i
		add_child(button)
		buttons.append(button)
		button.set_text(str(confidences[i]["title"]) + " (" + String.num(confidences[i]["confidence"],2)+ "%)")
		button.visible = true
		if i == 99:
			break
