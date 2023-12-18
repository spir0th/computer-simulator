extends Control

var _settings = preload("res://interface/menu/settings.tscn")

@onready var _header_title = $Contents/_/Header/Title
@onready var _btn_start = $Contents/_/Navigation/Start
@onready var _btn_options = $Contents/_/Navigation/Options
@onready var _btn_help = $Contents/_/Navigation/Help
@onready var _btn_quit = $Contents/_/Navigation/Quit
@onready var _animator = $Animator
@onready var _confirmation_quit = $QuitConfirmation

func _ready():
	_header_title.text = Global.application_name
	_animator.play("start")

func _on_start_pressed():
	_animator.play("end")

func _on_options_pressed():
	get_parent().add_child(_settings.instantiate())

func _on_quit_pressed():
	_confirmation_quit.show()

func _on_quit_confirmation_confirmed():
	get_tree().quit()

func _on_animation_started(_anim_name):
	set_process_input(false)

func _on_animation_finished(_anim_name):
	set_process_input(true)

func _load_game():
	get_tree().change_scene_to_file("res://game.tscn")
