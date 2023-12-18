extends Window

const TAB_INDEX_AUDIO = 0
const TAB_INDEX_DISPLAY = 1
const TAB_INDEX_INPUT = 2
const TAB_INDEX_LANGUAGE = 3

var _audio_device_setup = preload("res://interface/setup/audio_device.tscn")
var _audio_bus_master_idx = AudioServer.get_bus_index("Master")
var _audio_bus_music_idx = AudioServer.get_bus_index("Music")
var _audio_bus_sfx_idx = AudioServer.get_bus_index("SFX")

var _display_window_modes = [
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_FULLSCREEN,
	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
]
var _display_vsync_modes = [
	DisplayServer.VSYNC_DISABLED,
	DisplayServer.VSYNC_ENABLED,
	DisplayServer.VSYNC_ADAPTIVE
]
var _display_scaling_3d_modes = [
	Viewport.SCALING_3D_MODE_BILINEAR,
	Viewport.SCALING_3D_MODE_FSR,
	Viewport.SCALING_3D_MODE_FSR2
]
var _display_scaling_3d_scales = [
	0.50, # 50%
	0.75, # 75%
	0.95, # 95%
	1.00 # 100%
]
var _display_msaa_values = [
	Viewport.MSAA_DISABLED,
	Viewport.MSAA_2X,
	Viewport.MSAA_4X,
	Viewport.MSAA_8X
]
var _display_fxaa_values = [
	Viewport.SCREEN_SPACE_AA_DISABLED,
	Viewport.SCREEN_SPACE_AA_FXAA
]
var _display_shadow_sizes = [
	1024, # very low
	2048, # low (default, mobile)
	4096, # medium (default)
	8192, # high
	16384 # ultra
]

@onready var _scroller = $Contents/_/_/Options/Scroller/_

@onready var _option_audio = $Contents/_/_/Options/Scroller/_/Audio
@onready var _option_display = $Contents/_/_/Options/Scroller/_/Display
@onready var _option_input = $Contents/_/_/Options/Scroller/_/Input
@onready var _option_language = $Contents/_/_/Options/Scroller/_/Language

@onready var _btn_restore_defaults = $Contents/_/_/Header/RestoreDefaults

@onready var _audio_output_enable = $Contents/_/_/Options/Scroller/_/Audio/Output/Enable
@onready var _audio_output_device = $Contents/_/_/Options/Scroller/_/Audio/Output/Device
@onready var _audio_master_volume = $Contents/_/_/Options/Scroller/_/Audio/Master/Volume
@onready var _audio_music_volume = $Contents/_/_/Options/Scroller/_/Audio/Music/Volume
@onready var _audio_sfx_volume = $Contents/_/_/Options/Scroller/_/Audio/SFX/Volume
@onready var _audio_btn_device_setup = $Contents/_/_/Options/Scroller/_/Audio/Buttons/DeviceSetup

@onready var _display_graphics_name = $Contents/_/_/Options/Scroller/_/Display/Graphics/Name
@onready var _display_graphics_memory_usage = $Contents/_/_/Options/Scroller/_/Display/Graphics/MemoryUsage
@onready var _display_window_mode = $Contents/_/_/Options/Scroller/_/Display/Window/Mode
@onready var _display_vsync_mode = $Contents/_/_/Options/Scroller/_/Display/Vsync/Mode
@onready var _display_scaling_3d_mode = $Contents/_/_/Options/Scroller/_/Display/Scaling3D/Mode
@onready var _display_scaling_3d_scale = $Contents/_/_/Options/Scroller/_/Display/Scaling3D/Scale
@onready var _display_fsr_sharpness = $Contents/_/_/Options/Scroller/_/Display/FSR/Sharpness
@onready var _display_msaa_value = $Contents/_/_/Options/Scroller/_/Display/MSAA/Value
@onready var _display_fxaa_value = $Contents/_/_/Options/Scroller/_/Display/FXAA/Value
@onready var _display_shadow_size = $Contents/_/_/Options/Scroller/_/Display/Shadow/Size
@onready var _display_btn_benchmark = $Contents/_/_/Options/Scroller/_/Display/Buttons/Benchmark
@onready var _display_confirmation_benchmark = $Contents/_/_/Options/Scroller/_/Display/BenchmarkConfirmation

@onready var _input_mouse_sensitivity = $Contents/_/_/Options/Scroller/_/Input/Mouse/Sensitivity

@onready var _warning_restart = $Contents/_/_/RestartWarning
@onready var _warning_restart_btn_confirm = $Contents/_/_/RestartWarning/Confirm

@onready var _confirmation_restart = $RestartConfirmation
@onready var _confirmation_defaults = $DefaultsConfirmation

func _ready():
	_retrieve_audio_settings()
	_retrieve_display_settings()
	_retrieve_input_settings()
	_audio_output_enable.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		queue_free()

func _process(_delta):
	if _audio_output_device.visible:
		_audio_output_device.text = "Output: %s" % AudioServer.output_device
	if _display_graphics_name.visible:
		_display_graphics_name.text = "%s (%s)" % [RenderingServer.get_video_adapter_name(), RenderingServer.get_video_adapter_vendor()]
	if _display_graphics_memory_usage.visible:
		var display_graphics_mem_used = String.humanize_size(RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_VIDEO_MEM_USED))
		_display_graphics_memory_usage.text = "Memory usage: %s" % display_graphics_mem_used

func _on_window_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("close_requested")

func _on_close_requested():
	queue_free()

func _on_navigation_tab_changed(tab):
	for _c in _scroller.get_children():
		_c.hide()
	if tab == TAB_INDEX_AUDIO:
		_option_audio.show()
	elif tab == TAB_INDEX_DISPLAY:
		_option_display.show()
	elif tab == TAB_INDEX_INPUT:
		_option_input.show()
	elif tab == TAB_INDEX_LANGUAGE:
		_option_language.show()

func _on_restore_defaults_pressed():
	_confirmation_defaults.show()

func _on_audio_output_enable_toggled(button_pressed):
	AudioServer.set_bus_mute(_audio_bus_master_idx, not button_pressed)
	
	if button_pressed:
		_audio_master_volume.editable = true
		_audio_music_volume.editable = true
		_audio_sfx_volume.editable = true
	else:
		_audio_master_volume.editable = false
		_audio_music_volume.editable = false
		_audio_sfx_volume.editable = false

func _on_audio_master_volume_value_changed(value):
	AudioServer.set_bus_volume_db(_audio_bus_master_idx, value)

func _on_audio_music_volume_value_changed(value):
	AudioServer.set_bus_volume_db(_audio_bus_music_idx, value)

func _on_audio_sfx_volume_value_changed(value):
	AudioServer.set_bus_volume_db(_audio_bus_sfx_idx, value)

func _on_audio_device_setup_pressed():
	add_child(_audio_device_setup.instantiate())

func _on_display_window_mode_item_selected(index):
	DisplayServer.window_set_mode(_display_window_modes[index])

func _on_display_vsync_mode_item_selected(index):
	DisplayServer.window_set_vsync_mode(_display_vsync_modes[index])

func _on_display_scaling_3d_mode_item_selected(index):
	_display_scaling_3d_scale.select(3 if index > 0 else _display_scaling_3d_scale.selected)
	_display_scaling_3d_scale.visible = index < 1
	_display_fsr_sharpness.get_parent().visible = index > 0
	get_tree().root.scaling_3d_mode = _display_scaling_3d_modes[index]

func _on_display_scaling_3d_scale_item_selected(index):
	get_tree().root.scaling_3d_scale = _display_scaling_3d_scales[index]

func _on_display_fsr_sharpness_value_changed(value):
	get_tree().root.fsr_sharpness = value

func _on_display_msaa_value_item_selected(index):
	get_tree().root.msaa_3d = _display_msaa_values[index]

func _on_display_fxaa_value_item_selected(index):
	get_tree().root.screen_space_aa = _display_fxaa_values[index]

func _on_display_shadow_size_item_selected(index):
	get_tree().root.positional_shadow_atlas_size = _display_shadow_sizes[index]

func _on_display_benchmark_pressed():
	_display_confirmation_benchmark.show()

func _on_display_benchmark_confirmed():
	get_tree().change_scene_to_file("res://demo/benchmark/camera.tscn")

func _on_input_mouse_sensitivity_value_changed(value):
	Global.camera_default_sensitivity = value

func _restore_default_audio_settings():
	AudioServer.set_bus_mute(_audio_bus_master_idx, false)
	AudioServer.set_bus_volume_db(_audio_bus_master_idx, 0.0)
	AudioServer.set_bus_volume_db(_audio_bus_music_idx, -2.0)
	AudioServer.set_bus_volume_db(_audio_bus_sfx_idx, -2.0)
	_retrieve_audio_settings() # needed to refresh UI for changes

func _restore_default_display_settings():
	DisplayServer.window_set_vsync_mode(ProjectSettings.get_setting("display/window/vsync/vsync_mode", DisplayServer.VSYNC_ADAPTIVE))
	get_tree().root.scaling_3d_mode = ProjectSettings.get_setting("rendering/scaling_3d/mode", _display_scaling_3d_modes[0])
	get_tree().root.scaling_3d_scale = ProjectSettings.get_setting("rendering/scaling_3d/scale", _display_scaling_3d_scales[3])
	get_tree().root.fsr_sharpness = ProjectSettings.get_setting("rendering/scaling_3d/fsr_sharpness", 0.2)
	get_tree().root.msaa_3d = ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d", _display_msaa_values[0])
	get_tree().root.screen_space_aa = ProjectSettings.get_setting("rendering/anti_aliasing/quality/screen_space_aa", _display_fxaa_values[0])
	get_tree().root.positional_shadow_atlas_size = ProjectSettings.get_setting("rendering/lights_and_shadows/positional_shadow/atlas_size", _display_shadow_sizes[2])
	_retrieve_display_settings() # needed to refresh UI for changes

func _restore_default_input_settings():
	Global.camera_default_sensitivity = 0.25
	_retrieve_input_settings()

func _retrieve_audio_settings():
	_audio_output_enable.button_pressed = not AudioServer.is_bus_mute(_audio_bus_master_idx)
	_audio_master_volume.editable = not AudioServer.is_bus_mute(_audio_bus_master_idx)
	_audio_master_volume.value = AudioServer.get_bus_volume_db(_audio_bus_master_idx)
	_audio_music_volume.editable = not AudioServer.is_bus_mute(_audio_bus_master_idx)
	_audio_music_volume.value = AudioServer.get_bus_volume_db(_audio_bus_music_idx)
	_audio_sfx_volume.editable = not AudioServer.is_bus_mute(_audio_bus_master_idx)
	_audio_sfx_volume.value = AudioServer.get_bus_volume_db(_audio_bus_sfx_idx)

func _retrieve_display_settings():
	for i in _display_window_modes.size():
		if _display_window_modes[i] == DisplayServer.window_get_mode():
			_display_window_mode.select(i)
			break
	for i in _display_vsync_modes.size():
		if _display_vsync_modes[i] == DisplayServer.window_get_vsync_mode():
			_display_vsync_mode.select(i)
			break
	for i in _display_scaling_3d_modes.size():
		if _display_scaling_3d_modes[i] == get_tree().root.scaling_3d_mode:
			_display_scaling_3d_mode.select(i)
			break
	for i in _display_scaling_3d_scales.size():
		if _display_scaling_3d_scales[i] == get_tree().root.scaling_3d_scale:
			_display_scaling_3d_scale.select(i)
			break
	
	_display_scaling_3d_scale.visible = _display_scaling_3d_mode.selected < 1
	_display_fsr_sharpness.get_parent().visible = _display_scaling_3d_mode.selected > 0
	_display_fsr_sharpness.value = get_tree().root.fsr_sharpness
	
	for i in _display_msaa_values.size():
		if _display_msaa_values[i] == get_tree().root.msaa_3d:
			_display_msaa_value.select(i)
			break
	for i in _display_fxaa_values.size():
		if _display_fxaa_values[i] == get_tree().root.screen_space_aa:
			_display_fxaa_value.select(i)
			break
	for i in _display_shadow_sizes.size():
		if _display_shadow_sizes[i] == get_tree().root.positional_shadow_atlas_size:
			_display_shadow_size.select(i)
			break

func _retrieve_input_settings():
	_input_mouse_sensitivity.value = Global.camera_default_sensitivity

func _on_warning_restart_btn_confirm_pressed():
	_confirmation_restart.show()

func _on_restart_confirmed():
	OS.set_restart_on_exit(true)
	get_tree().quit()

func _on_restore_defaults_confirmed():
	_restore_default_audio_settings()
	_restore_default_display_settings()
	_restore_default_input_settings()
