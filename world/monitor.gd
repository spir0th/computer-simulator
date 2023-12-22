extends "res://world/interactable.gd"

@onready var _interface = $Interface

func _on_interacted():
	_interface.show()
