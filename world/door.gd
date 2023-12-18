extends StaticBody3D

@onready var _outside = $Outside
@onready var _animator = $Animator

func _ready():
	_outside.hide()
