extends Window

const TAB_INDEX_AUDIO = 0
const TAB_INDEX_DISPLAY = 1
const TAB_INDEX_INPUT = 2
const TAB_INDEX_LANGUAGE = 3

const DISPLAY_RENDERER_METHODS = [
	"gl_compatibility", # OpenGL rendering (runs on most hardware)
	"forward_plus" # Vulkan rendering (incompatible with older hardware)
]
const DISPLAY_WINDOW_MODES = [
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_FULLSCREEN,
	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
]
const DISPLAY_VSYNC_MODES = [
	DisplayServer.VSYNC_DISABLED,
	DisplayServer.VSYNC_ENABLED,
	DisplayServer.VSYNC_ADAPTIVE
]
const DISPLAY_RESOLUTION_VALUES = [
	Vector2i(0, 0), # reserved
	Vector2i(640, 480), # 640x480 (4:3)
	Vector2i(800, 600), # 800x600 (4:3)
	Vector2i(1024, 768), # 1024x768 (4:3)
	Vector2i(0, 0), # reserved
	Vector2i(960, 540), # 960x540 (16:9)
	Vector2i(1280, 720), # 1280x720 (16:9)
	Vector2i(1366, 768), # 1366x768 (16:9)
	Vector2i(1920, 1080), # 1920x1080 (16:9)
]
const DISPLAY_SCALE_VALUES = [
	0.5, # 50%
	0.8, # 75%
	1.0, # 100%
	1.2, # 125%
	1.5, # 150%
	2.0 # 200%
]
const DISPLAY_SHADOW_VALUES = [
	0, # Off
	4096, # Low
	8192, # Medium
	16384 # High
]
const DISPLAY_MSAA_VALUES = [
	Viewport.MSAA_DISABLED,
	Viewport.MSAA_2X,
	Viewport.MSAA_4X,
	Viewport.MSAA_8X
]
const DISPLAY_SSAA_VALUES = [
	Viewport.SCREEN_SPACE_AA_DISABLED,
	Viewport.SCREEN_SPACE_AA_FXAA
]

var _audio_bus_master = AudioServer.get_bus_index("Master")

@onready var _scroller = $Contents/_/_/Options/Scroller/_

@onready var _option_audio = $Contents/_/_/Options/Scroller/_/Audio
@onready var _option_display = $Contents/_/_/Options/Scroller/_/Display
@onready var _option_input = $Contents/_/_/Options/Scroller/_/Input
@onready var _option_language = $Contents/_/_/Options/Scroller/_/Language

@onready var _header_btn_restore_defaults = $Contents/_/_/Header/RestoreDefaults

@onready var _audio_output_device = $Contents/_/_/Options/Scroller/_/Audio/Output/Device
@onready var _audio_master_volume = $Contents/_/_/Options/Scroller/_/Audio/Master/Volume

@onready var _display_renderer_method = $Contents/_/_/Options/Scroller/_/Display/Renderer/Method
@onready var _display_window_mode = $Contents/_/_/Options/Scroller/_/Display/Window/Mode
@onready var _display_vsync_mode = $Contents/_/_/Options/Scroller/_/Display/VSync/Mode
@onready var _display_resolution_value = $Contents/_/_/Options/Scroller/_/Display/Resolution/Value
@onready var _display_scale_value = $Contents/_/_/Options/Scroller/_/Display/Scale/Value
@onready var _display_fov_value = $Contents/_/_/Options/Scroller/_/Display/FOV/Value
@onready var _display_shadow_value = $Contents/_/_/Options/Scroller/_/Display/Shadow/Value
@onready var _display_msaa_value = $Contents/_/_/Options/Scroller/_/Display/MSAA/Value
@onready var _display_ssaa_value = $Contents/_/_/Options/Scroller/_/Display/SSAA/Value

@onready var _input_mouse_sensitivity = $Contents/_/_/Options/Scroller/_/Input/Mouse/Sensitivity

@onready var _warning_restart = $Contents/_/_/RestartWarning

@onready var _confirmation_restart_scene = $RestartSceneConfirmation
@onready var _confirmation_defaults = $DefaultsConfirmation

func _ready():
	_retrieve_audio_settings()
	_retrieve_display_settings()
	_retrieve_input_settings()
	_warning_restart.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		queue_free()

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

func _on_audio_output_device_item_selected(index):
	var device = _audio_output_device.get_item_text(index)
	AudioServer.output_device = device

func _on_audio_master_volume_value_changed(value):
	AudioServer.set_bus_volume_db(_audio_bus_master, value)

func _on_display_renderer_method_item_selected(index):
	var value = DISPLAY_RENDERER_METHODS[index]
	var last_value = ProjectSettings.get_setting("rendering/renderer/rendering_method", "forward_plus")
	
	if value != last_value:
		ProjectSettings.set_setting("rendering/renderer/rendering_method", value)
		_warning_restart.show()

func _on_display_window_mode_item_selected(index):
	var value = DISPLAY_WINDOW_MODES[index]
	var last_value = DisplayServer.window_get_mode()
	
	if value != last_value:
		DisplayServer.window_set_mode(value)
		_display_resolution_value.disabled = value > DISPLAY_WINDOW_MODES[0]
		ProjectSettings.set_setting("display/window/size/mode", value)

func _on_display_vsync_mode_item_selected(index):
	var value = DISPLAY_VSYNC_MODES[index]
	var last_value = DisplayServer.window_get_vsync_mode()
	
	if value != last_value:
		DisplayServer.window_set_vsync_mode(value)
		ProjectSettings.set_setting("display/window/vsync/vsync_mode", value)

func _on_display_resolution_value_item_selected(index):
	var value = DISPLAY_RESOLUTION_VALUES[index]
	var last_value = get_tree().root.size
	
	if value != last_value:
		get_tree().root.size = value
		ProjectSettings.set_setting("display/window/size/viewport_width", value.x)
		ProjectSettings.set_setting("display/window/size/viewport_height", value.y)

func _on_display_scale_value_item_selected(index):
	var value = DISPLAY_SCALE_VALUES[index]
	var last_value = get_tree().root.scaling_3d_scale
	
	if value != last_value:
		get_tree().root.scaling_3d_scale = value
		ProjectSettings.set_setting("rendering/scaling_3d/scale", value)

func _on_display_fov_value_changed(value):
	var last_value = Global.camera_default_fov
	
	if value != last_value:
		Global.camera_default_fov = value
		ProjectSettings.set_setting("rendering/camera/field_of_view/value", value)

func _on_display_shadow_value_item_selected(index):
	var value = DISPLAY_SHADOW_VALUES[index]
	var last_value = get_tree().root.positional_shadow_atlas_size
	
	if value != last_value:
		get_tree().root.positional_shadow_atlas_size = value
		ProjectSettings.set_setting("rendering/lights_and_shadows/directional_shadow/size", value)
		ProjectSettings.set_setting("rendering/lights_and_shadows/positional_shadow/atlas_size", value)
	if value == DISPLAY_SHADOW_VALUES[0]:
		# When turning off shadows, it is advised for the player to quick restart the scene.
		# Note: QUICK RESTART only reloads the current scene, it does not fully restart the entire game.
		_confirmation_restart_scene.show()

func _on_display_msaa_value_item_selected(index):
	var value = DISPLAY_MSAA_VALUES[index]
	var last_value = get_tree().root.msaa_3d
	
	if value != last_value:
		get_tree().root.msaa_3d = value
		ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", value)

func _on_display_ssaa_value_item_selected(index):
	var value = DISPLAY_SSAA_VALUES[index]
	var last_value = get_tree().root.screen_space_aa
	
	if value != last_value:
		get_tree().root.screen_space_aa = value
		ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", value)

func _on_input_mouse_sensitivity_value_changed(value):
	var last_value = Global.camera_default_sensitivity
	
	if value != last_value:
		Global.camera_default_sensitivity = value
		ProjectSettings.set_setting("input_devices/pointing/camera/sensitivity", value)

func _restore_default_audio_settings():
	AudioServer.output_device = "default"
	AudioServer.set_bus_volume_db(_audio_bus_master, -10.0)
	_retrieve_audio_settings() # needed to refresh UI for changes

func _restore_default_display_settings():
	if DisplayServer.window_get_mode() < DisplayServer.WINDOW_MODE_FULLSCREEN:
		# If the window mode is Windowed (even minimized/maximized), we can
		# also set the viewport resolution back to it's default value
		get_tree().root.size = Vector2i(1280, 720)
	
	Global.camera_default_fov = 75.0
	get_tree().root.scaling_3d_scale = 1.0
	get_tree().root.positional_shadow_atlas_size = 4096
	get_tree().root.msaa_3d = Viewport.MSAA_DISABLED
	get_tree().root.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
	_retrieve_display_settings() # needed to refresh UI for changes

func _restore_default_input_settings():
	Global.camera_default_sensitivity = 0.25
	_retrieve_input_settings() # needed to refresh UI for changes

func _retrieve_audio_settings():
	var output_devices = AudioServer.get_output_device_list()
	
	for index in len(output_devices):
		var device = output_devices[index]
		_audio_output_device.add_item(device, index)
		
		if device == AudioServer.output_device:
			_audio_output_device.select(index)
	
	_audio_master_volume.value = AudioServer.get_bus_volume_db(_audio_bus_master)

func _retrieve_display_settings():
	var rendering_method = ProjectSettings.get_setting("rendering/renderer/rendering_method", "forward_plus")
	var window_mode = DisplayServer.window_get_mode()
	var vsync_mode = DisplayServer.window_get_vsync_mode()
	var resolution_value = get_tree().root.size
	var scale_value = get_tree().root.scaling_3d_scale
	var shadow_value = get_tree().root.positional_shadow_atlas_size
	var msaa_value = get_tree().root.msaa_3d
	var ssaa_value = get_tree().root.screen_space_aa
	
	_display_resolution_value.disabled = window_mode > DISPLAY_WINDOW_MODES[0]
	_display_fov_value.value = Global.camera_default_fov
	
	if rendering_method == DISPLAY_RENDERER_METHODS[1] or rendering_method == "mobile":
		_display_renderer_method.select(1)
	elif rendering_method == DISPLAY_RENDERER_METHODS[0]:
		_display_renderer_method.select(0)
	if window_mode == DISPLAY_WINDOW_MODES[0]:
		_display_window_mode.select(0)
	elif window_mode == DISPLAY_WINDOW_MODES[1]:
		_display_window_mode.select(1)
	elif window_mode == DISPLAY_WINDOW_MODES[2]:
		_display_window_mode.select(2)
	if vsync_mode == DISPLAY_VSYNC_MODES[0]:
		_display_vsync_mode.select(0)
	elif vsync_mode == DISPLAY_VSYNC_MODES[1]:
		_display_vsync_mode.select(1)
	elif vsync_mode == DISPLAY_VSYNC_MODES[2]:
		_display_vsync_mode.select(2)
	if resolution_value == DISPLAY_RESOLUTION_VALUES[1]:
		_display_resolution_value.select(1)
	elif resolution_value == DISPLAY_RESOLUTION_VALUES[2]:
		_display_resolution_value.select(2)
	elif resolution_value == DISPLAY_RESOLUTION_VALUES[3]:
		_display_resolution_value.select(3)
	elif resolution_value == DISPLAY_RESOLUTION_VALUES[5]:
		_display_resolution_value.select(5)
	elif resolution_value == DISPLAY_RESOLUTION_VALUES[6]:
		_display_resolution_value.select(6)
	elif resolution_value == DISPLAY_RESOLUTION_VALUES[7]:
		_display_resolution_value.select(7)
	elif resolution_value == DISPLAY_RESOLUTION_VALUES[8]:
		_display_resolution_value.select(8)
	if scale_value == DISPLAY_SCALE_VALUES[0]:
		_display_scale_value.select(0)
	elif scale_value == DISPLAY_SCALE_VALUES[1]:
		_display_scale_value.select(1)
	elif scale_value == DISPLAY_SCALE_VALUES[2]:
		_display_scale_value.select(2)
	elif scale_value == DISPLAY_SCALE_VALUES[3]:
		_display_scale_value.select(3)
	elif scale_value == DISPLAY_SCALE_VALUES[4]:
		_display_scale_value.select(4)
	elif scale_value == DISPLAY_SCALE_VALUES[5]:
		_display_scale_value.select(5)
	if shadow_value == DISPLAY_SHADOW_VALUES[0]:
		_display_shadow_value.select(0)
	elif shadow_value == DISPLAY_SHADOW_VALUES[1]:
		_display_shadow_value.select(1)
	elif shadow_value == DISPLAY_SHADOW_VALUES[2]:
		_display_shadow_value.select(2)
	elif shadow_value == DISPLAY_SHADOW_VALUES[3]:
		_display_shadow_value.select(3)
	if msaa_value == DISPLAY_MSAA_VALUES[0]:
		_display_msaa_value.select(0)
	elif msaa_value == DISPLAY_MSAA_VALUES[1]:
		_display_msaa_value.select(1)
	elif msaa_value == DISPLAY_MSAA_VALUES[2]:
		_display_msaa_value.select(2)
	elif msaa_value == DISPLAY_MSAA_VALUES[3]:
		_display_msaa_value.select(3)
	if ssaa_value == DISPLAY_SSAA_VALUES[0]:
		_display_ssaa_value.select(0)
	elif ssaa_value == DISPLAY_SSAA_VALUES[1]:
		_display_ssaa_value.select(1)

func _retrieve_input_settings():
	_input_mouse_sensitivity.value = Global.camera_default_sensitivity

func _on_restart_scene_confirmed():
	get_tree().reload_current_scene()
	self.show()

func _on_restore_defaults_confirmed():
	Settings.restore_defaults()
	_restore_default_audio_settings()
	_restore_default_display_settings()
	_restore_default_input_settings()
