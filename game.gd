extends Control

@onready var _pause_background = $Pause/Background
@onready var _pause_menu = $Pause/Menu
@onready var _pause_animator = $Pause/Animator

func _ready():
	# Auto-play wake up animation when world is ready.
	_pause_animator.play("wake-up")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Global.player == null:
			# If the escape key has been pressed but the player is nowhere to be found
			# Just do nothing as some node had been probably handling the inputs.
			return
		
		get_tree().paused = not get_tree().paused

func _process(_delta):
	if get_tree().paused:
		if not _pause_menu.visible:
			_pause_animator.play("freeze")
	else:
		if _pause_menu.visible:
			_pause_animator.play("unfreeze")
