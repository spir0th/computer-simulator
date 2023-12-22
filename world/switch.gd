extends "res://world/interactable.gd"

@export var _sun: DirectionalLight3D
@export var _light: OmniLight3D

@onready var _animator = $Animator

func _on_interacted():
	if _light == null:
		return
	if _light.omni_range < 1:
		_animator.play("on")
		_sun.light_energy = 0.0
		_light.omni_range = 10.0
	else:
		_animator.play("off")
		_sun.light_energy = 1.0
		_light.omni_range = 0.0
