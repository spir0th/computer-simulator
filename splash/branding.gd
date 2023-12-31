extends Control

@onready var _animator = $Animator

func _ready():
	_start()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# If player wants to skip this animation, call the animator to finish immediately.
		_animator.emit_signal("animation_finished", "branding-start")

func _start():
	# Temporarily hide mouse cursor, it will be brought back later.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Play the start animation and await for the animator.
	# When the animation ends, bring back the mouse cursor then transition to the main scene.
	_animator.play("branding-start")
	await _animator.animation_finished
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://main.tscn")
