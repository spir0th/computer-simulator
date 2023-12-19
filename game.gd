extends Control

@onready var _pause_menu = $Menu

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if Global.player == null:
			# If the escape key has been pressed but the player is nowhere to be found
			# Just do nothing as some node had been probably handling the inputs.
			return
		
		get_tree().paused = not get_tree().paused

func _process(_delta):
	if get_tree().paused:
		if not _pause_menu.visible:
			_pause_menu.show()
	else:
		if _pause_menu.visible:
			_pause_menu.hide()

func _on_menu_resumed():
	get_tree().paused = false
