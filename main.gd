extends Node3D

var _menu_started = false

func _ready():
	# Make sure the game is not frozen.
	get_tree().paused = false

func _on_menu_started():
	if _menu_started:
		return
	
	get_tree().change_scene_to_file("res://game.tscn")
	_menu_started = true
