extends Node3D

@onready var _header_title = $Interface/Header/Title
@onready var _camera = $Camera
@onready var _camera_animator = $Camera/Animator

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_header_title.text = "%s\nBenchmark Mode" % Global.application_name
	_camera_animator.play("benchmark")

func _on_benchmark_animation_finished(anim_name):
	if anim_name == "benchmark":
		_camera_animator.play("benchmark~1")
	elif anim_name == "benchmark~1":
		_camera_animator.play("benchmark~2")
	elif anim_name == "benchmark~2":
		_camera_animator.play("benchmark~3")
	elif anim_name == "benchmark~3":
		_camera_animator.play("benchmark~4")
	elif anim_name == "benchmark~4":
		_camera_animator.play("benchmark~5")
	elif anim_name == "benchmark~5":
		_camera_animator.play("outro")
	elif anim_name == "outro":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://main.tscn")
