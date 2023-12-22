extends StaticBody3D

@export var action = "player_interact"
@export var task = "Interact"

signal interacted

func _init():
	add_to_group("interactable", true)
