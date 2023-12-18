extends StaticBody3D

@export var _sun: DirectionalLight3D
@export var _light: OmniLight3D

@onready var _switcher_animator = $Switcher/Animator

func _on_interacted():
	if _light == null:
		return
	if _light.omni_range < 1:
		_switcher_animator.play("on")
		_sun.light_energy = 0.0
		_light.omni_range = 10.0
	else:
		_switcher_animator.play("off")
		_sun.light_energy = 1.0
		_light.omni_range = 0.0
	
