extends Node

var application_name
var application_version

var camera_default_sensitivity # Default camera sensitivity
var camera_default_smoothness # Default camera smoothness
var camera_default_fov # Default camera FOV (field-of-view)

var player # The player node that is currently being used in-game.
var menu # The menu node, it may be null or non-null, depending on the current scene.

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS
