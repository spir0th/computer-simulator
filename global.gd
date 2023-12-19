extends Node

var application_name = ProjectSettings.get_setting("application/config/name", "Godot Engine")
var application_version = ProjectSettings.get_setting("application/config/version", Engine.get_version_info().string)

var camera_default_sensitivity = 0.25 # Default camera sensitivity
var camera_default_fov = 75.0 # Default camera FOV (field-of-view)

var player # The player node that is currently being used in-game.
var menu # The menu node, it may be null or non-null, depending on the current scene.

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS
