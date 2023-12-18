@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("WindowportResizer", "res://addons/windowport_resizer/resizer.gd")

func _exit_tree():
	remove_autoload_singleton("WindowportResizer")
