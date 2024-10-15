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
var preferencesTuneBooksMenu
var preferencesTimeSignaturesMenu
var preferencesCountdownMenu
var preferencesLanguageMenu
var resultMenu

func _ready():
	menus = $Menus.get_children()
	recordMenu = $Menus/RecordMenu
	keywordsMenu = $Menus/KeywordsMenu
	myTunesMenu = $Menus/MyTunesMenu
	preferencesMenu = $Menus/PreferencesMenu
	preferencesMenus = preferencesMenu.get_children()
	preferencesMainMenu = $Menus/PreferencesMenu/MainMenu
	preferencesFundamentalMenu = $Menus/PreferencesMenu/FundamentalMenu
	preferencesTuneBooksMenu = $Menus/PreferencesMenu/TuneBooksMenu
	preferencesTimeSignaturesMenu = $Menus/PreferencesMenu/TimeSignaturesMenu
	preferencesCountdownMenu = $Menus/PreferencesMenu/CountdownMenu
	preferencesLanguageMenu = $Menus/PreferencesMenu/LanguageMenu
	moreMenu = $Menus/MoreMenu
	preferencesCurrentMenu = preferencesMainMenu
	resultMenu = $Menus/ResultMenu
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

func _on_tune_books_pressed():
	for i in menus:
		i.visible = false
	for i in preferencesMenus:
		i.visible = false
	preferencesMenu.visible = true
	preferencesCurrentMenu = preferencesTuneBooksMenu
	preferencesCurrentMenu.visible = true

func _on_time_signatures_pressed():
	for i in menus:
		i.visible = false
	for i in preferencesMenus:
		i.visible = false
	preferencesMenu.visible = true
	preferencesCurrentMenu = preferencesTimeSignaturesMenu
	preferencesCurrentMenu.visible = true


func _on_countdown_pressed():
	for i in menus:
		i.visible = false
	for i in preferencesMenus:
		i.visible = false
	preferencesMenu.visible = true
	preferencesCurrentMenu = preferencesCountdownMenu
	preferencesCurrentMenu.visible = true

func _on_language_pressed():
	for i in menus:
		i.visible = false
	for i in preferencesMenus:
		i.visible = false
	preferencesMenu.visible = true
	preferencesCurrentMenu = preferencesLanguageMenu
	preferencesCurrentMenu.visible = true

func _on_back_to_record_pressed():
	for i in menus:
		i.visible = false
	recordMenu.visible = true
	
