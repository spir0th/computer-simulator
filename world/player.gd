extends CharacterBody3D

@export_category("Player")
@export var speed = 5.0

var _camera_mouse_sensitivity = Global.camera_default_sensitivity
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

func _process(_delta):
	_camera_mouse_sensitivity = Global.camera_default_sensitivity
	_camera_fov = Global.camera_default_fov

func _input(event):
	if Global.player != self or not _camera.is_current():
		return
	if event is InputEventMouseMotion:
		var sensitivity = _camera_mouse_sensitivity
		var mouse_position = event.relative * sensitivity
		var yaw = mouse_position.x
		var pitch = mouse_position.y
		
		mouse_position = Vector2.ZERO
		pitch = clamp(pitch, -40 - _camera_pitch, 60 - _camera_pitch)
		_camera_pitch += pitch
		
		_head.rotate_y(deg_to_rad(-yaw))
		_camera.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(-pitch))
		_raycast.rotate_object_local(Vector3(1 ,0 ,0), deg_to_rad(-pitch))
	if event.is_action_pressed("player_interact") and _raycast.is_colliding():
		var object = _raycast.get_collider()
		
		if object.has_node("Interactable"):
			var interactable = object.get_node("Interactable")
			interactable.emit_signal("interacted")
			_prompt.hide()

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
		
		if object.has_node("Interactable"):
			var interactable = object.get_node("Interactable")
			_prompt.action = interactable.action
			_prompt.task = interactable.task
			_prompt.show()
	else:
		_prompt.hide()
