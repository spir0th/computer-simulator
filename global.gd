extends Node

#region Startup
func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS
#endregion
#region Application info
var application_name = ProjectSettings.get_setting("application/config/name", "Godot Engine")
var application_version = ProjectSettings.get_setting("application/config/version", Engine.get_version_info().string)
#endregion
#region Camera defaults
var camera_default_sensitivity = 0.25
var camera_default_fov = 75.0
#endregion

var player # The player node that is currently being used in-game.
