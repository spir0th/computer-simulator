@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("FreeMyHomies", "res://addons/fmh_internal/fmh.gd")

func _exit_tree():
	remove_autoload_singleton("FreeMyHomies")
