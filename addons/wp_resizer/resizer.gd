extends Node

func _process(_delta):
	await get_tree().create_timer(0.01).timeout
	var viewport_size = get_tree().root.content_scale_size
	var window_size = DisplayServer.window_get_size()
	
	if viewport_size != window_size:
		get_tree().root.content_scale_size = window_size
