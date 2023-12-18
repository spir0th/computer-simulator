extends Control

var _settings = preload("res://interface/menu/settings.tscn")

@onready var _header_title = $Contents/_/Header/Title

@onready var _btn_resume = $Contents/_/Navigation/Resume
@onready var _btn_return = $Contents/_/Navigation/Return
@onready var _btn_options = $Contents/_/Navigation/Options
@onready var _btn_help = $Contents/_/Navigation/Help
@onready var _btn_quit = $Contents/_/Navigation/Quit

@onready var _confirmation_return = $ReturnConfirmation
@onready var _confirmation_quit = $QuitConfirmation

func _ready():
	_header_title.text = Global.application_name
	assert(Global.player != null) # Must check if player is in-game
	hide() # Normally, pause menu should be hidden after being instantiated.

func _on_visibility_changed():
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed():
	get_tree().paused = false

func _on_return_pressed():
	_confirmation_return.show()

func _on_options_pressed():
	get_parent().add_child(_settings.instantiate())

func _on_quit_pressed():
	_confirmation_quit.show()

func _on_return_confirmed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_confirmation_confirmed():
	get_tree().quit()
