extends Control

@onready var _animator = $Animator

func _ready():
	_start()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# If player wants to skip this animation, call the animator to finish immediately.
		_animator.emit_signal("animation_finished", "copyright-start")

func _start():
	# Play the start animation and await for the animator to finish.
	_animator.play("copyright-start")
	await _animator.animation_finished
	# When animation ends, show the mouse cursor then change to Main
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://main.tscn")
