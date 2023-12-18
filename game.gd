extends Control

var _cpbam = 0.7843 # Used for calculating alpha on pause background.

@onready var _pause_background = $Pause/Background
@onready var _pause_menu = $Pause/Menu
@onready var _pause_animator = $Pause/Animator

func _ready():
	# Auto-play wake up animation when world is ready.
	_pause_animator.play("wake-up")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		_pause_menu.visible = not _pause_menu.visible

func _process(_delta):
	_update_background()
	_update_cursor()

func _update_cursor():
	# Updates the mouse cursor, depending on the game pause.
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED

func _update_background():
	# Updates the Pause background, depending on the game pause.
	if get_tree().paused:
		if _pause_background.color.a <= _cpbam:
			_pause_animator.play("freeze")
	else:
		if _pause_background.color.a >= _cpbam:
			_pause_animator.play_backwards("freeze")
