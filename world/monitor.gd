extends StaticBody3D

@onready var _interface = $Interface

func _on_interacted():
	_interface.show()
