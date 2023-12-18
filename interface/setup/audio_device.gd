extends Window

@onready var _message = $Contents/_/_/Message
@onready var _device_list = $Contents/_/_/DeviceList
@onready var _confirmation = $Contents/_/_/Confirmation

@onready var _error_no_device_selected = $NoDeviceSelectedError

func _ready():
	_retrieve_devices()
	_device_list.grab_focus()

func _on_window_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("close_requested")

func _on_close_requested():
	queue_free()

func _on_confirmation_pressed():
	if not _device_list.is_anything_selected():
		_error_no_device_selected.show()
	
	var device = _device_list.get_item_text(_device_list.get_selected_items()[0]) # item is always at index 0, multi-select does not bother here.
	AudioServer.output_device = device
	emit_signal("close_requested")

func _retrieve_devices():
	var devices = AudioServer.get_output_device_list()
	
	for i in range(devices.size()):
		var device = devices[i]
		_device_list.add_item(device)
		
		if device == AudioServer.output_device:
			_device_list.select(i)
	
	_device_list.ensure_current_is_visible()
