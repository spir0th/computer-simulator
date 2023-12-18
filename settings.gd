extends Node

const _CONFIG_PATH = "user://saved.cfg"

var _config = ConfigFile.new()
var _data = {}

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _enter_tree():
	_runtime_to_data() # Must load default settings to make sure as a fallback option when failing to load user configuration.
	load_settings()
	_data_to_runtime()

func _exit_tree():
	_runtime_to_data()
	save_settings()

func get_value(key, default = null):
	if not _data.has(key):
		return default
	
	return _data[key]

func set_value(key, value):
	_data[key] = value

func has_key(key):
	return _data.has(key)

func save_settings():
	_config.clear()
	
	for key in _data:
		_config.set_value("game", key, _data[key])
	
	_config.save(_CONFIG_PATH)

func load_settings():
	var error = _config.load(_CONFIG_PATH)
	
	if error != OK:
		return
	if not _config.has_section("game"):
		return
	
	_data.clear()
	
	for key in _config.get_section_keys("game"):
		var value = _config.get_value("game", key)
		_data[key] = value

func _runtime_to_data():
	_data = {
		"audio_output_enable": AudioServer.is_bus_mute(0),
		"audio_output_device": AudioServer.output_device,
		"audio_volume_master": AudioServer.get_bus_volume_db(0),
		"audio_volume_music": AudioServer.get_bus_volume_db(1),
		"audio_volume_sfx": AudioServer.get_bus_volume_db(2),
		"display_window_mode": DisplayServer.window_get_mode(),
		"display_vsync_mode": DisplayServer.window_get_vsync_mode(),
		"display_scaling_3d_mode": get_tree().root.scaling_3d_mode,
		"display_scaling_3d_scale": get_tree().root.scaling_3d_scale,
		"display_fsr_sharpness": get_tree().root.fsr_sharpness,
		"display_msaa_value": get_tree().root.msaa_3d,
		"display_fxaa_value": get_tree().root.screen_space_aa,
		"display_shadow_size": get_tree().root.positional_shadow_atlas_size,
		"input_mouse_sensitivity": Global.camera_default_sensitivity
	}

func _data_to_runtime():
	for key in _data:
		# Audio
		if "audio_output_enable" == key:
			AudioServer.set_bus_mute(0, _data[key])
		elif "audio_output_device" == key:
			AudioServer.output_device = _data[key]
		elif "audio_volume_master" == key:
			AudioServer.set_bus_volume_db(0, _data[key])
		elif "audio_volume_music" == key:
			AudioServer.set_bus_volume_db(1, _data[key])
		elif "audio_volume_sfx" == key:
			AudioServer.set_bus_volume_db(2, _data[key])
		# Display
		if "display_window_mode" == key:
			DisplayServer.window_set_mode(_data[key])
		elif "display_vsync_mode" == key:
			DisplayServer.window_set_vsync_mode(_data[key])
		elif "display_scaling_3d_mode" == key:
			get_tree().root.scaling_3d_mode = _data[key]
		elif "display_scaling_3d_scale" == key:
			get_tree().root.scaling_3d_scale = _data[key]
		elif "display_fsr_sharpness" == key:
			get_tree().root.fsr_sharpness = _data[key]
		elif "display_msaa_value" == key:
			get_tree().root.msaa_3d = _data[key]
		elif "display_fxaa_value" == key:
			get_tree().root.screen_space_aa = _data[key]
		elif "display_shadow_size" == key:
			get_tree().root.positional_shadow_atlas_size = _data[key]
		# Input
		if "input_mouse_sensitivity" == key:
			Global.camera_default_sensitivity = _data[key]
