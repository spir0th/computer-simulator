extends Control

func _ready():
	# Make sure the game is not frozen.
	get_tree().paused = false

func _on_menu_started():
	get_tree().change_scene_to_file("res://game.tscn")
