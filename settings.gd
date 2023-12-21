extends Node

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_init_custom_properties()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if save() != OK:
			OS.crash("Failed to save persistent settings, make sure file permissions are set correctly and is writable.")

func save() -> Error:
	_store_custom_properties()
	return ProjectSettings.save_custom("override.cfg")

func restore_defaults():
	var dir = DirAccess.open(OS.get_executable_path())
	
	if DirAccess.get_open_error() == OK:
		dir.remove("override.cfg")

func _store_custom_properties():
	# Store values from custom properties, since ProjectSettings does not handle them by default.
	var master_vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	var output_device = AudioServer.output_device
	ProjectSettings.set_setting("audio/buses/volume/master", master_vol)
	ProjectSettings.set_setting("audio/devices/output_device", output_device)

func _init_custom_properties():
	# Read values from custom properties, since ProjectSettings does not handle them by default.
	var master_vol = ProjectSettings.get_setting("audio/buses/volume/master", -4.8)
	var output_device = ProjectSettings.get_setting("audio/devices/output_device", "Default")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_vol)
	AudioServer.output_device = output_device
