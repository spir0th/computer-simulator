extends Control

@onready var _animator = $Animator

func _ready():
	_start()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# If player wants to skip this animation, call the animator to finish immediately.
		_animator.emit_signal("animation_finished", "branding-start")

func _start():
	# Temporarily hide mouse cursor, this will be handled by the CopyrightScreen later.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Play the start animation and await for the animator.
	# When the animation ends, transition to CopyrightScreen
	_animator.play("branding-start")
	await _animator.animation_finished
	get_tree().change_scene_to_file("res://splash/copyright.tscn")
