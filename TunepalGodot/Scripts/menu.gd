extends Control

var menus
var recordMenu
var keywordsMenu
var myTunesMenu
var preferencesMenu
var moreMenu
var preferencesMainMenu
var preferencesFundamentalMenu
var preferencesMenus
var preferencesCurrentMenu

func _ready():
	menus = $Menus.get_children()
	recordMenu = $Menus/RecordMenu
	keywordsMenu = $Menus/KeywordsMenu
	myTunesMenu = $Menus/MyTunesMenu
	preferencesMenu = $Menus/PreferencesMenu
	preferencesMenus = preferencesMenu.get_children()
	preferencesMainMenu = $Menus/PreferencesMenu/MainMenu
	moreMenu = $Menus/MoreMenu
	preferencesFundamentalMenu = $Menus/PreferencesMenu/FundamentalMenu
	preferencesCurrentMenu = preferencesMainMenu
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
	for i in preferencesMenus:
		i.visible = false
	preferencesCurrentMenu.visible = true

func _on_more_pressed():
	for i in menus:
		i.visible = false
	moreMenu.visible = true
	
func _on_transcription_fundamental_pressed():
	for i in menus:
		i.visible = false
	for i in preferencesMenus:
		i.visible = false
	preferencesMenu.visible = true
	preferencesCurrentMenu = preferencesFundamentalMenu
	preferencesCurrentMenu.visible = true

func _on_back_to_preferences_pressed():
	for i in menus:
		i.visible = false
	for i in preferencesMenus:
		i.visible = false
	preferencesCurrentMenu = preferencesMainMenu
	preferencesCurrentMenu.visible = true
	preferencesMenu.visible = true
