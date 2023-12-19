extends Node

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	ProjectSettings.connect("settings_changed", _on_settings_changed)

func _on_settings_changed():
	if OS.has_feature("editor"):
		return
	
	ProjectSettings.save_custom("override.cfg")
