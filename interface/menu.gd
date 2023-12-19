extends Control

signal started()
signal resumed()

enum MenuType {
	MAIN,
	PAUSE
}

@export var type: MenuType = MenuType.MAIN

var _settings = preload("res://interface/settings.tscn")

@onready var _background = $Background

@onready var _content_title = $Content/_/_/Title
@onready var _content_navigation = $Content/_/Navigation
@onready var _content_navigation_btn_start = $Content/_/Navigation/Start
@onready var _content_navigation_btn_resume = $Content/_/Navigation/Resume
@onready var _content_navigation_btn_options = $Content/_/Navigation/Options
@onready var _content_navigation_btn_help = $Content/_/Navigation/Help
@onready var _content_navigation_btn_quit = $Content/_/Navigation/Quit

@onready var _animator = $Animator

@onready var _confirmation_quit = $QuitConfirmation

func _ready():
	_update_title()
	_update_buttons()
	
	if type == MenuType.MAIN:
		_main_start()
	elif type == MenuType.PAUSE:
		hide()

func _process(_delta):
	print(_background.color)

func _on_visibility_changed():
	if is_node_ready():
		if type == MenuType.PAUSE:
			if visible:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				_pause_start()
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				_pause_end()
		
		_update_buttons()

func _on_start_pressed():
	if type != MenuType.MAIN:
		return
	
	_main_end()

func _on_resume_pressed():
	if type != MenuType.PAUSE:
		return
	
	emit_signal("resumed")

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

func _main_start():
	_animator.play("start")
	await _animator.animation_finished
	_content_navigation_btn_start.grab_focus()

func _main_end():
	_animator.play("end")
	await _animator.animation_finished
	emit_signal("started")

func _pause_start():
	_animator.play("start-pause")
	await _animator.animation_finished
	_content_navigation_btn_resume.grab_focus()

func _pause_end():
	_animator.play("end-pause")
	await _animator.animation_finished
	_content_navigation_btn_resume.release_focus()

func _update_title():
	_content_title.text = Global.application_name

func _update_buttons():
	for child in _content_navigation.get_children():
		child.hide()
	if type == MenuType.MAIN:
		_content_navigation_btn_start.show()
	elif type == MenuType.PAUSE:
		_content_navigation_btn_resume.show()
	
	_content_navigation_btn_options.show()
	_content_navigation_btn_help.show()
	_content_navigation_btn_quit.show()
