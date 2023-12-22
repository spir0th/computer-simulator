extends "res://world/interactable.gd"

@onready var _player = Global.player
@onready var _camera = $Camera

var _camera_yaw = 0.0
var _camera_pitch = 0.0

func _ready():
	assert(_player != null)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		await get_tree().create_timer(0.1).timeout
		_camera.clear_current()
		Global.player = _player
	if event is InputEventMouseMotion and _camera.is_current():
		var sensitivity = Global.camera_default_sensitivity
		var mouse_position = event.relative * sensitivity
		var yaw = mouse_position.x
		var pitch = mouse_position.y
		
		mouse_position = Vector2.ZERO
		yaw = clamp(yaw, -40 - _camera_yaw, 60 - _camera_yaw)
		_camera_yaw += yaw
		pitch = clamp(pitch, -40 - _camera_pitch, 60 - _camera_pitch)
		_camera_pitch += pitch
		
		_camera.rotate_y(deg_to_rad(-yaw))
		_camera.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(-pitch))

func _process(_delta):
	if _camera.current:
		Global.player = null

func _on_interacted():
	_camera.make_current()
