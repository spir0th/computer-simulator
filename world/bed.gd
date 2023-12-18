extends StaticBody3D

@onready var _player = Global.player
@onready var _camera = $Camera

func _ready():
	assert(_player != null)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		await get_tree().create_timer(0.1).timeout
		_camera.clear_current()
		Global.player = _player

func _process(_delta):
	if _camera.current:
		Global.player = null

func _on_interacted():
	_camera.make_current()
