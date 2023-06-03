extends Control

var menus
var recordMenu
var keywordsMenu
func _ready():
	menus = $Menus.get_children()
	recordMenu = $Menus/RecordMenu
	keywordsMenu = $Menus/KeywordsMenu
	recordMenu.visible = true
func _on_record_pressed():
	for i in menus:
		i.visible = false
	recordMenu.visible = true

func _on_keywords_pressed():
	for i in menus:
		i.visible = false
	keywordsMenu.visible = true
