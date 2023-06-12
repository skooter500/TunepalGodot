extends Control

var menus
var recordMenu
var keywordsMenu
var myTunesMenu
var preferencesMenu
var moreMenu

func _ready():
	menus = $Menus.get_children()
	recordMenu = $Menus/RecordMenu
	keywordsMenu = $Menus/KeywordsMenu
	myTunesMenu = $Menus/MyTunesMenu
	preferencesMenu = $Menus/PreferencesMenu
	moreMenu = $Menus/MoreMenu
	for i in menus:
		i.visible = false
	recordMenu.visible = true
	
func _on_record_pressed():
	for i in menus:
		i.visible = false
	recordMenu.visible = true

func _on_keywords_pressed():
	for i in menus:
		i.visible = false
	keywordsMenu.visible = true

func _on_my_tunes_pressed():
	for i in menus:
		i.visible = false
	myTunesMenu.visible = true

func _on_preferences_pressed():
	for i in menus:
		i.visible = false
	preferencesMenu.visible = true


func _on_more_pressed():
	for i in menus:
		i.visible = false
	moreMenu.visible = true
	
