extends Window

const TAB_INDEX_TUTORIAL = 0
const TAB_INDEX_ABOUT = 1
const TAB_INDEX_LICENSE = 2
const TAB_INDEX_THIRDPARTY = 3

@onready var _contents_navigation = $Contents/_/_/Navigation
@onready var _contents_display = $Contents/_/_/Display/_

@onready var _display_tutorial = $Contents/_/_/Display/_/Tutorial
@onready var _display_about = $Contents/_/_/Display/_/About
@onready var _display_license = $Contents/_/_/Display/_/License
@onready var _display_thirdparty = $Contents/_/_/Display/_/Thirdparty

func _ready():
	_read_from_files()

func _on_window_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("close_requested")

func _on_close_requested():
	queue_free()

func _on_navigation_tab_changed(tab):
	for child in _contents_display.get_children():
		child.hide()
	if tab == TAB_INDEX_TUTORIAL:
		_display_tutorial.show()
	elif tab == TAB_INDEX_ABOUT:
		_display_about.show()
	elif tab == TAB_INDEX_LICENSE:
		_display_license.show()
	elif tab == TAB_INDEX_THIRDPARTY:
		_display_thirdparty.show()

func _read_from_files():
	var tutorial = FileAccess.open("res://interface/info/tutorial.txt", FileAccess.READ)
	var about = FileAccess.open("res://interface/info/about.md", FileAccess.READ)
	var license = FileAccess.open("res://LICENSE", FileAccess.READ)
	var thirdparty = FileAccess.open("res://interface/info/thirdparty.txt", FileAccess.READ)
	_display_tutorial.text = tutorial.get_as_text()
	_display_about.markdown_text = about.get_as_text()
	_display_license.text = license.get_as_text()
	_display_thirdparty.text = thirdparty.get_as_text()
	tutorial.close()
	about.close()
	license.close()
	thirdparty.close()
