extends StaticBody3D

@onready var _animator = $Animator

func _ready():
	_animator.play("idle")
