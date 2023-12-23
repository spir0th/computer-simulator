extends Control

@onready var player = Global.player

func _ready():
	assert(player != null, "No player(s) assigned globally.")
	hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		await get_tree().create_timer(0.1).timeout
		hide()

func _on_visibility_changed():
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.player = null
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Global.player = player
