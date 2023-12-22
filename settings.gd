extends Node

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_init_custom_properties()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if save() != OK:
			OS.crash("Failed to save persistent settings, make sure file permissions are set correctly and is writable.")

func save() -> Error:
	return ProjectSettings.save_custom("override.cfg")

func restore_defaults():
	var dir = DirAccess.open(OS.get_executable_path())
	
	if DirAccess.get_open_error() == OK:
		dir.remove("override.cfg")

func _init_custom_properties():
	# Read values from custom properties, since ProjectSettings does not handle them by default.
	Global.application_name = ProjectSettings.get_setting("application/config/name", "Godot Engine")
	Global.application_version = ProjectSettings.get_setting("application/config/version", Engine.get_version_info().string)
	
	Global.camera_default_sensitivity = ProjectSettings.get_setting("input_devices/pointing/camera/sensitivity", 0.25)
	Global.camera_default_smoothness = ProjectSettings.get_setting("input_devices/pointing/camera/smoothness", 30)
	Global.camera_default_fov = ProjectSettings.get_setting("rendering/camera/field_of_view/value", 75.0)
	
	var master_vol = ProjectSettings.get_setting("audio/buses/volume/master", -4.8)
	var output_device = ProjectSettings.get_setting("audio/devices/output_device", "Default")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_vol)
	AudioServer.output_device = output_device
