extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		return # do nothing, user must decide first

func _on_yes_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://demo/test.tscn")

func _on_no_pressed():
	get_tree().quit()
