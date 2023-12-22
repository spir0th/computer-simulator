extends CharacterBody3D

@export_category("Player")
@export var speed = 5.0

var _camera_mouse_input = Vector2.ZERO
var _camera_mouse_sensitivity = Global.camera_default_sensitivity
var _camera_smoothness = Global.camera_default_smoothness
var _camera_fov = Global.camera_default_fov
var _camera_fov_interpolate = 1.5
var _camera_pitch = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

@onready var _head = $Head
@onready var _camera = $Head/Camera
@onready var _raycast = $Head/Raycast
@onready var _prompt = $Head/Prompt
@onready var _animator_tree = $Animator/Tree

func _enter_tree():
	Global.player = self

func _exit_tree():
	Global.player = null

func _input(event):
	if Global.player != self or not _camera.is_current():
		return
	if event is InputEventMouseMotion:
		_camera_mouse_input = event.relative
	if event.is_action_pressed("player_interact") and _raycast.is_colliding():
		var object = _raycast.get_collider()
		
		if object.is_in_group("interactable") and velocity.length() < 1:
			object.emit_signal("interacted")
			_prompt.hide()

func _process(delta):
	if Global.player != self or not _camera.is_current():
		return
	
	# Update camera properties
	_camera_mouse_sensitivity = Global.camera_default_sensitivity
	_camera_smoothness = Global.camera_default_smoothness
	_camera_fov = Global.camera_default_fov
	
	# Process camera rotation (both X and Y)
	_camera_mouse_input = _camera_mouse_input.lerp(_camera_mouse_input * _camera_mouse_sensitivity, delta * _camera_smoothness)
	
	var camera_mouse_position = _camera_mouse_input * _camera_mouse_sensitivity
	var camera_yaw = camera_mouse_position.x
	var camera_pitch = camera_mouse_position.y
	
	camera_mouse_position = Vector2.ZERO
	camera_pitch = clamp(camera_pitch, -40 - _camera_pitch, 60 - _camera_pitch)
	_camera_pitch += camera_pitch
	
	_head.rotate_y(deg_to_rad(-camera_yaw))
	_camera.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(-camera_pitch))
	_raycast.rotate_object_local(Vector3(1 ,0 ,0), deg_to_rad(-camera_pitch))

func _physics_process(delta):
	if Global.player != self or not _camera.is_current():
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= _gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input = Input.get_vector("player_move_left", "player_move_right", "player_move_forward", "player_move_backward")
	var direction = (_head.transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, speed * 2)
	var target_fov = _camera_fov + _camera_fov_interpolate * velocity_clamped
	_camera.fov = lerp(_camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	
	# Handle animation depending on velocity length
	_animator_tree.set("parameters/movement/blend_position", velocity.length() / speed)
	
	# Check if the raycast is colliding with an interactable node
	if _raycast.is_colliding():
		var object = _raycast.get_collider()
		
		if object.is_in_group("interactable"):
			_prompt.action = object.action
			_prompt.task = object.task
			_prompt.show()
	else:
		_prompt.hide()
